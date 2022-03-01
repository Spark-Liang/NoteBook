### flannel 网络

- 安装

- 配置

- 卸载

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
```

3. 重启kubelet服务。
