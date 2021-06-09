### Servlet

- Servlet基础
  
  - Servlet生命周期
  
  - Servlet过滤器
  
  - Servlet监听器
  
  - `web.xml`配置
  
  - web app 目录结构

- Tomcat配置

#### Servlet基础

Servlet主要任务如下：

1. 读取客户端（浏览器）发送的数据。

2. 处理数据，（如进行数据库操作）并生成结果返回给客户端。

Servlet的创建方式：

- 实现`Servlet`接口。这是最底层的方式。

- 继承`GenericServlet`类。

- 继承`HttpServlet`类。相比`GenericServlet`，`HttpServlet`的service方法接受的参数更方便处理http请求。
  
  **需要注意的是，Servlet接口只负责编写业务逻辑相关的代码，没有和url路由相关的配置。**

##### Servlet生命周期

每个线程对应一个Servlet实例，所以Servlet实例的生命周期和每个线程的生命周期相同。对应的方法有

1. `init()`，用于初始化实例。

2. `service(request,response)`，用于编写处理逻辑。

3. `destroy()`，用于编写资源清除相关代码。

其中`HttpServlet`会把`service(ServletRequest,ServletResponse)`细化为`doGet,doPost,doPut...`等方法对应不同的Http请求。

<img src="img/Servlet-LifeCycle.jpg" title="" alt="" data-align="center">

##### Servlet过滤器

Servlet过滤器用于动态拦截请求和相应，实现额外的逻辑注入。实现一个拦截器需要实现接口`javax.servlet.Filter`。需要实现的方法有：

- `init(FilterConfig)`：用于初始化Filter实例。

- `doFilter(ServletRequest, ServletResponse, FilterChain)`：用于编写拦截逻辑。`FilterChain`提供接口用于控制是否继续处理请求。

- `destroy()`：用于清除资源。

**每个Filter实例全局只初始化一次。**

###### Filter示例代码

```java
public void doFilter(ServletRequest req, ServletResponse resp,FilterChain chain) throws IOException, ServletException {
  if(...){
    // do sth before down stream servlet  
    ...
    // invoke down stream
    chain.doFilter(req, resp);
    // do sth after down stream servlet  
    ...
  }else{
    // do handle the request.
    return;
  }

}
```

##### Servlet 监听器

`Servlet listener`的作用主要是监听域对象的各种事件，并编写对应的处理逻辑。Servlet有三大域对象`request`，`session`和`servletcontext 或者说 application`。每个域对象的生成、结束或者属性变动对应着事件，注册了的listener可以在时间发生时调用对应的处理方法。一下是和listener相关接口。

- 和生命周期相关的接口
  
  - `ServletRequestListener`：和request生命周期相关的接口。
  
  - `HttpSessionListener`：和session生命周期相关的接口。
  
  - `ServletContextListener`：和context生命周期相关的接口。

- 和属性变通相关的接口
  
  - `ServletContextAttributeListener`
  
  - `HttpSessionAttributeListener`
  
  - `ServletRequestAttributeListener`

##### `web.xml`配置

`web.xml`用于配置web服务。

###### url映射相关配置

用于配置url和Servlet或者Filter的映射关系。例子：

```xml
<?xml version="1.0" encoding="UTF-8"?>  
<web-app>  
<!-- 配置过滤器的例子 -->
<filter>
   <filter-name>LogFilter</filter-name>
   <filter-class>com.runoob.test.LogFilter</filter-class>
   <init-param>
      <param-name>test-param</param-name>
      <param-value>Initialization Paramter</param-value>
   </init-param>
</filter>

<filter>
   <filter-name>AuthenFilter</filter-name>
   ...
</filter>

<filter-mapping>
   <filter-name>LogFilter</filter-name>
   <url-pattern>/*</url-pattern>
</filter-mapping>

<filter-mapping>
   <filter-name>AuthenFilter</filter-name>
   <url-pattern>/*</url-pattern>
</filter-mapping>

<!-- 配置Servlet的例子 -->
<servlet>  
  <!-- 类名 -->  
  <servlet-name>DisplayHeader</servlet-name>  
  <!-- 所在的包 -->  
  <servlet-class>com.runoob.test.DisplayHeader</servlet-class>  
</servlet>  
<servlet-mapping>  
  <servlet-name>DisplayHeader</servlet-name>  
  <!-- 访问的网址 -->  
  <url-pattern>/TomcatTest/DisplayHeader</url-pattern>  
</servlet-mapping>  
</web-app>  
```

**注意点**：

- 拦截器的顺序由位置决定，越靠前越早拦截。

###### 其他配置

- `<welcome-file-list>`：用于配置，在请求目录时默认查找的页面文件名。
  
  ```xml
  <welcome-file-list>
      <welcome-file>index.jsp</welcome-file>
      <welcome-file>index1.jsp</welcome-file>
  </welcome-file-list>
  ```

- `<error-page>`：配置不同情况下的错误页面。
  
  ```xml
  <!-- 按照返回状态值 -->
  <error-page>
      <error-code>404</error-code>
      <location>/error404.jsp</location>
  </error-page>
  <!-- 按照Exception -->
  <error-page>
      <exception-type>java.lang.Exception<exception-type>
      <location>/exception.jsp<location>
  </error-page>
  ```

- `<listener>`：配置监听器

- `<session-config>`：session相关配置。

##### web app 目录结构

涉及到 WEB-INF 子目录的 Web 应用程序结构是所有的 Java web 应用程序的标准，并由 Servlet API 规范指定。给定一个顶级目录名 myapp，目录结构如下所示：

```textile
/myapp
    /images
    /index.html
    /WEB-INF
        web.xml
        /classes
        /lib
```

#### Tomcat配置

##### 安装配置

1. 下载解压即可完成安装

2. 需要配置环境变量`JAVA_HOME`
