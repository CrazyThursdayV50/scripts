#!/bin/bash
# 脚本用于生成 OpenSSL 证书，用于服务端和客户端的自签名证书验证

OUTPUT_DIR=./certs

# 证书有效期（天）
VALID_DAYS=3650

# 文件路径
ROOT_CONFIG="./config/root.conf"
SERVER_CONFIG="./config/server.conf"
CLIENT_CONFIG="./config/client.conf"
ROOT_KEY="${OUTPUT_DIR}/root.key"
ROOT_CSR="${OUTPUT_DIR}/root.csr"
ROOT_CERT="${OUTPUT_DIR}/root.crt"
SERVER_KEY="${OUTPUT_DIR}/server.key"
SERVER_CSR="${OUTPUT_DIR}/server.csr"
SERVER_CERT="${OUTPUT_DIR}/server.crt"
CLIENT_KEY="${OUTPUT_DIR}/client.key"
CLIENT_CSR="${OUTPUT_DIR}/client.csr"
CLIENT_CERT="${OUTPUT_DIR}/client.crt"

# 检查 OpenSSL 是否可用
if ! command -v openssl &> /dev/null; then
    echo "错误：OpenSSL 未安装，请先安装 OpenSSL。"
    exit 1
fi

# 第一步：生成根证书
echo "正在生成根证书..."

# 生成根证书私钥
echo "正在生成 ${KEY_BITS} 位根证书私钥：${ROOT_KEY} ..."
openssl genrsa -out "${ROOT_KEY}" ${KEY_BITS}
if [ $? -ne 0 ]; then
    echo "生成根证书私钥失败"
    exit 1
fi
chmod 600 "${ROOT_KEY}"

echo "正在生成根证书签名请求：${ROOT_CSR}..."
openssl req -new -sha256 -out "${ROOT_CSR}" -key "${ROOT_KEY}" -config "${ROOT_CONFIG}"
if [ $? -ne 0 ]; then
    echo "生成根证书私钥失败"
    exit 1
fi

# 生成根证书
echo "正在生成根证书：${ROOT_CERT}（有效期 ${VALID_DAYS} 天）..."
openssl x509 -req -in "${ROOT_CSR}" -signkey "${ROOT_KEY}" -out "${ROOT_CERT}" -days "${VALID_DAYS}" -extfile "${ROOT_CONFIG}" -extensions v3_ca
if [ $? -ne 0 ]; then
    echo "生成根证书失败"
    exit 1
fi

echo "根证书生成成功："
echo "- 私钥：${ROOT_KEY}"
echo "- 证书：${ROOT_CERT}"

# 第二步：生成服务端证书
echo "正在生成服务端证书..."

# 生成服务端证书私钥
echo "正在生成 ${KEY_BITS} 位服务端证书私钥：${SERVER_KEY} ..."
openssl genrsa -out "${SERVER_KEY}" ${KEY_BITS}
if [ $? -ne 0 ]; then
    echo "生成服务端证书私钥失败"
    exit 1
fi
chmod 600 "${SERVER_KEY}"

# 生成服务端证书签名请求（CSR）
echo "正在生成服务端证书签名请求：${SERVER_CSR}..."
openssl req -new -sha256 -key "${SERVER_KEY}" -out "${SERVER_CSR}" -config "${SERVER_CONFIG}"
if [ $? -ne 0 ]; then
    echo "生成服务端证书签名请求失败"
    exit 1
fi

# 使用根证书签发服务端证书
echo "正在使用根证书签发服务端证书：${SERVER_CERT}（有效期 ${VALID_DAYS} 天）..."
openssl x509 -req -in "${SERVER_CSR}" -CA "${ROOT_CERT}" -CAkey "${ROOT_KEY}" -CAcreateserial -out "${SERVER_CERT}" -days ${VALID_DAYS} -extensions req_ext -extfile "${SERVER_CONFIG}" -extensions v3_req
if [ $? -ne 0 ]; then
    echo "签发服务端证书失败"
    exit 1
fi

echo "服务端证书生成成功："
echo "- 私钥：${SERVER_KEY}"
echo "- 证书：${SERVER_CERT}"

# 第三步：生成客户端证书
echo "正在生成客户端证书..."

# 生成客户端证书私钥
echo "正在生成 ${KEY_BITS} 位客户端证书私钥：${CLIENT_KEY} ..."
openssl genrsa -out "${CLIENT_KEY}" ${KEY_BITS}
if [ $? -ne 0 ]; then
    echo "生成客户端证书私钥失败"
    exit 1
fi
chmod 600 "${CLIENT_KEY}"

# 生成客户端证书签名请求（CSR）
echo "正在生成客户端证书签名请求：${CLIENT_CSR} ..."
openssl req -new -sha256 -key "${CLIENT_KEY}" -out "${CLIENT_CSR}" -config "${CLIENT_CONFIG}"
if [ $? -ne 0 ]; then
    echo "生成客户端证书签名请求失败"
    exit 1
fi

# 使用根证书签发客户端证书
echo "正在使用根证书签发客户端证书：${CLIENT_CERT}（有效期 ${VALID_DAYS} 天）..."
openssl x509 -req -in "${CLIENT_CSR}" -CA "${ROOT_CERT}" -CAkey "${ROOT_KEY}" -CAcreateserial -out "${CLIENT_CERT}" -days ${VALID_DAYS} -extensions req_ext -extfile "${CLIENT_CONFIG}" -extensions v3_req
if [ $? -ne 0 ]; then
    echo "签发客户端证书失败"
    exit 1
fi

echo "客户端证书生成成功："
echo "- 私钥：${CLIENT_KEY}"
echo "- 证书：${CLIENT_CERT}"

echo "所有证书生成完毕。"
