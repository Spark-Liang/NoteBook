### Nginx配置

- 安装

- 配置
  
  - 全局配置
    
    - 事件模型配置
  
  - http相关配置
    
    - 访问日志配置
    
    - upstream配置
    
    - server配置
    
    - location配置

- 配置示例

#### 安装

[Nginx 安装配置 | 菜鸟教程](https://www.runoob.com/linux/nginx-install-setup.html)

注意点：

- configure中的`--with-pcre=`配置选项配置的是pcre源码包解压后的路径

##### 配置service文件

参考[NGINX systemd service file | NGINX](https://www.nginx.com/resources/wiki/start/topics/examples/systemd/)

示例文件，保存内容到文件`/lib/systemd/system/nginx.service`：

```
[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
# 配置 nginx.conf 中配置的pid路径
PIDFile=/run/nginx.pid
User=nginx
ExecStartPre=/usr/sbin/nginx -t
ExecStart=/usr/sbin/nginx
ExecReload=/usr/sbin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
```

#### 配置

配置文件结构为：

- 全局块：用于配置nginx进程的全局配置，如运行用户、日志等
  
  - events：用于配置nginx采用的事件模型
  
  - http：用于配置和http请求相关的
    
    - server：用于配置处理请求的虚拟主机
      
      - location：负责配置请求路由
    
    - upstream: 用于配置反向代理相关的主机

##### 全局配置

常见配置项：

- user：配置运行的用户和用户组

- `worker_processes`：配置最大进程数

- `pid`：配置pid文件

- `error_log`：配置日志文件路径和等级

###### 事件模型配置

主要通过events块配置，用于优化nginx的性能。

常见配置项：

- `use`：配置io模型。linux建议epoll，FreeBSD建议采用kqueue，window下不指定。

- `worker_connections`: 每个worker的最大连接数。

- `keepalive_timeout`: keepalive超时时间。

- `client_header_buffer_size`: 客户端请求头部的缓冲区大小。这个可以根据你的系统分页大小来设置，linux可以通过`getconf PAGESIZE`命令取得。

- `open_file_cache`:文件缓存配置。max指定缓存数量，建议和打开文件数一致，inactive是指经过多长时间文件没被请求后删除缓存。

- `open_file_cache_valid`: 这个是指多长时间检查一次缓存的有效信息。

- `open_file_cache_min_uses`: inactive参数时间内文件的最少使用次数

##### http相关配置

###### 访问日志配置

在http块和server块都可通过`log_format`选项自定义访问日志。

访问日志常见的内置变量有：

几个常见配置项：

- $remote_addr 与 $http_x_forwarded_for 用以记录客户端的ip地址；
- $remote_user ：用来记录客户端用户名称；
- $time_local ： 用来记录访问时间与时区；
- $request ： 用来记录请求的url与http协议；
- $status ： 用来记录请求状态；成功是200；
- $body_bytes_s ent ：记录发送给客户端文件主体内容大小；
- $http_referer ：用来记录从那个页面链接访问过来的；
- $http_user_agent ：记录客户端浏览器的相关信息；

示例`log_format`，配置好的`log_format`可以在`access_log`中引用:

```
log_format myFormat '$remote_addr–$remote_user [$time_local] $request $status $body_bytes_sent $http_referer $http_user_agent $http_x_forwarded_for'; #自定义格式
access_log log/access.log myFormat;  #combined为日志格式的默认值
```

###### upstream配置

upstream用于配置某个虚拟站点对应的后端机器。<br>

在http节点下，添加`upstream`节点。然后在`server`节点下的`location`节点中的`proxy_pass`配置为：http:// + upstream名称。<br>

upstream常见的请求分配策略是：

- 基于轮训，并通过weight配置权重。

- `ip_hash`, 基于请求ip的hash

**轮询实例**：

```
upstream linuxidc{ 
      server 10.0.0.77 weight=5; 
      server 10.0.0.88 weight=10; 
}
```

**ip_hash示例**：

```
upstream favresin{ 
      ip_hash; 
      server 10.0.0.10:8080; 
      server 10.0.0.11:8080; 
}
```

参考文档：[Nginx使用upstream实现负载均衡 - 永恒的回忆 - 博客园](https://www.cnblogs.com/muhy/p/10528449.html)

###### server 配置

用于配置每个虚拟服务，通常一个`server_name`加一个`listen`端口代表一个虚拟服务器。然后通过`location`配置将指定的url路径转发到指定的后端服务。

server级配置项:

- listen: 监听的端口

- server_name: 当前服务器的FQDN，或者是当前服务器FQDN的子域`{子服务名称}.{FQDN}`。

- access_log：访问日志配置，配置文件路径及使用的日志格式

- error_page：当返回错误码时，跳转的路径

###### location配置
