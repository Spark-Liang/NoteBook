### 全局配置

docker的全局配置文件放在 /etc/sysconfig 中，以docker开头的文件。

用 systemctl enable docker 启用服务后，编辑 /etc/systemd/system/multi-user.target.wants/docker.service 文件，找 到 ExecStart= 这一行。这个选项就是docker 的全局配置项，里面实际上引用的一些变量都是通过 /etc/sysconfig 下的配置文件进行配置。



#### 网络相关

- -b / --bridge：指定容器挂载的网桥，默认使用的是docker0。

- 
