### Easy-Rsa

easy-rsa主要是用于openvpn中的服务器和客户端的证书管理。

安装方式：下载对应版本的zip文件，直接解压使用

- 在GitHub上下载 “wget https://github.com/OpenVPN/easy-rsa/archive/v3.0.6.zip”

- 或者[在attachements文件夹下下载](attachements/easy-rsa-3.0.6.zip)

在解压后可以在解压目录下的 easyrsa3/ 文件夹中只用 vars.example 模板创建 vars 文件，该文件用于配置一些常用的信息，比如国家，组织名等。常用的配置内容如下：

```bash
>>> cat vars | grep set_var | grep -vE '#set_var|# '

set_var EASYRSA_REQ_COUNTRY     "CN"
set_var EASYRSA_REQ_PROVINCE    "BJ"
set_var EASYRSA_REQ_CITY        "BEIJING"
set_var EASYRSA_REQ_ORG         "YXJY"
set_var EASYRSA_REQ_EMAIL       "brian@@qq.com"
set_var EASYRSA_REQ_OU          "YUEXINJIAOYU"
```

#### easy-rsa 生成证书文件的位置

- ca 公钥：pki/ca.crt

- ca 私钥：pki/private/ca.key

- 签名证书公钥：pki/issued

- 签名证书私钥：pki/private

- 签名证书请求：pki/reqs

#### easy-rsa的基本流程

```mermaid
graph LR

A[init-pki]-->B[build-ca]
B --> C[gen-req for server]
C-->D[sign sign request for server]
D-->E[gen-dh]
```

使用easy-rsa构建openvpn的证书pki主要有以下的步骤：

1. 先通过init-pki构建一个新的pki

2. 然后通过 build-ca 构建一个新的ca

3. 使用 gen-req 构建server的私钥和签名请求

4. 然后签名认证server的请求。

下面是详细的步骤：

##### 1.初始化

```bash
>>> ./easyrsa init-pki


Note: using Easy-RSA configuration from: ./vars

init-pki complete; you may now create a CA or requests.
Your newly created PKI dir is: /etc/openvpn/easy-rsa/easyrsa3/pki
```

##### 2.构建ca

构建ca过程中需要用到vars中的参数来构建有关ca的一些信息。并且需要设置ca私钥的密码

```bash
>>> ./easyrsa build-ca


Note: using Easy-RSA configuration from: ./vars

Using SSL: openssl OpenSSL 1.0.2k-fips  26 Jan 2017

# 这里要输入两次密码，密码自定义(一定不能忘)
Enter New CA Key Passphrase:
Re-Enter New CA Key Passphrase:

Generating RSA private key, 2048 bit long modulus
.........................................................................................+++
..........................................................+++
e is 65537 (0x10001)
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
# 输入CA的通用名(唯一，不能和server或者client的通用名重复)

Common Name (eg: your user, host, or server name) [Easy-RSA CA]:yxjy

CA creation complete and you may now import and sign cert requests.
Your new CA certificate file for publishing is at:
/etc/openvpn/easy-rsa/easyrsa3/pki/ca.crt
```

##### 3.构建服务器私钥和请求

```bash
# 过程中需要设置server的私钥密码，nopass 参数可以使easy-rsa自动生成私钥。
>>> ./easyrsa gen-req server 


Note: using Easy-RSA configuration from: ./vars

Using SSL: openssl OpenSSL 1.0.2k-fips  26 Jan 2017
Generating a 2048 bit RSA private key
....................+++
....+++
writing new private key to '/etc/openvpn/easy-rsa/easyrsa3/pki/private/server.key.8wvYsw415K'
-----
You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
# 一个通用名(唯一)
Common Name (eg: your user, host, or server name) [server]:brian

Keypair and certificate request completed. Your files are:
req: /etc/openvpn/easy-rsa/easyrsa3/pki/reqs/server.req
key: /etc/openvpn/easy-rsa/easyrsa3/pki/private/server.key
```

##### 4.认证服务器证书

**注意下面第一个“server” 是类型，可选 server 或者 client。第二个是sign的request 的名字。**

```bash
>>> ./easyrsa sign-req server server


Note: using Easy-RSA configuration from: ./vars

Using SSL: openssl OpenSSL 1.0.2k-fips  26 Jan 2017


You are about to sign the following certificate.
Please check over the details shown below for accuracy. Note that this request
has not been cryptographically verified. Please be sure it came from a trusted
source or that you have verified the request checksum with the sender.

Request subject, to be signed as a server certificate for 1080 days:

subject=
    commonName                = brian


# 这里输入yes即可
Type the word 'yes' to continue, or any other input to abort.
  Confirm request details: yes
Using configuration from /etc/openvpn/easy-rsa/easyrsa3/pki/safessl-easyrsa.cnf

# 这里要输入上面一开始的密码
Enter pass phrase for /etc/openvpn/easy-rsa/easyrsa3/pki/private/ca.key:
Check that the request matches the signature
Signature ok
The Subject's Distinguished Name is as follows
commonName            :ASN.1 12:'brian'
Certificate is to be certified until Oct 19 09:08:51 2021 GMT (1080 days)

Write out database with 1 new entries
Data Base Updated

Certificate created at: /etc/openvpn/easy-rsa/easyrsa3/pki/issued/server.crt
```

##### 5.生成Diffie-Hellman，保证key分发安全

```bash
>>> ./easyrsa gen-dh


Note: using Easy-RSA configuration from: ./vars

Using SSL: openssl OpenSSL 1.0.2k-fips  26 Jan 2017
Generating DH parameters, 2048 bit long safe prime, generator 2
This is going to take a long time
.................................................................................+
..................................................................+............................
..............+........................+.......................................................
...........................................+.
DH parameters of size 2048 created at /etc/openvpn/easy-rsa/easyrsa3/pki/dh.pem
```
