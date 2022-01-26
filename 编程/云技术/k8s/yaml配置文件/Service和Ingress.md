### Service和Ingress

- Service类型及作用
  
  - 类型
  
  - Headless Service

- Service配置
  
  - 常用配置字段

#### Service类型及作用

service用于给集群内部或者外部提供固定的DNS名称用于访问服务，并且提供负载均衡的功能。

##### 类型

Service的有4种类型，不同类型对应着不同的服务暴露级别：

- ClusterIP：只将服务通过clusterIP暴露给集群内部的其他Pod使用。
  
  ![](E:\Notebook\Personal\NoteBook\img\cdf73c35d3e743dcd560ed811051ef4c5d88b724.jpeg)

- NodePort：将服务的端口绑定到所有Node的指定端口上，即集群外部可以通过Node上的端口访问服务。
  
  ![](E:\Notebook\Personal\NoteBook\img\abf35701d51a293491822baee41153c192680b29.jpeg)

- LoadBalancer：借助外部的负载均衡器，提供统一的入口将请求发送到NodePort上。
  
  ![](E:\Notebook\Personal\NoteBook\img\d4173b81ec2a9dfcfd4609b8e6a8da5908a5ea93.jpeg)

##### HeadLess Service

由于Service需要ClusterIP作为其他pod访问的地址，然后进行负载均衡。通过把ClusterIP设置为None，使得k8s不生成ClusterIP，其他pod通过service本身的url访问时，会返回所有pod的ip。

常规Service的DNS解析结果

![](E:\Notebook\Personal\NoteBook\img\f33f289e882c3c3946e49374d75e5430421d1eef.png)

Headless Service的DNS解析结果

![](E:\Notebook\Personal\NoteBook\img\48fbd38b76f35e83a8879eb5f062fe40de2f3f5d.png)

#### Service配置

##### 常用配置字段

- clusterIP：配置Service所属的clusterIP。当不配置时，k8s自动生成。当配置为None时，service没有clusterIP，dns解析时会返回所有pod的ip地址

- selector：通过标签选择组成service的pod

- ports：service暴露服务的端口。包含下列配置字段
  
  - port：service会暴露的端口
  
  - targetPort：对应pod的端口
  
  - nodePort：暴露到节点上的端口
