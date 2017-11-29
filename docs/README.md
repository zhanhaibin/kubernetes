单节点k8s安装

Kubernetes 是Google的一种基于容器的开源服务编排解决方案，在我们进行Kubernetes的学习前,为了对Kubernetes的工作有一个大概的认识, 我们需要先安装一个单节点的实例服务,用于平常的开发与测试。在官网 中，有各种各样的搭建方式，但这里我们想要有更贴近实际的例子，只有这样才能让docker和k8s体现出关系的紧密。

我们先看k8s的架构图，以便对它的部署有个直观的了解

![image](https://github.com/zhanhaibin/kubernetes/blob/master/docs/images/an-introduction-to-kubernetes-21-638.jpg)


环境准备
本文的例子是基于Centos 7的Linux版本，大家也可以使用ubuntu或其他发行版，软件搭建的方式基本是差不多的，为了让例子更简单， 本文省去了网络Fannel的安装与配置，只做基本通用的开发环境搭建，希望对大家有帮助。

本例子用于测试的服务器，虚拟机安装centos  7 ,ip为：10.10.64.133

yum源

为了让国内下载etcd和kubernetes更流畅，我们先切换阿里云的yum源

wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo

yum makecache

关闭防火墙服务

centos7 默认使用firewall为防火墙，而Kubernetes的Master与工作Node之间会有大量的网络通信，安全的做法是在防火墙上配置各种需要相互通讯的端口号，在一个安全的内部网络环境中可以关闭防火墙服务；

这里我们将其更改为iptables，具体步骤如下：

systemctl disable firewalld.service

systemctl stop firewalld.service

安装iptables，其操作为：

yum install -y iptables-services

systemctl start iptables.service

systemctl enable iptables.service

安装etcd和Kubernetes软件（docker会在安装kubernetes的过程中被安装）

yum install -y etcd kubernetes

配置修改

安装完服务组件后，我们需要修改相关的配置

Docker配置文件 /etc/sysconfig/docker，其中的OPTIONS的内容设置为：

vim /etc/sysconfig/docker

OPTIONS='--selinux-enabled=false --insecure-registry gcr.io'

Kubernetes修改apiserver的配置文件，在/etc/kubernetes/apiserver中

vim /etc/kubernetes/apiserver

 KUBE_ADMISSION_CONTROL="--admission_control=NamespaceLifecycle,NamespaceExists,
 LimitRanger,SecurityContextDeny,ServiceAccount,ResourceQuota"

去掉 ServiceAccount 选项。否则会在往后的pod创建中，会出现类似以下的错误：

 Error from server: error when creating "mysql-rc.yaml": Pod "mysql" is forbidden:
 no API token found for service account default/default, 
 retry after the token is automatically created and added to the service account

切换docker hub 镜像源

在国内为了稳定pull镜像，我们最好使用Daocloud的镜像服务 :)

curl -sSL https://get.daocloud.io/daotools/set_mirror.sh | sh -s http://dbe35452.m.daocloud.io

按顺序启动所有服务

systemctl start etcd

systemctl start docker

systemctl start kube-apiserver.service

systemctl start kube-controller-manager.service

systemctl start kube-scheduler.service

systemctl start kubelet.service

systemctl start kube-proxy.service

然后，我们检验下kubernetes的服务是否跑起来

ps -ef | grep kube

到目前为止，一个单机版的Kubernetes的环境就安装启动完成了。接下来，我就基于这个单机版，撸起袖子，认真干！！！

启动MySQL容器服务
我们先拉取mysql的服务镜像 ：

sudo docker pull mysql
或
docker pull hub.c.163.com/library/mysql:latest

启动MySQL服务

首先为MySQL服务创建一个RC定义文件：mysql-rc.yaml，下面给出了该文件的完整内容

apiVersion: v1
kind: ReplicationController
metadata:
  name: mysql
spec:
  replicas: 1
  selector:
    app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
      - name: mysql
        image: hub.c.163.com/library/mysql
        ports: 
        - containerPort: 3306
        env:
        - name: MYSQL_ROOT_PASSWORD
          value: "123456"

yaml定义文件说明：

