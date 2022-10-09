### flannel 网络

- 安装

- 配置

- 卸载

- 错误整理

#### 卸载

1. 运行`kubectl delete`删除对应的资源

2. node节点清理flannel网络留下的文件

```bash
ip link set cni0 down
ip link delete cni0
ip link set flannel.1 down
ip link delete flannel.1
rm -rf /var/lib/cni/
rm -f /etc/cni/net.d/*
rm -f /run/flannel/*
```

3. 检查
4. 重启kubelet服务。

#### 错误整理

##### `error retrieving pod spec,... dial tcp 10.96.0.1:443: connect: network is unreachable`

###### 原因

节点没有默认路由，导致无法通过默认路由找到10.96.0.1

###### 解决方法

```bash
route add default gw <网关ip>
```

`Error from server: Get "https://...:10250/containerLogs/kube-system/kube-flannel-ds-m96r5/kube-flannel?follow=true":`
