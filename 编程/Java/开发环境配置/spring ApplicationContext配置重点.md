##### 基本步骤：

1.配置需要扫描的路径

一般如果采用了spring mvc的话，扫描的包中可以排除controller包含的包

2.配置数据库相关数据源

3.配置激活spring 的事务管理

4.配置激活spring的Aop管理



**在ref/applicationContext(spring与mybatis整合).xml 有样例配置。**

##### spring事务事务管理重点：

1.注意事务的隔离级别

2.注意spring事务管理的关键是注意整个事务的范围并且需要在sql语句中结合相关的加锁方式，特别是insert，update和delete前的select，因为select没有主动加锁的话事务不会其作用的

##### spring Aop的配置重点

1.不仅仅要配置pointcut表达式，还需要把pointcut需要管理的类注册进spring中，只有在spring的容器中才能被spring管理
