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

**可以同时配置多个源，注意每个源的host都要添加到 trusted-host中**

```textile
extra-index-url=http://pypi.douban.com/pypi/simple/
	http://pypi.hustunique.com/pypi/simple/
	http://pypi.tuna.tsinghua.edu.cn/pypi/simple/
	http://pypi.python.org/pypi/simple/
trusted-host = mirrors.aliyun.com
	pypi.douban.com
	pypi.hustunique.com
	pypi.tuna.tsinghua.edu.cn
	pypi.python.org

```

##### pip 配置代理

```batch
pip config set global.https_proxy http://ip:port
```



##### 配置文件位置

全局配置文件位于用户目录下，`~\AppData\Roaming\pip\pip.ini`
