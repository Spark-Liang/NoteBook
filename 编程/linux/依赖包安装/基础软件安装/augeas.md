### augeas

- 简介

#### 简介

#### 编译

##### 依赖

- | 模块名称     | 描述  | 安装方式                                                                                                                                                                                                                                             |
  | -------- | --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
  | readline |     | [源码](https://git.savannah.gnu.org/cgit/readline.git?h=devel)编译                                                                                                                                                                                   |
  | libxml2  |     | [源码](https://gitlab.gnome.org/GNOME/libxml2/-/releases)编译，参考[文档](https://www.cnblogs.com/Anker/p/3542058.html)。<br/>注意编译需要安装autoconf、automake和libtool<br/>构建过程依赖python-devel<br/>如果libxml2的安装路径不在`/usr`在需要使用，`PKG_CONFIG_PATH`环境变量配置包的`.pc`文件的路径 |
  
  


