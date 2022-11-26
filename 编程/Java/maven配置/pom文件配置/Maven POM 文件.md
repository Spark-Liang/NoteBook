### pom文件

- 文件结构

#### 文件结构

pom文件主要包含几个部分的内容：

1. 第一部分主要用于配置项目的基础信息，包含 `group id`，`artifactId`， `version`。如果存在父子结构的项目需要配置`parent`或者`modules`标签。具体查看[Maven多模块管理](./Maven多模块管理.md)

2. 第二部分是 properties ，配置pom文件中的重复使用的参数。在 pom文件的其他地方可以通过 \$\{value name\} 进行引用。

3. 第三部分是配置依赖，具体查看[Maven依赖管理](./Maven依赖管理.md)

4. 第四部分是配置项目的构建，这些构建相关的内容配置在\<build\>的标签下。具体查看[](Maven构建配置.md)

5. 第五部分是配置不同的构建 profile，当需要使用不同的参数构建出不同的jar包，可以采用profile，定义不同的参数。在运行maven命令时，通过 -P 参数进行指定。

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

#### 其他问题

##### 使用maven构件非公共父项目的项目。

当pom文件中配置了依赖其他本地的maven项目，需要先把依赖公共项目install成jar包才能编译和install自身。
