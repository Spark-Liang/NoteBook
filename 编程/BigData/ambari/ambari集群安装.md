### 错误及解决方案

##### 1. host can't not reach Ambari server '....'

报错信息如下:

```bash
STDOUT: Host registration aborted. Ambari Agent host cannot reach Ambari Server 'ambari:8080'. Please check the network connectivity between the Ambari Agent host and the Ambari Server
```

主要是因为节点无法通过ambari解析到 Ambari 本身的主服务器。<br>

###### 解决方案：

- 再节点的 /etc/hosts 文件中添加 ambari 对应的 ip 地址。

##### 2. Register Failed. Please check the SSL version

主要的原因是在python 2.7.5 之后的版本中添加了 certificate verification，导致 ambari agaent 无法连接到 ambari server。

###### 解决方案：

1. 修改 /etc/python/cert-verification.cfg 中的 verify 为 verify=disable

2. 修改ambari-agent的启动文件 /etc/ambari-agent/conf/ambari-agent.ini ，添加 force_https_protocol=PROTOCOL_TLSv1_2 到 [security] 下
