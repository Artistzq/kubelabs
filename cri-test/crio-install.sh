#!/bin/bash
set -o errexit -o nounset -o pipefail
export OS=Debian_11
export VERSION=1.24.6
export SUBVERSION=$(echo $VERSION | awk -F'.' '{print $1"."$2}')

# 安装所需包
echo "Installing Packages ..."
apt-get install -y tcpdump vim gnupg tzdata

# 安装cri-o
echo "Installing cri-o"
CONTAINERS_URL="https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/${OS}/"
CRIO_URL="http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/${SUBVERSION}:/${VERSION}/${OS}/"

echo "deb ${CONTAINERS_URL} /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb ${CRIO_URL} /" > /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:${VERSION}.list

curl -L ${CONTAINERS_URL}Release.key | apt-key add - || true
curl -L ${CRIO_URL}Release.key | apt-key add - || true

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get install -y cri-o cri-o-runc

ln -s /usr/libexec/podman/conmon /usr/local/bin/conmon

# 配置cri-o
echo "[crio.runtime]
cgroup_manager=\"cgroupfs\"
conmon_cgroup=\"pod\"
pause_image = \"k8s.gcr.io/pause:3.2\"
storage_driver = \"vfs\"" > /etc/crio/crio.conf

sed -i 's/containerd/crio/g' /etc/crictl.yaml

# 系统服务管理
systemctl disable containerd
systemctl enable crio

# 以上操作仅在当前临时环境中模拟了Dockerfile的步骤，实际构建Docker镜像时还需通过Dockerfile完成

