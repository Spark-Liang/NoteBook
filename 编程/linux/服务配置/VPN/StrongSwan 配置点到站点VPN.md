##### 源码安装

###### 依赖包

```bash
yum install -y gmp-devel pam-devel openssl-devel make gcc 
```

###### 安装包获取

```bash
wget --no-check-certificate https://download.strongswan.org/strongswan-5.5.3.tar.gz
```

###### 安装步骤

1. 解压安装包

2. 配置安装路径和其他属性
   
   ```bash
   ./configure \
       --prefix=/usr/local/strongswan \
       --sysconfdir=/etc/strongswan \
       --enable-openssl \
       --enable-nat-transport \
       --disable-mysql \
       --disable-ldap \
       --disable-static \
       --enable-shared \
       --enable-md4 \
       --enable-eap-mschapv2 \
       --enable-eap-aka \
       --enable-eap-aka-3gpp2 \
       --enable-eap-gtc \
       --enable-eap-identity \
       --enable-eap-md5 \
       --enable-eap-peap \
       --enable-eap-radius \
       --enable-eap-sim \
       --enable-eap-sim-file \
       --enable-eap-simaka-pseudonym \
       --enable-eap-simaka-reauth \
       --enable-eap-simaka-sql \
       --enable-eap-tls \
       --enable-eap-tnc \
       --enable-eap-ttls
   ```

3. 执行安装命令`make && make install`

4. 进行证书生成，证书生成的工具在安装目录的`bin`目录下
   
   1. 创建生成证书的临时目录
      
      ```bash
      cd /usr/local/strongswan
      mkdir tmp
      cd tmp
      ```
   
   2. 生成ca根证书
      
      ```bash
      # 生成私钥
      ../bin/pki --gen --outform pem > ca.key.pem
      # 根证书自签名
      ../bin/pki --self --ca --in ca.key.pem \
      --dn "C=CN, O=SparkLiang-Clound-VPN, CN=SparkLiang-Clound-VPN-CA"  \
      --lifetime 3650 --outform pem > ca.cert.pem
      ```
      
      `--self` 表示自签证书  
      `--in` 是输入的私钥  
      `--dn` 是判别名
      
      - C 表示国家名，同样还有 ST 州/省名，L 地区名，STREET（全大写） 街道名
      - O 组织名称
      - CN 友好显示的通用名
      
      `--ca` 表示生成 CA 根证书  
      `--lifetime` 为有效期, 单位是天
   
   3. 生成服务端证书
      
      ```bash
      # 生成私钥
      ../bin/pki --gen --outform pem > server.key.pem
      # 生成公钥
      ../bin/pki --pub --in server.key.pem --outform pem > server.pub.pem
      
      # 使用ca公钥签名服务器公钥
      ../bin/pki  --issue --lifetime 3600 \
      --cacert ca.cert.pem --cakey ca.key.pem \
       --in server.pub.pem \
       --dn "C=CN, O=SparkLiang-Clound-VPN, CN=120.24.189.240" \
       --san="120.24.189.240" --flag serverAuth --flag ikeIntermediate \
       --outform pem > server.cert.pem
      ```
      
      - `--issue`, `--cacert` 和 `--cakey` 就是表明要用刚才自签的 CA 证书来签这个服务器证书。
      
      - `--in`服务器私钥文件
      
      - `--dn`：服务器证书文件的判别名，不需要和ca的`--dn`相同
      
      - `--san`：服务器的公网地址或者域名
      
      - 其他`--flag`选项的作用
        
        - iOS 客户端要求 CN 也就是通用名必须是你的服务器的 URL 或 IP 地址;
        
        - Windows 7 不但要求了上面，还要求必须显式说明这个服务器证书的用途（用于与服务器进行认证），–flag serverAuth;
        
        - 非 iOS 的 Mac OS X 要求了“IP 安全网络密钥互换居间（IP Security IKE Intermediate）”这种增强型密钥用法（EKU），–flag ikdeIntermediate;
        
        - Android 和 iOS 都要求服务器别名（serverAltName）就是服务器的 URL 或 IP 地址，–san。
   
   4. 生成客户端证书，步骤与服务器相同，只是无需`--san`和`--flag`等参数
      
      ```bash
      # 生成私钥
      ../bin/pki --gen --outform pem > client.key.pem
      # 生成公钥
      ../bin/pki --pub --in client.key.pem --outform pem > client.pub.pem
      
      # 使用ca公钥签名服务器公钥
      ../bin/pki  --issue --lifetime 3600 \
      --cacert ca.cert.pem --cakey ca.key.pem \
       --in client.pub.pem \
       --dn "C=CN, O=SparkLiang-Cloud-VPN, CN=VPN-Client" \
       --outform pem > client.cert.pem
      ```
   
   5. 拷贝生成的证书到`ipsec.d`中
      
      ```bash
      cp -r ca.key.pem /etc/strongswan/ipsec.d/private/
      cp -r ca.cert.pem /etc/strongswan/ipsec.d/cacerts/
      cp -r server.cert.pem /etc/strongswan/ipsec.d/certs/
      cp -r server.pub.pem /etc/strongswan/ipsec.d/certs/
      cp -r server.key.pem /etc/strongswan/ipsec.d/private/
      cp -r client.cert.pem /etc/strongswan/ipsec.d/certs/
      cp -r client.key.pem /etc/strongswan/ipsec.d/private/
      ```

##### IKEv2-EAP 方式配置

###### 配置项解析

- 配置魔术字
  
  - `%any`：任意输入

- 验证相关配置
  
  - `[left|right]auth`: 本地端和远端的验证方式
    
    - pubkey：公钥验证身份
    
    - eap-mschapv2：用户名密码验证身份
  
  - 公钥验证信息
    
    - `[left|right]ca`：ca的dn
    
    - `[left|right]cert`：pem格式的证书路径，证书放在`${配置路径}/ipsec.d/certs`下
    
    - `[left|right]sendcert`：是否发生证书

- ip和登录标识配置
  
  - `[left|right]`：在vpn中的ip地址
  
  - `[left|right]id`：在vpn中的标识
  
  - `[left|right]subnet`：本地或者远端的子网
  
  - `[left|right]sourceip`：本地或远端的ip池

- 

###### 配置`ipsec.secret`文件

配置格式：

- RSA：`[ <id selectors> ] : RSA <private key file> [ <passphrase> | %prompt ]`

- EAP: `[ <id selectors> ] : EAP <secret>`



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



##### 其他各种配置场景的官方教程

[strongSwan - Test Scenarios](https://www.strongswan.org/test-scenarios/)
