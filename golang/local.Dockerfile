FROM golang:1.25 AS builder

ENV GOPROXY=https://goproxy.cn,direct

WORKDIR /build

COPY go.mod go.sum ./
RUN go mod download
COPY . .

RUN go build -o /app/main main.go

# 最终镜像
FROM alpine AS final

COPY --from=builder /usr/share/zoneinfo/Asia/Shanghai /usr/share/zoneinfo/Asia/Shanghai
ENV TZ=Asia/Shanghai

WORKDIR /app
COPY --from=builder /app/main /app/main
ENV CONFIG_NAME=config

# 修正：Alpine 默认没有 /bin/bash，建议直接执行或使用 /bin/sh
ENTRYPOINT ["/bin/sh", "-c", "./main"]
