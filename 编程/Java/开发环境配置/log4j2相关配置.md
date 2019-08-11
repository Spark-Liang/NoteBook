使用log4j2只需要在classpath下有log4j2.xml文件，log4j2就会加载相应的配置文件

log4j2.xml配置<br>

log4j的configuration配置主要有两个节点一个是appenders另外一个是loggers。其中appenders节点下主要配置日志的输入方式，可以有三种方式，控制台，file，和RollingFile<br>

配置一个appender的几个关键点是

1.需要配置name属性，immediateFlush属性限制是否立即输出，对于File和RollingFile
需要配置file属性，console需要配置target属性，一般为SYSTEM_OUT和SYSTEM_ERR

2.配置ThresholdFilter用于过滤不同级别的日志信息，以及onMatch和onMismatch时的操作

3.PatternLayout 用于限制日志的输出格式

    %d{yyyy-MM-dd HH:mm:ss, SSS} : 日志生产时间
    
    %p : 日志输出格式
    
    %c : logger的名称
    
    %m : 日志内容，即 logger.info("message")
    
    %n : 换行符
    
    %C : Java类名
    
    %L : 日志输出所在行数
    
    %M : 日志输出所在方法名
    
    %x: 表示方法的相对于某一个类的调用栈
    
    hostName : 本地机器名
    
    hostAddress : 本地ip地址

配置一个logger的几个关键点是

1. name属性用于限制该logger记载日志的基础package

2.每个logger下可以有多个appender-ref用于指定日志的输出方式

loggers下有两个节点，一个是root节点，一个是logger节点，logger的节点属性默认继承root几点的属性
