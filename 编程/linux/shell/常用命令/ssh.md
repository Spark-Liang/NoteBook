##### ssh命令常用要点

- 设置ssh为自动添加hostkey到know\_hosts
- Permission denied (publickey,gssapi-keyex,gssapi-with-mic)
- ssh 静默生成公钥

###### 设置ssh为自动添加hostkey到know_hosts

而此时必须输入yes，连接才能建立。

```bash
The authenticity of host ‘git.sws.com (10.42.1.88)’ can’t be established. 
ECDSA key fingerprint is 53:b9:f9:30:67:ec:34:88:e8:bc:2a:a4:6f:3e:97:95. 
Are you sure you want to continue connecting (yes/no)? yes 
```

但其实我们可以在ssh_config配置文件中配置此项. 配置 StrictHostKeyChecking no。配置文件路径为 /etc/ssh/ssh_config

**注意此时是配置 ssh_config , 并不是 sshd_config**

###### Permission denied (publickey,gssapi-keyex,gssapi-with-mic)

出现这种错误主要是因为 root 用户配置了 ssh 公钥登录，而对应主机的公钥却没有在对应用户目录下的 .ssh/authorized_keys 中有对应记录。

解决办法：把需要ssh登录的主机的公钥复制到 .ssh/authorized_keys 中

```bash
# 公钥用三个部分
<加密算法> 内容 <用户>@<server名>
```

###### ssh 静默生成公钥

ssh 静默生成公钥至少需要配置两个参数，一个是私钥的密码，另一个是文件存放的路径。

```bash
ssh-keygen -N '' -f /root/.ssh/id_rsa -q

# -N 表示私钥的密码
# -f 表示文件存放的位置。其中公钥的文件存放在私钥相同的目录，并且添加.pub 作后缀
```


