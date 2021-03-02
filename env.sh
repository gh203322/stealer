#!/usr/bin/env bash
set -eu

echo -e "******************************* 安装环境检测中... ************************************"


echo -e "***************************** 更新centos7阿里镜像源...********************************"
sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
sudo curl -s -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
sudo curl -s -o /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
sudo yum clean all
sudo yum makecache fast
sudo echo y | sudo yum update

echo -e "******************************* wget工具检测安装中...*********************************"
sudo echo y | sudo yum install wget

echo -e "******************************* docker环境检测安装中...*******************************"
#生成docker-ce.repo
sudo mkdir -p /etc/yum.repos.d/
cat>/etc/yum.repos.d/docker-ce.repo<<EOF
[docker-ce-stable]
name=Docker CE Stable - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/\$basearch/stable
enabled=1
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-stable-debuginfo]
name=Docker CE Stable - Debuginfo \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/debug-\$basearch/stable
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-stable-source]
name=Docker CE Stable - Sources
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/source/stable
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-edge]
name=Docker CE Edge - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/\$basearch/edge
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-edge-debuginfo]
name=Docker CE Edge - Debuginfo \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/debug-\$basearch/edge
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-edge-source]
name=Docker CE Edge - Sources
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/source/edge
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-test]
name=Docker CE Test - \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/\$basearch/test
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-test-debuginfo]
name=Docker CE Test - Debuginfo \$basearch
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/debug-\$basearch/test
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg

[docker-ce-test-source]
name=Docker CE Test - Sources
baseurl=https://mirrors.aliyun.com/docker-ce/linux/centos/7/source/test
enabled=0
gpgcheck=1
gpgkey=https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
EOF

install_docker(){
    sudo yum install -y yum-utils device-mapper-persistent-data lvm2
    #sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    sudo yum makecache fast
    sudo yum -y install docker-ce docker-ce-cli containerd.io
    sudo systemctl enable docker
    sudo systemctl start docker
    sudo docker version
}
#安装docker
path=`pwd`
install_docker

#配置docker加速地址
sudo mkdir -p /etc/docker/
cat>/etc/docker/daemon.json<<EOF
{ "registry-mirrors": ["https://7bezldxe.mirror.aliyuncs.com","https://registry.docker-cn.com"] }
EOF
systemctl daemon-reload
systemctl restart docker

echo -e "**************************** docker-compose环境检测安装中...****************************"
install_docker_compose(){
    #sudo mkdir -p ./docker-compose
    #sudo curl -s -o ./docker-compose/docker-compose https://gitee.com/tang_cheng_cheng/docker-compose-mirror/raw/master/1.28.2/docker-compose-Linux-x86_64
    sudo tar -zxvf ./env.tar.gz -C ./
    sudo chmod 777 -R ./docker-compose/*
    sudo echo y | rm /usr/bin/docker-compose
    sudo ln -s $path/docker-compose/docker-compose /usr/bin/docker-compose
    docker-compose -version
}
#安装docker-compose
install_docker_compose

echo -e "******************************* 安装环境准备完毕 ************************************"
