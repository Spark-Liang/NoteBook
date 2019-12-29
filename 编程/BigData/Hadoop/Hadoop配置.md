##### Hadoop 配置过程

- 配置 hadoop-env.sh (该文件主要是用户配置脚本调用的环境变量)

- 配置 core-site.xml (主要是配置 hdfs 命令行工具相关选项，比如默认的hdfs地址)

- 配置 hdfs-site.xml (主要是配置 hdfs 相关选项，比如默认的hdfs)

- 配置 mapred-site.xml (主要是配置 map-reduce task时的默认选项)

- 配在 yarn-site.xml (主要是配置 yarn相关选项，比如resource manager 的界面端口)

###### hadoop-env.sh

一般只需要配置内的 JAVA_HOME。而且一般都需要在此处配置 JAVA_HOME， 因为hadoop调用脚本时不会从 /etc/profile 中加载环境变量。

###### core-site.xml

常用选项：

- fs.defaultFS：配置 hdfs 的默认通信协议，已经默认的host和端口
  
  - example：hdfs://www.spark-liang.top:9000

- io.file.buffer.size ： 上传下载的缓存大小。单位Byte

###### hdfs-site.xml

常用选项：

- dfs.webhdfs.enable：打开webhdfs
  
  - 默认webhdfs 以及 namenode 的overview信息都在namenode 的 50070端口。

- **dfs.name.dir** 或者 dfs.namenode.name.dir : namenode 数据存放路径

- **dfs.data.dir** 或者 dfs.datanode.data.dir ：datanode 数据存放路径

- dfs.namenode.handler.count ：处理客户端的远程过程调用及集群守护进程的调用的线程池数量。
  
  - 一般原则是将其设置为集群大小的自然对数乘以20，即20logN，N为集群大小
  
  - 计算方式 python -c 'import math ; print int(math.log(6) * 20)'

- **dfs.datanode.handler.count** ：DataNode用来连接NameNode的RPC请求的线程数量
  
  - 默认为3

- **dfs.replication** ：默认每个文件在集群中的数量。

- 心跳相关参数：
  
  - heartbeat.recheck.interval ： 单位是毫秒
  
  - dfs.heartbeat.interval：单位是秒
  
  - worknode节点timeout计算公式：
    
    - timeout  = 2 * heartbeat.recheck.interval + 10 * dfs.heartbeat.interval

- **dfs.datanode.max.xcievers**：相当于linux下的打开文件最大数量，文档中无此参数，当出现DataXceiver报错的时候，需要调大。默认256

###### mapred-site.xml

常用选项：

- mapreduce.framework.name：map-reduce管理框架，一般都选择yarn

- mapreduce.jobhistory.address ：job history 端口
  
  - 默认：10020

- mapreduce.jobhistory.webapp.address ：job history 的web UI端口
  
  - 默认19888

###### yarn-site.xml

常用选项：

- yarn.nodemanager.aux-services

- yarn.resourcemanager.address

- yarn.resourcemanager.scheduler.address

- yarn.resourcemanager.resource-tracker.address

- yarn.resourcemanager.admin.address

- yarn.resourcemanager.webapp.address：resource manager的 UI端口

- 日志聚合相关
  
  - yarn.log-aggregation-enable：开启yarn的日志聚合功能，默认各个container 是放置在各个主机的 \${HADOOP_HOME}/logs 上 
  
  - yarn.log.server.url ：配置聚合日志的重定向url。不配置该url，在resource manager中点击 container 对应的 “logs” 时依旧会直接访问该container的本地日志。
    
    - 例子：http://www.spark-liang.top:19888/jobhistory/logs
  
  - yarn.nodemanager.remote-app-log-dir 和 yarn.nodemanager.remote-app-log-dir-suffix
    
    - 这两个参数共同决定用户的日志目录
    
    - \${yarn.nodemanager.remote-app-log-dir}/\${user}/\${yarn.nodemanager.remote-app-log-dir-suffix}
  
  - yarn.log-aggregation.retain-seconds ： 聚合日志保留时间
  
  - yarn.log-aggregation.retain-check-interval-seconds ： 检测超时日志的时间间隔。
