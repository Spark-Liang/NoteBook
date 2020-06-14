## pySparkSQL

pySparkSQL 是 SparkSQL 在 python 的api

### 获取 sparkSQL 的执行环境

```python
from pyspark.sql import SparkSession

spark = SparkSession.builder.getOrCreate()
```

### 文件操作

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

### DataFrame 操作

在 pySparkSQL 中，提供了和SQL 非常相似的API 方法，使得对于一些小型的查询不需要通过写sql实现，直接调用相应的方法即可。写SQL去处理简单DataFrame比较麻烦，因为使用sql 处理的 DataFrame 需要首先注册为 tempView 通过方法 createTempView 或者 createOrReplaceTempView.

#### 直接调用sql

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

#### select 和 selectExpr 方法

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

#### SQL API 的链式调用

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
