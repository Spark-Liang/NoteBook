### nfs配置

- 安装

- 配置nfs服务

- 客户端配置

#### 安装

1. 安装`nfs-utils` 和`rpcbind`
   
   ```bash
   yum -y install nfs-utils rpcbind
   ```

2. 启动`nfs-utils` 和`rpcbind`并配置开机自启
   
   ```bash
   systemctl start nfs && systemctl enable nfs
   systemctl start rpcbind && systemctl enable rpcbind
   ```

#### 配置nfs服务

##### nfs相关文件路径

- /etc/exports: NFS服务的主要配置文件

- /usr/sbin/exportfs: NFS服务的管理命令

- /usr/sbin/showmount: 客户端的查看命令

- /var/lib/nfs/etab:  记录NFS分享出来的目录的完整权限设定值

- /var/lib/nfs/xtab:  记录曾经登录过的客户端信息

##### exports配置文件

格式

```
<输出目录> [客户端1 选项（访问权限,用户映射,其他）] [客户端2 选项（访问权限,用户映射,其他）]
```

 **输出目录：**

输出目录是指NFS系统中需要共享给客户机使用的目录；

**客户端：**

客户端是指网络中可以访问这个NFS输出目录的计算机

客户端常用的指定方式

- 指定ip地址的主机：192.168.0.200
- 指定子网中的所有主机：192.168.0.0/24 192.168.0.0/255.255.255.0
- 指定域名的主机：david.bsmart.cn
- 指定域中的所有主机：*.bsmart.cn
- 所有主机：*

**选项：**

选项用来设置输出目录的访问权限、用户映射等。

NFS主要有3类选项：

访问权限选项

- 设置输出目录只读：ro
- 设置输出目录读写：rw

用户映射选项

- all_squash：将远程访问的所有普通用户及所属组都映射为匿名用户或用户组（nfsnobody）；
- no_all_squash：与all_squash取反（默认设置）；
- root_squash：将root用户及所属组都映射为匿名用户或用户组（默认设置）；
- no_root_squash：与rootsquash取反；
- anonuid=xxx：将远程访问的所有用户都映射为匿名用户，并指定该用户为本地用户（UID=xxx）；
- anongid=xxx：将远程访问的所有用户组都映射为匿名用户组账户，并指定该匿名用户组账户为本地用户组账户（GID=xxx）；

其它选项

- secure：限制客户端只能从小于1024的tcp/ip端口连接nfs服务器（默认设置）；
- insecure：允许客户端从大于1024的tcp/ip端口连接服务器；
- sync：将数据同步写入内存缓冲区与磁盘中，效率低，但可以保证数据的一致性；
- async：将数据先保存在内存缓冲区中，必要时才写入磁盘；
- wdelay：检查是否有相关的写操作，如果有则将这些写操作一起执行，这样可以提高效率（默认设置）；
- no_wdelay：若有写操作则立即执行，应与sync配合使用；
- subtree：若输出目录是一个子目录，则nfs服务器将检查其父目录的权限(默认设置)；
- no_subtree：即使输出目录是一个子目录，nfs服务器也不检查其父目录的权限，这样可以提高效率；

#### 客户端配置

##### 安装依赖

安装`nfs-utils` 和`rpcbind`

##### 挂载nfs

```bash
# mount 命令
mount -t nfs common-service.spark-liang:/data/nfs /mnt/nfs/

# 通过fstab
common-service.spark-liang:/data/nfs   /mnt/nfs/    nfs  defaults   0 0
```

#### 参考文档

- [Linux NFS服务器的安装与配置 - David_Tang - 博客园](https://www.cnblogs.com/mchina/archive/2013/01/03/2840040.html)
