### exporter部署

- 主机exporter

- JMX exporter

- 大数据框架
  
  - ceph
  
  - kafka
  
  - hadoop

#### 主机exporter

注意点：

- 容器化部署的主机exporter必须使用主机网络，否则主机名等信息会不正确。

##### docker部署

```bash
docker run -d \
  --net="host" \
  --pid="host" \
  --name=node-exporter \
  -v "/:/host:ro,rslave" \
  common-service.spark-liang:8091/prom/node-exporter \
  --path.rootfs /host
```

##### k8s部署

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
  namespace: kube-system
  labels:
    k8s-app: node-exporter
spec:
  selector:
    matchLabels:
      k8s-app: node-exporter
  template:
    metadata:
      labels:
        k8s-app: node-exporter
    spec:
      imagePullSecrets:
        - name: common-service.spark-liang
      # 配置tolerations允许pod运行在master上
      tolerations:
        - key: node-role.kubernetes.io/master
          operator: Exists
          effect: NoSchedule
      containers:
        - image: common-service.spark-liang:8091/prom/node-exporter
          name: node-exporter
          ports:
            - containerPort: 9100
              protocol: TCP
              name: http
              hostPort: 39100
```



#### JMX exporter

JMX exporter通过java进程的jmx端口连接并获取监控信息。

##### 连接java程序配置

exporter连接java程序有两个方式，直接通过javaagent连接，以及采用jmx端口远程连接。其中javaagent连接需要重启

##### javaagent连接

Prometheus官方提供的javaagent支持配置jvm参数和动态attache两种方式attach到java进程中，但是jdk版本必须是`1.7+`。[Prometheus 官方javaagent下载链接](https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.16.1/jmx_prometheus_javaagent-0.16.1.jar)

jvm参数attach，需要在jvm启动时添加以下参数：

```bash
java -javaagent:./jmx_prometheus_javaagent-0.16.1.jar=8080:config.yaml -jar yourJar.jar
```

jvm动态attach需要执行命令

```bash

```

###### 使用jmx进程远程连接

java进程支持启动时通过启动参数开启jmx端口，或者通过jcmd动态开启jmx端口。

1. 在java程序的启动参数中添加启动jmx相关参数
   
   jmx相关参数：
   
   ```
   -Dcom.sun.management.jmxremote.authenticate=false \
   -Dcom.sun.management.jmxremote.ssl=false \
   -Dcom.sun.management.jmxremote.local.only=false \
   -Dcom.sun.management.jmxremote.port=1234 
   ```
   
   - 启动时添加通过在java程序的启动命令中添加启动参数实现
   
   - 运行添加通过jcmd方式启动
     
     ```bash
     jcmd pid ManagementAgent.start jmxremote.port=9999 jmxremote.ssl=false jmxremote.authenticate=false
     
     
     ```

2. 配置

##### 相关文档

- [#yyds干货盘点# Prometheus Exporter（十七） JMX Exporter_耳东-Erdong的技术博客_51CTO博客](https://blog.51cto.com/erdong/4810427)

- [【JVM】使用 javaagent 和 动态 Attach两种方式实现类的动态修改和增强 - N!CE波 - 博客园](https://www.cnblogs.com/756623607-zhang/p/12575509.html)

- [java jmx 开启_动态开启jmx服务_静待天时的博客-CSDN博客](https://blog.csdn.net/weixin_42389770/article/details/114216823)



#### 大数据框架

##### ceph



##### kafka



##### hadoop

采用
