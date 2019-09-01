#### 并发编程

- Future 类使用

- Akka 框架
  
  - 环境需求
  - 编写 Actor类
  - Actor 间的信息交互

##### Akka框架

scala最常用的并发编程框架，这个框架的并发思路是采用消息机制。Akka中的每个actor都采用发送消息的方式进行多线程协作。

###### 环境需求

使用akka框架需要导入相应的包到项目依赖中，下面是maven POM 文件对应需要的依赖

```pom
<properties>
    <scala.version>2.12.9</scala.version>
    <scala.compat.version>2.12</scala.compat.version>
    <akka.version>2.4.17</akka.version>
</properties>

<dependencies>
    <!-- 添加akka的actor依赖 -->
    <dependency>
        <groupId>com.typesafe.akka</groupId>
        <artifactId>akka-actor_${scala.compat.version}</artifactId>
        <version>${akka.version}</version>
    </dependency>

    <!-- 多进程之间的Actor通信 -->
    <dependency>
        <groupId>com.typesafe.akka</groupId>
        <artifactId>akka-remote_${scala.compat.version}</artifactId>
        <version>${akka.version}</version>
    </dependency>
</dependencies>
```

###### 编写 Actor类

开发过程中主要是编写 receive，来控制Actor 在接收到信息时的操作。

```scala
// 常见的receive 方法是用过模式匹配进行重写
override def receive = {
  case "Hello" => println(getClass + " say hi")
  case "Call Back" => {
    println("receive call back request")
    sender ! "reply msg"
  }
}
```



###### actor 间的信息交互


