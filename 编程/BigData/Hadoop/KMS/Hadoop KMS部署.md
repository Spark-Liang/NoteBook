### Hadoop KMS

- 简介
  
  - 接口使用

- 部署
  
  - Java KeyStore方案

#### 简介

Hadoop KMS提供管理秘钥的接口，可以通过`hadoop key`命令进行秘钥的增删改查

##### 接口使用

示例命令：

```bash
# 创建秘钥
hadoop key create <key name>
# 查看所有秘钥
hadoop key list [-metadata]
# 删除秘钥
hadoop key delete <key name>
```

注意点：

- 需要在`core-site.xml`配置`hadoop.security.key.provider.path`选项，用于设置操作的kms的后端。
  
  - 常用的是http的kms后端，url格式是`kms://http@<host>:<port>/kms`

#### 部署

hadoop本身提供了内置的kms后端实现，将秘钥存储在JavaKeyStore中，并启动web后端操作KeyStore文件

##### KeyStore方案配置

###### 配置文件

1. 修改`kms-site.xml`，配置keystore文件的路径，keystore如果不存在kms会自动创建。
   
   ```xml
   <property>
     <name>hadoop.kms.key.provider.uri</name>
     <value>jceks://file@<keystore path></value>
   </property>
   ```

2. 修改`kms-env.sh`
   
   - `HADOOP_KEYSTORE_PASSWORD`：keystore文件密码
   
   - `KMS_HTTP_PORT`：设置KMS服务的端口。

3. 配置`core-site.xml`设置kms 的访问方式
   
   ```xml
   <property>
   <name>hadoop.security.key.provider.path</name>
   <value>kms://http@<kms host>:<kms port>/kms</value>
   </property>
   ```

4. 配置`hdfs-site.xml`设置kms访问方式
   
   ```xml
   <property>
   <name>dfs.encryption.key.provider.uri</name>
   <value>kms://http@<kms host>:<kms port>00/kms</value>
   </property>
   ```

5. 重启hdfs

###### 参考文档

- [hadoop-KMS密钥管理服务配置使用_shy_snow的博客-CSDN博客_hadoop kms](https://blog.csdn.net/shy_snow/article/details/123094930)
