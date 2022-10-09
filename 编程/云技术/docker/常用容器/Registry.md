### Registry

- 启动命令

- 配置方式

- 参考文档

#### 启动命令

示例：

```bash
docker run -d -p 5000:5000  \
--name registry --restart=always \
-v `pwd`/registry:/var/lib/registry \
-v `pwd`/config.yml:/etc/docker/registry/config.yml \
registry:2
```

#### 配置方式

##### 配置ssl

1. 使用cfssl生成公钥和私钥

2. 通过环境变量，`REGISTRY_HTTP_ADDR`、`REGISTRY_HTTP_TLS_CERTIFICATE`和`REGISTRY_HTTP_TLS_KEY`配置端口、公钥和私钥。

示例

```bash

```

#### 参考文档

- [docker registry详解_原来是木斯的博客-CSDN博客_docker registry](https://blog.csdn.net/weixin_39548163/article/details/118491641)
