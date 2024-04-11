# Kafka安装配置

[TOC]

## 安装

### 前置条件

- 每一台主机都互相ssh 互信。并且每台主机对自己互信

- 配置环境变量 `KAFKA_HOME` 和 `PATH=${KAFKA_HOME}/bin:$PATH`

### 配置kafka配置文件

**需要在每一台 kafka服务器上配置**

1. 修改 `config/server.properties` ，修改下列常用的配置
   
   1. `broker.id`：代表该broker进程对应的id，这个配置必须每个broker进程唯一
      
      1. `broker.id` 默认值-1，取值范围必须大于-1，并且小于`reserved.broker.max.id`
      
      2. 例：`broker.id=0`
   
   2. `listeners`：配置监听器的类型和监听端口
      
      1. 例：`listeners=PLAINTEXT://:9092`
   
   3. `log.dir`：配置server 进程的日志位置
   
   4. `broker.id.generation.enable`：是否自动生成 broker id，当enable时，自动从`reserved.broker.max.id`开始生成broker id

### 启动服务

**注意：每调用一个该命令只是根据给定的配置文件启动一个broker进程。当需要启动多个broker进程时，必须调用多次**

```shell
./bin/kafka-server-start.sh -daemon config/server.properties
```

## 常用命令

### 读写数据

```bash
# 打开命令行生产者，输入内容按回车发送消息
./kafka-console-producer.sh \
--bootstrap-server hadoop1:9094 \
--producer-property security.protocol=SASL_PLAINTEXT --producer-property sasl.mechanism=SCRAM-SHA-512 \
--topic flinksource5 

# 打开命令行消费者，将消息打印到命令行
# 其中 --from-beginning 代表从主题开始打印消息
./kafka-console-consumer.sh \
--bootstrap-server hadoop1:9094 \
--consumer-property security.protocol=SASL_PLAINTEXT --consumer-property sasl.mechanism=SCRAM-SHA-512 \
--topic flinksource5 --from-beginning
```

### 主题

```bash
# ./bin/kafka-topics.sh 命令可以通过 ----bootstrap-server 或者 --zookeeper 指定需要操作的kafka集群

# 创建
./bin/kafka-topics.sh --create \
--bootstrap-server localhost:9092 \
--replication-factor 2 --partitions 3 --topic hello-topic

# 修改分区数量
./bin/kafka-topics.sh --alter \
--bootstrap-server localhost:9092 \
--partitions 3 --topic hello-topic

# 删除
./bin/kafka-topics.sh --delete \
--bootstrap-server localhost:9092 \
--topic hello-topic


# 查看主题列表
./bin/kafka-topics.sh --list \
--bootstrap-server localhost:9092 

# 查看主题详情
./bin/kafka-topics.sh --describe \
--bootstrap-server localhost:9092 \
--topic hello-topic
```

**注意点：**

- `kafka-topics.sh --delete`命令不进行物理删除，需要在`server.properties`中设置`delete.topic.enable`为`true`才行。

  或者使用zookeeper客户端进行删除。

  ```bash
  cd "$ZOOKEEPER_HOME" 
  ./bin/zookeeper-client 
  # 进入zookeeper客户端后
  # 查看topic坐在目录
  ls /brokers/topics
  # 执行删除命令 
  rmr /brokers/topics/test
  ```

- 



## 配置

### `server.properties`配置

#### 身份验证

### 服务进程参数配置

kafka服务进程的参数可以通过`export XXX`修改或者直接修改`kafka-server-start.sh`文件

常用参数

- `KAFKA_HEAP_OPTS`：堆内存选项，默认值`-Xmx1G -Xms1G`
- `KAFKA_JMX_OPTS`: jmx 配置项
- `KAFKA_LOG4J_OPTS`: log4j环境变量配置
