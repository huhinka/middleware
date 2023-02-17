# MongoDB Replica Set

MacOS、Linux 下 MongoDB Replica Set 单机部署示例。

> **警告**
> 此项目仅适用于本地测试，生产环境请将副本部署到不同的服务器上。

## 默认设置

- hostname: mongo1、mongo2、mongo3
- port: 30011、30012、30013
- username: admin
- password: admin
- replicaSet: vision-set

## 操作步骤

### 生成 keyfile

keyfile 是节点间用于认证的文件。

```shell
openssl rand -base64 755 > keyfile
chmod 400 keyfile
chown 999:999 keyfile
```

### 修改文件权限

```shell
chown 999:999 setup.sh
chmod 755 setup.sh
chown 999:999 create_user.sh
chmod 755 create_user.sh
```

### 启动并初始化

如果需要修改数据库修改 `create_user.sh` 配置需要的 admin 账户。
目前默认的是账户密码是 `admin`、`admin`。

```shell
# 启动
docker compose up -d
```

```shell
# 配置 Replica Set，并等待几秒保证选举出主节点
docker exec mongo1 /setup.sh
```

```shell
# 创建用户
# 注意：需等待节点选举出 PRIMARY 节点后再创建用户
docker exec mongo1 /create_user.sh
```

### 配置 Hostname

配置 hosts，确保本地能够通过 mongo1 等节点的地址访问 MongoDB。
如果不配置将无法访问集群。

```shell
> sudo vim /etc/hosts

# Local MongoDB
127.0.0.1      mongo1
127.0.0.1      mongo2
127.0.0.1      mongo3
```

### 客户端连接 Replica Set

连接地址需要添加 SECONDARY 地址保证主节点故障时客户端可以主动切换。

连接参数需要添加 `replicaSet` 参数，并与前面配置的一致。

部署完成后可以通过以下 URL 访问 MongoDB：

```shell
mongodb://admin:admin@mongo1:30011,mongo2:30012/?replicaSet=vision-set
```

或者使用 localhost:

```shell
mongodb://admin:admin@localhost:30011,localhost:30012/?replicaSet=vision-set
```
