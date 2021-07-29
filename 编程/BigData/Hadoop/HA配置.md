##### HDFS HA配置例子

```xml
<property>
    <name>dfs.nameservices</name>
    <value>hadoopHDFS</value>
</property>
<property>
    <name>dfs.ha.namenodes.hadoopHDFS</name>
    <value>hadoop-node001,hadoop-node002</value>
</property>

<!--namenode 1配置 -->
<property>
    <name>dfs.namenode.rpc-address.hadoopHDFS.hadoop-node001</name>
    <value>hadoop-node001:8020</value>
</property>
<property>
    <name>dfs.namenode.http-address.hadoopHDFS.hadoop-node001</name>
    <value>hadoop-node001:50070</value>
</property>
<property>
    <name>dfs.namenode.secondary.http-address.hadoopHDFS.hadoop-node001</name>
    <value>hadoop-node001:9001</value>
</property>

<!--namenode 2配置 -->
<property>
    <name>dfs.namenode.rpc-address.hadoopHDFS.hadoop-node002</name>
    <value>hadoop-node002:8020</value>
</property>
<property>
    <name>dfs.namenode.http-address.hadoopHDFS.hadoop-node002</name>
    <value>hadoop-node002:50070</value>
</property>
<property>
    <name>dfs.namenode.secondary.http-address.hadoopHDFS.hadoop-node002</name>
    <value>hadoop-node002:9001</value>
</property>

<!--journalnode 配置 -->
<property>
    <name>dfs.namenode.shared.edits.dir</name>
    <value>qjournal://hadoop-node001:8485;hadoop-node002:8485;hadoop-node003:8485/hadoopHDFS</value>
</property>
<property>
    <name>dfs.journalnode.edits.dir</name>
    <value>/data/hadoop/hdfs/jnn</value>
</property>

<!--客户端通过代理访问namenode，访问文件系统，HDFS 客户端与Active 节点通信的Java 类，使用其确定Active 节点是否活跃 -->
<property>
    <name>dfs.client.failover.proxy.provider.hadoopHDFS</name>
    <value>org.apache.hadoop.hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider</value>
</property>

<!--这是配置自动切换的方法，有多种使用方法，具体可以看官网，在文末会给地址，这里是远程登录杀死的方法 -->
<property>
    <name>dfs.ha.fencing.methods</name>
    <value>sshfence</value>
</property>

<!-- 这个是使用sshfence隔离机制时才需要配置ssh免登陆 -->
<property>
    <name>dfs.ha.fencing.ssh.private-key-files</name>
    <value>/root/.ssh/id_rsa</value>
</property>

<!-- 配置sshfence隔离机制超时时间，这个属性同上，如果你是用脚本的方法切换，这个应该是可以不配置的 -->
<property>
    <name>dfs.ha.fencing.ssh.connect-timeout</name>
    <value>30000</value>
</property>

<!-- 这个是开启自动故障转移，如果你没有自动故障转移，这个可以先不配 -->
<property>
    <name>dfs.ha.automatic-failover.enabled</name>
    <value>true</value>
</property>
```

##### HDFS HA启动步骤

1. 启动所有节点的journalnode 进程
   
   ```bash
   $HADOOP_HOME/sbin/hadoop-daemon.sh start  journalnode
   ```

2. 在主namenode上格式化共享数据
   
   ```bash
   $HADOOP_HOME/bin/hdfs namenode -initializeSharedEdits
   $HADOOP_HOME/sbin/hadoop-daemon.sh start  namenode
   ```

3. 在副namenode上同步 journalnode 的共享数据，和 NameNode 上存放的元数据，然后启动 namenode 进程
   
   ```bash
   
   ```

4. 在其中一台namenode上启动所有datanode
   
   ```bash
   $HADOOP_HOME/sbin/hadoop-daemons.sh  start datanode
   ```

5. 
