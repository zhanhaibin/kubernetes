使用RKE在阿里ECS单机部署K8s


Kubernetes 是Google的一种基于容器的开源服务编排解决方案，在我们进行Kubernetes的学习前,为了对Kubernetes的工作有一个大概的认识, 我们需要先安装一个单节点的实例服务,用于平常的开发与测试。在官网 中，有各种各样的搭建方式，但这里我们想要有更贴近实际的例子，只有这样才能让docker和k8s体现出关系的紧密。

我们先看k8s的架构图，以便对它的部署有个直观的了解

![image](https://github.com/zhanhaibin/kubernetes/blob/master/docs/images/an-introduction-to-kubernetes-21-638.jpg)


一、环境准备

1、宿主机系统：Ubuntu16.04

2、docker源：阿里云

二、安装前准备

1、添加docker源
```
cat >/etc/apt/sources.list.d/docker-main.list<<EOF
deb [arch=amd64] http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial main
EOF
```

2、Add Docker’s official GPG key:
```
curl -fsSL https://apt.dockerproject.org/gpg | sudo apt-key add -
```

3、更新源和升级系统
```
apt-get update && apt-get upgrade -y 
```

4、卸载旧版本docker
```
apt-get purge lxc-docker*
```

5、列出docker版本
```
apt-cache policy docker-engine


docker-engine:
  Installed: 1.12.6-0~ubuntu-xenial
  Candidate: 17.05.0~ce-0~ubuntu-xenial
  Version table:
     17.05.0~ce-0~ubuntu-xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
     17.04.0~ce-0~ubuntu-xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
     17.03.1~ce-0~ubuntu-xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
     17.03.0~ce-0~ubuntu-xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
     1.13.1-0~ubuntu-xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
     1.13.0-0~ubuntu-xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
 *** 1.12.6-0~ubuntu-xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
        100 /var/lib/dpkg/status
     1.12.5-0~ubuntu-xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
     1.12.4-0~ubuntu-xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
     1.12.3-0~xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
     1.12.2-0~xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
     1.12.1-0~xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
     1.12.0-0~xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
     1.11.2-0~xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
     1.11.1-0~xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages
     1.11.0-0~xenial 500
        500 http://mirrors.aliyun.com/docker-engine/apt/repo ubuntu-xenial/main amd64 Packages

```

6、安装指定版本

apt-get install -y docker-engine=xxxxx

本次安装使用的是docker 1.12.6

```
apt-get install -y docker-engine=1.12.6-0~ubuntu-xenial
```

7、查看docker 版本
```
docker version

Client:
 Version:      1.12.6
 API version:  1.24
 Go version:   go1.6.4
 Git commit:   78d1802
 Built:        Tue Jan 10 20:38:45 2017
 OS/Arch:      linux/amd64

Server:
 Version:      1.12.6
 API version:  1.24
 Go version:   go1.6.4
 Git commit:   78d1802
 Built:        Tue Jan 10 20:38:45 2017
 OS/Arch:      linux/amd64

 ```

三、Linux系统（Ubuntu16.04）ssh配置无密码登录

原理是验证公钥而不验证密码

1、配置本机无密码登录
```
ssh-keygen -t rsa
```
三次回车后，生成公钥。

2、将公钥追加到 authorized_keys 文件中
```
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
```
3、赋予 authorized_keys 文件权限
```
chmod 600 ~/.ssh/authorized_keys
```
4、验证是否成功
```
ssh  localhost
```

四、安装K8s

1、下载rke工具。

可以从https://github.com/rancher/rke/releases 下载最新版本

```
wget https://github.com/rancher/rke/releases/download/v0.0.12-dev/rke_linux-amd64
```
2、下载rke需要的docker镜像

提前下载好，在安装过程中就不会在重新下载等待了。而且镜像里有的需要翻墙下载。

默认安装需要的镜像列表

```
docker pull quay.io/coreos/etcd:latest
docker pull rancher/rke-nginx-proxy:v0.1.1
docker pull rancher/rke-service-sidekick:v0.1.0
docker pull rancher/rke-cert-deployer:v0.1.1
docker pull alpine:latest
docker pull rancher/k8s:v1.8.3-rancher2
docker pull quay.io/coreos/flannel:v0.9.1
docker pull quay.io/coreos/flannel-cni:v0.2.0
docker pull gcr.io/google_containers/pause-amd64:3.0
docker pull gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.5
docker pull gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.5
docker pull gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.5
docker pull gcr.io/google_containers/cluster-proportional-autoscaler-amd64:1.0.0
```

为了能在墙内使用，已经将几个镜像上传到个人的阿里云镜像仓库里。

登录阿里元私有镜像仓库
```
docker pull registry.cn-qingdao.aliyuncs.com/zhanhaibin/pause-amd64:3.0
docker pull registry.cn-qingdao.aliyuncs.com/zhanhaibin/k8s-dns-kube-dns-amd64:1.14.5
docker pull registry.cn-qingdao.aliyuncs.com/zhanhaibin/k8s-dns-dnsmasq-nanny-amd64:1.14.5
docker pull registry.cn-qingdao.aliyuncs.com/zhanhaibin/k8s-dns-sidecar-amd64:1.14.5
docker pull registry.cn-qingdao.aliyuncs.com/zhanhaibin/cluster-proportional-autoscaler-amd64:1.0.0
docker pull registry.cn-qingdao.aliyuncs.com/zhanhaibin/kubernetes-dashboard-amd64:v1.8.2
```

```
docker tag registry.cn-qingdao.aliyuncs.com/zhanhaibin/pause-amd64:3.0 gcr.io/google_containers/pause-amd64:3.0
docker tag registry.cn-qingdao.aliyuncs.com/zhanhaibin/k8s-dns-kube-dns-amd64:1.14.5 gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.5
docker tag registry.cn-qingdao.aliyuncs.com/zhanhaibin/k8s-dns-dnsmasq-nanny-amd64:1.14.5 gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.5
docker tag registry.cn-qingdao.aliyuncs.com/zhanhaibin/k8s-dns-sidecar-amd64:1.14.5 gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.5
docker tag registry.cn-qingdao.aliyuncs.com/zhanhaibin/cluster-proportional-autoscaler-amd64:1.0.0 gcr.io/google_containers/cluster-proportional-autoscaler-amd64:1.0.0
docker tag registry.cn-qingdao.aliyuncs.com/zhanhaibin/kubernetes-dashboard-amd64:v1.8.2  k8s.gcr.io/kubernetes-dashboard-amd64:v1.8.2

docker rmi registry.cn-qingdao.aliyuncs.com/zhanhaibin/pause-amd64:3.0
docker rmi registry.cn-qingdao.aliyuncs.com/zhanhaibin/k8s-dns-kube-dns-amd64:1.14.5
docker rmi registry.cn-qingdao.aliyuncs.com/zhanhaibin/k8s-dns-dnsmasq-nanny-amd64:1.14.5
docker rmi registry.cn-qingdao.aliyuncs.com/zhanhaibin/k8s-dns-sidecar-amd64:1.14.5
docker rmi registry.cn-qingdao.aliyuncs.com/zhanhaibin/cluster-proportional-autoscaler-amd64:1.0.0
docker rmi registry.cn-qingdao.aliyuncs.com/zhanhaibin/kubernetes-dashboard-amd64:v1.8.2

```

3、修改安装的配置信息

cluster.yml

```

---
auth:
  strategy: x509
  options:
    foo: bar

# supported plugins are:
# flannel
# calico
# canal
# weave
#
# If you are using calico on AWS or GCE, use the network plugin config option:
# 'calico_cloud_provider: aws'
# or
# 'calico_cloud_provider: gce'
network:
  plugin: flannel
  options:
    flannel_image: quay.io/coreos/flannel:v0.9.1
    flannel_cni_image: quay.io/coreos/flannel-cni:v0.2.0

ssh_key_path: ~/.ssh/rsa   #路径改为自己的证书路径
enforce_docker_version: false
# Kubernetes authorization mode; currently only `rbac` is supported and enabled by default.
# Use `mode: none` to disable authorization
authorization:
  mode: rbac
  options:

nodes:
  - address: 1.1.1.1   #改成自己的IP
    user: root
    role: [controlplane, etcd,worker]
    ssh_key_path: ~/.ssh/id_rsa     #路径改为自己的证书路径
services:
  etcd:
    image: quay.io/coreos/etcd:latest
  kube-api:
    image: rancher/k8s:v1.8.3-rancher2
    service_cluster_ip_range: 10.233.0.0/18
    pod_security_policy: false
    extra_args:
      v: 4
  kube-controller:
    image: rancher/k8s:v1.8.3-rancher2
    cluster_cidr: 10.233.64.0/18
    service_cluster_ip_range: 10.233.0.0/18
  scheduler:
    image: rancher/k8s:v1.8.3-rancher2
  kubelet:
    image: rancher/k8s:v1.8.3-rancher2
    extra_args: {"cgroup-driver":"systemd","fail-swap-on":"false"}
    cluster_domain: cluster.local
    cluster_dns_server: 10.233.0.3
    infra_container_image: gcr.io/google_containers/pause-amd64:3.0
  kubeproxy:
    image: rancher/k8s:v1.8.3-rancher2


system_images:
  alpine: alpine:latest
  nginx_proxy: rancher/rke-nginx-proxy:v0.1.1
  cert_downloader: rancher/rke-cert-deployer:v0.1.1
  service_sidekick_image: rancher/rke-service-sidekick:v0.1.0
  kubedns_image: gcr.io/google_containers/k8s-dns-kube-dns-amd64:1.14.5
  dnsmasq_image: gcr.io/google_containers/k8s-dns-dnsmasq-nanny-amd64:1.14.5
  kubedns_sidecar_image: gcr.io/google_containers/k8s-dns-sidecar-amd64:1.14.5
  kubedns_autoscaler_image: gcr.io/google_containers/cluster-proportional-autoscaler-amd64:1.0.0
```

4、开始安装

```
./rke_linux-amd64 up --config cluster.yml
```

5、安装kubectl工具
 
RKE会在配置文件所在的目录下部署一个本地文件，该文件中包含kube配置信息以连接到新生成的群集。默认情况下，kube配置文件被称为.kube_config_cluster.yml。将这个文件复制到你的本地~/.kube/config，就可以在本地使用kubectl了。

需要注意的是，部署的本地kube配置名称是和集群配置文件相关的。例如，如果您使用名为mycluster.yml的配置文件，则本地kube配置将被命名为.kube_config_mycluster.yml。

cp .kube_config_cluster.yml   ~/.kube/config

参考https://kubernetes.io/docs/tasks/tools/install-kubectl/ 安装kubtctl

kubectl v1.8 下载地址

https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG-1.8.md#client-binaries
```
wget https://dl.k8s.io/v1.8.7/kubernetes-client-linux-amd64.tar.gz
```

如果下载不下来，被墙了。个人kubectlv1.8.7墙内下载

https://pan.baidu.com/s/1mjBHcuc

下载后解压
```
tar -zxvf kubernetes-client-linux-amd64.tar.gz

cd kubernetes/client/bin/

chmod +x ./kubectl

sudo mv ./kubectl /usr/local/bin/kubectl
```

6、安装k8s dashboard 

下载dashboard的yaml文件
```
wget https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

kubectl create -f kubernetes-dashboard.yaml
```

由于1.8以后版本，增加的RBAC权限模型，所以UI上会报错。

如果浏览器会出现 

User “system:serviceaccount:kube-system:kubernetes-dashboard” cannot list statefulsets.apps in the namespace “default”的错误

解决办法是创建kubernetes-dashboard-admin.yaml文件对ServiceAccount进行授权


增加kubernetes-dashboard-admin.yaml 文件

kubernetes-dashboard-admin.yaml
```
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: kubernetes-dashboard
  labels:
    k8s-app: kubernetes-dashboard
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: kubernetes-dashboard
  namespace: kube-system



kubectl create -f kubernetes-dashboard-admin.yaml


kubectl proxy --address='0.0.0.0' --disable-filter=true

```
访问

http://10.10.64.140:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/