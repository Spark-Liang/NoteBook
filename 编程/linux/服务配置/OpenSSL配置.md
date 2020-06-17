#### OpenSSL配置

- 版本号查看

- 安装

- 共享库使用

##### 版本号查看

使用命令

```bash
openssl version -a
```

##### 安装

1. 下载源码包 wget [https://www.openssl.org/source/openssl-1.0.2l.tar.gz](https://www.openssl.org/source/openssl-1.0.2l.tar.gz)

2. 解压压缩包并进入目录 tar zxf openssl-1.0.2l.tar.gz && cd openssl-1.0.2l

3. 配置编译安装 
   
   ```bash
   ./config -fPIC --prefix=/usr/local/openssl/ enable-shared && make && make install
   ```
   
   其中 --prefix：指定安装目录，-fPIC:编译openssl的静态库，enable-shared:编译动态库

4. 把原本 /usr/bin/openssl 下的文件重命名或者把软连接删除，然后创建新的软连接指向 /usr/local/openssl 下的 bin/openssl。

引用[https://blog.csdn.net/ai2000ai/article/details/79620924](https://blog.csdn.net/ai2000ai/article/details/79620924)
