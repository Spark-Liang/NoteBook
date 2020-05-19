#### shell进程信息查询

- top 命令

- /proc 目录

##### top 命令

1. PID ：进程的ID
2. USER ：进程所有者
3. PR ：进程的优先级别，越小越优先被执行
4. NInice ：值
5. VIRT ：进程占用的虚拟内存
6. RES ：进程占用的物理内存
7. SHR ：进程使用的共享内存
8. S ：进程的状态。S表示休眠，R表示正在运行，Z表示僵死状态，N表示该进程优先值为负数
9. %CPU ：进程占用CPU的使用率
10. %MEM ：进程使用的物理内存和总内存的百分比
11. TIME+ ：该进程启动后占用的总的CPU时间，即占用CPU使用时间的累加值。
12. COMMAND ：进程启动命令名称

同时我们可以使用**shift+(P ：按%CPU 使用率排行 T ：按 MITE+ 排行 M ：按%MEM )进行排序显示**

##### /proc 目录

###### 进程信息部分

在 /proc/[pid] 目录下存放着每个进程相应的信息

- /proc/[pid]/auxv：包含传递给进程的 ELF 解释器信息

- /proc/[pid]/cmdline：包含进程完成的命令行信息。如果进程被交换出内存或者是zombie进程，则这个文件没有任何内容

- /proc/[pid]/comm：进程的命令名

- /proc/[pid]/cwd：进程的当前目录

- /proc/[pid]/environ：进程的环境变量，每个环境变量用 NULL 字符分隔。可以使用 strings 命令读取

- /proc/[pid]/exe：实际运行程序的符号链接

- /proc/[pid]/fd：该目录存放所有该进程打开的文件描述符。

- /proc/[pid]/maps：显示进程的内存区域映射信息。其中注意的一点是 [stack:] 是线程的堆栈信息，对应于 /proc/[pid]/task/[tid]/ 路径。

- /proc/[pid]/root：进程根目录链接

- /proc/[pid]/stack：进程的内核调用栈信息

- /proc/[pid]/statm：进程的内存占用大小统计。其中每个值得信息是：
  
  a）进程占用的总的内存
  b）进程当前时刻占用的物理内存
  c）同其它进程共享的内存
  d）进程的代码段
  e）共享库(从2.6版本起，这个值为0)
  f）进程的堆栈
  g）dirty pages(从2.6版本起，这个值为0)

- /proc/[pid]/status：包含进程的状态信息

- /proc/[pid]/status：显示当前进程正在执行的系统调用。

- /proc/[pid]/wcham：显示当进程 sleep 时，kernel 当前运行的函数。

###### 系统信息部分

###### 参考

- [Linux中 /proc/[pid] 目录各文件简析](https://www.cnblogs.com/DataArt/p/10089850.html)

- [Linux中/proc目录下文件详解](https://www.cnblogs.com/baiduboy/p/6098226.html)
