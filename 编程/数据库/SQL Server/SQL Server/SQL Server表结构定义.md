SQL Ser

### 表分区的创建

创建表分区首先要创建需要要摆放分区的文件组。然后创建分区函数和分区方案，最后在创建表的时候选择需要使用的分区方案和进行分区的列。<br>
分区函数：用来描述分区数值的分界点。

```SQL
create partition function [分区函数名] (分区值类型)
range [left|right] -- left表示与分界点相等的记录放在分界点左边的分区，right则放在右侧的分区
for values(分区值...)
```

分区方案: 用来描述分区函数中每个分区对应的文件组。

```SQL
create partition scheme [分区方案名]
as partition [分区函数名]
[all] To (文件组名...)
```

有了分区方案之后就可以在表或者索引上使用分区。

```SQL
--定义表中使用分区
create table [表名]
(
    ... --表定义
) on [分区方案名](分区列名)

create index [索引名] on [表名](列名) on [分区方案名](分区列名)
```

### 分区表操作

添加分区：<br>
添加分区首先要在对应的分区方案中指定下一个分区使用的文件组。

```SQL
alter partition scheme [分区方案名] next used [文件组名]
```

然后才能在分区函数中添加分区

```SQL
alter partition function [分区函数名]() split range (分区值)
```
