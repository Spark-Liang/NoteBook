#### pip

##### pip 配置国内镜像

```batch
pip config  set global.index-url http://mirrors.aliyun.com/pypi/simple/
pip config  set global.trusted-host mirrors.aliyun.com 
:: 设置trusted-host 避免报错

:: 国内镜像
阿里云 http://mirrors.aliyun.com/pypi/simple/ 
中国科技大学 https://pypi.mirrors.ustc.edu.cn/simple/ 

豆瓣(douban) http://pypi.douban.com/simple/ 

清华大学 https://pypi.tuna.tsinghua.edu.cn/simple/ 

中国科学技术大学 http://pypi.mirrors.ustc.edu.cn/simple/
```

##### pip 配置代理

```batch
pip config set global.https_proxy http://ip:port
```
