#### 选取节点

1. 节点路径

2. 谓语

3. 通配符

4. 选取多个路径

5. 实例xml

##### 节点路径

| 表达式      | 描述                            |
| -------- | ----------------------------- |
| nodename | 选取此节点的所有子节点。                  |
| /        | 从根节点选取。                       |
| //       | 从匹配选择的当前节点选择文档中的节点，而不考虑它们的位置。 |
| .        | 选取当前节点。                       |
| ..       | 选取当前节点的父节点。                   |
| @        | 选取属性。                         |

**实例**：

| 路径表达式           | 结果                                                         |
| --------------- | ---------------------------------------------------------- |
| bookstore       | 选取 bookstore 元素的所有子节点。                                     |
| /bookstore      | 选取根元素 bookstore。注释：假如路径起始于正斜杠( / )，则此路径始终代表到某元素的绝对路径！      |
| bookstore/book  | 选取属于 bookstore 的子元素的所有 book 元素。                            |
| //book          | 选取所有 book 子元素，而不管它们在文档中的位置。                                |
| bookstore//book | 选择属于 bookstore 元素的后代的所有 book 元素，而不管它们位于 bookstore 之下的什么位置。 |
| //@lang         | 选取名为 lang 的所有属性。                                           |

**通过xpath选取节点，最后输出的是所有符合条件的节点集合。输出的依旧是一个xml**



##### 谓语

**实例**

| 路径表达式                              | 结果                                                              |
| ---------------------------------- | --------------------------------------------------------------- |
| /bookstore/book[1]                 | 选取属于 bookstore 子元素的第一个 book 元素。                                 |
| /bookstore/book[last()]            | 选取属于 bookstore 子元素的最后一个 book 元素。                                |
| /bookstore/book[last()-1]          | 选取属于 bookstore 子元素的倒数第二个 book 元素。                               |
| /bookstore/book[position()<3]      | 选取最前面的两个属于 bookstore 元素的子元素的 book 元素。                           |
| //title[@lang]                     | 选取所有拥有名为 lang 的属性的 title 元素。                                    |
| //title[@lang='eng']               | 选取所有 title 元素，且这些元素拥有值为 eng 的 lang 属性。                          |
| /bookstore/book[price>35.00]       | 选取 bookstore 元素的所有 book 元素，且其中的 price 元素的值须大于 35.00。            |
| /bookstore/book[price>35.00]/title | 选取 bookstore 元素中的 book 元素的所有 title 元素，且其中的 price 元素的值须大于 35.00。 |

##### 通配符

| 通配符    | 描述         |
| ------ | ---------- |
| *      | 匹配任何元素节点。  |
| @*     | 匹配任何属性节点。  |
| node() | 匹配任何类型的节点。 |

**实例**

| 路径表达式        | 结果                     |
| ------------ | ---------------------- |
| /bookstore/* | 选取 bookstore 元素的所有子元素。 |
| //*          | 选取文档中的所有元素。            |
| //title[@*]  | 选取所有带有属性的 title 元素。    |

##### 选取多个路径

| 路径表达式                 | 结果           |
| --------------------- | ------------ |
| //book/title          | //book/price |
| //title               | //price      |
| /bookstore/book/title | //price      |

##### 实例xml

```xml
<?xml version="1.0" encoding="ISO-8859-1"?>

<bookstore>

<book>
  <title lang="eng">Harry Potter</title>
  <price>29.99</price>
</book>

<book>
  <title lang="eng">Learning XML</title>
  <price>39.95</price>
</book>

</bookstore>
```












