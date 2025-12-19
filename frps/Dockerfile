FROM alpine:latest

ARG TARGETARCH
ARG FRP_VERSION

# Set minimalist working directory
WORKDIR /frp

# Preset timezone to Shanghai (can be overridden in compose via environment variable)
ENV TZ=Asia/Shanghai

# Complete all operations in one command to reduce image layers
RUN apk add --no-cache ca-certificates tzdata \
    # Download latest version and extract
    && wget -qO- "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${TARGETARCH}.tar.gz" \
    | tar -xz --strip-components=1 -C /frp \
    # Keep only frps and example config, remove client and useless files
    && rm -f frpc frpc.toml LICENSE \
    && chmod +x frps

# [No Command] Default reads /frp/frps.toml inside container
CMD ["./frps", "-c", "frps.toml"]
