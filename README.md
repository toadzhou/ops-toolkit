# ops-toolkit 🛠️

这是一个为云原生运维设计的轻量级工具箱镜像。

## 🧰 内置工具

* **Kubernetes**: `kubectl`, `helm`, `kustomize`
* **Data Processing**: `jq`, `yq`
* **Networking**: `curl`, `bind-tools` (dig, nslookup)
* **VCS**: `git`, `openssh`

## 🐳 快速使用

推荐挂载宿主机的 K8s 配置和当前工作目录，以便直接在容器内操作集群和本地文件：

```bash
docker run -it --rm \
  -v ~/.kube:/root/.kube \
  -v ~/.helm:/root/.config/helm \
  -v $(pwd):/work \
  toadzhou/ops-toolkit:latest \
  bash

```

> **提示**：在 CI/CD 流水线中，你可以直接将其作为基础镜像：`FROM toadzhou/ops-toolkit:latest`

---

## 🏗️ 手动构建 (本地)

如果你需要修改 Dockerfile 或在本地重新打包，可以使用以下命令。

### 1. 普通构建

```bash
docker build -t ops-toolkit:v1.0.1 .

```

### 2. 国内环境加速构建

由于构建过程中需要从 GitHub 和 Google 下载二进制文件，建议开启代理加速：

```bash
# 请将 10.1.254.1:10808 替换为你实际的代理地址
docker build \
  --build-arg http_proxy=http://10.1.254.1:10808 \
  --build-arg https_proxy=http://10.1.254.1:10808 \
  --build-arg HTTP_PROXY=http://10.1.254.1:10808 \
  --build-arg HTTPS_PROXY=http://10.1.254.1:10808 \
  -t ops-toolkit:v1.0.1 .

```

---

## 🤖 自动化集成

本项目已配置 **GitHub Actions**。只需在本地打上版本标签并推送，即可自动触发 Docker Hub 的构建与发布：

```bash
git tag v1.0.1
git push origin v1.0.1

```
