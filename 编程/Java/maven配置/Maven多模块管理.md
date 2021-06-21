### Maven 多模块管理

- 父模块
  
  - 父模块中常用的标签
    
    - `<dependencyManagement>`和`<pluginManagement>`
    
    - `<modules>`和`<module>`

- 依赖聚合模块



#### 父模块

父模块的作用是对项目各个子模块进行聚合，同时通过父模块管理各个子模块间公共的属性及公共的依赖文件。



##### 父模块常用标签

###### `<dependencyManagement>`和`<pluginManagement>`标签：

dependencyManagement主要用于定义默认的依赖版本，当子模块中使用到该依赖时提供默认的版本。



###### `<modules>`和`<module>`

这两个标签用于指定模块所有所属的子模块。module标签中填的是子模块的相对路径。



#### 依赖聚合模块

由于每个模块只能有一个parent，所以当某个parent只是用于依赖管理作用的父模块，可以通过dependencyMangement进行依赖。比如springboot 的依赖。
