##### 调优点

- 并行度

- db resource 使用

- sql 执行是否存在等待

- hadoop 集群资源使用完全

###### 并行度

- check point: 
  
  - 查看yarn 中的syslog，查看是由有split=一个大于1的数。

- solution:
  
  - 检查source 表是否有主键
  
  - 是否配置了 -m
  
  - 如果没有主键，是否有能够split-by 的字段

###### db resource 使用

- check point:
  
  - 查看当前执行的sql，查看是否有等待的情况，如果有，就检查等待的原因

- possible reason:
  
  - 如果wating status 是 ASYNC_NETWORK_IO，有可能是网络带宽，有可能是hadoop的每个task接收record的速度没有发送的快。
  - 在写入时，等待 SLEEP_TASK，MEMORY_ALLOCATION_EXT，PAGELATCH_EX，LOGBUFFER
