##### 常用容器列表

- sql server for linux

- mysql on docker

- 

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
```

###### mysql on docker

```bash
docker run -p 3306:3306 --name mysql-container \
-e MYSQL_ROOT_PASSWORD=123456 -d mysql:5.6 

# 额外定义配置文件
-v $PWD/conf:/etc/mysql/conf.d -v $PWD/logs:/logs -v $PWD/data:/var/lib/mysql
```
