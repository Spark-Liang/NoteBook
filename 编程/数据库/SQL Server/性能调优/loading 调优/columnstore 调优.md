###### check point

- **检查是否使用 bulk insert**
  
  - 使用 sys.dm_exec_requests 中的 command，检查运行时的 sql 对应的类型是否为 Bulk 

- 检查每个batch 的行数是否超过 102,400 行。
