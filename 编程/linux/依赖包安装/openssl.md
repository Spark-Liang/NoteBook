#### openssl

- 依赖环境

- 安装配置

##### 依赖环境

- perl 5

- 编译环境`gcc g++ make`

- 

##### 安装配置

###### 源码安装

1. 下载源码包 https://www.openssl.org/source/openssl-1.1.1h.tar.gz
2. 添加软连接保证可以使用openssl的库文件

```bash
# 库文件连接
ln -s /usr/local/openssl/lib/libssl.so.1.1 /usr/lib64/libssl.so.1.1

# 头文件连接
ln -s /usr/local/openssl/include/openssl /usr/include/openssl
```

1. 

#### 参考文档

- [Openssl源码安装及升级_bestmem的博客-CSDN博客_openssl源码安装](https://blog.csdn.net/turnaroundfor/article/details/86076214)
