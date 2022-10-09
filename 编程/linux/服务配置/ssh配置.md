### ssh 配置

#### ssh 密钥体系

##### 简介

ssh 中在服务端和客户端验证都有使用到密钥对。

- 服务端身份验证
  
  - 相关的文件是在`/etc/ssh`目录下的`ssh_host_*_key`文件和`$HOME/.ssh/know_hosts`文件。
  
  - `ssh_host_*_key`代表的是服务端的私钥，是服务端的身份凭证
  
  - `$HOME/.ssh/know_hosts`代表客户端信任的服务端列表，通过记录了不同主机名称对应的公钥，在登录时校验服务端身份
    
    - 第一列是主机名称的模式，支持`*`通配和`,`逗号分隔多个主机名
    
    - 第二，三列分别是公钥类型和公钥，分别对应服务端`ssh_host_*_key.pub`公钥文件的内容

- 客户端身份验证
  
  - 相关文件是服务端对应用户的`$HOME/.ssh/authorized_keys`和客户端登录时使用的私钥文件。
  
  - 客户端身份验证验证过程主要是，客户端发起连接时，服务端发送随机字符串到客户端，然后客户端使用私钥进行加密，然后服务端使用`authorized_keys`中记录的公钥进行解密，如果可以解密就说明是受信客户端
  
  - `$HOME/.ssh/authorized_keys`文件是客户端公钥文件的列表，公钥文件包含三列，公钥类型，公钥和备注。
  
  - 

##### 密钥对生成

非交互生成：

```bash
# 服务端秘钥
ssh-keygen -q -t dsa      -N ''  -C 'host-key' -f ssh_host_dsa_key
ssh-keygen -q -t ecdsa    -N ''  -C 'host-key' -f ssh_host_ecdsa_key
ssh-keygen -q -t ed25519  -N ''  -C 'host-key' -f ssh_host_ed25519_key
ssh-keygen -q -t rsa      -N ''  -C 'host-key' -f ssh_host_rsa_key
ssh-keygen -q -t rsa1     -N ''  -C 'host-key' -f ssh_host_rsa1_key

# 客户端秘钥
ssh-keygen -q -t rsa      -N ''  -C 'client-key' -f id_rsa
```

私钥生成公钥：

```bash
# ssh-keygen -y 使用私钥生成公钥
```

注意点：

- 私钥权限必须为`600`，拥有者必须是用户本身



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
