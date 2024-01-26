ARG IMAGE_VERSION=v0.0.1

# 使用官方的Golang基础镜像作为父镜像
FROM golang:latest as builder

# 设置工作目录
WORKDIR /app

# 将项目文件复制到容器的工作目录中
COPY . .

ENV CGO_ENABLED=0

# 构建应用
RUN go build -o main .

# 使用一个新的轻量级基础镜像，例如Alpine
FROM alpine:latest

RUN apk update

# 安装curl和其他可能需要的依赖
RUN apk add --no-cache curl

WORKDIR /app

# 复制编译好的二进制文件到新镜像中
COPY --from=builder /app/main /app/

# 设置工作目录和提供运行时环境
WORKDIR /app
CMD ["./main"]

# 声明运行时容器提供的服务端口
EXPOSE 8080
