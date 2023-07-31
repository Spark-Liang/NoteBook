Hive 安装配置

- linux

###### linux

安装路径https://hive.apache.org/downloads.html

1. 前期准备：
   
   1. 安装JDK
   
   2. 安装Hadoop
   
   3. 安装mysql

2. 下载并解压 apache-hive-2.1.1-bin.tar.gz

3. 在/etc/profile 中配置环境变量 HIVE_HOME 已经添加到 PATH

4. 复制 hive-env.sh.template 到 hive-env.sh，并export 对应的HADOOP_HOME 和 JAVA_HOME

5. 复制 hive-default.xml.template 到 hive-site.xml 但是需要注意的是，**要删除template中原本的配置项，否则新添加的配置项会导致重复配置的错误。**

6. 在HDFS中创建对应的文件路径
   
   ```bash
   hdfs dfs -mkdir -p /user/hive/warehouse
   hdfs dfs -mkdir -p /user/hive/tmp
   hdfs dfs -mkdir -p /user/hive/log
   hdfs dfs -chmod g+w /user/hive/warehouse
   hdfs dfs -chmod g+w /user/hive/tmp
   hdfs dfs -chmod g+w /user/hive/log
   ```

7. 在 hive-site.xml中添加对应的配置项
   
   ```xml
   <property>
       <name>hive.exec.scratchdir</name>
       <value>/user/hive/tmp</value>
       <description>HDFS root scratch dir for Hive jobs which gets created with write all (733) permission. For each connecting user, an HDFS scratch dir: ${hive.exec.scratchdir}/<username> is created, with ${hive.scratch.dir.permission}.</description>
     </property>
     <property>
       <name>hive.metastore.warehouse.dir</name>
       <value>/user/hive/warehouse</value>
       <description>location of default database for the warehouse</description>
     </property>
   <property>
       <name>hive.querylog.location</name>
       <value>/user/hive/log</value>
       <description>Location of Hive run time structured log file</description>
     </property>
   ```

8. 在mysql中配置对应的db和用户
   
   使用下面的命令在mysql 创建对应的用户
   
   ```sql
   CREATE USER 'hive'@'%'  IDENTIFIED BY   'hive'
   ```
   
   **需要注意的是xml 中 & 需要用$\&amp;$进行替换**
   
   ```<property>xml
   <property>
       <name>javax.jdo.option.ConnectionURL</name>
       <value>jdbc:mysql://localhost:3306/hive?createDatabaseIfNotExist=true&characterEncoding=UTF-8&useSSL=false</value>
     </property>
     <property>
       <name>javax.jdo.option.ConnectionDriverName</name>
       <value>com.mysql.jdbc.Driver</value>
     </property>
     <property>
       <name>javax.jdo.option.ConnectionUserName</name>
       <value>hive</value>
     </property>
     <property>
       <name>javax.jdo.option.ConnectionPassword</name>
       <value>hive</value>
     </property>
   ```

9. 启动hadoop和mysql

10. 拷贝 jdbc driver到lib目录下

11. 初始化hive schema 。
    
    ```
    schematool -dbType mysql -initSchema
    ```

12. 执行hive命令进入

##### 配置启动 metastore

增加metastore绑定端口配置

```xml
<property>
  <name>hive.metastore.port</name>
  <value>9083</value>
</property>
```

运行启动命令

```bash
nohup bin/hive --service metastore 2>&1 1>logs/metastore.log &
```

其他进程比如hiveserver2 `hive.metastore.uris` 配置的地址访问metastore

```xml
<property>
    <name>hive.metastore.uris</name>
    <value>thrift://{ip}:9083</value>
  </property>
```

###### 配置hiveserver2

启动hiveserver2 需要在hive-site.xml中添加下列的配置项

```xml
<!-- 这是hiveserver2 -->
<property>
    <name>hive.server2.thrift.port</name>
    <value>10000</value>
</property>
<property>
  <name>hive.server2.webui.port</name>
  <value>10002</value>
</property>
<property>
    <name>hive.server2.thrift.bind.host</name>
    <value>your host name</value>
</property>
```

运行启动命令：

```bash
nohup bin/hive --service hiveserver2 2>&1 1>logs/hiveserver2.log &
```

通过beeline命令连接hive：

```bash
bin/beeline -u 'jdbc:hive2://127.0.0.1:10000' -n root -p 'pass@word1'
```

##### 错误收集

###### hive schema 版本和数据库不对应:"message:Hive Schema version 2.1.0 does not match metastore's schema version 1.2.0 Metastore is not upgraded or corrupt"

直接到hive对应的metadata 数据库，把 VERSION 表下的 SCHEMA_VERSION update 成对应版本的。

另外可以直接禁用schema 版本检查

```xml
<property>
    <name>hive.metastore.schema.verification</name>
    <value>false</value>
</property>
```

###### `Cannot find hadoop installation: $HADOOP_HOME or $HADOOP_PREFIX must be set or hadoop must be in the path`

检查`hive-env.sh`配置的HADOOP_HOME 环境变量，是否配置正确

###### `NoSuchMethodError: com.ibm.icu.impl.ICUBinary.getRequiredData`

移除lib目录下的`icu4j-4.8.1.jar`包
