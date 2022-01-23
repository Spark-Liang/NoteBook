### Yarn标签队列配置

- 标签配置

- 队列配置

#### 标签配置

##### 启用标签相关配置项

```xml
<!-- 启用标签 -->
<property>
    <name>yarn.node-labels.enabled</name>
    <value>true</value>
</property>
<!-- 存放标签信息的路径，尽量配置在所有节点都能访问到的路径上 -->
<property>
    <name>yarn.node-labels.fs-store.root-dir</name>
    <value>/user/node-label</value>
</property>
```

##### 配置标签的命令

###### 配置步骤：

1. 在集群上添加标签
   
   ```bash
   yarn rmadmin -addToClusterNodeLabels "normal,highmem"
   # 删除标签命令
   yarn rmadmin -removeFromClusterNodeLabels 
   ```

2. 给节点打上标签
   
   ```bash
   yarn rmadmin -replaceLabelsOnNode "<hostname1>[:<port1>]=<标签名> ..."
   ```
   
   当省略port时代表某个主机上的所有nodemanager都是指定的标签

注意点：

- 一个nodemanager只能有一个标签

#### 队列配置

##### 配置文件位置

- capacity 队列在`capacity-scheduler.xml`

##### 基于capacity的队列配置

###### 配置错误整理

1. `Illegal capacity of 0.8 for children of queue root for label=mem`
   
   原因是`root`的子队列的`capacity`在label是`mem`的分区相加总和不是100.

2. 

参考文档：

- [Apache Hadoop 2.7.7 &#x2013; YARN Node Labels](https://hadoop.apache.org/docs/r2.7.7/hadoop-yarn/hadoop-yarn-site/NodeLabel.html)

- [Yarn Label 调度_Chdaring的博客-CSDN博客](https://blog.csdn.net/co_zjw/article/details/81974977)
