##### Spark RDD 并行度

- 影响RDD的partition的参数

- 修改partition 数量的方式

- RDD的partition继承性

###### 影响RDD的partition的参数

spark中会根据以下优先级配置RDD的partition数量

1. 首先是创建RDD时定义的数量

2. spark.default.parallelism 参数配置的值

3. task scheduler中配置的默认并行度

###### 修改partition 数量的方式

- coalesce 方法
  
  - 该方法有一个可选的参数是是否进行shuffle。
  
  - 通常而言减少partition 数量采用coalesce方法。

- repartition 方法
  
  - 实际上调用coalesce，并且配置coalesce的shuffle为true

###### RDD的partition继承性

在窄依赖的情况下，RDD会直接继承parent的partition数量。只有在发生shuffle或者调用coalesce的时候才会发成变化。而shuffle之后的RDD的partition数量，spark会按照下面的优先级配置接下来的RDD的数量

1. 如果配置了方法中指定的partition参数，就按照方法给定的参数。

2. 如果配置了spark.default.parallelism，则采用spark.default.parallelism对应的数值，

3. 否则采用parent对应的partition数值。

例子：

当一个RDD调用了 groupByKey。如果直接就是调用groupByKey(10)，则接下来的RDD为10个partition。如果调用groupByKey()，则去查看是否有配置spark.default.parallelism，如果有就采用该值，没有就继承parent RDD。
