##### Hadoop Yarn 内存配置

- yarn-site.xml 配置项

###### yarn-site.xml 配置项

**yarn的container并不是jvm，yarn管理资源的方式是通过系统层面的API统计某个进程所使用的资源。所以yarn.scheduler.maximum-allocation-mb这个参数并不等同于 JVM 的 -Xmx。**

- **yarn.nodemanager.resource.memory-mb**

表示该节点上YARN可使用的物理内存总量，默认是8192（MB），注意，如果你的节点内存资源不够8GB，则需要调减小这个值，而YARN不会智能的探测节点的物理内存总量。

- **yarn.nodemanager.vmem-pmem-ratio**

任务每使用1MB物理内存，最多可使用虚拟内存量，默认是2.1。

- **yarn.nodemanager.pmem-check-enabled**

是否启动一个线程检查每个任务正使用的物理内存量，如果任务超出分配值，则直接将其杀掉，默认是true。

- **yarn.nodemanager.vmem-check-enabled**

是否启动一个线程检查每个任务正使用的虚拟内存量，如果任务超出分配值，则直接将其杀掉，默认是true。

- **yarn.scheduler.minimum-allocation-mb**

单个任务可申请的最少物理内存量，默认是1024（MB），如果一个任务申请的物理内存量少于该值，则该对应的值改为这个数。

- **yarn.scheduler.maximum-allocation-mb**

单个任务可申请的最多物理内存量，默认是8192（MB）。
