### docker-compose.yml

- 配置文件语法

- 服务配置
  
  - 配置结构
  
  - 镜像相关配置
  
  - 运行进程相关配置
  
  - 存储相关配置
  
  - 网络相关配置

- 参考文档

#### 配置文件语法

配置文件支持读取环境变量，实现变量插值。<br>

支持插值语法

- `${VARIABLE:-default}`：如果VARIABLE未设置或为空，则会应用default的值。

- `${VARIABLE-default}`：仅当VARIABLE未设置时才会应用default的值。

- `${VARIABLE:?err}`：如果VARIABLE未设置或为空，退出并输出一条包含err的错误信息。

- `${VARIABLE?err}`：如果VARIABLE未设置，退出并输出一条包含err的错误信息。

避免插值的方式，是使用`$$`表示`$`：

```yml
web:
  build: .
  command: "$$VAR_NOT_INTERPOLATED_BY_COMPOSE"
```

#### 服务配置

##### 配置结构

docker-compose配置文件的大致结构是：

```yml
version: "3.8"
service: # 配置容器
  <服务名称>:
    # 服务容器配置
volumes: # 定义数据卷
  <卷名称>:
    # 数据卷配置
networks: # 定义网络
  <网络名称>:
    # 网络配置
configs: # 定义配置
  <配置集合名称>:
    # 配置内容
```

##### 镜像相关配置

docker-compose 支持直接指定镜像，或者指定构建镜像的方式来设置容器使用的镜像。

###### 使用image字段指定容器镜像

###### 使用build字段指定容器镜像构建方式

#### 参考文档

- [Docker Compose 配置文件 docker-compose.yml 详解_BUG弄潮儿的博客-CSDN博客](https://blog.csdn.net/huangjinjin520/article/details/124054043)
