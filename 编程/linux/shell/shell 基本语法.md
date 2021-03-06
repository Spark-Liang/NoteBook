##### shell基本语法

- 系统变量设置

- 数组定义

- 数组遍历

- shell命令执行

- 进程权限传递

- 使用nologin 的 user 运行命令

##### 系统变量设置

linux 的系统变量有三种：

- 一种是所有用户共有的永久的生效的，这些变量放在 /etc/profile 文件上.
- 一种是单个用户共有的永久的生效的，这些变量放在对应用户目录的 .bash_profile 文件上.用户目录可以通过 "cd ~" 直接进行跳转。

##### 数组定义

```bash
var=(value1 value2 value3 ...)
# shell 中数组的定义只需要用空格把值间隔开,并且需要使用括号把所有值包起来
# shell 中只有一维数组
```

##### 数组遍历

```bash
# 直接通过变量名读取数组变量只会读取数组的第一个值
arr=(1 2 3 4)
echo $arr # 只会打印 1

# 只能通过${<arr_name>[@]} 或者 ${<arr_name>[*]} 传递整个数组
```

##### shell命令执行

shell和进程的关系： 我们从login shell 说起，login shell用于表示登陆进程，是指用户刚登录系统时，由系统创建，用以运行shell 的进程。每在shell 中执行一个命令，内部就是linux 从 login shell 中fork 出一个子进程执行相应的命令。

##### 进程的权限传递

子进程的权限是由父进程copy过来的。

##### 使用nologin 的 user 运行命令

- 方法1. 为了安全，使用nologin账号来运行程序，  
  
  su -s /bin/bash -c "ls" www  
  
  这条命令到底做了什么呢？su -s 是指定shell，这里www用户是nologin用户，是没有默认的shell的，这里指定使用/bin/bash, -c 后面接需要运行的命令， 后面www是用www用户来运行  

- 方法2：  这种方法只能用于非nologin 用户
  
  sudo -u www command 这样也可以使用www用户来执行命令
