#### 快速构建spring boot应用

- 使用maven 构建



##### 使用maven 构建

1. 构建添加基础依赖到pom文件中
   
   ```xml
   <!-- 添加到 /project 下 -->
   <parent>
       <groupId>org.springframework.boot</groupId>

       <artifactId>spring-boot-starter-parent</artifactId>

       <version>2.0.3.RELEASE</version>

   </parent>
   
   <!-- 添加到 /project/dependencies 下 -->
   <dependency>
       <groupId>org.springframework.boot</groupId>

       <artifactId>spring-boot-starter-web</artifactId>

   </dependency>
   
   <!-- 添加到 /project/build/plugins 下 -->
   <plugin>
   	<groupId>org.springframework.boot</groupId>
   	<artifactId>spring-boot-maven-plugin</artifactId>
   </plugin>
   ```

2. 编写 app 启动类
   
   ```java
   @SpringBootApplication  

   @ComponentScan(basePackages = "org.sparkliang") //默认spring boot 只扫描 App所在包一下的所有类，当有类存在在兄弟目中则需要使用该注解添加

   public class ServerApp {
       public static void main(String[] args) {
           System.setProperty("server.port", "9090"); //控制绑定端口

           SpringApplication.run(ServerApp.class, args);

       }
   }
   ```

3. 编写controller
   
   ```java
   @Controller // 可以使用 Controller，或者被 Controller 注解的任何注解

   public class DemoController {
       // 配置方法映射的路径

       @RequestMapping(value = "/home",method = RequestMethod.GET)
       @ResponseBody // 代表方法返回的内容就是响应的内容

       public String home(){
           return "hello, world";
       }
   
   }
   ```

4. 
