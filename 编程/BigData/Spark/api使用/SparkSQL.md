#### SparkSQL

- [SparkSQL语法](#SparkSQL语法)
  
  - [官方参考文档](#官方参考文档)
  - [数据源相关](#数据源相关)
  - [元数据查看](#元数据查看)

- [pySparkSQL](#pySparkSQL)
  
  - [获取 sparkSQL 的执行环境](#获取 sparkSQL 的执行环境)
  
  - [文件操作](#文件操作)
  
  - [DataFrame 操作](#DataFrame 操作)

#### SparkSQL语法

##### 官方参考文档

- [Data Types - Spark Documentation](http://spark.apache.org/docs/latest/sql-ref-datatypes.html)

- [Datetime patterns - Spark Documentation](http://spark.apache.org/docs/latest/sql-ref-datetime-pattern.html)

- [SQL Syntax - Spark Documentation](http://spark.apache.org/docs/latest/sql-ref-syntax.html)

- [Functions - Spark SQL, Built-in Functions](http://spark.apache.org/docs/latest/api/sql/index.html)

##### 常用语法

###### 数据源相关

基本语法如下：

```sql
DROP TABLE IF EXISTS table_identifier
;
CREATE TABLE [ IF NOT EXISTS ] table_identifier
    [ ( col_name1 col_type1 [ COMMENT col_comment1 ], ... ) ]
    USING data_source
    [ OPTIONS ( key1=val1, key2=val2, ... ) ]
    [ PARTITIONED BY ( col_name1, col_name2, ... ) ]
    [ CLUSTERED BY ( col_name3, col_name4, ... ) 
        [ SORTED BY ( col_name [ ASC | DESC ], ... ) ] 
        INTO num_buckets BUCKETS ]
    [ LOCATION path ]
    [ COMMENT table_comment ]
    [ TBLPROPERTIES ( key1=val1, key2=val2, ... ) ]
    [ AS select_statement ]
;
```

其中：

- table_identifier 是创建的表名，可以是  `[ database_name. ] table_name`
- USING data_source：代表data source 的格式，可以选CSV, TXT, ORC, JDBC, PARQUET 等。如果需要拓展新的data source 类型，需要创建 BaseRelation 的实现类。
- OPTIONS：用于配置 datasource 的各种选项，其中key是字符串，用单引号或者双引号括起。
- LOCATION：通常用于读取 hdfs 上指定路径的文件。其中路径需要使用引号括起，并且允许使用通配符 \*

此外，

###### 元数据查看

- show databases：查看所有database

- describe database：查看指定database信息

- show tables：查看db 下的所有table
  
  - show tables [like regular expression]: 直接执行该命令查看当前db 下的表, 可以通过like 筛选表名
  
  - show tables in \`db name\`[like regular expression] ：查看指定db 下的表

- describe table：查看表结构，主要是查看column 类型和 nullable

- show columns: 查看表含有的
  
  - 例子：
    
    ```sql
    show columns in `dbname`.`table_name`
    ```

- show create table：查看建表语句

- 

#### pySparkSQL

pySparkSQL 是 SparkSQL 在 python 的api

###### 获取 sparkSQL 的执行环境

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()
```

###### 文件操作

csv

```python
# 读取
path = "filepath"
df = spark.read.csv(path)
"""
spark.read.csv(
  path,
  schema,
  header,
  encoding,
  ...
) -> DataFrame
"""
# 其中 read 默认是不包含 header

# 写入
# 方法1：
df.repartition(1).write.csv(path)
# 采用上述方法，spark会在给定的路径创建一个folder，里面包含一个结果csv

# 方法2：
df
with open(path,'w') as out_file:
  out_file.write(','.join(df.columns) + '\n')
  for row in df.collect():
    out_file.write(','.join([str(field) for field in row]) + '\n')
# 采用上述方法输出成 csv 时，需要注意是否需要格式化，因为str() 转换为字符串不是对所有类型都有效
```

##### DataFrame 操作

在 pySparkSQL 中，提供了和SQL 非常相似的API 方法，使得对于一些小型的查询不需要通过写sql实现，直接调用相应的方法即可。写SQL去处理简单DataFrame比较麻烦，因为使用sql 处理的 DataFrame 需要首先注册为 tempView 通过方法 createTempView 或者 createOrReplaceTempView.

###### 直接调用sql

调用sql 前应当确认是否把DataFrame 注册到 spark 的上下文中。

```python
sql = "select * from <view name>"
df.createTempView('<view name>')
# 需要注意在 sql 中的表名是注册到 spark 上下文中的表名

# 如果想直接通过变量名作为sql中的表名，可以封装一下调用sql 的方法
from pyspark.sql import SparkSession,DataFrame
spark = SparkSession.builder.getOrCreate()
def exec_sql(sql):
  gbl_vars = globals()
  for k,v in gbl_vars.items():
    if isinstance(v,DataFrame):
      v.createOrReplaceTempView(k)
  spark_ctx = gbl_vars['spark']
  spark_ctx.sql(sql)
```

###### select 和 selectExpr 方法

这两个方法能够对 DataFrame 进行 select
其中 select 把所有接收到的参数都当做是字段名，而selectExpr 则把所有接收到的字符串都当做是表达式

```python
# 比如有个字段叫 “简 称”
df.select('简 称')
df.selectExpr("`简 称`")
# 注意 spark 中对复杂字段所包围的引号

#其中 select 方法会把 "*" 替换成当前表的所有字段
df.select('col1','*')
# return 'col1',...(全表字段，包括col1)
```

###### SQL API 的链式调用

```python
sql = """
select
  *
from df
where col1 > 1
"""
df.createTempView('df')
spark.sql(sql)
# 等价的链式调用
df.select('*').where('col1 > 1')
```
