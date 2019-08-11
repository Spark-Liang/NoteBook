#### 文件结构

pom文件主要包含几个部分的内容：

1. 第一部分主要用于配置项目的基础信息，包含 group id，artifactId version。

2. 

3. 第二部分是 properties ，配置pom文件中的重复使用的参数。在 pom文件的其他地方可以通过 \$\{value name\} 进行引用。

4. 第三部分是配置依赖，每个依赖中有两个重要的标签一个是scope另一个是 classifier
   
   1. \<scope\>：主要是配置该依赖会出现在maven生命周期中的那些部分
      
      - complie：只出现在编译时期。比如说一些声明接口的类。
      
      - test：只出现在测试阶段。
   
   2. \<classifier\>：指定从仓库中拉取某个版本中的不同子版本，通常是用于区分支持不同jdk

5. 第四部分是配置项目的构建，这些构建相关的内容配置在\<build\>的标签下。

6. 第五部分是配置不同的构建 profile，当需要使用不同的参数构建出不同的jar包，可以采用profile，定义不同的参数。在运行maven命令时，通过 -P 参数进行指定。

###### pom文件内置属性

- ${basedir}表示项目根目录,即包含pom.xml文件的目录;

- \${version}表示项目版本;

- \${project.basedir}同\${basedir};

- \${project.baseUri}表示项目文件地址;

- ${project.build.directory}表示主源码路径;

- ${project.build.sourceEncoding}表示主源码的编码格式;

- ${project.build.sourceDirectory}表示主源码路径;

- ${project.build.finalName}表示输出文件名称;

- \${project.version}表示项目版本,与\${version}相同;

- java系统属性：即 System.getProperties 对应的属性

- 环境变量：使用 \${env.\<environment variable name\>} 进行调用。

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

通过maven命令控制项目构建到不同阶段达到不同的目的，比如需要对项目进行测试，则只需要对项目构建到 test 阶段，如果需要进行部署就需要对项目进行到 deploy 阶段。<br>

maven插件的作用就是通过在不同阶段添加对应的插件，实现对构建过程的自定义，比如自定义构建的输出是jar包还是war包。

###### 常见maven插件及其用处

- maven-dependency-plugin：将依赖包导出到指定文件夹
- maven-resources-plugin：将资源文件导出到指定目录
- maven-antrun-plugin：使用ant构建工具，执行复杂的构建逻辑。[更多ant构建命令](https://ant.apache.org/)
