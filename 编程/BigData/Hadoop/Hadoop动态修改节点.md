##### Hadoop 中增删节点都是通过配合 slaves 和 exclude文件完成

###### include 和 exclude 中是否存在与对节点操作

| In Include | In Exclude | node operation |
| ---------- | ---------- | -------------- |
| N          | N          | 无法连接           |
| N          | Y          | 无法连接           |
| Y          | N          | 可连接            |
| Y          | Y          | 可连接，将被删除       |

###### 相关参数配置

- hdfs 的include 和 exclude参数：
  
  - include 文件路径：dfs.hosts
  
  - exclude 文件路径：dfs.hosts.exclude

- yarn 的include 和 exclude参数：
  
  - include 文件路径：yarn.resourcemanager.nodes.include-path
  
  - exclude 文件路径：yarn.resourcemanager.nodes.exclude-path

###### 节点上线流程

1. 添加节点到 include 文件中

2. 如果节点存在exclude文件中，则从中移除节点的 hostname

3. 对于 hdfs 添加节点调用 hdfs dfsadmin -refreshNodes

4. 对于 yarn 添加节点调用 yarn  rmadmin -refreshNodes

###### 节点下线流程

1. 添加节点到 exclude 文件中

2. 对于 hdfs 添加节点调用 hdfs dfsadmin -refreshNodes

3- 对于 yarn 添加节点调用 yarn rmadmin -refreshNodes

4- 对于hdfs 下线还需要检查节点是否处于 discommissioning 的状态。可以通过命令下面检查

   1-  hdfs dfsadmin -report -decommissioning

   2- 当返回结果中包含 “Decommissioning datanodes (0):” 则可以停止节点上的 datanode。
