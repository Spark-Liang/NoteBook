### 设置 阿里云 源

```bash
sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
sudo wget -O /etc/yum.repos.d/CentOS-Base.repo  http://mirrors.aliyun.com/repo/Centos-7.repo
```

### 配置本地 yum 镜像

#### 挂在 iso 到 media 目录下

```bash
# 在 fstab 中添加如下内容，使得开机自动挂载 iso 文件
/data/FilesForVMM/CentOS-7-x86_64-Everything-1810.iso /media/CentOS iso9660 defaults,ro,loop 0 0
#其中 iso9660 是挂在后文件系统的类型
当不知道挂载后的文件系统类型，可以先挂载了，然后用下面的命令查看
df -T
```

#### 设置 CentOS-Media.repo (本地源配置文件)

```bash
vim bendi.repo

[bash]  #库名
name=bash  #库名 （这一行其实可以不用写，用 yum reipolist会报个错但不影响使用）
baseurl=file:///mnt/  #“源所在路径”
enabled=1  #1为启动0为不启用
gpgcheck=0  #检查签名1为检测0为不检测
```

#### 配置 yum 源优先级

需要安装 yum-plugin-priorities.noarch 插件

```bash
# 查看是否安装了插件
rpm -qa | grep yum-plugin-

#设置优先级
[bash]  #库名
name=bash  #库名 （这一行其实可以不用写，用 yum reipolist会报个错但不影响使用）
baseurl=file:///mnt/  #“源所在路径”
enabled=1  #1为启动0为不启用
gpgcheck=0  #检查签名1为检测0为不检测
priority=1 # 在原来的基础上加上这句，设置优先级，数字越小优先级越大。
```

#### 配置 epel 源

```bash
# 使用 yum 直接安装
yum install -y epel-release
# 下载 rpm 进行安装
wget https://mirrors.ustc.edu.cn/epel//7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
rpm -ivh epel-release-7-11.noarch.rpm
```

#### yum 意外终端恢复
