##### 执行计划子步骤种类

- 表扫描：加载整个数据表，按照筛选条件进行筛选
  
  - Table Scan（普通表扫描）：对堆表（没有聚集索引的表）的全表扫描
  
  - Clustered Index Scan：对有聚集索引的表的全表扫描
  
  - Index Scan：如果查询的所有列的都被某个索引包含，则采用索引扫描。
    
    - 例子：select PARENT_OID from Tbl group by PARENT_OID 
    
    - <font color='red'>索引所包含的列包括两个部分：一个是索引本身包含的列，以及聚集索引所包含的列。</font>

- 表查找：（优于扫描）
  
  - Clustered Index Seek / Index Seek：直接通过索引查找
    
    - 使用条件：满足左上原则
    
    - 对于非聚集索引，需要额外关注的是 select 的列是否被索引包含，如果不包含就需要额外地考虑查询结果的行数（或者说选择率），如果行数多（选择率低）则直接采用 Table Scan 或者 Clustered Index Scan。如果行数少则会使用索引并且需要额外加上 Nested Loop 以及  Key Lookup（聚集索引表） 或者 RID Lookup（堆表）。
  
  - Key Lookup：
  
  - RID Lookup：

- 连接算法：
  
  - Nested Loop：
    
    - <font color='red'>驱动表（外层循环表）</font>
    
    - 使用场景：内层表行数比外层表多，并且有索引，并且索引能够包含select所需的字段
  
  - Hash Match：
    
    - 使用场景：内层表提取出的字段（包括匹配字段和select的字段）能够全部存入内存中并且没有索引的时候。
    
    - 限制条件：只能用于等值匹配或者反连接（类似left join where is null）
  
  - Merge Join：
    
    - 使用场景：
      
      - 两个连接的表都按照连接的字段排序。
      
      - 两个大表连接
      
      - 查询有Order by 子句，并且 Order by 的字段包含连接的字段。

- 其他：
  
  - Sort：
  
  - Segment：






