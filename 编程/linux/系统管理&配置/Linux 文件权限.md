## shell命令执行

shell和进程的关系：
我们从login shell 说起，login shell用于表示登陆进程，是指用户刚登录系统时，由系统创建，用以运行shell 的进程。每在shell 中执行一个命令，内部就是linux 从 login shell 中fork 出一个子进程执行相应的命令。

### 进程的权限传递

子进程的权限是由父进程copy过来的。
