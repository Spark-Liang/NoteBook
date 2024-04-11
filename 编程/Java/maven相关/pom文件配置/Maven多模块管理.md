### Maven多模块管理

- 继承关系
  - 定义继承关系的方式
  - 继承关系的依赖处理
  - 继承关系的其他元素的继承关系
  - 继承关系处理的注意点
- 项目聚合关系
  - 定义聚合关系的方式
  - 

#### 继承关系

##### 定义继承关系的方式

在项目中通过`parent`标签声明继承的项目

```xml
<parent>
    <groupId>org.example</groupId>
    <artifactId>LearningMaven</artifactId>
    <version>1.1-SNAPSHOT</version>
</parent>
```

**注意点：**

- `parent`标签内的`group id`，`artifactId`， `version`只能使用常量值不能使用`${xxx}`的变量。

- 一个项目只能有一个父项目

##### 继承关系的依赖处理

- 父模块`dependencies`标签中定义的依赖会被子模块直接继承

- 而定义在`dependencyManagement`中的依赖只有在`继承项目`使用 `groupId`和`artifactId`进行引用时才会继承。`继承项目`会继承掉`dependencyManagement`中声明的所有属性如`version`和`scope`等，`继承项目`可以重写覆盖这些选项。

##### 继承关系的其他元素的继承关系

- `properties`属性会被继承
- `plugins`不会被子模块直接继承。
- 通过`pluginManagement`声明子模块可以继承的插件

##### 继承关系处理的注意点

- 如果在`dependencyManagement`或者`pluginManagement`中声明了变量的话，变量的解析会在继承模块内部才进行解析，比如`${pom.baseDir}`对应的就是继承模块的pom文件对应的路径，而不是父模块对应的路径。

#### 项目聚合关系

##### 定义聚合关系的方式

在聚合根项目中使用`modules`定义项目中需要聚合的子项目。其中`module`声明的值子模块的目录名称。

```xml
<modules>
    <module>SubModule</module>
</modules>
```