kind：表明此资源对象的类型，例如上面表示的是一个RC
spec: 对RC的相关属性定义，比如说spec.selector是RC的Pod标签（Label）选择器，既监控和管理拥有这些表情的Pod实例，确保当前集群上始终有且 仅有replicas个Pod实例在运行。
spec.template定义pod的模板，这些模板会在当集群中的pod数量小于replicas时，被作为依据去创建新的Pod
创建好 mysql-rc.yaml后， 为了将它发布到Kubernetes中，我们在Master节点执行命令

kubectl create -f mysql-rc.yaml

replicationcontroller "mysql” created
接下来，我们用kuberctl命令查看刚刚创建的RC:

kubectl get rc

NAME      DESIRED   CURRENT   READY     AGE
mysql     1         1         0         14s

查看Pod的创建情况，可以运行下面的命令：

kubectl get pods

NAME          READY     STATUS              RESTARTS   AGE
mysql-b0gk0   0/1       ContainerCreating   0          3s

可见pod的状态处于ContainerCreating，我们需要耐心等待一下，直到状态为Running

NAME          READY     STATUS    RESTARTS   AGE
mysql-b0gk0   1/1       Running   0          6m

如果状态一直是ContainerCreating状态，可以使用

kubectl describe pod mysql 

查看节点状态

[root@Master mysql]# kubectl describe pod mysql
Name:           mysql-4vsp1
Namespace:      default
Node:           127.0.0.1/127.0.0.1
Start Time:     Wed, 29 Nov 2017 15:51:44 +0800
Labels:         app=mysql
Status:         Pending
IP:
Controllers:    ReplicationController/mysql
Containers:
  mysql:
    Container ID:
    Image:              hub.c.163.com/library/mysql
    Image ID:
    Port:               3306/TCP
    State:              Waiting
      Reason:           ContainerCreating
    Ready:              False
    Restart Count:      0
    Volume Mounts:      <none>
    Environment Variables:
      MYSQL_ROOT_PASSWORD:      123456
Conditions:
  Type          Status
  Initialized   True
  Ready         False
  PodScheduled  True
No volumes.
QoS Class:      BestEffort
Tolerations:    <none>
Events:
  FirstSeen     LastSeen        Count   From                    SubObjectPath   Type            Reason          Message
  ---------     --------        -----   ----                    -------------   --------        ------          -------
  2s            2s              1       {default-scheduler }                    Normal          Scheduled       Successfully assigned mysql-4vsp1 to 127.0.0.1
  2s            2s              1       {kubelet 127.0.0.1}                     Warning         FailedSync      Error syncing pod, skipping: failed to "StartContainer" for "POD" with ErrImagePull: "image pull failed for registry.access.redhat.com/rhel7/pod-infrastructure:latest, this may be because there are no credentials on this request.  details: (open /etc/docker/certs.d/registry.access.redhat.com/redhat-ca.crt: no such file or directory)"

看到registry.access.redhat.com/rhel7/pod-infrastructure:latest感觉很奇怪，我设置的仓库是grc.io，为什么去拉取这个镜像，怀疑是不是什么没有安装好。
尝试运行docker pull registry.access.redhat.com/rhel7/pod-infrastructure:latest，提示redhat-ca.crt: no such file or directory。
ls查看改文件是个软连接，链接目标是/etc/rhsm，查看没有rhsm，尝试安装yum install *rhsm*，出现相关软件，感觉比较符合，所以安装查看产生了/etc/rhsm文件夹。

重新查看pod状态，发现已经成功Running

[root@Master mysql]# kubectl get pods
NAME          READY     STATUS    RESTARTS   AGE
mysql-kqxcw   1/1       Running   0          35m



最后，我们创建一个与之关联的Kubernetes Service - MySQL的定义文件：mysql-svc.yaml

apiVersion: v1
kind: Service
metadata: 
  name: mysql
spec:
  ports:
    - port: 3306
  selector:
    app: mysql
其中 metadata.name是Service的服务名，port定义服务的端口，spec.selector确定了哪些Pod的副本对应本地的服务。

运行kuberctl命令，创建service：

$ kubectl create -f mysql-svc.yaml

service "mysql" created
然后我们查看service的状态

$ kubectl get svc

NAME         CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
kubernetes   10.254.0.1      <none>        443/TCP    18m
mysql        10.254.185.20   <none>        3306/TCP   14s
注意到MySQL服务被分配了一个值为 10.254.185.20的CLUSTER-IP，这是一个虚地址，随后，Kubernetes集群中的其他新创建的Pod就可以通过Service 的CLUSTER-IP+端口6379来连接和访问它了。

