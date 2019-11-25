##### 配置步骤

1. server端配置
   
   1. 生成客户端所需证书。
   
   2. 配置ipsec.conf 文件
   
   3. 修改内核参数文件，来支持内核转发
   
   4. 启动服务
   
   5. 阿里云的路由表配置相应条目，把client的网段指向 VPN server。

2. client端配置
   
   1. 安装证书
   
   2. **配置路由，把server端的网段指向 vpn 接口。**
      
      1. route add 172.18.0.0 mask 255.255.0.0 10.168.2.1 -p
      2. 查看路由配置命令 route 

###### 配置教程

[https://blog.itnmg.net/2015/04/03/centos7-ipsec-vpn/](https://blog.itnmg.net/2015/04/03/centos7-ipsec-vpn/)
