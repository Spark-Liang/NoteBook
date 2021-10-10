### 配置 VPN 服务端

https://www.jianshu.com/p/2bfabcdd88b7

### 配置 VPN 客户端

1.安装ppp pptp pptp-setup

```bash
yum install ppp pptp pptp-setup
```

2.创建VPN连接

```bash
pptpsetup --create <vpn_name> --server ip地址 \
--username <username> --password <password> --start
# username 和 password 是服务端的 /etc/ppp/chap-secrets 配置的 username 和 password
```

3.连接VPN连接

```bash
pppd call test  # 这里的test是上面创建vpn连接
```

4.成功后会多出一个虚拟网口ppp0

```bash
[root@localhost peers]# route -n
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
112.124.132.142 192.168.10.1    255.255.255.255 UGH   0      0        0 eth0
192.168.8.1     0.0.0.0         255.255.255.255 UH    0      0        0 ppp0
192.168.10.0    0.0.0.0         255.255.255.0   U     1      0        0 eth0
0.0.0.0         192.168.10.1    0.0.0.0         UG    0      0        0 eth0
```

#### 错误处理

##### FATAL: Module ppp_mppe not found.

```bash
FATAL: Module ppp_mppe not found.
/usr/sbin/pptpsetup: couldn't find MPPE support in kernel.
```

解决方法：

```bash
modprobe ppp_mppe
```

##### LCP terminated by peer (MPPE required but peer refused)

```bash
Using interface ppp0
Connect: ppp0 <--> /dev/pts/3
CHAP authentication succeeded
LCP terminated by peer (MPPE required but peer refused)
Modem hangup
```

解决方法：

```bash
# vim /etc/ppp/peers/test  //test是上面创建的连接

文件尾部，加上以下内容

require-mppe-128
```

##### unknown authentication type 26; Naking

在配置文件`/etc/ppp/options`或者`/etc/ppp/options.pptp`添加以下选项

```textile
refuse-pap
refuse-eap
refuse-chap
refuse-mschap
require-mppe
```
