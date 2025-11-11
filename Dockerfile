FROM debian:13-slim

ARG OTEL_VERSION=0.139.0

RUN apt-get update && \
    apt-get install -y systemd wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget "https://github.com/open-telemetry/opentelemetry-collector-releases/releases/download/v${OTEL_VERSION}/otelcol-contrib_${OTEL_VERSION}_linux_arm64.tar.gz" && \
    tar -xzf "otelcol-contrib_${OTEL_VERSION}_linux_arm64.tar.gz" && \
    mv "otelcol-contrib" /usr/local/bin/otelcol-contrib && \
    rm "otelcol-contrib_${OTEL_VERSION}_linux_arm64.tar.gz"

RUN chmod +x /usr/local/bin/otelcol-contrib

RUN groupadd --system --gid 10001 otel && \
    useradd --system --uid 10001 --gid otel otel

RUN usermod -aG systemd-journal otel

USER otel

ENTRYPOINT ["/usr/local/bin/otelcol-contrib"]

CMD ["--config", "/etc/otelcol-contrib/config.yaml"]
