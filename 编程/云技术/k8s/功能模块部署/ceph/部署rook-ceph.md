### 部署rook-ceph

- 部署
  
  - 

- 卸载

#### 卸载

执行卸载可能需要执行的脚本

```bash
# 进入资源清单文件目录
cd rook/cluster/examples/kubernetes/ceph/

# 删除上面创建的所有资源对象
kubectl delete -f .

# 在所有节点执行下面的清除命令
rm -rf /var/lib/ceph-* 
# 清理LVM配置，擦除磁盘信息
dmsetup ls 
dmsetup remove_all 
dd if=/dev/zero of=/dev/sdb bs=512k count=1 
wipefs -af /dev/sdb

# 如果发现有删除不掉的资源对象可以通过下面的命令强制删除
# 删除POD
kubectl delete pod PODNAME --force --grace-period=0
# 删除NAMESPACE
kubectl delete namespace NAMESPACENAME --force --grace-period=0

# 如果上面的命令无法强制删除namespace资源对象我们可以使用下面的工具删除
yum install jq culr -y
git clone https://github.com/ctron/kill-kube-ns.git
cd kill-kube-ns && ./kill-kube-ns {要删除的namespace}
```

- 

- [Rook快速编排Kubernetes分布式存储Ceph &#8211; 邹坤个人博客](https://blog.z0ukun.com/?p=2938)

- [Kubernetes使用Rook部署Ceph存储集群_VincentQB的博客-CSDN博客_k8s部署ceph集群](https://blog.csdn.net/zwjzqqb/article/details/104988391)

- [kubernetes 之战 基于 rook 搭建 ceph 分布式存储_xiliangMa的博客-CSDN博客](https://blog.csdn.net/weixin_41806245/article/details/100743378)
