# Optimized FRP Docker Images

A minimalist Docker build for FRP (Fast Reverse Proxy).

## Quick Start

### Server (frps)

`docker-compose.yml`:

```yaml
version: '3.8'
services:
  frps:
    image: yuanjua/frps:latest
    container_name: frps
    restart: always
    network_mode: host
    volumes:
      - ./frps.toml:/frp/frps.toml
    environment:
      - TZ=Asia/Shanghai
```

### Client (frpc)

`docker-compose.yml`:

```yaml
version: '3.8'
services:
  frpc:
    image: yuanjua/frpc:latest
    container_name: frpc
    restart: always
    network_mode: host
    volumes:
      - ./frpc.toml:/frp/frpc.toml
    environment:
      - TZ=Asia/Shanghai
```

## Architecture Support

This image is built as a **multi-arch manifest**. 
- `latest` supports both `linux/amd64` and `linux/arm64`.
- Docker will automatically pull the correct architecture for your device.
