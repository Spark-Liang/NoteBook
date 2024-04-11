[TOC]

## 基础概念

### 动态表和实时流对应关系



### sql与回撤流、更新流



### sql查询

#### 关联

##### 常规关联

##### 时间间隔关联

##### 具有版本的维度表关联（Temproal Join）

- 语义：
  - 主表与会随时间变化的维度表进行的关联，关联条件是主表的消息时间字段、
- 限制条件：
  - 只允许进行 Left join 或者 inner join
  - 

##### lookup 关联



#### 聚合



#### 分析函数







## 连接器相关

### kafka

#### 相关文档

- [如何在FlinkSQL中读取&写入到Kafka](https://blog.csdn.net/weixin_42845827/article/details/133708706)



## 相关文档

- [Flink SQL官方文档](https://nightlies.apache.org/flink/flink-docs-release-1.17/docs/dev/table/sql/overview/)

