#### service 启动失败排查方法

在 service 其中失败后，通常报错信息很少。更详细的信息可以通过 **/var/log/message** 文件查看，在启动过程中的所有输出。用于排查service 启动失败原因。



#### 本地能够正常访问服务，但是无法进行远程访问

需要检查 selinux 和 Firewalld 是否配置对应端口开放

```bash
# 可以先将 selinux 设为 disable 检查是否由于 selinux 造成
vim /etc/selinux/config

# SELinux=enforcing
SELinux=disable

# 停止 firewalld 服务检查是否由于 firewalld 造成。
sudo service firewalld stop
```
