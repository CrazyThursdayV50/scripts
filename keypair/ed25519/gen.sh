#!/bin/bash

# 文件名：generate_ed25519_openssl.sh

PRIVATE_KEY_FILE="ed25519_private.pem"
PUBLIC_KEY_FILE="ed25519_public.pem"

echo "--- 正在使用 OpenSSL 生成 ed25519 密钥对 ---"

# 1. 生成私钥文件 (ed25519_private.pem)
echo "1. 正在生成私钥 ($PRIVATE_KEY_FILE)..."
openssl genpkey -algorithm ed25519 -out "$PRIVATE_KEY_FILE"

# 检查私钥是否生成成功
if [ $? -ne 0 ]; then
    echo "❌ 私钥生成失败。请检查 OpenSSL 命令是否可用或权限问题。"
    exit 1
fi

# 2. 从私钥中提取公钥文件 (ed25519_public.pem)
echo "2. 正在提取公钥 ($PUBLIC_KEY_FILE)..."
openssl pkey -in "$PRIVATE_KEY_FILE" -pubout -out "$PUBLIC_KEY_FILE"

# 检查公钥是否提取成功
if [ $? -ne 0 ]; then
    echo "❌ 公钥提取失败。"
    # 如果公钥提取失败，删除已生成的私钥，保持操作的原子性
    rm -f "$PRIVATE_KEY_FILE"
    exit 1
fi

echo "✅ OpenSSL ed25519 密钥对生成成功！"
echo "私钥文件 (PEM 格式)：$PRIVATE_KEY_FILE"
echo "公钥文件 (PEM 格式)：$PUBLIC_KEY_FILE"
echo "------------------------------------------------"
