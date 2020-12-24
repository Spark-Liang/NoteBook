#### Python 内置属性

- 属性获取 
  
  - `__getattribute__`，`__getattr__`，`__get__`

- 实例化相关
  
  - `__init__`
  
  - `__new__`
  
  - `__prepare__`
  
  - `__init_subclass___`

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

##### 实例化相关

和实例化相关的函数有`__new__`和`__init__`。<br>

**注意点**：

- 当通过`<class name>(...)`的方式创建实例时，接受的参数都会传到`__new__`和`__init__`中。

- 当`__new__`返回的实例的类型，和调用的类构造器的类型不同时，是不会自动调用`__init__`方法。

##### `__new__`

这个函数用于为用户实例申请内存，并且创建实例对象。当某个类重载了这个方法就可以增强，实例对象的创建过程。下面是这个方法的常用签名:

```python
# 对于普通类型
def __new__(cls,*args,**kwargs):
    pass

# 对于metaclass类型（type的子类）
def __new__(mcs,name,bases,namespace,**kwargs):
    pass
```

**需要注意的是，这个方法在并不是实例方法或者类方法，在调用的时候只是作为普通函数被调用。只不过python底层会自动把该class本身放到第一个参数上，其自动赋值的实现原理和[实例方法和类方法的](Python面向对象相关.md#原理)不同。**<br>

此外，在重载`__new__`函数时，需要注意对象的创建最终需要调用`object.__new__`方法，并且在python3.6，该方法调用不能带有参数，必须使用`object.__new__()`进行创建。



`__init__`

这个函数用于实现对象实例的初始化。



###### `__init_subclass___`

这个函数用于在定义子类时，父类的回调函数。

[3.3.3. Customizing class creation](https://docs.python.org/3.6/reference/datamodel.html?highlight=__getattr__#customizing-class-creation)



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
