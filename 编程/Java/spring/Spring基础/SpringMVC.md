### SpringMVC

- url映射

- 参数映射

- 过滤器映射

#### url映射

主要通过`@RequestMapping`注解配置某个方法或者Controller处理的url。`@RequestMapping`能够配置在类或者方法上：

- 配置在类上相当于配置了类中的所有方法的跟url，并且配置了所有方法与url映射相关的属性的默认值。

- 配置在方法上是代码实际处理某个url对应的请求。

##### `@RequestMapping`配置属性

`@RequestMapping`主要用于配置过滤请求的条件

- value 或者 path：映射的路径，支持使用`${变量名}`作为路径变量的占位符，在方法参数中使用`@PathVariable("变量名")`引用

- method：过滤http请求方法

- params 和 headers：过滤url参数和请求header的表达式数组。表达式支持`=`和`!=`以及通配符`*`。能够使用`变量名!`表示不支持某个变量

- consumes：对headers中的`content-type`的过滤表达式，支持通配符`*`

- produces：对headers中的`Accept`的过滤表达式，支持通配符`*`

#### 参数映射

常用的参数映射注解有：

- `@PathVariable`：配置映射的路径变量

- `@RequestParam`：配置映射的url参数

- `@RequestBody`：配置将http请求体映射到某个参数中

- `@ModelAttribute`：该注解会将所有url参数映射到注解变量的类型对应的实体中。其中多层级对象的字段用`a.b.c.d`表示，列表元素使用`a.b.c.d[idx]`方法表示。**注意，列表元素对应的java类型必须是数组或者List的子类**
  
  ```text
  url参数:
  people.name=a&people.age=18&listField[0]=1&listField[1]=2
  实体:
  class Request{
      People people;
      List<String> listField;
  }
  ```

- `@RequestHeader`：将header映射到指定变量

- `@RequestAttribute`：

- `@SessionAttributes`：将多个会话属性中的组合成指定类型的实体

- `@SessionAttribute`：将单个会话属性映射到参数上

- `@CookieValue`

##### 自定义消息格式适配

##### 自定义参数类型适配

#### 过滤器

spring 4.0后增加了对自定义过滤器的加载逻辑，使用的是sevlet-api的注解`@Order`和`@WebFilter`

```java
@Order(1)
@WebFilter(filterName = "myFilter", urlPatterns = "/*")
public class myFilterimplements Filter {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {
    }
}
```

注意点：

- 使用tomcat启动的spring mvc需要保证tomcat启动是能够扫描到Filter所在的jar包。配置项在`catalina.properties`文件中，配置项是`tomcat.util.scan.StandardJarScanFilter.jarsToScan=`

- spring boot应用需要保证配置了`@ServletComponentScan(basePackages = {"filter所在包"})`
