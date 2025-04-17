OUTPUT_DIR=./certs
VALID_DAYS=3650
ROOT_KEY="${OUTPUT_DIR}/root.key"
ROOT_CERT="${OUTPUT_DIR}/root.crt"
SERVER_CONFIG="./config/server.conf"
SERVER_KEY="${OUTPUT_DIR}/server.key"
SERVER_CSR="${OUTPUT_DIR}/server.csr"
SERVER_CERT="${OUTPUT_DIR}/server.crt"

echo "正在生成服务端证书..."

# 生成服务端证书私钥
echo "正在生成服务端证书私钥：${SERVER_KEY} ..."
openssl genrsa -out "${SERVER_KEY}"
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
