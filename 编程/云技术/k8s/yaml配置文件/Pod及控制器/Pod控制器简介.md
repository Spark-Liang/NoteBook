#### Pod控制器

- 简介

- 类型简介

- 常见配置项

#### 简介

k8s通过对pod的编排实现各种引用功能。而控制器是对pod在不同维度进行了增强，增加了特定的控制逻辑。

#### 类型简介

- ReplicationController 和 ReplicaSet：增加按照pod模板创建pod，并控制集群中满足条件的pod的数量。
  
  - 支持通过scale命令动态扩容。

- Deployment：在ReplicateSet上增加对pod的部署和版本控制功能。
  
  - 支持通过scale命令动态扩容。
  
  - 支持通过patch命令实现滚动升级
  
  - 通常用于无状态应用

- StatefulSet：固定Pod的hostname和FQDN，并且能够按照PVC模板创建PVC挂载持久化存储
  
  - StatefulSet只是负责生成固定hostname的pod，路由FQDN需要Service实现
  
  - 

- DaemonSet：确保满足条件的node启动一个后台运行pod。
  
  - 常用于后台服务pod，如监控、存储等

#### 常见配置项

- selector：
  
  labels是定义资源对象的不同功能标签，为了使selector客户端/用户能够识别一组有共同特征或属性的资源对象。不同的资源的selector字段用于筛选不同类型的资源
