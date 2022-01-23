### ssh 配置

#### ssh互信

互信步骤：

1. 生成`id_rsa`和`id_rsa.pub`文件

2. 使用`ssh-copy-id`或者直接将`id_rsa.pub`添加到目标主机上用户的`~/.ssh/authorized_keys`中



#### sshd\_config配置及相关问题

##### root登录显示Permission Denied

###### 原因：

sshd配置了禁止使用root登录

###### 解决方式

修改`/etc/ssh/sshd_config`文件，配置`PermitRootLogin`为`yes`
