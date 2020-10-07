#### Spark 集成 Hive

- [SparkSQL操作Hive Table](#SparkSQL操作Hive Table)

- [配置 Thrift Server](#配置 Thrift Server)

- [Hive site 文件配置](#Hive site 文件配置)



##### SparkSQL操作Hive Table

- 基础配置

###### 基础配置

- 在对应的项目中添加 spark-hive 的依赖比如maven 的项目添加如下依赖
  
  ```<dependency>xml
  <dependency>
        <groupId>org.apache.spark</groupId>
  
        <artifactId>spark-hive_2.11</artifactId>
  
        <version>${spark.version}</version>
  
  </dependency>
  ```

- 在对应的代码中，保证获得的





##### 

##### 配置 Thrift Server

Thrift server 用于提供使用 jdbc 或者 odbc 访问 spark sql 的能力。





###### 前置条件

1. 先安装 hive，或者下载hive 的安装包。[下载地址](https://hive.apache.org/downloads.html)

###### 配置步骤

1. 创建 hive-site.xml 或者从 hive的安装目录中的 conf 目录下将 hive-site.xml 拷贝 spark/conf. hive-site.xml 的基本结构是 configuration 为根的配置文件。hive-site.xml 中没有配置的选项，其默认值参考 [](https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties#ConfigurationProperties-MetaStore)
   
   ```xml
   <configuration>
   <!-- your configuration -->
   </configuration>
   ```

2. 从 hive 安装目录中 和 hadoop 的安装包中拷贝对应的 jar 包到 spark/jars 下
   
   ```shell
   cp ${HIVE_HOME}/lib/hive-shims-* ${SPARK_HOME}/jars
   cp ${HADOOP_HOME}/share/hadoop/yarn/hadoop-yarn-server-resourcemanager*.jar ${SPARK_HOME}/jars
   ```

3. 启动Thrift server
   
   ```shell
   ${SPARK_HOME}/sbin/start-thriftserver.sh
   ```

##### Hive site 文件配置

Hive site 所有可选配置项及其默认值，可以参考[官方文档](https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties#ConfigurationProperties-MetaStore)

###### Hive site 文件变量命名空间

hive-site.xml 这个文件可以通过配置 hive.variable.substitute 为true，来启用变量引用功能。**引用语法为：\${变量名} 进行引用**。Hive的变量前面可以有一个命名空间，包括三个hiveconf，system，env，还有一个hivevar

- hiveconf的命名空间指的是hive-site.xml下面的配置变量值。
- system的命名空间是系统的变量，包括JVM的运行环境。如\$\{system:java.io.tmpdir\}
- env的命名空间，是指环境变量，包括Shell环境下的变量信息，如HADOOP_HOME之类的。如 \${env:JAVA\_HOME}。



###### 常用hive site 选项

**[metastore配置相关](https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties#ConfigurationProperties-MetaStore)**

- javax.jdo.option.ConnectionURL：配置 metastore 的db 的url

- javax.jdo.option.ConnectionDriverName：配置 metastore db 的 driver 类名

- javax.jdo.option.ConnectionUserName：配置用于连接 metastore db 的 user name

- javax.jdo.option.ConnectionPassword：配置用于连接 metastore db 的密码
