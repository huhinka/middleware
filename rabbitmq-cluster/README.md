# RabbitMQ Cluster

RabbitMQ 集群模式示例。

## 集群模式

```shell
docker-compose up -d
```

docker-compose 创建三个节点：

* rabbitmq1
* rabbitmq2
* rabbitmq3

```shell
docker exec -it rabbitmq1 bash
rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl start_app
exit

docker exec -it rabbitmq2 bash
rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl join_cluster --disc rabbit@rabbitmq1
rabbitmqctl start_app
exit

docker exec -it rabbitmq3 bash
rabbitmqctl stop_app
rabbitmqctl reset
rabbitmqctl join_cluster --ram rabbit@rabbitmq1
rabbitmqctl start_app
exit
```

### RAM 节点与 DISK 节点

至少保证有两个 DISK 节点，这样在主节点挂掉后还有一个节点保存有元数据。

## 镜像集群模式

普通集群模式无法做到高可用，子节点的数据只是元数据，当主节点宕机集群服务继续提供服务。

镜像集群的节点会互相复制数据，当一台宕机其他节点还可以继续使用。

```shell
rabbitmqctl set_policy [-p <vhost>] [--priority <priority>] [--apply-to <apply-to>] <name> <pattern>  <definition>

-p Vhost： 可选参数，针对指定vhost下的queue进行设置

Name: policy 的名称
Pattern: queue 的匹配模式（正则表达式）
Definition: 镜像定义，包括三个部分 ha-mode, ha-params, ha-sync-mode
  ha-mode: 指明镜像队列的模式，有效值为 all/exactly/nodes
    all: 表示在集群中所有的节点上进行镜像
    exactly: 表示在指定个数的节点上进行镜像，节点的个数由 ha-params 指定
    nodes: 表示在指定的节点上进行镜像，节点名称通过 ha-params 指定
  ha-params: ha-mode 模式需要用到的参数
    ha-sync-mode: 进行队列中消息的同步方式，有效值为 automatic 和 manual
    priority: 可选参数，policy 的优先级
```

```shell
rabbitmqctl set_policy 'ha-all' '^' '{"ha-mode":"all","ha-sync-mode":"automatic"}'
```

## 高可用负载均衡

对于客户端如果要连接多个节点自己负责负载均衡负担会很大，提供服务端负载均衡是更好的选择。

使用 HaProxy 的第四层负载均衡 RabbitMQ 的集群节点。

## Keepalived

HaProxy 节点负载均衡了 RabbitMQ 集群节点，但是它自身单点的特性同样会有高可用问题。

可以使用 Keepalived 保证 HaProxy 主备服务器的高可用。
