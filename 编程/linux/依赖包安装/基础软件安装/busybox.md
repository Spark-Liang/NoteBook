### busybox

- 简介

- 编译

#### 简介

#### 编译

##### 依赖环境

| 模块名称         | 描述       | 安装方式                                                                                                                          |
| ------------ | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| ncurses      | 图形化配置界面库 | [源码](https://ftp.gnu.org/pub/gnu/ncurses/)编译，参考文档[LINUX下载编译ncurses](https://blog.csdn.net/quantum7/article/details/106175841) |
| glibc-static |          | - yum 安装 glibc-static<br/>-                                                                                                   |

##### 源码相关

- [官网](https://busybox.net/)

##### 编译步骤

1. 使用`make menuconfig`命令配置busybox编译选项

2. 使用`make && make install`

##### 参考文档

- [busybox的编译使用及安装_whatday的博客-CSDN博客_busybox编译](https://blog.csdn.net/whatday/article/details/86787385)
- [CentOS下编译安装Busybox_weixin_30737433的博客-CSDN博客](https://blog.csdn.net/weixin_30737433/article/details/95840066)

##### 编译错误收集

###### /usr/bin/ld: cannot find -lxxx

- 原因：缺少glibc-static静态库
