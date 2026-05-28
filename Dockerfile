FROM node:20-trixie-slim

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Minimal dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    unzip \
    make \
    python3 python3-venv python3-pip \
 && rm -rf /var/lib/apt/lists/*

# Install GitHub CLI (gh)
RUN mkdir -p -m 755 /etc/apt/keyrings \
 && curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
 && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" > /etc/apt/sources.list.d/github-cli.list \
 && apt-get update \
 && apt-get install -y --no-install-recommends gh \
 && rm -rf /var/lib/apt/lists/*

# Install uv (as root, in system PATH) for running serena mcp server and installing claude-monitor
RUN curl -LsSf https://astral.sh/uv/install.sh | \
    UV_INSTALL_DIR=/usr/local/bin INSTALLER_NO_MODIFY_PATH=1 sh \
 && chmod +x /usr/local/bin/uv /usr/local/bin/uvx

# Cleaning the cache, update npm, install MCP CLI tools
RUN npm cache clean --force \
 && npm install -g npm@11.11.1 \
 && npm install -g backlog.md@1.44.0

# Install Rust to system paths
ENV RUSTUP_HOME=/usr/local/rustup
ENV CARGO_HOME=/usr/local/cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path \
 && chmod -R a+rx /usr/local/rustup /usr/local/cargo
ENV PATH="/usr/local/cargo/bin:${PATH}"

# Non-root user (security)
RUN useradd -m aiuser
USER aiuser

WORKDIR /workspace

# Environment
ENV HOME=/home/aiuser
ENV PATH="/home/aiuser/.local/bin:/usr/local/bin:${PATH}"

# Install AI tools
RUN curl -fsSL https://claude.ai/install.sh | bash
RUN curl -LsSf https://mistral.ai/vibe/install.sh | bash
RUN curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | sh
