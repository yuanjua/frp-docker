FROM alpine:latest

ARG TARGETARCH
ARG FRP_VERSION

WORKDIR /frp
ENV TZ=Asia/Shanghai

RUN apk add --no-cache ca-certificates tzdata \
    && wget -qO- "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${TARGETARCH}.tar.gz" \
    | tar -xz --strip-components=1 -C /frp \
    # Keep only frpc, remove server
    && rm -f frps frps.toml LICENSE \
    && chmod +x frpc

# [No Command] Default reads /frp/frpc.toml inside container
CMD ["./frpc", "-c", "frpc.toml"]
