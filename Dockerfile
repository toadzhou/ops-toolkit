# 第一阶段：构建环境
FROM alpine:latest AS builder

WORKDIR /workspace

# 替换为阿里云源并安装下载工具
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories && \
    apk add --no-cache curl grep sed

# --- 自动获取最新版本并下载 ---
RUN KUBE_LATEST=$(curl -L -s https://dl.k8s.io/release/stable.txt) && \
    curl -LO "https://dl.k8s.io/release/${KUBE_LATEST}/bin/linux/amd64/kubectl" && \
    chmod +x kubectl

# 修复点 1: 下载、解压后立即清理，避免干扰后续步骤
RUN HELM_TAG=$(curl -s https://api.github.com/repos/helm/helm/releases/latest | grep 'tag_name' | cut -d\" -f4) && \
    curl -LO "https://get.helm.sh/helm-${HELM_TAG}-linux-amd64.tar.gz" && \
    tar -zxvf helm-${HELM_TAG}-linux-amd64.tar.gz && \
    mv linux-amd64/helm . && \
    rm -rf linux-amd64 helm-${HELM_TAG}-linux-amd64.tar.gz

# 修复点 2: 明确解压目标，增加执行权限
RUN KUSTOMIZE_URL=$(curl -s https://api.github.com/repos/kubernetes-sigs/kustomize/releases/latest | grep "browser_download_url.*linux_amd64.tar.gz" | head -n 1 | cut -d '"' -f 4) && \
    curl -L -o kustomize.tar.gz "${KUSTOMIZE_URL}" && \
    tar -zxvf kustomize.tar.gz && \
    chmod +x kustomize && \
    rm kustomize.tar.gz

# --- 最终镜像 ---
FROM alpine:latest

# 替换为阿里云源
RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories

# 基础运维全家桶
RUN apk add --no-cache \
    git \
    openssh-client \
    bash \
    curl \
    jq \
    ca-certificates \
    tzdata \
    bind-tools \
    yq

# 从 builder 拷贝二进制
COPY --from=builder /workspace/kubectl /usr/local/bin/kubectl
COPY --from=builder /workspace/helm /usr/local/bin/helm
COPY --from=builder /workspace/kustomize /usr/local/bin/kustomize

WORKDIR /work
ENV SHELL="/bin/bash"

# 验证版本
CMD ["/bin/bash", "-c", "echo '--- Versions ---' && kubectl version --client && helm version && kustomize version && git --version"]
