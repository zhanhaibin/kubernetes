部署 Ingress 

一、Ingress 介绍
Kubernetes 暴露服务的方式目前只有三种：LoadBlancer Service、NodePort Service、Ingress；前两种估计都应该很熟悉，具体的可以参考下 这篇文章；下面详细的唠一下这个 Ingress

1.1、Ingress 是个什么玩意
可能从大致印象上 Ingress 就是能利用 Nginx、Haproxy 啥的负载均衡器暴露集群内服务的工具；那么问题来了，集群内服务想要暴露出去面临着几个问题：

1.2、Pod 漂移问题
众所周知 Kubernetes 具有强大的副本控制能力，能保证在任意副本(Pod)挂掉时自动从其他机器启动一个新的，还可以动态扩容等，总之一句话，这个 Pod 可能在任何时刻出现在任何节点上，也可能在任何时刻死在任何节点上；那么自然随着 Pod 的创建和销毁，Pod IP 肯定会动态变化；那么如何把这个动态的 Pod IP 暴露出去？这里借助于 Kubernetes 的 Service 机制，Service 可以以标签的形式选定一组带有指定标签的 Pod，并监控和自动负载他们的 Pod IP，那么我们向外暴露只暴露 Service IP 就行了；这就是 NodePort 模式：即在每个节点上开起一个端口，然后转发到内部 Pod IP 上，如下图所示

