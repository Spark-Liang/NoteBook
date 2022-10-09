### Java IO API

- BIO

- NIO

#### BIO

阻塞型IO以 Input/OutputStream 和 Reader/Writer 为主，其中的read和write方法均为阻塞操作。

##### 读操作

示例代码:

```java
 public static  byte[] readInputStream(InputStream inputStream) throws IOException {
     byte[] buffer = new byte[1024];
     int len = 0;
     ByteArrayOutputStream bos = new ByteArrayOutputStream();
     while((len = inputStream.read(buffer)) != -1) {
         bos.write(buffer, 0, len);
     }
     bos.close();
     return bos.toByteArray();
 }
```

- read方法返回`-1`表示数据流终结

#### NIO

##### Buffer

- Buffer类是负责NIO中在用户程序和Channel之间传递数据，数据写入方把要传递的数据写入Buffer，将引用传递到读取方，然后读取方从Buffer中读取数据。

- Buffer类似只是定义了缓冲区共有的指针操作，由于不同数据类型的缓冲区方法签名的不同所以没有定义数据读写的方法。

###### 缓冲区的指针操作

缓冲区指针相关的字段：

- position：当前指针，指向下一次读写的位置。

- limit：数据读写的上界，对于读是有效数据的上界。由于写通常位于缓冲区末尾，代表能够写入整个缓冲区。

- mark：指针标记，记录指针可以回退的位置，常用于存在读写过程中需要在某个位置重来的场景 ，比如词法语法解析器的预读操作。

Buffer类的其他字段：

- capacity：缓冲区的最大容量。

常见指针操作：

- 数据读写：
  
  - 相对读写：完成数据读取或写入后position会加一，常用于顺序读写场景。
  
  - 绝对读写：读写某个指定索引的数据，position不会改变，常用于随机读写场景。

- flip：表示数据完成写入，可以送去读取方读取。
  
  - 对应的指针操作是：limit设置为position位置，position设置为0，清除mark

- rewind：表示重新读取
  
  - 对应指针操作是：position设置为0，清除mark，limit不变

- mark：设置mark指针，用于回退

- reset：回退position到mark指针

- compact：表示清除已经读取的数据，将未读取的数据移动到缓冲区起始位置。
  
  - 对应指针操作是：将position到limit之间的数据拷贝到缓冲区开头，然后position设置为0，limit设置为capacity。

- clear：重置所有指针到原始状态，通常作为读取完毕后，准备下一次写入。

其他常用的方法：

- position、limit、mark、capacity：获取Buffer属性

- remaining、hasRemaing：是否有还有剩余的数据没读取，或者还有剩余空间可以写入。
