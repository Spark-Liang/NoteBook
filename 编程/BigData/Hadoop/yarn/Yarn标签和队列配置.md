### Yarn标签队列配置

- 配置简介

- 标签配置

- 队列配置

#### 配置简介

- 队列配置
  
  - 队列配置是将yarn在资源总量上划分成多个资源池，用于控制在队列上运行的作业能够使用的资源总量。
  
  - 队列也是yarn进行权限控制的基本单位，通过设置队列的acl进行权限控制

- 标签配置：
  
  - 队列配置是将yarn在物理机器上划分成多个资源池，实现任务在物理隔离的资源池上进行计算，而队列配置只能配置作业能够使用的资源总量，但无法配置资源所在位置

#### 队列配置

##### 配置文件位置

- capacity 队列在`capacity-scheduler.xml`

##### 基于capacity的队列配置

###### yarn-site配置

```xml
<!-- 配置yarn使用capacity scheduler -->
<property>
    <name>yarn.resourcemanager.scheduler.class</name>
    <value>org.apache.hadoop.yarn.server.resourcemanager.scheduler.capacity.CapacityScheduler</value>
</property>
```

###### capacity-scheduler

*配置约束*

- 每个队列的子队列在每个标签的容量上相加必须为100。

- 每个叶子队列的名称不能相同，比如不能存在`root.a`和`root.test.a`

- 每次刷新队列时，只能增加队列不能删除队列，所以通常删除队列的做法是将队列的容量调整到其他队列，然后将状态设置成STOPPED

- 队列最好配置`maximum-applications`属性，避免默认为0导致作业卡在`ACCEPTED`状态

*声明队列*

通过队列的`queues`字段声明队列包含的子队列，如果队列没有配置queues字段，说明该队列是叶子队列，能够提交作业到该队列。例子：

```xml
<property>
  <name>yarn.scheduler.capacity.root.queues</name>
  <value>a,b,c</value> 
</property>

<property>
  <name>yarn.scheduler.capacity.root.a.queues</name>
  <value>a1,a2</value> 


<property>
  <name>yarn.scheduler.capacity.root.b.queues</name>
  <value>b1,b2,b3</value> 
</property>
```

*队列属性配置*

队列属性主要包含三个部分：

- 容量和可用标签配置，非叶子和叶子队列均需要配置，并且不同标签需要单独配置。

- 作业资源使用配置，只有叶子队列需要配置

- 作业数量限制选项，只有叶子队列需要配置

- 队列的管理和权限控制，只有叶子队列需要配置

队列配置中，使用`<queue-path>`表示定位某个队列的配置，比如root下的a下的a1队列，其`<queue-path>`为`root.a.a1`。如果配置需要标签的配置则配置项前缀为`yarn.scheduler.capacity.<queue-path>.accessible-node-labels.<label>.`。<br>

- 容量和可用标签配置，队列中只有`capacity`和`maximum-capacity`是需要区分标签配置的，其他队列属性均不需要区分标签。对于配置默认标签的选项，则不需要添加`.accessible-node-labels.<label>`
  
  | 属性                                                                                     | 作用                                                     |
  | -------------------------------------------------------------------------------------- | ------------------------------------------------------ |
  | `yarn.scheduler.capacity.<queue-path>.accessible-node-labels`                          | 配置队列的可用标签，每个标签采用`,`号分隔。采用""表示默认分区，如`,a,b`表示可用a、b和默认分区。 |
  | `yarn.scheduler.capacity.<queue-path>.default-node-label-expression`                   | 队列上的作业默认使用的标签                                          |
  | `yarn.scheduler.capacity.<queue-path>.accessible-node-labels.<label>.capacity`         | 表示队列在指定标签的容量                                           |
  | `yarn.scheduler.capacity.<queue-path>.accessible-node-labels.<label>.maximum-capacity` | 队列在指定标签的最大弹性容量，**该配置项非空时必须比capacity选项大**               |

