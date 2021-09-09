### Lombok

- 配置
  
  - maven 依赖
  
  - 配置Lombok maven 插件
  
  - 配置Idea Lombok插件

- 常用注解

- 源码

- 自定义

#### 配置

##### maven配置

依赖配置

```xml
<dependency>
    <groupId>org.projectlombok</groupId>
    <artifactId>lombok</artifactId>
    <version>1.18.4</version>
</dependency>
```

**在常用的springboot项目中，通常已经有lombok依赖了，可以直接使用`${lombok.version}`获取项目中使用的lombok依赖版本**

##### 配置Lombok maven 插件

使用maven进行项目编译时，是通过`maven-compiler-plugin`中对代码进行预处理有再编译。是通过`configuration`下的`annotationProcessorPaths`进行配置。每个`annotationProcessorPaths`下的`path`代表一个代码预处理器。其中Lombok的配置例子是

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-compiler-plugin</artifactId>
    <configuration>
    <annotationProcessorPaths>
        <path>
            <groupId>org.projectlombok</groupId>
            <artifactId>lombok</artifactId>
            <version>${lombok.version}</version>
        </path>
    </annotationProcessorPaths>
    </configuration>
</plugin>
```

#### 常用注解

##### getter，setter相关

`@Getter`和`@Setter`注解可以用于实体和字段。可配置属性有：

- value：用于配置getter和setter的访问级别

**NonNull**

**主要作用于成员变量和参数中，标识不能为空，否则抛出空指针异常。**

##### 构造器相关

相关注解有：

- `@NoArgsConstructor`：无参数构造器

- `@RequiredArgsConstructor`：对final和有`@NotNull`注解的字段生成构造器

- `@AllArgsConstructor`：对所有参数生成构造器

共同的属性：

- access：配置访问级别

- staticName：静态方法名称

##### **ToString**

配置toString 注解，选项有：

- `of`：配置包含的字段

- `exclude`：配置需要排除的字段

- `doNotUseGetters`：使用字段getter还是直接通过字段访问。默认使用getter

除此之外，还可以通过`ToString.Include`和`ToString.Exclude`直接在字段上进行配置。

**EqualsAndHashCode**

配置`EqualsAndHashCode`注解，选项有：

- `of`：配置包含的字段

- `exclude`：配置需要排除的字段

- `doNotUseGetters`：使用字段getter还是直接通过字段访问。默认使用getter

除此之外，还可以通过`EqualsAndHashCode.Include`和`EqualsAndHashCode.Exclude`直接在字段上进行配置。

##### 日志相关

`@Slf4j`和`@Log4j`都可用于注入一个static的log变量。用于日志输出。
