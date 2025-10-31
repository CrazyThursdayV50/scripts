# 使用 BUILDPLATFORM 提高编译速度
FROM --platform=$BUILDPLATFORM golang:1.25 AS builder
ARG TARGETOS
ARG TARGETARCH

# 环境变量：国内加速
ENV GOPROXY=https://goproxy.cn,direct

# 核心步骤：安装交叉编译器
# 如果目标是 amd64，需要 gcc-x86-64-linux-gnu
# 如果目标是 arm64，需要 gcc-aarch64-linux-gnu
RUN apt-get update && apt-get install -y --no-install-recommends \
	gcc-x86-64-linux-gnu \
	libc6-dev-amd64-cross \
	gcc-aarch64-linux-gnu \
	libc6-dev-arm64-cross \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download
COPY . .

# 关键：根据目标架构动态设置 CC (C 编译器)
RUN if [ "$TARGETARCH" = "amd64" ]; then \
	export CC=x86_64-linux-gnu-gcc; \
	elif [ "$TARGETARCH" = "arm64" ]; then \
	export CC=aarch64-linux-gnu-gcc; \
	fi && \
	CGO_ENABLED=1 GOOS=${TARGETOS} GOARCH=${TARGETARCH} \
	go build -ldflags '-linkmode "external" -extldflags "-static"' \
	-o /app/main main.go

# 最终镜像
FROM alpine AS final
# 安装 tzdata 以确保时区文件可用
RUN apk add --no-cache tzdata ca-certificates

COPY --from=builder /usr/share/zoneinfo/Asia/Shanghai /usr/share/zoneinfo/Asia/Shanghai
ENV TZ=Asia/Shanghai

WORKDIR /app
COPY --from=builder /app/main /app/main
ENV CONFIG_NAME=config

# 修正：Alpine 默认没有 /bin/bash，建议直接执行或使用 /bin/sh
ENTRYPOINT ["/bin/sh", "-c", "./main"]
