### 使用第三方邮件服务器发送邮件
1. 请求第三方服务器的数字证书（公钥）
```bash
#向 qq 请求证书

echo -n | openssl s_client -connect smtp.qq.com:465 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ~/.certs/qq.crt
#增加一个证书到证书数据库中
certutil -A -n "GeoTrust SSL CA" -t "C,," -d ~/.certs -i ~/.certs/qq.crt
#再增加一个证书到证书数据库中
certutil -A -n "GeoTrust Global CA" -t "C,," -d ~/.certs -i ~/.certs/qq.crt

# 此处需要注意的是，证书需要防止在一个所有用户都能够读取到的地方。推荐放在 /etc/ssl/certs
# 否则会报错： Error initializing NSS: Unknown error -8015.

# 出现“Error in certificate: Peer's certificate issuer is not recognized.”的报错。（证明证书不被信任）
certutil -A -n "GeoTrust SSL CA - G3" -t "Pu,Pu,Pu" -d ./ -i qq.crt
```
2. 配置 /etc/mail.rc 
```bash
# 在 /etc/mail.rc 中添加如下内容 
set ssl-verify=ignore
set nss-config-dir=/etc/ssl/certs
set smtp=smtps://smtp.qq.com:465
set smtp-auth-user=369453502@qq.com
set smtp-auth-password=mypgjhpxzqxabhfd
set smtp-auth=login
set from=369453502@qq.com
```

### vps 部署邮件服务器
#### 配置postfix
1.配置myhostname，mydomain，myorigin

2.配置 mynetworks ：配置该 smtp 信任的网络。主要影响  smtpd_relay_restrictions ，smtpd_client_restrictions 和 smtpd_recipient_restrictions 中 permit_mynetworks 对应的网络范围。<br>
restrictions可选选项有：<ul>
    <li>permit_mynetworks</li>
    <li>permit_sasl_authenticated</li>
    <li>reject_unauth_destination</li>
</ul>
3.配置 mydestination 以及 relayhost。
```bash
# mydestination 是配置该邮件服务器直接发送邮件的目标地址。可以配置 ip 或者 服务器网址。
# relayhost 是配置转发的服务器，如果目标邮件服务器不在 mydestination 中就会转发到 relayhost。
```

可以采用 vpn 的方式绕过 25端口的限制。

### 错误处理
postfix 日志存放位置：/var/log/maillog

##### 5.7.8 Error: authentication failed: generic failure
1. saslauthd 服务没有启动。
2. 查看 /etc/sasldb2 是否对所有人有阅读权限

##### 5.7.8 Error: authentication failed: authentication failure
检查 /etc/mail.rc 中的用户名和密码是否配置正确。
```bash
# 此处配置的是邮件登陆的用户名，需要带上 domain 名。
set smtp-auth-user=root@local.spark-liang.top
# saslpasswd2 中创建的用户对应的密码
set smtp-auth-password=123456
```

##### 邮件成功发送到邮件服务器，但是邮件服务器无法解析内网目标地址。
```bash
postconf -e 'smtp_host_lookup = dns, native'
```

##### Relay access denied
在 postfix 2.10 版本之后就需要配置 smtpd_relay_restrictions。<br>
该选项需要配置一下选项中的任意一项:
reject_unauth_destination, defer_unauth_destination, reject, defer, defer_if_permit or check_relay_domains