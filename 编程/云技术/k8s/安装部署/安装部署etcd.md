### 安装配置

- 安装

- 配置

- 集群容灾

#### 安装

1. 下载etcd 二进制文件

```bash
ETCD_VER=v3.4.10

DOWNLOAD_URL=https://storage.googleapis.com/etcd

rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-download-test && mkdir -p /tmp/etcd-download-test

curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
```

2. 解压并放置到 `/usr/local/bin`中

3. 查看version检查是否安装成功

```bash
etcd
```

#### 配置

1. 使用`easyrsa`生成生成自签证书。由于每个etcd节点需要需要同时作为server和client，所以证书必须支持server和client使用。否则启动时会报`certificate specifies an incompatible key usage`错误。
   
   同时，可以使用`subjectAltName`使证书同时支持多个域名

```bash
./easyrsa \
    --subject-alt-name="IP:192.168.188.71,IP:192.168.188.72,IP:192.168.188.73,DNS:k8s-master-001,DNS:k8s-master-001.spark-liang,DNS:etcd-node-1,DNS:etcd-node-1.spark-liang,DNS:k8s-master-002,DNS:k8s-master-002.spark-liang,DNS:etcd-node-2,DNS:etcd-node-2.spark-liang,DNS:k8s-master-003,DNS:k8s-master-003.spark-liang,DNS:etcd-node-3,DNS:etcd-node-3.spark-liang" \
    build-serverClient-full etcd-node nopass
```

2. 配置etcd配置文件，该配置文件主要用于给etcd提供环境变量，其中`${ip}`代表当前节点的ip。
   
   `${ETCD_INITIAL_CLUSTER}`是节点列表，使用“,”分隔，格式是“节点名称=节点的peer端口”

```bash
ETCD_NAME=${ETCD_NAME}  # ETCD name代表节点名称
ETCD_LISTEN_PEER_URLS=https://${ip}:2380 # 接收服务端对接的端口
ETCD_LISTEN_CLIENT_URLS=https://${ip}:2379 # 接收客户端请求的接口
ETCD_INITIAL_CLUSTER_TOKEN=etcd-cluster # 集群的标识，所有参加同一个集群的节点，token必须相同
ETCD_INITIAL_CLUSTER=${ETCD_INITIAL_CLUSTER} # 
ETCD_INITIAL_ADVERTISE_PEER_URLS=https://${ip}:2380 
ETCD_ADVERTISE_CLIENT_URLS=https://${ip}:2379
ETCD_TRUSTED_CA_FILE=/etc/etcd/etcd-ca.crt
ETCD_CERT_FILE=/etc/etcd/etcd-node.crt
ETCD_KEY_FILE=/etc/etcd/etcd-node.key
ETCD_PEER_CLIENT_CERT_AUTH=true
ETCD_PEER_TRUSTED_CA_FILE=/etc/etcd/etcd-ca.crt
ETCD_PEER_KEY_FILE=/etc/etcd/etcd-node.key
ETCD_PEER_CERT_FILE=/etc/etcd/etcd-node.crt 
ETCD_DATA_DIR=/data/etcd # etcd 的数据目录，数据目录必须权限是 700
```

3. 配置etcd的service文件。配置文件放在`/usr/lib/systemd/system/etcd.service`

```
[Unit]
Description=etcd key-value store
Documentation=https://github.com/etcd-io/etcd
After=network.target

[Service]
Type=notify
EnvironmentFile=/etc/etcd/etcd.conf
ExecStart=/usr/local/bin/etcd 
Restart=always
RestartSec=10s
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
```

4. 启动etcd service

```bash
sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl restart etcd
sudo systemctl status etcd
```

#### 集群容灾

[运维指南 - 灾难恢复 - 《Etcd官方文档中文版》 - 书栈网 · BookStack](https://www.bookstack.cn/read/etcd/documentation-op-guide-recovery.md)

#### 参考文档

- [如何设置一个生产级别的高可用etcd集群 - k3s中文社区 - 博客园](https://www.cnblogs.com/k3s2019/p/13731527.html)

- [etcd install&amp;configuration_期待幸福-CSDN博客](https://blog.csdn.net/sinat_24092079/article/details/121433664)

- [运维指南 - 配置 - 《Etcd官方文档中文版》 - 书栈网 · BookStack](https://www.bookstack.cn/read/etcd/documentation-op-guide-configuration.md)