[images](https://github.com/zhanhaibin/kubernetes/blob/master/ingress/images/5a1i4.jpg)

1.3、端口管理问题
采用 NodePort 方式暴露服务面临一个坑爹的问题是，服务一旦多起来，NodePort 在每个节点上开启的端口会及其庞大，而且难以维护；这时候引出的思考问题是 “能不能使用 Nginx 啥的只监听一个端口，比如 80，然后按照域名向后转发？” 这思路很好，简单的实现就是使用 DaemonSet 在每个 node 上监听 80，然后写好规则，因为 Nginx 外面绑定了宿主机 80 端口(就像 NodePort)，本身又在集群内，那么向后直接转发到相应 Service IP 就行了，如下图所示

[images](https://github.com/zhanhaibin/kubernetes/blob/master/ingress/images/rrcuu.jpg)

1.4、域名分配及动态更新问题
从上面的思路，采用 Nginx 似乎已经解决了问题，但是其实这里面有一个很大缺陷：每次有新服务加入怎么改 Nginx 配置？总不能手动改或者来个 Rolling Update 前端 Nginx Pod 吧？这时候 “伟大而又正直勇敢的” Ingress 登场，如果不算上面的 Nginx，Ingress 只有两大组件：Ingress Controller 和 Ingress

Ingress 这个玩意，简单的理解就是 你原来要改 Nginx 配置，然后配置各种域名对应哪个 Service，现在把这个动作抽象出来，变成一个 Ingress 对象，你可以用 yml 创建，每次不要去改 Nginx 了，直接改 yml 然后创建/更新就行了；那么问题来了：”Nginx 咋整？”

Ingress Controller 这东西就是解决 “Nginx 咋整” 的；Ingress Controoler 通过与 Kubernetes API 交互，动态的去感知集群中 Ingress 规则变化，然后读取他，按照他自己模板生成一段 Nginx 配置，再写到 Nginx Pod 里，最后 reload 一下，工作流程如下图

[images](https://github.com/zhanhaibin/kubernetes/blob/master/ingress/images/Ingress.jpg)
 

当然在实际应用中，最新版本 Kubernetes 已经将 Nginx 与 Ingress Controller 合并为一个组件，所以 Nginx 无需单独部署，只需要部署 Ingress Controller 即可

二、Nginx Ingress

2.1、部署默认后端

我们知道 前端的 Nginx 最终要负载到后端 service 上，那么如果访问不存在的域名咋整？官方给出的建议是部署一个 默认后端，对于未知请求全部负载到这个默认后端上；这个后端啥也不干，就是返回 404，部署如下

```
kubectl create -f default-backend.yaml
deployment "default-http-backend" created
service "default-http-backend" created
```

2.2、部署 Ingress Controller

部署完了后端就得把最重要的组件 Nginx+Ingres Controller(官方统一称为 Ingress Controller) 部署上

```
kubectl create -f nginx-ingress-controller.yaml
daemonset "nginx-ingress-lb" created
```

注意：官方的 Ingress Controller 有个坑，至少我看了 DaemonSet 方式部署的有这个问题：没有绑定到宿主机 80 端口，也就是说前端 Nginx 没有监听宿主机 80 端口(这还玩个卵啊)；所以需要把配置搞下来自己加一下 hostNetwork，截图如下

[images](https://github.com/zhanhaibin/kubernetes/blob/master/ingress/images/n1fsc.jpg)


2.3、部署 Ingress

从上面可以知道 Ingress 就是个规则，指定哪个域名转发到哪个 Service，所以说首先我们得有个 Service，当然 Service 去哪找这里就不管了；这里默认为已经有了两个可用的 Service，以下以 Dashboard 和 kibana 为例

先写一个 Ingress 文件，语法格式啥的请参考 官方文档，由于我的 Dashboard 和 Kibana 都在 kube-system 这个命名空间，所以要指定 namespace，写之前 Service 分布如下



三、部署 Ingress TLS

上面已经搞定了 Ingress，下面就顺便把 TLS 怼上；官方给出的样例很简单，大致步骤就两步：创建一个含有证书的 secret、在 Ingress 开启证书；但是我不得不喷一下，文档就提那么一嘴，大坑一堆，比如多域名配置，还有下面这文档特么的是逗我玩呢？

[images](https://github.com/zhanhaibin/kubernetes/blob/master/ingress/images/douniwan.jpg)

3.1、创建证书

首先第一步当然要有个证书，由于我这个 Ingress 有两个服务域名，所以证书要支持两个域名；生成证书命令如下：

```
# 生成 CA 自签证书
mkdir cert && cd cert
openssl genrsa -out ca-key.pem 2048
openssl req -x509 -new -nodes -key ca-key.pem -days 10000 -out ca.pem -subj "/CN=kube-ca"

# 编辑 openssl 配置
cd /usr/lib/ssl/openssl.cnf .
vim openssl.cnf

# 主要修改如下
[req]
req_extensions = v3_req # 这行默认注释关着的 把注释删掉
# 下面配置是新增的
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names
[alt_names]
DNS.1 = www.zhanhaibin.com
DNS.2 = app.zhanhaibin.com
DNS.3 = avaapp.avacloud.com.cn

# 生成证书
openssl genrsa -out ingress-key.pem 2048
openssl req -new -key ingress-key.pem -out ingress.csr -subj "/CN=kube-ingress" -config /usr/lib/ssl/openssl.cnf
openssl x509 -req -in ingress.csr -CA ca.pem -CAkey ca-key.pem -CAcreateserial -out ingress.pem -days 365 -extensions v3_req -extfile /usr/lib/ssl/openssl.cnf
```

3.2、创建 secret

创建好证书以后，需要将证书内容放到 secret 中，secret 中全部内容需要 base64 编码，然后注意去掉换行符(变成一行)；以下是我的 secret 样例(上一步中 ingress.pem 是证书，ingress-key.pem 是证书的 key)

```
vim ingress-secret.yml

apiVersion: v1
data:
  tls.crt: MIIEowIBAAKCAQEA4gxhwBEB2y65A7P1QPSx13OqdbDj+ZZSs5QtL5NvPwrNDIu01aaBObmhIkpq9RMBj/09iibHo41VlGfcT7MXVBnc6MXE3BdCofEGK8T8nAWOZCx00ZsO0Nt8IzpXF5YnPjKEpCcWJOpWO3GOkHuwPS4NTBbRniw6YoWJ5l06CS87r97w0gFURJM6aJNCUU1doC2HOJe7BVU8lNYGo5Yox8XQMMSk0BAvCpEMlCiwOfPplw/UBaqzwTeAaPWoMWG1u8EMTv4m2nBwA/79Fw+4v2bbj6Yd6QspSjl1MQDNVuDKjUCjS6XBJnTLQvajrqoKgfaeQSAtWn6MxCqi9ACCVwIDAQABAoIBAB6v8aFCbc8Uo7dV+eiMj4whPrXlgr2CY83PQucfi82yKK4YVT9f8FEm2zItiiGlJ+QlS/JyW03fxQt1ohoLxRH8xNmw5429dqVHdEAC6QxBUNhWlLFT7In8EfkyVVp1XvR5pTonuEDgsz40p1cEA6P6mYGH44Mmm/J+EH9+jn9qcbt/v1w88cI+qHPfIEQUlZC4H7QKNziUHXYTkzzX8MsvUCgJS5ACQCVOIhFWzgfQ9SuqqLoXPHNLkTL9CKS409MiGAJpI7gz955UGqiZpigufd6PQzQDUw+giYEhDA+UkhviJnuAdc76HtWeO9u39yY7p10lXxUx3fGOkSZNMeECgYEA/DbBiUCmRJ8zSNnKXmQ7OrpShUf9v6zseJlph4nyYwZXtUV6XCcQKbr/i+VrvIqeqKgRDUODrrZVWeve0eFPZU/pUHzcdzIw1qB+q87Ie72T7g9+P1zqHROmGkLv7x9DkTy60GWFu3UtdJ4saI+FEXmvJhVB859PizD0XQgOeycCgYEA5XESu8n5Ql5gwgl889T91Q5gvFw3tkP4X8lT4soEhS8GthX6N9Ga7yOYFMR3R6+1GXAi/cCSKFUl3piIXDQ72QLoPuZE2AuzEsbOspMq39e1k7mc9N4tN4ThaiHQYW+tDvJPX5Vx9f+LmF7WypbDDz1uEQ1RZnVDzjsBe1Ra/VECgYEA9VQ9xUhBcxZ4SDCxDEfq5SFAC60PQlbuXhC7+b9RKsmMnyLJ9sF4k172HBo5RdiApAV3MLOvb06kjydEQlsrY5zrkgMiYD9OCjdrf6tQkCzDrBkd8HxsrYPjWkAqKyr6ClhMT1GxV7qPUJRbFgokoe7/U8fxswwPz5D64VNo4pkCgYAsxvJ2/6XLlAuiEqP2Gh0nlVS/reeZhI5Wcz4Rxoc3TsQqiQN6HUf1X6bwdp8ouFvJiR7rEsfzYxqu5GnIRNFhOrYEgH/zAeWCxpXUN/BoGvrux4ygJTQB38b2JX87ZMYLYrKm3s2MysB9jhSxGNcchEqUvVqjekMvXkidvwq64QKBgCem+qeZc0o4buQBcbDMxhs+nXGSoOlQpaU0xD/2gyu03wvTilg6AQh7wxnRb0snotFYl3PkqwbpaZBFhODCMgmtrbghSwWqdwoTzoK5kTbn1P6Pk8882C1HlVXOkEcJZBFAmVWEUko93Sh4ogGib3PuNX56EQHNzTTO4QiGMVY+
  tls.key: MIIEowIBAAKCAQEA4gxhwBEB2y65A7P1QPSx13OqdbDj+ZZSs5QtL5NvPwrNDIu01aaBObmhIkpq9RMBj/09iibHo41VlGfcT7MXVBnc6MXE3BdCofEGK8T8nAWOZCx00ZsO0Nt8IzpXF5YnPjKEpCcWJOpWO3GOkHuwPS4NTBbRniw6YoWJ5l06CS87r97w0gFURJM6aJNCUU1doC2HOJe7BVU8lNYGo5Yox8XQMMSk0BAvCpEMlCiwOfPplw/UBaqzwTeAaPWoMWG1u8EMTv4m2nBwA/79Fw+4v2bbj6Yd6QspSjl1MQDNVuDKjUCjS6XBJnTLQvajrqoKgfaeQSAtWn6MxCqi9ACCVwIDAQABAoIBAB6v8aFCbc8Uo7dV+eiMj4whPrXlgr2CY83PQucfi82yKK4YVT9f8FEm2zItiiGlJ+QlS/JyW03fxQt1ohoLxRH8xNmw5429dqVHdEAC6QxBUNhWlLFT7In8EfkyVVp1XvR5pTonuEDgsz40p1cEA6P6mYGH44Mmm/J+EH9+jn9qcbt/v1w88cI+qHPfIEQUlZC4H7QKNziUHXYTkzzX8MsvUCgJS5ACQCVOIhFWzgfQ9SuqqLoXPHNLkTL9CKS409MiGAJpI7gz955UGqiZpigufd6PQzQDUw+giYEhDA+UkhviJnuAdc76HtWeO9u39yY7p10lXxUx3fGOkSZNMeECgYEA/DbBiUCmRJ8zSNnKXmQ7OrpShUf9v6zseJlph4nyYwZXtUV6XCcQKbr/i+VrvIqeqKgRDUODrrZVWeve0eFPZU/pUHzcdzIw1qB+q87Ie72T7g9+P1zqHROmGkLv7x9DkTy60GWFu3UtdJ4saI+FEXmvJhVB859PizD0XQgOeycCgYEA5XESu8n5Ql5gwgl889T91Q5gvFw3tkP4X8lT4soEhS8GthX6N9Ga7yOYFMR3R6+1GXAi/cCSKFUl3piIXDQ72QLoPuZE2AuzEsbOspMq39e1k7mc9N4tN4ThaiHQYW+tDvJPX5Vx9f+LmF7WypbDDz1uEQ1RZnVDzjsBe1Ra/VECgYEA9VQ9xUhBcxZ4SDCxDEfq5SFAC60PQlbuXhC7+b9RKsmMnyLJ9sF4k172HBo5RdiApAV3MLOvb06kjydEQlsrY5zrkgMiYD9OCjdrf6tQkCzDrBkd8HxsrYPjWkAqKyr6ClhMT1GxV7qPUJRbFgokoe7/U8fxswwPz5D64VNo4pkCgYAsxvJ2/6XLlAuiEqP2Gh0nlVS/reeZhI5Wcz4Rxoc3TsQqiQN6HUf1X6bwdp8ouFvJiR7rEsfzYxqu5GnIRNFhOrYEgH/zAeWCxpXUN/BoGvrux4ygJTQB38b2JX87ZMYLYrKm3s2MysB9jhSxGNcchEqUvVqjekMvXkidvwq64QKBgCem+qeZc0o4buQBcbDMxhs+nXGSoOlQpaU0xD/2gyu03wvTilg6AQh7wxnRb0snotFYl3PkqwbpaZBFhODCMgmtrbghSwWqdwoTzoK5kTbn1P6Pk8882C1HlVXOkEcJZBFAmVWEUko93Sh4ogGib3PuNX56EQHNzTTO4QiGMVY+
kind: Secret
metadata:
  name: ingress-secret
  namespace: kube-system
type: Opaque
```