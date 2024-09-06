#!/usr/bin/env bash

user=`whoami`

sudo pacman -S --noconfirm --needed docker

if [ ! -d /etc/docker/ ]; then
  sudo mkdir /etc/docker/
fi

if [ ! -f /etc/docker/daemon.json ] || [ -z "`cat /etc/docker/daemon.json | grep registry-mirrors`" ]; then
echo '
{
  "registry-mirrors": [
    "https://hub-mirror.c.163.com",
    "https://mirror.baidubce.com",
    "https://dockerproxy.com",
    "https://ccr.ccs.tencentyun.com"
  ]
}' | sudo tee /etc/docker/daemon.json
fi

if [ ! -f /etc/systemd/system/docker.service.d/proxy.conf ]; then
sudo mkdir /etc/systemd/system/docker.service.d/
echo '
[Service]
Environment="HTTP_PROXY=http://10.7.43.30:1081"
Environment="HTTPS_PROXY=http://10.7.43.30:1081"
Environment="NO_PROXY=hub-mirror.c.163.com,mirror.baidubce.com,dockerproxy.com,ccr.ccs.tencentyun.com"
' | sudo tee /etc/systemd/system/docker.service.d/proxy.conf
fi

sudo usermod -aG docker $user
sudo systemctl daemon-reload