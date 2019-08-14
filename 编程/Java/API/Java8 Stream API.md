#### Stream API

Stream API 主要的目的是把对集合的操作抽象成了流水线，通过调用Stream类库的方法去构建对Collection处理的流水线.

###### 构建流水线

常见的构建方式是通过 collection 对象的 stream() 获取 或者 直接 



Stream 流水线中主要有两种类型的操作：中间操作和最终操作

###### 构建中间操作的方法有：

map (mapToInt, flatMap 等)、 filter、 distinct、 sorted、 peek、 skip、 parallel、 sequential、 unordered

其中中间操作又细分为两种类型，一种是有状态操作，另一种是无状态操作。<font color='red'>这两种中间操作的却表只有在并行流处理中才会显现出来</font>

###### 构建最终操作的方法有：

forEach、 forEachOrdered、 toArray、 reduce、 collect、 min、 max、 count、iterator

map : 提供转换的函数，把接收到的对象转换成另一个对象。

flatMap：通过转换函数把从每个对象中获取一个流并且，把所有的流对象合并成一个新的流对象

###### 流操作的重要特点是：延迟计算

延迟计算：只有在执行最终操作的时候才会开始流的计算，其他中间操作只是定义管道的操作的中间过程。

流操作可能抛出异常的位置，只会在流创建

**流操作只是定义了对流的遍历操作的框架，但是不包含对流来源的善后工作，包括对一些inputStream 的关闭等操作。**


