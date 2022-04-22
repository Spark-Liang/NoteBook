### bash

- 编译安装

#### 编译安装

##### 依赖文件

- 源码包：[Index of /gnu/bash](https://ftp.gnu.org/gnu/bash/)

依赖模块：

| 模块名称    | 描述  | 安装方式                                     |
| ------- | --- | ---------------------------------------- |
| termcap |     | [源码](https://ftp.gnu.org/gnu/termcap/)编译 |
|         |     |                                          |

##### 编译

###### 常用选项

- `--enable-static-link`：使用静态连接

- `--enable-history`：启用历史记录

- `--without-bash-malloc`

实例命令：

```bash
./configure --prefix=/usr \
--enable-static-link --enable-history --without-bash-malloc

make && make install
```

**注意点**：

- bash的`--prefix`可能不生效，需要检查Makefile中配置的prefix是否为对应的值。

参考文档：

- [bash 编译_yh2869的博客-CSDN博客_bash源码编译](https://blog.csdn.net/yh2869/article/details/83058524)
