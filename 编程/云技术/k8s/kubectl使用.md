### Kubectl使用

- 信息查看

- 输出格式控制

#### 信息查看

##### 当前集群信息

- kubeadm 引导集群的相关配置：查看 kube-system下的kubeadm-config的configmap

- 查看kubelet配置：查看kube-system下的kubelet-config-xxx 配置



##### 查看当前用户上下文信息

使用`kubectl config`命令



#### 输出控制

##### 过滤数据

支持的筛选方式：

- `-l`：使用label选择器

- `--field-selector`：使用资源的某个字段作为筛选条件

支持的逻辑操作符

- 值判断：`=`，`!=`

- 值列表判断：`in ()`，`not in ()`

- 多个逻辑表达式进行连接：`,`代表and


