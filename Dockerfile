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

# cfn-guard（install-guard.sh 実行 → 実体を /usr/local/bin へ）
# cfn-guard（install-guard.sh 実行 → 実体を /usr/local/bin へ）
RUN set -eux; \
  curl -sSfL https://raw.githubusercontent.com/aws-cloudformation/cloudformation-guard/main/install-guard.sh -o /tmp/install-guard.sh; \
  bash /tmp/install-guard.sh; \
  cp -L /root/.guard/bin/cfn-guard /usr/local/bin/cfn-guard; \
  chmod 0755 /usr/local/bin/cfn-guard; \
  rm -rf /root/.guard /tmp/install-guard.sh; \
  command -v cfn-guard; \
  cfn-guard --version