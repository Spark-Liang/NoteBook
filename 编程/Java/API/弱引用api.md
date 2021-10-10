### 弱引用api

- 弱引用回收时机

- Reference对象本身回收时机

- 弱引用内存泄露例子



#### 弱引用回收时机

| 引用类型 | 被回收时机           | 用途        |
| ---- | --------------- | --------- |
| 强引用  | 从来不会            | 对象引用的一般状态 |
| 软引用  | 由于内存不足而触发的gc会回收 | 对象缓存      |
| 弱引用  | 任何GC时           | 对象缓存      |
| 虚引用  | 任何时候            | 只用于标记是否回收 |

**注意点**

- 只有`Reference.referent`这个引用指向的对象，会在没有其他强引用的情况下被清理。除此之外，Reference及其子类的其他字段都是强引用，所指对象都不会被清理。



#### Reference对象本身回收时机

Reference对象本身如果被其他对象，是不会被回收的。



#### 弱引用内存泄露例子

##### WeakHashMap的key被引用时，无法回收entry

```java
public class Locker {
    private String id;

    public Locker (String id){this.id=id}
}

// 以下代码会导致WeakHashMap，无法清理Entry,因为 Locker.id是强引用
// 即 entry 强引用了key，导致无法释放内存
Locker locker = new Locker("1");
WeakHashMap<> map = new WeakHashMap();
map.put(locker.id,locker)


// 正确做法应该是
map.put(new String(locker.id),locker)
```


