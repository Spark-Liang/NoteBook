[TOC]



### LVM（逻辑卷管理器） 概念

LVM对磁盘的分层管理结构如下：

![](img/LVM分层结构.png)

在LVM中有三层结构，最底层是 PV（硬盘分区），中间层是vg（卷组），顶层是lv（逻辑卷）。<br>

LVM通过三层结构的方式首先将底层的pv（物理分区）统一成多个大的vg，然后在通过对 vg 进行逻辑分区实现对单个或者多个磁盘的分区管理。其中在物理层面最小的块被称为 “PE”，在逻辑层面最小的块称为“VE”。

#### LVM常用命令

| 功能/命令 | 物理卷管理     | 卷组管理      | 逻辑卷管理     |
|:-----:| --------- | --------- | --------- |
| 扫描    | pvscan    | vgscan    | lvscan    |
| 创建    | pvcreate  | vgcreate  | lvcreate  |
| 显示    | pvdisplay | vgdisplay | lvdisplay |
| 删除    | pvremove  | vgremove  | lvremove  |
| 扩展    |           | vgextend  | lvextend  |
| 缩小    |           | vgreduce  | lvreduce  |

#### PV 管理

##### PV创建

在硬盘新插入到主机的时候，如果识别不出需要执行 `echo "- - -" > /sys/class/scsi_host/host0/scan` 来扫描新插入的硬盘。PV 的创建是通过 pvcreate 命令实现。下面是例子

```bash
# 对新添加的硬盘创建 PV
>>> pvcreate /dev/sdb
Physical volume "/dev/sdb" successfully created.

# 当出现 Device /dev/sdb excluded by a filter. 需要进行如下操作：
>>> dd if=/dev/zero of=/dev/sdb bs=512 count=64
```

##### 其他的pv操作

查看全部的pv操作可以通过输入 “pv” 然后双击 “tab” 获取到所有pv相关的命令提示。

- pvs：查看所有的 PV

- pvremove：移除PV

#### VG 管理

查看全部的vg操作可以通过输入 “vg” 然后双击 “tab” 获取到所有vg相关的命令提示。<br>

##### vg创建

lvm通过 vgcreate 创建vg。

```bash
>>> vgcreate vgtest /dev/sda{4,5,6}
>>> vgcreate vgtest /dev/sda4 /dev/sda5 /dev/sda6 # 与上面的命令等价
>>> vgcreate -s 16m vgtest /dev/sda{4,5,6} # -s 可以指定PE的大小。默认4m
```

##### vg扩容

在运行时，可以动态地向vg中添加pv。

```bash
vgextend vgtest /dev/sda7
```

#### LV 管理

##### lv创建

```bash
lvcreate -L 10G -n lv0 vgtest # -L 表示用尺寸控制的新的 lv 的大小。
lvcreate -l 20%VG -n lv0 vgtet # -l 表示用百分比控制新的lv的大小
```

##### lv扩容缩容

```bash
lvextend  -L +10G /dev/vgtest/lv0 # 表示向 vgtest 下的 lv0 添加10G
lvextend -L 10G /dev/vgtest/lv0 # 表示向 vgtest 下的 lv0 添加到10G

lvreduce -L -10G /dev/vgtest/lv0 # 表示向 vgtest 下的 lv0 减少10G
lvreduce -L 10G /dev/vgtest/lv0 # 表示向 vgtest 下的 lv0 减少到10G

# 扩容后需要刷新容量
# 对ext4的文件系统使用 resize2fs
resize2fs /dev/vgtest/lv0
# 对xfs的文件系统使用 resize2fs
 xfs_growfs /dev/vgtest/lv0
```

对xfs 无法支持缩容，必须先卸载硬盘重新格式化再挂载，才能完成缩容。

##### lv格式化

```bash
mkfs.xfs /dev/vgtest/lv0 # 创建xfs文件系统
mkfs.ext4 /dev/vgtest/lv0 # 创建ext4文件系统

mkdir <mount point>
mount <logical volumn path> <mount point>
```

##### lv删除

```bash
lvremove /dev/vg_name/lv_name
```

