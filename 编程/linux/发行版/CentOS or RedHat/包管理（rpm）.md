### 包管理（rpm）

- 源码安装

#### 源码安装

##### 编译依赖

###### 基础软件包依赖

- `autoconf`

###### Berkeley DB依赖

构建依赖步骤：

1. 下载源码包：[](https://download.oracle.com/berkeley-db/db-4.6.18.tar.gz)

2. 解压源码包，并在解压目录创建`build`目录

3. 在`build`中运行命令

```bash
../dist/configure --prefix=/usr/local/BerkeleyDB
```

4. 确认没有报错后运行，make和make install命令
