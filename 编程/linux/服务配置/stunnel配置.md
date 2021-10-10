### stunnel

stunnel 是用于在服务端和客户端之间构建一条基于ssl的安全信道。

#### stunnel 配置

##### 安装：

```bash
yum install stunnel
```

配置配置文件，stunnel 默认使用的配置文件位置在 /etc/stunnel/stunnel.conf。配置文件分为两个部分，全局配置和service level 配置

##### 测试

可以通过telnet测试stunnel端口是否能够连接

##### 错误

###### Connection closed by foreign host

当telnet失败出现`Connection closed by foreign host.`时，需要检查日志文件查看原因。

- `routines:ssl_choose_client_version:unsupported protocol`:
  
  - 原因：客户端允许的SSL版本与服务器不兼容
  
  - 解决方案：
    
    - 找到openssl的配置文件。可以通过find命令在etc目录下找
    
    - 找到openssl.cnf后，查看`openssl_conf = `指向的配置项中`MinProtocol`和`MaxProtocol`的允许范围。一般是`TLSv1.0`到`TLSv1.3`
    
    - 然后重启stunnel即可

#### 配置stunnel自启动

如果使用的私钥文件有加密，需要通过yum安装`expect`实现密码自动输入。

##### expect文件配置

```shell
#!/bin/expect #用expect执行下面脚本
spawn su#执行su命令
expect "Password:"#看到这样的文本时
exp_send "123123\r"#输入密码
interact#进入交互状态
```

启动脚本内容：

```shell
#!/bin/bash
#chkconfig:35 85 25
#description: stunnel
#processname: stunnel

source /etc/profile

EXEC_USER=root
SERVICE_LOCK_PATH=/var/lock/subsys/`basename $0`

case $1 in
  start)
    ./etc/stunnel/start_stunnel.expect
    touch "$SERVICE_LOCK_PATH"
  ;;
  stop)
    stunnel stop
    [[ -f "$SERVICE_LOCK_PATH" ]] && rm "$SERVICE_LOCK_PATH"
  ;;
  *) echo "can only start or stop" ;;
esac
```
