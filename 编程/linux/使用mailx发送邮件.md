1. 安装mailx
```bash
yum install mailx
```
2. 首先在邮箱中开启smtp，开启后会得到一个授权码，这个授权码就代替了密码（自行去邮箱开启）。
3. 请求数字证书（这里用的qq邮箱，所以向qq请求证书）
```bash
mkdir -p /root/.certs/
echo -n | openssl s_client -connect smtp.qq.com:465 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ~/.certs/qq.crt
certutil -A -n "GeoTrust SSL CA" -t "C,," -d ~/.certs -i ~/.certs/qq.crt
certutil -A -n "GeoTrust Global CA" -t "C,," -d ~/.certs -i ~/.certs/qq.crt
certutil -A -n "GeoTrust SSL CA - G3" -t "Pu,Pu,Pu" -d ~/.certs/./ -i qq.crt
certutil -L -d /root/.certs
```
4. 配置/etc/mail.rc
```bash
set from=xxx@qq.com #之前设置好的邮箱地址
set smtp=smtps://smtp.qq.com:465 #邮件服务器
set smtp-auth-user=xxx@qq.com #之前设置好的邮箱地址
set smtp-auth-password=xxxx #授权码
set smtp-auth=login #默认login即可
set ssl-verify=ignore #ssl认证方式
set nss-config-dir=/root/.certs #证书所在目录
```