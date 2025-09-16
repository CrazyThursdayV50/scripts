#! /usr/bin/env bash
OUTPUT_DIR=./certs
VALID_DAYS=3650
ROOT_CONFIG="./config/root.conf"
ROOT_KEY="${OUTPUT_DIR}/root.key"
ROOT_CSR="${OUTPUT_DIR}/root.csr"
ROOT_CERT="${OUTPUT_DIR}/root.crt"

# 检查 OpenSSL 是否可用
if ! command -v openssl &> /dev/null; then
    echo "错误：OpenSSL 未安装，请先安装 OpenSSL。"
    exit 1
fi

# 第一步：生成根证书
echo "正在生成根证书..."

# 生成根证书私钥
echo "正在生成根证书私钥：${ROOT_KEY} ..."
openssl genrsa -out "${ROOT_KEY}"
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