启动Web容器服务
先拉取一个测试镜像到本地

docker pull kubeguide/tomcat-app:v1
上面我们定义和启动了MySQL的服务，接下来我们用同样的步骤，完成Tomcat应用的服务启动过程，首先我们创建对应的RC文件 myweb-rc.yaml，具体内容如下：

apiVersion: v1
kind: ReplicationController
metadata:
  name: myweb
spec:
  replicas: 5
  selector:
    app: myweb
  template:
    metadata:
      labels:
        app: myweb
    spec:
      containers:
      - name: myweb
        image: docker.io/kubeguide/tomcat-app:v1
        ports: 
        - containerPort: 8080
        env:
        - name: MYSQL_SERVICE_HOST
          value: "mysql"
        - name: MYSQL_SERVICE_PORT
          value: "3306"
与mysql一样，我们创建rc服务：

$ kubectl create -f myweb-rc.yaml
replicationcontroller "myweb" created

$ kubectl get rc
NAME      DESIRED   CURRENT   READY     AGE
mysql     1         1         0         14m
myweb     5         5         0         10s
接着，我们看下pods的状态：

$ kubectl get pods
NAME          READY     STATUS    RESTARTS   AGE
mysql-b0gk0   1/1       Running   0          15m
myweb-1oyb7   1/1       Running   0          43s
myweb-8ffs6   1/1       Running   0          43s
myweb-xge1t   1/1       Running   0          43s
myweb-xr214   1/1       Running   0          43s
myweb-zia37   1/1       Running   0          43s
wow..从命理结果我们发现，我们yaml中声明的5个副本都被创建并运行起来了，我们隐约感受到k8s的威力咯

我们创建对应的Service, 相关的myweb-svc文件如下：

apiVersion: v1
kind: Service
metadata: 
  name: myweb
spec:
  type: NodePort
  ports:
    - port: 8080
      nodePort: 30001
  selector:
    app: myweb
运行kubectl create 命令进行创建

$ kubectl create  -f myweb-svc.yaml
service "myweb" created
最后，我们使用kubectl查看前面创建的Service

[root@kdev tmp]# kubectl get services
NAME         CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
kubernetes   10.254.0.1      <none>        443/TCP    4h
mysql        10.254.185.20   <none>        3306/TCP   4m
myweb        10.254.18.53    <nodes>       8080/TCP   57s
验证与总结
通过上面的几个步骤，我们可以成功实现了一个简单的K8s单机版例子，我们可以在浏览器输入 http://192.168.139.149:30001/demo/ 来测试我们发布的web应用。

$ curl http://192.168.139.149:30001


<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8" />
        <title>Apache Tomcat/8.0.35</title>
        <link href="favicon.ico" rel="icon" type="image/x-icon" />
        <link href="favicon.ico" rel="shortcut icon" type="image/x-icon" />
        <link href="tomcat.css" rel="stylesheet" type="text/css" />
    </head>

    <body>
        <div id="wrapper">
            <div id="navigation" class="curved container">
                <span id="nav-home"><a href="http://tomcat.apache.org/">Home</a></span>
                <span id="nav-hosts"><a href="/docs/">Documentation</a></span>
                <span id="nav-config"><a href="/docs/config/">Configuration</a></span>
                <span id="nav-examples"><a href="/examples/">Examples</a></span>
                <span id="nav-wiki"><a href="http://wiki.apache.org/tomcat/FrontPage">Wiki</a></span>
                <span id="nav-lists"><a href="http://tomcat.apache.org/lists.html">Mailing Lists</a></span>
                <span id="nav-help"><a href="http://tomcat.apache.org/findhelp.html">Find Help</a></span>
                <br class="separator" />
            </div>
            <div id="asf-box">
                <h1>Apache Tomcat/8.0.35</h1>
            </div>
...
...
...
但我们不只是要搭建环境那么简单，我们希望更深入一下，比如说运用这里例子拓展一下深度：

研究 RC、Service等文件格式

熟悉 kuberctl 的命令

手工停止某个Service对应的容器进程，然后观察有什么现象发生

修改RC文件，改变副本数量，重新发布，观察结果