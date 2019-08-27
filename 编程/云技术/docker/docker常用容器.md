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
