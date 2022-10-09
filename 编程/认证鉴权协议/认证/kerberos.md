### Kerberos

- 原理简介

- 安装部署

#### 原理简介

##### 协议目的

- 在KDC、client和server为与不信任的网络时，在不传递秘钥的情况下完成三方的相互认证

##### 基本假设

- 处于不信任的网络，所以存在以下问题：
  
  - 过程中通信可能会被监听，所以不能采用传递秘钥进行身份验证。
  
  - 通信可能会被重定向，所以协议必须保证认证过后双方是互信的。

- Kerberos只是认证协议，并不包含秘钥分发协议。所以Kerberos假设KDC在分发秘钥给客户端和服务端时，秘钥没有被窃取。基于这个假设才有下面的信任条件
  
  - 请求方信任响应方的条件是，响应方知道自己的秘钥。
  
  - 响应方信任请求方的条件是，请求方能够用自己的秘钥正确解密出随机信息。

- 

##### 技术原理

###### 相关技巧

- 如何在不交换秘钥认证对方身份





#### 参考文档

- [kerberos认证_卢延吉的博客-CSDN博客_kerberos](https://blog.csdn.net/weixin_38233104/article/details/122963237)

- [Kerberos 安装&amp;使用_张伯毅的博客-CSDN博客_kerberos安装配置与使用](https://blog.csdn.net/zhanglong_4444/article/details/115246149)

- [数仓 用户认证 Hadoop Kerberos配置_Alienware^的博客-CSDN博客_kerberos设置密码](https://blog.csdn.net/weixin_45417821/article/details/122759955)
