#### 客户端配置



[客户端配置教程](https://blog.liuguofeng.com/p/4010)



#### 客户端启动

```bash
# 使用nohup 保证 ssh 会话推出时进程依旧不会被kill
nohup sslocal -c /etc/shadowsocks.json /dev/null 2>&1 & 

privoxy --user privoxy /usr/local/etc/privoxy/config
```
