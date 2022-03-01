### Helm安装使用

- 安装

- 使用

#### 安装

1. 在[Releases · helm/helm · GitHub](https://github.com/helm/helm/releases)连接中下载helm3对应的安装包

2. 解压，并在解压出的`linux-amd64`文件夹拷贝helm文件到`/usr/local/bin`中

#### 使用

##### 简介

Helm主要包含两个部分的使用内容。一部分是Chart模板的管理，包括获取模板、打包上传下载模板，以及测试模板。另一部分是运行实例（Release）的管理，即通过模板部署的实例的管理，如部署卸载、更新回滚等。<br>

Helm主要是把按照一定目录结构编排好的yaml作为模板，然后通过不同的参数动态部署不同的k8s应用。

##### Chart模板管理

相关常用子命令：

- pull ： 将Chart拉取成tar压缩包

- package：将Chart目录打包成压缩包

- lint：检查Chart目录是否存在语法问题。用法`helm lint <Chart 目录>`

- template：本地渲染Chart的输出。用法`helm template <release name> <chart 目录>`



##### Release管理





#### 参考文献

- https://www.cnblogs.com/qiyebao/p/13389621.html

- [k8s之helm入门 - 法外狂徒 - 博客园](https://www.cnblogs.com/fawaikuangtu123/p/11296574.html)

- [minikube - Kubernetes - How to define ConfigMap built using a file in a yaml? - Stack Overflow](https://stackoverflow.com/questions/53429486/kubernetes-how-to-define-configmap-built-using-a-file-in-a-yaml)

- [Helm | example](https://helm.sh/docs/chart_template_guide/accessing_files/#basic-example)
