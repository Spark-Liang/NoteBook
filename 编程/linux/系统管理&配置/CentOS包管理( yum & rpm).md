#### yum配置文件

路径为`/etc/yum.conf`，用于配置yum命令的一些属性，常用属性有

- 

#### 设置 阿里云 源

**centos 7**

```bash
sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
sudo wget -O /etc/yum.repos.d/CentOS-Base.repo  http://mirrors.aliyun.com/repo/Centos-7.repo
```

**centos 8**

```bash
cp /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
cp /etc/yum.repos.d/CentOS-AppStream.repo /etc/yum.repos.d/CentOS-AppStream.repo.bak
cp /etc/yum.repos.d/CentOS-Extras.repo /etc/yum.repos.d/CentOS-Extras.repo.bak

sed -i 's/mirrorlist=/#mirrorlist=/g' /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-AppStream.repo /etc/yum.repos.d/CentOS-Extras.repo
sed -i 's/#baseurl=/baseurl=/g' /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-AppStream.repo /etc/yum.repos.d/CentOS-Extras.repo
sed -i 's/http:\/\/mirror.centos.org/https:\/\/mirrors.aliyun.com/g' /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-AppStream.repo /etc/yum.repos.d/CentOS-Extras.repo
```

#### 配置本地 yum 镜像

##### 挂在 iso 到 media 目录下

```bash
# 在 fstab 中添加如下内容，使得开机自动挂载 iso 文件
/data/FilesForVMM/CentOS-7-x86_64-Everything-1810.iso /media/CentOS iso9660 defaults,ro,loop 0 0
#其中 iso9660 是挂在后文件系统的类型
# 当不知道挂载后的文件系统类型，可以先挂载了，然后用下面的命令查看
df -T

# 使用 mount -a 使得修改生效
```

##### 设置 CentOS-Media.repo (本地源配置文件)

```bash
vim bendi.repo

[bash]  #库名
name=bash  #库名 （这一行其实可以不用写，用 yum reipolist会报个错但不影响使用）
baseurl=file:///mnt/  #“源所在路径”
enabled=1  #1为启动0为不启用
gpgcheck=0  #检查签名1为检测0为不检测
```

#### 配置 epel 源

```bash
# 使用 yum 直接安装
yum install -y epel-release
# 下载 rpm 进行安装
wget https://mirrors.ustc.edu.cn/epel//7/x86_64/Packages/e/epel-release-7-11.noarch.rpm
rpm -ivh epel-release-7-11.noarch.rpm
```

 [epel repo文件](ref/epel-centos7.repo)

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

#### 通过yum 下载软件所有的依赖包

##### 通过yumdownloader

命令：

```shell
yumdownloader --resolve --downloadonly --destdir <target folder> <package 1> ...
```

其他常用选项：

- **\-c [config file]** : 用于配置额外的 yum 源或者yum设置。**当有多个 yum 源时，必须配置在同一个文件中。**

##### 通过repotrack命令

通过repotrack命令，可以使用 yum 下载某个软件包对应的所有依赖的包。使用之前需要安装 yum -y install yum-utils。

```bash
repotrack <software nane> -p <path to store packages>
```

并且在需要离线安装的机器上调用以下命令

```bash
rpm -Uvh --force --nodeps *.rpm
```

#### 非root用户使用yum安装软件

步骤：

1. 使用yumdownloader 或者 repotrack 下载所有软件所需的 rpm 文件。

2. 使用 rpm2cpio 和 cpio 把软件安装到指定目录
   
   ```shell
   rpm2cpio <rpm file> | cpio -idmv [target directory]
   
   # -i = extract
   # -d = make directories
   # -m = preserve modification time
   # -v = verbose
   ```

3. 配置环境变量
   
   ```shell
   LOCAL_SOFTWARE_PATH=...
   
   export PATH="${LOCAL_SOFTWARE_PATH}/usr/bin:${LOCAL_SOFTWARE_PATH}/usr/sbin:$PATH"
   export LD_LIBRARY_PATH="${LOCAL_SOFTWARE_PATH}/usr/lib:${LOCAL_SOFTWARE_PATH}/usr/lib64:$LD_LIBRARY_PATH"
   export CFLAGS="-I${LOCAL_SOFTWARE_PATH}/usr/include "
   export LDFLAGS="-L${LOCAL_SOFTWARE_PATH}/usr/lib64 -L${LOCAL_SOFTWARE_PATH}/usr/lib -L${LOCAL_SOFTWARE_PATH}/lib"
   ```

#### 使用 rpm

命令模板：

- 安装一个包：rpm -ivh

- 升级一个包 ：rpm -Uvh

- 移走一个包：rpm -e

- 查询包是否被安装：rpm -q

其他命令参数：

- \-\-force：强制覆盖已安装的包

- \-\-nodeps：强制安装对应的包，即使没有对应的依赖

- \-v：等价于 --verbose

- \-h ：等价于 --hash

##### 使用 dnf
