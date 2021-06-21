#### 服务端配置

[配置教程](ref/ssr_blog.html)

#### 客户端配置

[客户端配置教程](https://blog.liuguofeng.com/p/4010)

#### 客户端启动

```bash
# 使用nohup 保证 ssh 会话推出时进程依旧不会被kill
nohup sslocal -c /etc/shadowsocks.json /dev/null 2>&1 & 

privoxy --user privoxy /usr/local/etc/privoxy/config
```

##### 报错处理

###### 启动报undefined symbol: EVP_CIPHER_CTX_cleanup错误

错误信息：

```shell
AttributeError: /usr/local/ssl/lib/libcrypto.so.1.1: undefined symbol: EVP_CIPHER_CTX_cleanup
```

原因：在openssl1.1.0版本中，废弃了EVP_CIPHER_CTX_cleanup函数转而用EVP_CIPHER_CTX_reset替代。

解决方案：找到相关的openssl.py文件，修改EVP_CIPHER_CTX_cleanup成EVP_CIPHER_CTX_reset。

##### 自启动配置
