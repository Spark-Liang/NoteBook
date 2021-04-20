#### Spark文件写入过程

- 执行计划调用过程

- 文件写入过程



##### 执行计划调用过程

```textile
save
-> saveToV1Source
-> planForWriting
-> planForWritingFileFormat 
    获取路径和选项
-> InsertIntoHadoopFsRelationCommand
    生成写入的执行计划
```



##### 文件写入过程

生成的执行计划会在 DataFrameWriter 的runCommand方法中执行，最终会调用 InsertIntoHadoopFsRelationCommand 的run 方法

```textile

```


