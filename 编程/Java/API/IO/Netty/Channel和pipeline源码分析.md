### Channel和pipeline源码分析

- 相关接口分析
  
  - Channel
  - Eventloop
  - Futurn-Promise 编程模型

#### 相关接口分析

##### Channel

<img src="file:///E:/Notebook/Personal/NoteBook/img/319bac863ecc3a72cc67a9264c8db05701acd02c.png" title="" alt="" data-align="center">

- 接口描述了一个具有完整业务逻辑处理能力的通道对外提供的行为，外界只需要在适当的时刻调用对应的行为方法即可实现数据读写处理逻辑。

- Channel接口继承了ChannelOutboundInvoker，可以理解为接口的实例可以看作是通道的本地端，能进行什么操作。

- Channel接口本身定义的方法定义了具备二进制数据加工能力的通道需要具备的方法。
  
      Channel是具备层级结构的，支持按照树状组织数据处理逻辑，比如“java对象的读写通道 = 数据流分包的通道 + 数据包解码编码器通道”

业务处理流程

![](E:\Notebook\Personal\NoteBook\img\48c0b5798c47f84eec31368746a565270df8b664.png)



#### Eventloop

- [【Netty学习】EventLoop源码剖析_蛙广志的博客-CSDN博客](https://blog.csdn.net/CPrimer0/article/details/116568636)



#### Futurn-Promise编程模型

- https://zhuanlan.zhihu.com/p/493225557
