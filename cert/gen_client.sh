#! /usr/bin/env bash
OUTPUT_DIR=./certs
VALID_DAYS=3650
ROOT_KEY="${OUTPUT_DIR}/root.key"
ROOT_CERT="${OUTPUT_DIR}/root.crt"
CLIENT_CONFIG="./config/client.conf"
CLIENT_KEY="${OUTPUT_DIR}/client.key"
CLIENT_CSR="${OUTPUT_DIR}/client.csr"
CLIENT_CERT="${OUTPUT_DIR}/client.crt"

echo "正在生成客户端证书..."

# 生成客户端证书私钥
echo "正在生成客户端证书私钥：${CLIENT_KEY} ..."
openssl genrsa -out "${CLIENT_KEY}"
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
