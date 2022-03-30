### 包管理(yum)

- yum使用
  
  - 常用子命令
  
  - 软件离线安装方式

- yum配置
  
  - 配置文件
  
  - yum源配置

- yum错误收集

- 安装包相关资源网站

#### yum使用

##### 常用命令

查找包相关：

- `yum search <name>`: 查找软件包

- `yum list [condition]`: 列出可能的软件包。其中`[condition]`是条件，可选`updates`（可更新的），`installed`（已安装的）和 `extras`（已安装但不在repository中，通常是通过rpm直接安装）
  
  - `--showduplicates`：显示某个软件包的所有版本

- `yum providers <name>`：查看指定文件在哪个软件包中可以提供。

查看包信息

- `yum info <name>`

##### 软件离线安装方式

步骤：

1. 下载软件包和依赖包

2. 使用`createrepo`创建所有相关软件包的元数据，然后打包软件包和元数据文件。

3. 在离线机器中解压，并把解压目录配置成本地源

###### 下载软件包和依赖包

可用命令：

- `yum-utils`相关命令
  
  - `yumdownloader`:
    
    - 用于下载软件包及其**直接**依赖，可以指定软件包的版本
    
    - 例子`yumdownloader --resolve --destdir=/tmp/test_yum_downloader kubelet-1.20.10-0`
  
  - `repotrack`:
    
    - 用于下载软件包及其**所有**依赖，但不能指定软件包的版本
    
    - 例子`repotrack -p /tmp/download kubelet`

- 使用`yum install --downloadonly --installroot=/tmp --downloaddir /tmp/download kubelet-1.20.10-0`选项
  
  - 支持下载指定版本的所有依赖。
  
  - 其中`--installroot`用于指定一个非`/`路径用于避免yum检测到已安装的软件包。
  
  - 注意点：
    
    - `--downloadonly`选项可能导致`$releasers`变量不可用，可以手动将使用了变量的仓库替换成实际值。
    
    - `--downloadonly`选项可能导致gpgkey校验失败，可以增加`--nogpgcheck`选项效果检测

###### createrepo 创建仓库文件

yum是通过某个url下是否有`repodata`目录来判断当前url是否是仓库。`createrepo`命令可以将指定目录下的rpm都创建成一个仓库。此时该目录可以作为一个本地源进行使用。

###### 解压压缩包并配置本地源

在`/etc/yum.repo.d`目录中添加一个`.repo`结尾的仓库配置文件

```
[local-k8s]
name=local k8s repo
baseurl=file:///tmp/k8s-1.20.10
gpgcheck=0
```

#### yum配置

yum包含两部分配置文件

- `/etc/yum.conf`：配置yum命令行的选，如是否cache等

- `/etc/yum.repo.d`：配置yum的源。该目录下所有`.repo`结尾的文件都会当作配置文件

##### yum源配置

###### 阿里云

CentOS7 x86：

```bash
mv -f /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
curl http://mirrors.aliyun.com/repo/Centos-7.repo -o /etc/yum.repos.d/CentOS-Base.repo
```

CentOS7 其他架构

```bash
mv -f /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
curl http://mirrors.aliyun.com/repo/Centos-altarch-7.repo -o /etc/yum.repos.d/CentOS-Base.repo
```

#### yum错误收集

##### repository are already installed but they are not correct

- 原因 软件包的公钥不正

- 解决方式： 增加`--nogpgcheck`选项

##### 依赖报错

可能原因：

- 软件包在更新时出现了错误，某些已存在的包无法正常卸载。
  
  - 如`audit-lib`包更新，由于系统中同时存在`audit`和`audit-lib`导致audit无法正常更新。

#### 安装包资源网站

- https://pkgs.org/
- [RPM resource](http://www.rpmfind.net/linux/rpm2html/search.php)
