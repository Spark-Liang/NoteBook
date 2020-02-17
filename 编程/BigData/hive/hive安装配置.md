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
       <description>HDFS root scratch dir for Hive jobs which gets created with write all (733) permission. For each connecting user, an HDFS scratch dir: ${hive.exec.scratchdir}/&lt;username&gt; is created, with ${hive.scratch.dir.permission}.</description>
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
   
   ```<property>xml
   <property>
       <name>javax.jdo.option.ConnectionURL</name>
       <value>jdbc:mysql://localhost:3306/hive?createDatabaseIfNotExist=true&amp;characterEncoding=UTF-8&amp;useSSL=false</value>
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

10. 初始化hive schema 。
    
    ```
    schematool -dbType mysql -initSchema
    ```

11. 执行hive命令进入
