SQL DataWarehouse的表结构管理主要涉及几个部分：<br>

1. 数据字段的管理
2. 表索引的管理
3. 表分区管理

## 表结构定义

SQL DataWarehouse创建表的语法主要有两种，一种是直接定义表结构另一种是通过 CTAS(create table as select)的方式。这两种表结构定义方式的语法如下：<br>
直接定义表结构:<br>

```SQL
    create table [table_name]
    (
        ...字段属性定义
        ...表级别约束定义（比如定义多字段的主键）
    )
    with(<表结构选项>)
```

通过 CTAS 方式：<br>

```SQL
    create table [table_name]
    with(<表结构选项>)
    as
    select [字段]
    ...
```

### 表结构选项

表结构选项主要设置表的分区，分布，以及聚集索引的类型。

```SQL
<table_option> ::= 
        CLUSTERED COLUMNSTORE INDEX --default for SQL Data Warehouse 
      | HEAP --default for Parallel Data Warehouse   
      | CLUSTERED INDEX ( { index_column_name [ ASC | DESC ] } [ ,...n ] ) -- default is ASC 
    ,  
        DISTRIBUTION = HASH ( distribution_column_name ) 
      | DISTRIBUTION = ROUND_ROBIN -- default for SQL Data Warehouse
      | DISTRIBUTION = REPLICATE -- default for Parallel Data Warehouse
    ,
     PARTITION ( partition_column_name RANGE [ LEFT | RIGHT ] -- default is LEFT  
        FOR VALUES ( [ boundary_value [,...n] ] ) )
```

## 索引的管理

创建索引有几种方式，可以在

## 表分区

在 SQL DW 中只能在表结构定义的时候定义的表分区，不能在定义完成之后对表分区进行修改
