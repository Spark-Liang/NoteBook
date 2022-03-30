#### OpenSSL配置

- 版本号查看

- 安装

- 共享库使用

- 常用命令
  
  - 查看证书对应公钥

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

##### 常用命令

###### 查看证书对应公钥

```bash
openssl x509 -in <证书文件> -pubkey  -noout
```

#### 创建自签证书

1. 创立根证书密钥文件(自己做CA)root.key：
   
   ```bash
   openssl genrsa -des3 -out root.key
   ```

2. 创立根证书的申请文件root.csr：
   
   ```bash
   openssl req -new -key root.key -out root.csr
   ```

3. 创立一个自目前日期起为期十年的根证书root.crt：
   
   ```bash
   openssl x509 -req -days 3650 -sha1 -extensions v3_ca -signkey root.key -in root.csr -out root.crt
   ```

4. 创立服务器证书密钥server.key：
   
   ```bash
   openssl genrsa –des3 -out server.key 2048
   ```
   
   5.创立服务器证书的申请文件server.csr：
   
   ```bash
   openssl req -new -key server.key -out server.csr
   ```

5. 创立自目前日期起管用期为期两年的服务器证书server.crt：
   
   ```bash
   openssl x509 -req -days 730 -md5 -extensions v3_req -CA root.crt -CAkey root.key -CAcreateserial -in server.csr -out server.crt
   ```

### 修改证书请求模板

修改 /etc/pki/tls/openssl.cnf 该文件里面的 "_default" 结尾的选项。
