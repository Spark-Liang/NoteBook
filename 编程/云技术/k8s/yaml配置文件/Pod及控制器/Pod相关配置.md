### Pod相关配置

- 配置分类
  
  - 常见pod级别配置
  
  - 常见container级别配置

- pod级别配置

- container级别配置

#### 配置分类

pod主要包含两个级别的配置。一个是pod级别的配置，通常直接配置在spec字段中。另一个是container级别的配置，配置在containers、initContainers、ephemeralContainers字段中。

##### 常见pod级别配置有：

- volumes：与container目录挂载相关

- imagePullSecrets：配置拉取镜像时使用的密码信息

- 网络路由相关配置：dnaConfig、dnsPolicy、hostIPC、hostNetwork、hostPID、hostname

- 调度相关配置：
  
  - 调度方式：schedulerName
  
  - 节点选择：affinity、nodeName、nodeSelector、tolerations、topologySpreadConstraints
  
  - 优先级：preemptionPolicy、priority、priorityClassName

- restartPolicy：容器的重启逻辑

##### 常见container级别配置：

- name：container名称，在pod中必须唯一

- 镜像拉取相关：image和imagePullPolicy

- 端口暴露：ports

- 容器状态检测：readinessProbe、livenessProbe、startupProbe

- 容器入口：args和command

- 环境变量配置：env和envFrom

- 资源相关：resources、volumeMounts和volumeDevices

- 生命周期回调：lifecycle

#### pod级别配置

##### volumes

volumes用于配置声明可被容器挂载的文件系统，pod中的容器可以通过名称进行引用挂载。k8s提供了各种volume插件，其中常用的有

- configMap：挂载只读的配置文件

- emptyDIr：创建临时目录

- hostPath：挂载pod运行节点上的路径。

##### imagePullSecrets

需要通过命令`kubectl create secret docker-registry`在**pod对应的命名空间**创建访问目标私有仓库的秘钥。命令格式是：

```bash
kubectl create secret docker-registry \
<secret name> --namespace=<target namespace> \
--docker-server='<server address>' \
--docker-username='admin' --docker-password='admin' \
--docker-email='op@test.cn'
```

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
