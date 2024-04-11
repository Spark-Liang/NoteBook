#### 常用容器列表

- sql server for linux

- mysql on docker

- dns 服务

##### sql server for linux

启动命令

```bash
# ms 官网脚本
sudo docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=<YourStrong@Passw0rd>" \
   -p 1433:1433 --name sqlserver-container \
   -d mcr.microsoft.com/mssql/server

# docker hub sql server for linux 镜像
sudo docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=<YourStrong@Passw0rd>" \
 -p 1433:1433 --name sqlserver-container \
 -d microsoft/mssql-server-linux
 -v <host path>:/var/opt/mssql
#  容器放置数据的位置在/var/opt/mssql
```

##### mysql on docker

docker 命令启动：

```bash
docker run -p 3306:3306 --name mysql-container \
-e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.6 

# 额外定义配置文件
-v $PWD/conf:/etc/mysql/conf.d -v $PWD/logs:/logs -v $PWD/data:/var/lib/mysql
```

docker compose 文件：

```yaml
version: "3.2"
services:
  mysql:
    container_name: mysql-container
    image: mysql:5.7
    restart: always
    networks:
      - mysql-bridge
    ports:
      - "3306:3306"
    volumes:
      - /data1/mysql-container/etc:/etc/mysql
      - /data1/mysql-container/data:/var/lib/mysql
      - /etc/localtime:/etc/localtime
    environment:
      MYSQL_ROOT_PASSWORD: pass@word1
    deploy:
      resources:
        limits:
          cpus: "1"
          memory: "1024M"
networks:
   mysql-bridge:
     driver: bridge
```



##### dns 服务

###### 下载镜像

```bash
docker pull jpillora/dnsmasq
```

###### 启动命令

```bash
docker run \
    --name dnsmasq \
    -d \
    -p 53:53/udp \
    -p 8080:8080 \
    -v /opt/dnsmasq.conf:/etc/dnsmasq.conf \
    --log-opt "max-size=100m" \
    -e "HTTP_USER=admin" \
    -e "HTTP_PASS=admin" \
    --restart always \
    jpillora/dnsmasq
```

###### 配置方式

环境变量配置：

| 名称        | 说明     |
| --------- | ------ |
| max-size  | 日志最大保存 |
| HTTP_USER | 登录用户名  |
| HTTP_PASS | 登录密码   |

配置文件映射：

- /etc/dnsmasq.conf：
  
  ```bash
  #dnsmasq config, for a complete example, see:
  #  http://oss.segetech.com/intra/srv/dnsmasq.conf
  #dns解析日志
  log-queries
  #定义主机与IP映射
  address=/h0/172.17.205.28
  address=/h1/172.17.205.32
  ```

参考文档：

- [Docker 1分钟搭建DNS服务器_多一份贡献,多一份环保-CSDN博客_dns docker](https://blog.csdn.net/dounine/article/details/78778258)

- [jpillora/dnsmasq](https://hub.docker.com/r/jpillora/dnsmasq)
