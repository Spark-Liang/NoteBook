### ConfigMap

- 功能和应用场景
- 数据结构
- 创建方式
- 引用方式

#### 功能和应用场景

- 可以用来保存单个属性、保存整个配置文件或者JSON二进制大对象

- 注入的方式一般有两种，一种是挂载存储卷，一种是传递变量。

- 用于实现配置中心，使配置和程序、数据解耦

**注意点：**

- ConfigMap被引用之前必须存在，属于名称空间级别，不能跨名称空间使用，内容明文显示。

- ConfigMap内容修改后，对应的pod必须重启或者重新加载配置

##### 数据结构

config包含`data`和`binaryData`两个存储配置项的字段。两个字段均以键值对的方式存储配置项。data中，存放文本数据，binaryData存在二进制数据。

#### 创建方式

##### yaml文件创建

在yaml文件的`data`和`binaryData`中直接填写配置项的文本数据。然后通过kubectl进行创建。示例：

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: test_config_map
data:
  HADOOP_NAMENODE_HOSTNAME: hadoop-namenode
```

##### 命令创建

通过`kubectl create cm`命令创建配置ConfigMap。控制配置项数据选项有：

- `--from-literal`：直接配置字面值

- `--from-file`：从文本文件读取值作为配置项内容。

- `--from-dir`：从目录加载配置项，以文件名作为key。

https://zhuanlan.zhihu.com/p/434199276



#### 引用方式

##### 环境变量引用



##### 命令变量引用



##### 挂载成文件


