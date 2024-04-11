[TOC]

## docker相关磁盘空间清理

### 容器日志

假设docker的数据目录在 `/var/lib/docker`

```bash
# 检查容器日志，按照日志文件大小排倒序
ll -rSh /var/lib/docker/containers/*/*json.log
# 清理指定容器日志文件
truncate -s 0 xxxx-json.log
```

限制日志容器大小

在配置文件`/etc/docker/daemon.json`增加配置项，然后重启docker容器服务

```json
{
  "log-driver": "json-file",
  "log-opts": {"max-size": "200m", "max-file": "3"}
}
```

docker-compose限制日志大小（以nginx为例）

```yaml
nginx: 
  image: nginx:1.12.1 
  restart: always 
  logging: 
    driver: "json-file"
    options: 
      max-size: "512M"
```



