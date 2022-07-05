# MongoDB Replica Set

MongoDB Replica Set 单机部署。

只用于本地测试。生产环境需要部署到不同的服务器上。

## Usage

### 生成 keyfile：

keyfile 是节点间用于认证的文件。

```shell
openssl rand -base64 755 > keyfile
chmod 400 keyfile
chown 999:999 keyfile
```

### 文件权限

```shell
chown 999:999 setup.sh
chmod 755 setup.sh
chown 999:999 create_user.sh
chmod 755 create_user.sh
```

### 启动并初始化

修改 `setup.sh`，配置其中的所有节点的 host 地址与端口，改为本地 IP 与容器对外的端口。

```bash
#!/bin/bash

mongo <<EOF
    var cfg = {
        _id: 'vision-set',
        "version": 1,
        "members": [
            {
                "_id": 0,
                host: '192.168.50.62:30011',
                "priority": 2
            },
            {
                "_id": 1,
                host: '192.168.50.62:30012',
                "priority": 0
            },
            {
                "_id": 2,
                host: '192.168.50.62:30013',
                "priority": 0
            }
        ]
    };
    rs.initiate(cfg, { force: true });
    //rs.reconfig(cfg, { force: true });
    rs.status();
EOF
```

修改 `create_user.sh` 配置需要的 admin 账户。
目前默认的是账户密码是 `admin`、`admin`。
```shell
#!/bin/bash

mongo <<EOF
   use admin;
   admin = db.getSiblingDB("admin");
   admin.createUser(
     {
	user: "admin",
        pwd: "admin",
        roles: [ { role: "root", db: "admin" } ]
     });
     db.getSiblingDB("admin").auth("admin", "admin");
     rs.status();
EOF
```

```shell
docker compose up -d
# 配置 Replica Set
docker exec mongo1 /setup.sh
# 创建用户
# 等待节点选举出 PRIMARY 节点后再创建用户
docker exec mongo1 /create_user.sh
```

### 客户端连接 Replica Set

连接地址需要添加 SECONDARY 地址保证主节点故障时客户端可以无缝切换。

连接参数需要添加 `replicaSet` 参数，并与前面配置的一致。

```shell
mongodb://KF:mango252@localhost:30011,localhost:30012,localhost:30013/vsp-api?replicaSet=vision-set
```