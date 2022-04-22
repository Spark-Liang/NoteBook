### Pod相关配置

- 配置分类
  
  - 常见pod级别配置
  
  - 常见container级别配置

- pod级别配置
  
  - 持久化相关
  
  - 镜像拉取相关
  
  - 进程隔离相关配置
  
  - 调度相关配置
  
  - Pod主体权限

- container级别配置
  
  - 

#### 配置分类

pod主要包含两个级别的配置。一个是pod级别的配置，通常直接配置在spec字段中。另一个是container级别的配置，配置在containers、initContainers、ephemeralContainers字段中。

##### 常见pod级别配置有：

- 持久化相关：volumes

- 镜像拉取相关：imagePullSecret

- 进程隔离相关配置：
  
  - DNS：dnsConfig、dnsPolicy、hostAliases、setHostnameAsFQDN、hostname、subdomain
  
  - 网络通信：hostIPC、hostNetwork
  
  - PID空间：hostPID、shareProcessNamespace
  
  - 用户和权限空间：securityContext

- 调度相关配置：
  
  - 容器调度：activeDeadlineSeconds、restartPolicy，terminationGracePeriodSeconds
  
  - 调度方式：schedulerName
  
  - 节点选择：affinity、nodeName、nodeSelector、tolerations、topologySpreadConstraints
  
  - 调度优先级：preemptionPolicy、priority、priorityClassName

- Pod主体权限：serviceAccountName、automountServiceAccountToken

##### 常见container级别配置：

- 容器标识：name，container名称，在pod中必须唯一

- 镜像拉取相关：image和imagePullPolicy，其中imagePullPolicy，可选Never、IfNotPresent和Always，其中Always不是每次都更新，而是每次都向registry发出请求检查本地的镜像是否是最新。

- 端口暴露：ports，只是用于声明，没有声明的也能被访问到。

- 容器入口：args、command、workingDir。

- 环境变量配置：env和envFrom，**注意，环境变量不是直接注入到系统配置中，所以只对容器的主进程有效。这两个配置项只是等价于k8s自动通过export命令在启动容器进程前注册环境变量。**

- 资源设备相关：resources、volumeMounts和volumeDevices、tty

- 用户权限空间映射：securityContext

- 生命周期
  
  - 状态检测：readinessProbe、livenessProbe、startupProbe
  
  - 回调钩子：lifecycle

#### pod级别配置

##### 持久化相关

volumes用于配置声明可被容器挂载的文件系统，pod中的容器可以通过名称进行引用挂载。k8s提供了各种volume插件，其中常用的有

- configMap：挂载只读的配置文件

- emptyDIr：创建临时目录

- hostPath：挂载pod运行节点上的路径。

##### 镜像拉取相关

需要通过命令`kubectl create secret docker-registry`在**pod对应的命名空间**创建访问目标私有仓库的秘钥。命令格式是：

```bash
kubectl create secret docker-registry \
<secret name> --namespace=<target namespace> \
--docker-server='<server address>' \
--docker-username='admin' --docker-password='admin' \
--docker-email='op@test.cn'
```

##### 调度相关

###### 容器调度

用于控制pod内容器的总体生命周期。

- restartPolicy：控制容器主进程退出后是否重启容器。
  
  - 可选`Always`，`OnFailure`和 `Never`
  
  - 重试间隔时间为，10s、20s、40s指数增加，其最长延迟为 5 分钟。
  
  - 重试间隔时间会在容器正常运行10分钟后重置为10s

- activeDeadlineSeconds：控制容器在转为`Running`后最多能运行多久。

- terminationGracePeriodSeconds：在Pod转为`Terminating` 后多久将强制删除pod，不管是否有还在运行的容器。

###### 节点选择

- `nodeName`:直接手动指定pod运行的node

- `nodeSelector`：通过label按照key-value的形式选择满足条件的node。
  
  ```yaml
  spec:
    nodeSelector:
      label1:value1
      ...
  ```

- `affinity`：通过更加精细化的条件筛选节点。
  
  - 其中包含`nodeAffinity`（节点亲和性）,`nodeAntiAffinity`（节点反亲和性）,`podAntiAffinity`（当某个节点存在满足条件的pod时，不调度到该节点上）。
  
  - 每个字段`requiredDuringSchedulingIgnoredDuringExecution`代表必须满足的条件，`preferredDuringSchedulingIgnoredDuringExecution`用于对满足条件的节点进行筛选

- `tolerations`：代表pod对节点的容忍度，通常用于限制调度或者驱逐pod。

- `topologySpreadConstraints`：用于均匀地将pod分散到不同节点上。

##### Pod主体权限

#### container级别配置

##### image和imagePullPolicy

imagePullPolicy 只有3 种，`Always`标签为latest或者本地不存在从仓库拉取，`IfNotPresent`本地缺失才从仓库拉取，`Never`仅使用本地镜像

###### ports

端口暴露的列表

可配置字段有：

- containerPort（必须）：

- name：自定义名字，用于其他资源引用

- hostIP：绑定到节点的IP

- hostPort：暴露到容器所在host的某个端口上。

##### args和command

|        | 入口文件       | 传入参数 |
| ------ | ---------- | ---- |
| docker | ENTRYPOINT | CMD  |
| k8s    | command    | args |

##### env和envFrom

- env中定义的值优先级高于envFrom

- env和envFrom定义的环境变量只读。

###### env

- name：变量名称

- value：变量值

- valueFrom：变量值引用。
  
  - configMapKeyRef：引用configMap中的某个值
  
  - fieldRef：引用pod运行时元数据
    
    - 支持的选项有：`supports metadata.name, metadata.namespace,
      
           metadata.labels, metadata.annotations, spec.nodeName,
           spec.serviceAccountName, status.hostIP, status.podIP, status.podIPs`
  
  - resourceFieldRef：引用资源相关的元数据
  
  - secretKeyRef：引用秘钥

##### resources、volumeMounts和volumeDevices

##### resources

配置资源的需求和限制。

##### volumeMounts

定义挂载文件系统的路径

- mountPath：容器内挂载路径

- name：引用的volume

- readOnly：只读

- subPath：挂载到volume的某个子路径中

- subPathExpr：通过`${VAR_NAME}`引用环境变量实现变量替换

# 

##### 参考文档

- [K8S Pod配置进阶1 containers字段解释_杨仕虎的博客-CSDN博客](https://blog.csdn.net/yangshihuz/article/details/112599962)
