### cfssl工具构建pki及自签证书

- 安装

- 使用

#### 安装

从官网下载对应架构的可执行文件，放到`/usr/local/bin`中

```bash
current_arch=amd64
wget https://pkg.cfssl.org/R1.2/cfssl-certinfo_linux-${current_arch}
wget https://pkg.cfssl.org/R1.2/cfssl_linux-${current_arch}
wget https://pkg.cfssl.org/R1.2/cfssljson_linux-${current_arch}

mv cfssl-certinfo_linux-${current_arch} /usr/local/bin/cfssl-certinfo
mv cfssl_linux-${current_arch} /usr/local/bin/cfssl
mv cfssljson_linux-${current_arch} /usr/local/bin/cfssljson

chmod a+x  /usr/local/bin/cfssl*
```

#### 使用

##### 相关配置文件

- `ca-config.json`：ca配置文件，用于配置ca签发证书的选项，如失效时间、证书支持功能。

- `xxx-csr.json`：证书请求配置，用于配置证书的主体信息。

`ca-config.json`示例：

```json
{
  "signing": {
    "default": {
      "expiry": "87600h"
    },
    "profiles": {
      "kubernetes": {
        "usages": [
            "signing", "key encipherment","server auth","client auth"
        ],
        "expiry": "87600h"
      }
    }
  }
}
```

- default：配置签发证书的默认配置

- profiles：配置多个证书签发的配置项组合，通过`--profile=`选择在签发证书时使用。
  
  - usages：用于配置证书的用途。
    
    - `signing`：代表这是ca证书
    
    - `server auth`和`client auth`：分别代表服务器和客户端证书

`xxx-csr.json`示例:

```json
{
  "CN": "kubernetes",    
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "CN",
      "ST": "GuangDong",
      "L": "ShenZhen",
      "O": "k8s",
      "OU": "System"
    }
  ]
  "hosts": [
        "*.example.com",
        "www.example.com",
        "https://www.example.com",
        "jdoe@example.com",
        "127.0.0.1"
    ],
}   
```

- CN: 配置common name
- key：配置证书秘钥类型
- names：配置证书的其他主题信息
- hosts：配置证书的可选名称

##### 证书生成步骤

1. 生成自签根ca
   
   ```bash
   cfssl gencert -initca ca-csr.json | cfssljson -bare ca
   ```

2. 生成证书
   
   ```bash
   cfssl gencert -ca=ca.pem -ca-key=ca-key.pem \
   -config=ca-config.json -profile=kubernetes \
   kubernetes-csr.json | cfssljson -bare kubernetes
   ```

注意点：

- `-bare`:用于控制生成的文件名的前缀

#### 参考文档

- [CFSSL使用方法重新整理说明_weixin_34102807的博客-CSDN博客](https://blog.csdn.net/weixin_34102807/article/details/92184312)
