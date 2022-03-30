### make命令

- 安装

#### 安装

##### centos

#### 报错收集

##### machine not recognize

- 原因：源码包下的`config.guess`和`config.sub`过旧没有包含最新的主机信息。<br>

- 解决方法: 下载最新的`config.guess`和`config.sub`

```bash
# 查找文件路径
find . -name "config.guess"
find . -name "config.sub"

# 下载最新文件
wget -O config.guess 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.guess;hb=HEAD'
wget -O config.sub 'http://git.savannah.gnu.org/gitweb/?p=config.git;a=blob_plain;f=config.sub;hb=HEAD'
```

- 
