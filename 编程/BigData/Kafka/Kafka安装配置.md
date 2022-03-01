#### Kafka安装配置

- 安装

- 常用命令

##### 安装

###### 前置条件

- 每一台主机都互相ssh 互信。并且每台主机对自己互信

- 配置环境变量 `KAFKA_HOME` 和 `PATH=${KAFKA_HOME}/bin:$PATH`

###### 配置kafka配置文件

**需要在每一台 kafka服务器上配置**

1. 修改 `config/server.properties` ，修改下列常用的配置
   
   1. `broker.id`：代表该broker进程对应的id，这个配置必须每个broker进程唯一
      
      1. `broker.id` 默认值-1，取值范围必须大于-1，并且小于`reserved.broker.max.id`
      
      2. 例：`broker.id=0`
   
   2. `listeners`：配置监听器的类型和监听端口
      
      1. 例：`listeners=PLAINTEXT://:9092`
   
   3. `log.dir`：配置server 进程的日志位置
   
   4. `broker.id.generation.enable`：是否自动生成 broker id，当enable时，自动从`reserved.broker.max.id`开始生成broker id

###### 启动服务

**注意：每调用一个该命令只是根据给定的配置文件启动一个broker进程。当需要启动多个broker进程时，必须调用多次**

```shell
./bin/kafka-server-start.sh -daemon config/server.properties
```

##### 常用命令
