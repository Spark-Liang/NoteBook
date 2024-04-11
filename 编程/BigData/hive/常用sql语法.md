# 常用sql语法

[TOC]

## 常用DDL语句

### 表创建

### 分区表

#### 创建：

```sql
-- 创建hive表
create table test_s3a_table_orc(
    user_id   string,
    user_name string,
    age integer
) partitioned by (province string, city string)
    clustered by (user_id) into 2 buckets
    stored as orc
    Location 's3a://ddsdata/test_s3a_partition_table_orc'
    TBLPROPERTIES ('transactional'='true');
    
-- 创建hive外部表
create external table test_s3a_partition_table_orc(
    user_id   string,
    user_name string,
    age integer
) partitioned by (province string, city string)
    clustered by (user_id) into 2 buckets
    stored as orc
    Location 's3a://ddsdata/test_s3a_partition_table_orc'
    TBLPROPERTIES ('transactional'='true');
```

#### 分区操作：

```sql
-- 创建分区
alter table test_s3a_partition_table_orc add partition (province='hubei');

-- 删除分区
alter table test_s3a_partition_table_orc drop partition (province='hubei');

-- 重命名分区
alter table test_s3a_partition_table_orc
    partition (province = 'guangdong', city = 'guangzhou')
        rename to partition (province = 'guangdong', city = 'shenzhen');

-- 交换分区数据
alter table test_s3a_partition_table_orc 
    exchange partition (dt='2016-01-13',shop='9510') 
    with table test_s3a_partition_table_orc_tgt;

-- 扫描文件系统并重建表的分区信息
msck repair table test_s3a_partition_table_orc;
```





## 常用DML语句

### hive 开启update和delete支持

默认在hive中没有默认开启支持单条、更新以及删除（delete）操作，需要自己配置。比如以下sql会报`Attempt to do update or delete using transaction manager that does not support these operations`错误。

```sql
delete from table_1 where username='abc'
update table_1 set age=18 where username='abc'
```

表允许进行update和delete操作的条件

- 开启相关允许update和delete配置
- 进行update和delete的表必须是hive表，不能是外部表。
- 并且该hive表需要是有聚集索引的，并且是类似ocr能够进行ACID操作的存储格式。

配置步骤：

1. 需要增加如下配置并重启metastore和hiveservice2服务

   ```xml
   <!-- hive 支持update和delete: start -->
   <property>
     <name>hive.support.concurrency</name>
     <value>true</value>
   </property>
     <property>
     <name>hive.enforce.bucketing</name>
     <value>true</value>
   </property>
     <property>
     <name>hive.exec.dynamic.partition.mode</name>
     <value>nonstrict</value>
   </property>
   <property>
     <name>hive.txn.manager</name>
     <value>org.apache.hadoop.hive.ql.lockmgr.DbTxnManager</value>
   </property>
     <property>
     <name>hive.compactor.initiator.on</name>
     <value>true</value>
   </property>
   <property>
     <name>hive.compactor.worker.threads</name>
     <value>1</value>
   </property>
   <property>
     <name>hive.in.test</name>
     <value>true</value>
   </property>
   <!-- hive 支持update和delete: end -->
   ```

   

2. 创建符合要求的hive表

   ```sql
   create table student(
     id int,
     name String,
     sex varchar(2),
     birthday varchar(10),
     major varchar(1)
   )clustered by (id) into 2 buckets stored as orc 
   TBLPROPERTIES('transactional'='true');
   ```

3. 

### 分区表插入

hive默认情况下分区表需要指定需要插入的分区字段的值

```sql
insert into test_s3a_external_partition_table 
partition (province = 'guangdong') -- 指定分区字段值
values ('test-user-001','test-user-001',18);
```

如果需要在插入时动态创建分区，需要设置以下选项

```sql
--设置动态分区
set hive.exec.dynamic.partition=true;
--设置动态分区为非严格模式
set hive.exec.dynamic.partition.mode=nonstrict;
```









## 分区表