# 使用 Debian 作为基础镜像
FROM debian:bullseye-slim

# 设置环境变量，避免交互模式
ENV DEBIAN_FRONTEND=noninteractive

# 更新软件包列表并安装必要的依赖
RUN apt update -y && apt install -y \
    curl \
    wget \
    git \
    build-essential \
    ca-certificates \
    gettext-base \
    && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /app

# 下载并安装 Go
RUN wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz && \
    rm go1.21.0.linux-amd64.tar.gz

# 将 Go 路径添加到 PATH
ENV PATH="/usr/local/go/bin:${PATH}"

# 验证 Go 是否安装成功
RUN go version

# 安装 xcaddy 并验证
RUN go install github.com/caddyserver/xcaddy/cmd/xcaddy@latest && \
    /root/go/bin/xcaddy version

# 构建 Caddy
RUN /root/go/bin/xcaddy build --with github.com/caddyserver/forwardproxy@caddy2=github.com/klzgrad/forwardproxy@naive && \
    mv caddy /usr/local/bin/caddy

# 创建 Caddy 配置目录
RUN mkdir -p /etc/caddy

# 复制 Caddyfile 模板
COPY Caddyfile.template /app/Caddyfile.template

# 暴露端口（默认 443 和 80，但可以通过环境变量覆盖）
EXPOSE 443 80

# 设置启动命令
CMD ["sh", "-c", "envsubst < /app/Caddyfile.template > /etc/caddy/Caddyfile && caddy run --config /etc/caddy/Caddyfile --adapter caddyfile"]
