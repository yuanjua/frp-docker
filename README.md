# FRP Docker Images

A latest Docker build for FRP (Fast Reverse Proxy).
最新的 FRP 镜像(每日更新)。
https://github.com/yuanjua/frp-docker.git

## Installation

### Server (frps) 服务器

`docker-compose.yml`:

```yaml
version: '3.8'
services:
  frps:
    image: yuanjua/frps:latest # OR ghcr.io/yuanjua/frps:latest
    container_name: frps
    restart: always
    network_mode: host
    volumes:
      - ./frps.toml:/frp/frps.toml
    environment:
      - TZ=Asia/Shanghai
```

Example `frps.toml`:

```toml
# frps.toml
bindPort = 7000
vhostHTTPPort = 80
auth.token = "12345678"  # Change to Strong Token

```

Start the server:

```bash
docker compose up -d 
```

### Client (frpc) 客户端

`docker-compose.yml`:

```yaml
version: '3.8'
services:
  frpc:
    image: yuanjua/frpc:latest # OR ghcr.io/yuanjua/frpc:latest
    container_name: frpc
    restart: always
    network_mode: host
    volumes:
      - ./frpc.toml:/frp/frpc.toml
    environment:
      - TZ=Asia/Shanghai
```

Example `frpc.toml`:

```toml
# frpc.toml
serverAddr = "1.2.3.4"
serverPort = 7000
auth.token = "12345678" # Must Match Server Token

[[proxies]]
name = "ssh-tcp"
type = "tcp"
localIP = "127.0.0.1"
localPort = 22
remotePort = 6000
```

Start the client:

```bash
docker compose up -d 
```

## Build from Source

```bash
docker buildx build --build-arg FRP_VERSION=0.65.0 -t local/frps:test ./frps --load

docker buildx build --build-arg FRP_VERSION=0.65.0 -t local/frpc:test ./frpc --load
```

## Architecture Support

This image is built as a **multi-arch manifest**. 
- `latest` supports both `linux/amd64` and `linux/arm64`. 支持 AMD64 和 ARM64 架构。
- Docker will automatically pull the correct architecture for your device.  Docker 会自动拉取适合您设备的架构。 
