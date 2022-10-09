### SLF4J

- 使用
  
  - maven依赖配置
  
  - Logger获取
  
  - 信息级别
  
  - 日志消息格式化

- 原理
  
  - 实现类自动绑定机制
    
    - 2.0.0以前
    
    - 2.0.0 开始使用Java SPI机制

#### 使用

##### maven配置

依赖项目：<br/>

api：

```xml
<dependency>
    <groupId>org.slf4j</groupId>
    <artifactId>slf4j-api</artifactId>
    <version>1.6.1</version>
</dependency>
```

实现项目：

- log4j
  
  ```xml
  <dependency>  
      <groupId>org.slf4j</groupId>  
      <artifactId>slf4j-log4j12</artifactId>  
      <version>1.7.2</version>  
  </dependency>
  <dependency>
      <groupId>log4j</groupId>
      <artifactId>log4j</artifactId>
      <version>1.2.17</version>
  </dependency>
  ```

- log4j2
  
  ```xml
  <!--log4j2核心包-->
  <dependency>
      <groupId>org.apache.logging.log4j</groupId>
      <artifactId>log4j-api</artifactId>
      <version>2.9.1</version>
  </dependency>
  <dependency>
      <groupId>org.apache.logging.log4j</groupId>
      <artifactId>log4j-core</artifactId>
      <version>2.9.1</version>
  </dependency>
  <!-- Web项目需添加 -->
  <dependency>
      <groupId>org.apache.logging.log4j</groupId>
      <artifactId>log4j-web</artifactId>
      <version>2.9.1</version>
  </dependency>
  <!--用于与slf4j保持桥接-->
  <dependency>
      <groupId>org.apache.logging.log4j</groupId>
      <artifactId>log4j-slf4j-impl</artifactId>
      <version>2.9.1</version>
  </dependency>
  <!-- slf4j核心包-->
  <dependency>
      <groupId>org.slf4j</groupId>
      <artifactId>slf4j-api</artifactId>
      <version>1.7.25</version>
  </dependency>
  ```

- logback
  
  ```xml
  <dependency>
      <groupId>ch.qos.logback</groupId>
      <artifactId>logback-classic</artifactId>
      <version>${logback.version}</version>
  </dependency>
  ```

#### Logger获取

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

private static final Logger logger = LoggerFactory.getLogger(PluginService.class);
```

##### 消息级别

SLF4J将日志分为trace、debug、info、warn、error五个级别，每个级别对应记录不同的日志，对应不同的使用场景。

| level | 使用场景                                                             |
| ----- | ---------------------------------------------------------------- |
| trace | 一般用来追踪详细的程序运行流                                                   |
| debug | 往往用在判断是否有出现bug的场景。通过记录代码运行的详细信息，比如方法调用传入的参数信息等方便排查问题             |
| info  | info记录的是整个系统的运行信息，比如系统运行到了哪一个阶段，到达了哪一个状态。                        |
| warn  | 警告信息表示，程序进入了一个特殊的状态，在该状态下程序可以继续运行，但是不建议让程序进入该状态，因为该状态可能导致结果出现问题。 |
| error |                                                                  |
