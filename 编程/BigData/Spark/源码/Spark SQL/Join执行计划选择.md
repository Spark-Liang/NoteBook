#### Join 执行计划选择

- join 算法选择

- broadcast side 选择

##### 

##### broadcast side 选择

入口：org.apache.spark.sql.execution.SparkStrategies.JoinSelection#broadcastSide

```textile
JoinSelection#apply
    |    判断是否进行broadcast join的方法
    +--- canBroadcastByHints()
    +--- canBroadcastBySizes()
    |    判断是左侧 broadcast 还是右侧 broadcast 的方法
    +--- broadcastByHints()
    +--- broadcastBySizes()

```



1. BroadcastByHints 和 BroadcastBySizes 最终会调用 broadcastSide。<br>
   
   该方法入参：左表右表是否能被广播，以及左表和右表的LogicalPlan。<br>判断逻辑：当只有一侧能能够broadcast时，选择那一侧，否侧选择体积更小的一侧。

![](img/BroadcastSide_SourceCode.png)

2. BroadcastByHints， BroadcastBySizes，broadcastByHints 和 broadcastBySizes 都会调用 canBuildLeft 和 canBuildRight 分别判断左表和右表是否具备 broadcast 的条件。<br>
   
   其中 canBuildLeft 的逻辑如下：
   
   ![](img/canBuildLeft_SourceCode.png)
   
   其中 canBuildRight 的逻辑如下：
   
   ![](img/canBuildRight_SourceCode.png)
   
   
3. 对于 canBroadcastByHints 来说，能够 build某一侧的表的条件是 sql 中使用了 hint
   
   ![](img/canBroadcastByHints_SourceCode.png)
4. 对于 canBroadcastBySizes 来说，需要文件大小小于 autoBroadcastThreshold
   
   ![](img/canBroadcastBySizes_SourceCode.png)


