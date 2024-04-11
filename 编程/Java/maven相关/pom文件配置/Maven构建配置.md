### Maven构建配置

- 构建插件配置
  
  - maven生命周期
  
  - 插件配置
  
  - 常见插件的用处

#### 插件配置

##### maven生命周期

```mermaid
graph LR

B[validate]
B --> C[compile] 
C --> D[test]
D --> E[package]
E --> F[verify]
F --> G[install]
G --> H[deploy]
```

通过maven命令控制项目构建到不同阶段达到不同的目的，比如需要对项目进行测试，则只需要对项目构建到 test 阶段，如果需要进行部署就需要对项目进行到 deploy 阶段。  

maven插件的作用就是通过在不同阶段添加对应的插件，实现对构建过程的自定义，比如自定义构建的输出是jar包还是war包。

##### 插件配置

###### 配置格式

```xml
<plugin>
  <!-- 可选，默认是 <groupId>org.apache.maven.plugins</groupId> -->
  <artifactId>maven-antrun-plugin</artifactId>
  <version>3.0.0</version>
  <!-- 配置插件所有可能的执行步骤 -->
  <executions>
    <execution>
      <!-- 配置插件单个执行步骤的配置 -->
      <!-- 执行步骤id，在需要独立运行插件时通过 [pllugin]:[goal]@[id] -->
      <id>ant-execute</id> 

      <!-- 可选，用于配置插件要挂载到那个maven的生命周期，在对应生命周期执行插件
      <phase>clean</phase> 
      -->

      <!-- 配置使用插件的哪个入口进行运行 -->
      <goals>
        <goal>run</goal>                
      </goals>
      <!-- 配置执行步骤的配置 -->
      <configuration>
      </configuration>
    </execution>
  </executions>
</plugin>
```

##### 配置注意点

###### 执行顺序

- 不同插件间按照`plugin`声明的顺序执行

- 同一个`plugin`按照execution声明的顺序执行。

###### 其他注意点

- 同一个插件的execution的id不能重复

- 同一个插件可以有多个execution绑定统一phase



###### 常见maven插件及其用处

- maven-dependency-plugin：将依赖包导出到指定文件夹
- maven-resources-plugin：将资源文件导出到指定目录
- maven-antrun-plugin：使用ant构建工具，执行复杂的构建逻辑。[更多ant构建命令](https://ant.apache.org/)