- 作业资源使用配置：
  
  - `minimum-user-limit-percent`: 
    
    - 保证用户用户在当前队列能够使用的最小资源比例。
    
    - 比如，假设minimum-user-limit-percent为25。
      
      - 当两个用户向该队列提交应用程序时，每个用户可使用资源量不能超过50%
      
      - 如果三个用户提交应用程序，则每个用户可使用资源量不能超多33%
      
      - 如果四个或者更多用户提交应用程序，则每个用户可用资源量不能超过25%。
  
  - `user-limit-factor`：每个用户最多可使用的资源量（百分比）。比如，假设该值为30，则任何时刻，每个用户使用的资源量不能超过该队列容量的30%。
  
  - `maximum-allocation-mb`: 每个container的最大内存值
  
  - `maximum-allocation-vcores`：每个container的最大cpu数量

- 作业数量限制选项
  
  - `maximum-applications`:  队列能够提交的最大作业上限。可以通过`yarn.scheduler.capacity.maximum-applications`设置所有队列的默认值。
  
  - `maximum-am-resource-percent`: 设置队列中ApplicationMaster占用的资源上限。比如`0.1`对应最大占用`10%`

- 队列的管理和权限控制:
  
  - `state`: 可选`STOPPED`或者`RUNNING`，当为`STOPPED`时不能提交作业到该队列或者子队列，但是原有作业可以正常运行到退出。
  
  - `acl_submit_applications`: 
    
    - 队列能够提交的用户或组，采用`,`分隔。
    
    - 需要注意的是，该属性具有继承性，即如果一个用户可以向某个队列中提交应用程序，则它可以向它的所有子队列中提交应用程序。
  
  - `acl_administer_queue`:
    
    - 为队列指定一个管理员，该管理员可控制该队列的所有应用程序
    
    - 比如杀死任意一个应用程序等。同样，该属性具有继承性。

*其他配置*

- `yarn.scheduler.capacity.queue-mappings`：
  
  - 这个参数指定user和用户组（group）属于哪个queue。可以指定一格user或者一组user属于这个队列。
  
  - 语法是： `[u or g]:[name]:[queue_name][,next_mapping]*` 
  
  - 这里的u和g指定这个mapping是对于user还是对group的mapping。name代表是username还是groupname。

- `yarn.scheduler.capacity.queue-mappings-override.enable`:
  
  - 指定user指定的队列是否可以被覆盖，默认为false。

*队列与作业提交*

作业提交中通过`-Dmapreduce.job.queuename=`控制作业提交的队列，**参数的值是叶子队列的名称**。通过参数`-Dmapreduce.job.node-label-expression=`配置作业提交的标签。

##### 刷新队列配置

更新了`capacity-scheduler.xml`后运行以下命令刷新队列配置

```bash
yarn rmadmin -refreshQueues
```

##### 配置错误整理

1. `Illegal capacity of 0.8 for children of queue root for label=mem`
   
   原因是`root`的子队列的`capacity`在label是`mem`的分区相加总和不是100.

##### 参考文档

- [hadoop 2.7.2 yarn中文文档—— Capacity Scheduler_Ebaugh的博客-CSDN博客_hadoop2.7文档](https://blog.csdn.net/AntKengElephant/article/details/84400966)
- [EMR集群上capacity scheduler的ACL实现-阿里云开发者社区](https://developer.aliyun.com/article/80641)

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
    <value>/yarn/node-label</value>
</property>
```

注意点：

1. 由于标签需要读写hdfs，需要在hdfs-site中添加下面的配置项保证，hdfs访问报错时候可以重试
   
   ```xml
   
   ```

2. 

##### 配置标签的命令

###### 配置步骤：

1. 在集群上添加标签
   
   ```bash
   # 新增集群标签
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



参考文档：

- [Apache Hadoop 2.7.7 &#x2013; YARN Node Labels](https://hadoop.apache.org/docs/r2.7.7/hadoop-yarn/hadoop-yarn-site/NodeLabel.html)

- [Yarn Label 调度_Chdaring的博客-CSDN博客](https://blog.csdn.net/co_zjw/article/details/81974977)
