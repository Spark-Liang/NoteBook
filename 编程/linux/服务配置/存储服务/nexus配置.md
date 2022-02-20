### nexus配置

- 安装
  
  - 依赖
  
  - 安装
  
  - 基础配置
    
    - 配置运行用户
    
    - 配置service文件
    
    - 配置https

- 仓库源配置
  
  - 配置maven源
  
  - 配置docker镜像仓库

#### 安装

##### 依赖

- jdk环境

##### 基础配置

###### 配置运行用户和jdk参数

- 修改`$NEXUS_HOME\bin\nexus.rc`文件的`run_as_user`变量修改运行用户。

- 修改`$NEXUS_HOME\bin\nexus.vmoptions`文件修改jvm参数。

###### 配置nexus成service

在`/etc/systemd/system/` 目录下创建一个名称为`nexus.service`的文件，文件内容为：

```
[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
# 解决Nexus自启动JDK版本报错方案,添加INSTALL4J_JAVA_HOME_OVERRIDE环境变量
Environment="INSTALL4J_JAVA_HOME_OVERRIDE=/opt/jdk"
ExecStart=/opt/nexus/bin/nexus start
ExecStop=/opt/nexus/bin/nexus stop
User=nexus
Restart=on-abort


[Install]
WantedBy=multi-user.target
```

###### 配置https

1. 使用`openssl`命令将crt和key文件转成p12格式的证书。
   
   ```bash
   openssl pkcs12 -export -out <output path> \
   -inkey <key path> -in <crt path>  
   ```

2. 再通过`keytool`将p12格式文件转为.jks格式
   
   ```bash
   keytool -v -importkeystore -srcstoretype PKCS12  -deststoretype JKS \
   -srckeystore <p12 file path>  -destkeystore <out path>
   ```

3. 在配置文件`$NEXUS_HOME/etc/nexus-default.properties`文件，添加`application-port-ssl=8443`选项配置ssl端口，以及在`nexus-args` 添加`${jetty.etc}/jetty-https.xml`。可以通过设置`application-port=0`禁用http端口。

4. 配置文件`$NEXUS_HOME/etc/jetty/jetty-https.xml`文件，在`sslContextFactory`元素中配置KeyStorePath和密码。注意`KeyStorePath`和`TrustStorePath`均以`$NEXUS_HOME/etc/ssl`为起始路径

5. 重启nexus

#### 仓库源配置

##### 配置maven源

##### 配置docker镜像仓库

nexus支持3种docker镜像仓库：

- hosted：本地私人仓库

- proxy：代理远程仓库

- group：将多个仓库合并单个仓库，使用统一的url对外开放

###### 共有配置项

- name：配置仓库名

- blob store：仓库的存储位置

- Repository Connectors：是否另外占用端口对外暴露docker仓库。由于docker仓库不允许使用子路径，所以仓库必须通过端口直接暴露。通常只暴露group仓库

###### hosted仓库

常用配置项：name、blob store

###### proxy仓库

常用配置项：

- Remote Storage：需要代理的仓库地址

- Docker index：使用docker hub或者docker hub的镜像仓库则选择 `Use Docker Hub`否则采用`Use proxy registry`使用远程仓库的index。

[使用nexus3.x配置docker镜像仓库及仓库代理_D_SJ的博客-CSDN博客](https://blog.csdn.net/weixin_33910385/article/details/88764952)
