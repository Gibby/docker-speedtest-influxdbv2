FROM python:3.8-slim-bullseye

ARG BUILD_DATE

LABEL \
  maintainer="Gibby <gibby@twoitguys.com>" \
  org.opencontainers.image.authors="Gibby <gibby@twoitguys.com>" \
  org.opencontainers.image.title="docker-speedtest-influxdb" \
  org.opencontainers.image.description="Runs Ookla's Speedtest CLI program in Docker, sends the results to InfluxDB" \
  org.opencontainers.image.created=$BUILD_DATE

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && apt-get -y install --no-install-recommends \
    ca-certificates \
    curl \
    gnupg2 \
    tzdata && \
    curl -s https://install.speedtest.net/app/cli/install.deb.sh | bash && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://packagecloud.io/ookla/speedtest-cli/gpgkey | gpg --dearmor > /etc/apt/keyrings/ookla_speedtest-cli-archive-keyring.gpg && \
    apt-get update && apt-get -y install --no-install-recommends speedtest && \
    rm -rf /var/lib/apt/lists/* && \
    adduser --system speedtest

USER speedtest

WORKDIR /usr/src/app

COPY app .

RUN pip3 install --no-cache-dir -r requirements.txt

CMD ["python", "-u", "./speedtest.py"]
