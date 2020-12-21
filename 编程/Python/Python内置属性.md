#### Python 内置属性

- 属性获取 
  
  - `__getattribute__`，`__getattr__`，`__get__`

- 实例化相关
  
  - `__init__`
  
  - `__new__`
  
  - `__prepare__`

- 操作符相关

- 其他
  
  - \_\_mro\_\_

##### 属性获取

###### `__getattribute__`，`__getattr__`，`__get__`

官方文档：[3. Data model &#8212; Python 3.6.12 documentation](https://docs.python.org/3.6/reference/datamodel.html?highlight=__getattr__#customizing-attribute-access)

- `__getattribute__`：这个方法可以拦截所有属性访问。最终的实现是在`object.__getattribute__`。

- `__getattr__`：当从`__getattribute__`中无法查询到属性产生AttributeError时，这个方法才会调用。

- `__get__`：有定义这个方法的class可以被称为descriptor（描述符），当这个class的实例在其他类中以属性的方式访问时，这个方法会被调用。
  
  例子
  
  ```python
  class C(object):
      def __get__(self, instance, owner):
          print("__get__() is called", instance, owner)
          return self
  class C2(object):
      d = C()
  C2().d
  # __get__() is called <__main__.C2 object at 0x16d2310> <class '__main__.C2'>
  ```

- 



##### 其他

###### \_\_mro\_\_

用于查看方法的搜索顺序，mro 的全称是method resolution order，是多继承时方法和属性搜索的路径。

例子（python3）：

```python
class A:
    pass
class B:
    pass
class C(A,B):
    pass

print(C.__mro__)
# (<class '__main__.C'>, <class '__main__.A'>, <class '__main__.B'>, <class 'object'>)
```
