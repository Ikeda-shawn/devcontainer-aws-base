# ベースイメージ（必ず最初に置く）
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

ARG DEBIAN_FRONTEND=noninteractive
# 必要パッケージ
RUN apt-get update && apt-get install -y \
    python3 python3-pip python3-venv \
    curl unzip jq make git ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# PEP668 回避のため venv にインストール
RUN python3 -m venv /opt/venv \
 && /opt/venv/bin/pip install --no-cache-dir --upgrade pip \
 && /opt/venv/bin/pip install --no-cache-dir cfn-lint checkov
ENV PATH="/opt/venv/bin:${PATH}"

# cfn-guard（/usr/local/bin に直インストール）
RUN set -eux; \
  curl -sSfL https://raw.githubusercontent.com/aws-cloudformation/cloudformation-guard/main/install-guard.sh \
  | sh -s -- -b /usr/local/bin