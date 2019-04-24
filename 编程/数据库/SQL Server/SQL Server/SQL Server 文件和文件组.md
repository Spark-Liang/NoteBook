SQL Server 的数据文件结构如下图所示：<br>
在一个数据库下会有多个文件组，而一个文件组下又会有多个文件。并且表分区的建立是基于文件组级别进行管理。使得用户仅仅针对文件组来建立表和索引，而不用关心实际磁盘中的文件的情况。<br>



## 文件和文件组的创建
文件组和文件可以在创建 Database 的时候一同创建，也可以单独向数据库中添加文件和文件组。<br>
和 Database 一同创建:
```
create database 数据库名
on 文件组名
    (
        name = 数据库内部文件标识
        ,filename = 文件完整路径
        ,size = 
        ,maxsize = 最大大小，非必须
        ,filegrowth = 
    )
log on 日志文件组
    (文件选项)
```
向已有数据库添加文件组:
```
alter database [数据库名]
add filegroup [文件组名]
```
向文件组中添加文件：
```
alter database [数据库名]
add file 
(文件选项)
To filegroup [文件组名];
```

## 文件和文件组删除
移除文件组:
```
alter database [数据库名] remove filegroup [文件组名]
```
移除文件:
```
alter database [数据库名] remove file [文件名]
```

