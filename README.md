# ops-toolkit 🛠️

这是一个为云原生运维设计的轻量级工具箱镜像。

## 🧰 内置工具
- **Kubernetes**: `kubectl`, `helm`, `kustomize`
- **Data Processing**: `jq`, `yq`
- **Networking**: `curl`, `bind-tools` (dig, nslookup)
- **VCS**: `git`, `openssh`

## 🐳 快速使用
```bash
# 进入交互式环境
docker run -it --rm \
-v ~/.kube:/root/.kube \
-v ~/.helm:/root/.config/helm \
-v $(pwd):/work \
toadzhou/ops-toolkit:latest \
bash

# 在 CI/CD 中作为 Base 镜像
# FROM toadzhou/ops-toolkit:latest
```