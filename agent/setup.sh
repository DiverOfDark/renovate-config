#!/bin/sh
# Tools for agent.py in the job container (node:24-trixie): PyYAML, gh, kubectl, Claude
# Code, and cargo for regenerating Cargo.lock after a fix (resolution only, no builds).
# Versions are pinned; Renovate bumps them (customManagers in renovate.json).
set -eu

GH_VERSION=2.105.0 # renovate: datasource=github-releases depName=cli/cli
KUBECTL_VERSION=1.37.2 # renovate: datasource=github-releases depName=kubernetes/kubernetes
CLAUDE_CODE_VERSION=2.1.330 # renovate: datasource=npm depName=@anthropic-ai/claude-code
RUST_VERSION=1.100.0 # renovate: datasource=docker depName=rust

arch=$(dpkg --print-architecture)
apt-get update -qq
apt-get install -y -qq --no-install-recommends python3-yaml >/dev/null

curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_linux_${arch}.tar.gz" \
  | tar -xz -C /usr/local --strip-components=1 "gh_${GH_VERSION}_linux_${arch}/bin/gh"
curl -fsSLo /usr/local/bin/kubectl "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/${arch}/kubectl"
chmod +x /usr/local/bin/kubectl
npm install --global --silent "@anthropic-ai/claude-code@${CLAUDE_CODE_VERSION}"
curl -fsSL https://sh.rustup.rs | sh -s -- -y --quiet --profile minimal --default-toolchain "${RUST_VERSION}" --no-modify-path
ln -sf "${HOME}/.cargo/bin/cargo" /usr/local/bin/cargo

gh --version | head -1
kubectl version --client | head -1
claude --version
cargo --version
