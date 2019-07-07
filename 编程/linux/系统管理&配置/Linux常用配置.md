### 设置 yum 源

```bash
sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
sudo wget -O /etc/yum.repos.d/CentOS-Base.repo  http://mirrors.aliyun.com/repo/Centos-7.repo
```

### 设置swap

```bash
sudo dd if=/dev/zero of=/var/swap bs=1G count=4
sudo chmod 600 /var/swap
sudo mkswap /var/swap
sudo bash -c "echo '/var/swap swap swap defaults 0 0' >> /etc/fstab"
sudo swapon -a

vm.swappiness = 20
```

### 设置清理缓存

```bash
sudo crontab -e

*/1 * * * * echo 3 > /proc/sys/vm/drop_caches
```

### 配置 github 加速

```bash
# 向/etc/hosts 添加以下地址
151.101.44.249 github.global.ssl.fastly.net 
192.30.253.113 github.com 
103.245.222.133 assets-cdn.github.com 
23.235.47.133 assets-cdn.github.com 
203.208.39.104 assets-cdn.github.com 
204.232.175.78 documentcloud.github.com 
204.232.175.94 gist.github.com 
107.21.116.220 help.github.com 
207.97.227.252 nodeload.github.com 
199.27.76.130 raw.github.com 
107.22.3.110 status.github.com 
204.232.175.78 training.github.com 
207.97.227.243 www.github.com 
185.31.16.184 github.global.ssl.fastly.net 
185.31.18.133 avatars0.githubusercontent.com 
185.31.19.133 avatars1.githubusercontent.com
```
