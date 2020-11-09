#### inspect

- [基本用法](#基本用法)
  
  - [获取对象成员，以及判断对象类型](#获取对象成员，以及判断对象类型)
  - [获取源码](#获取源码)
  - [获取函数参数信息](#获取函数参数信息)
  - [解析堆栈](#解析堆栈)

##### 基本用法

inspect，提供以下常用的功能：

1. 对是否是模块、框架、函数进行类型检查 

2. 获取源码 

3. 获取类或者函数的参数信息  

4. 解析堆栈

###### 获取对象成员，以及判断对象类型

获取成员的方法：

```python
inspect.getmembers(object[, predicate]) -> list[tuple(str,Any)]
```

判断成员的类型，同时也可直接用于getmember 中的 predicate

```python
inspect.ismodule(object)： 是否为模块
inspect.isclass(object)：是否为类
inspect.ismethod(object)：是否为方法（bound method written in python）
inspect.isfunction(object)：是否为函数(python function, including lambda expression)
inspect.isgeneratorfunction(object)：是否为python生成器函数
inspect.isgenerator(object):是否为生成器
inspect.istraceback(object)： 是否为traceback
inspect.isframe(object)：是否为frame
inspect.iscode(object)：是否为code
inspect.isbuiltin(object)：是否为built-in函数或built-in方法
inspect.isroutine(object)：是否为用户自定义或者built-in函数或方法
inspect.isabstract(object)：是否为抽象基类
inspect.ismethoddescriptor(object)：是否为方法标识符
inspect.isdatadescriptor(object)：是否为数字标识符，数字标识符有__get__ 和__set__属性； 通常也有__name__和__doc__属性
inspect.isgetsetdescriptor(object)：是否为getset descriptor
inspect.ismemberdescriptor(object)：是否为member descriptor
```

不同的类型的对象大致能通过getmember获得以下内置信息。

| Attribute           | Type      | Description                                                                                       | Notes       |
| ------------------- | --------- | ------------------------------------------------------------------------------------------------- | ----------- |
| __doc__             | module    | documentation string 文档字符串                                                                        |             |
| __file__            |           | filename (missing for built-in modules) 文件名(内置模块没有文件名)                                            |             |
| __doc__             | class     | documentation string 文档字符串                                                                        |             |
| __module__          |           | name of module in which this class was defined 该类型被定义时所在的模块的名称                                    |             |
| __doc__             | method    | documentation string 文档字符串                                                                        |             |
| __name__            |           | name with which this method was defined 该方法定义时所使用的名称                                              |             |
| im_class            |           | class object that asked for this method                                                           | (1)         |
| im_func or __func__ |           | function object containing implementation of method 实现该方法的函数对象                                    |             |
| im_self or __self__ |           | instance to which this method is bound, or None 该方法被绑定的实例，若没有绑定则为 None                            |             |
| __doc__             | function  | documentation string 文档字符串                                                                        |             |
| __name__            |           | name with which this function was defined 用于定义此函数的名称                                              |             |
| func_code           |           | code object containing compiled function bytecode 包含已编译函数的代码对象                                    |             |
| func_defaults       |           | tuple of any default values for arguments                                                         |             |
| func_doc            |           | (same as __doc__)                                                                                 |             |
| func_globals        |           | global namespace in which this function was defined                                               |             |
| func_name           |           | (same as __name__)                                                                                |             |
| __iter__            | generator | defined to support iteration over container                                                       |             |
| close               |           | raises new GeneratorExit exception inside the generator to terminate the iteration                |             |
| gi_code             |           | code object                                                                                       |             |
| gi_frame            |           | frame object or possibly None once the generator has been exhausted                               |             |
| gi_running          |           | set to 1 when generator is executing, 0 otherwise                                                 |             |
| next                |           | return the next item from the container                                                           |             |
| send                |           | resumes the generator and “sends” a value that becomes the result of the current yield-expression |             |
| throw               |           | used to raise an exception inside the generator                                                   |             |
| tb_frame            | traceback | frame object at this level 此级别的框架对象                                                               |             |
| tb_lasti            |           | index of last attempted instruction in bytecode                                                   |             |
| tb_lineno           |           | current line number in Python source code                                                         |             |
| tb_next             |           | next inner traceback object (called by this level)                                                |             |
| f_back              | frame     | next outer frame object (this frame’s caller)                                                     |             |
| f_builtins          |           | builtins namespace seen by this frame                                                             |             |
| f_code              |           | code object being executed in this frame                                                          |             |
| f_exc_traceback     |           | traceback if raised in this frame, or None                                                        |             |
| f_exc_type          |           | exception type if raised in this frame, or None                                                   |             |
| f_exc_value         |           | exception value if raised in this frame, or None                                                  |             |
| f_globals           |           | global namespace seen by this frame                                                               |             |
| f_lasti             |           | index of last attempted instruction in bytecode                                                   |             |
| f_lineno            |           | current line number in Python source code                                                         |             |
| f_locals            |           | local namespace seen by this frame                                                                |             |
| f_restricted        |           | 0 or 1 if frame is in restricted execution mode                                                   |             |
| f_trace             |           | tracing function for this frame, or None                                                          |             |
| co_argcount         | code      | number of arguments (not including * or ** args)                                                  |             |
| co_code             |           | string of raw compiled bytecode 原始编译字节码的字符串                                                       |             |
| co_consts           |           | tuple of constants used in the bytecode 字节码中使用的常量元组                                               |             |
| co_filename         |           | name of file in which this code object was created 创建此代码对象的文件的名称                                  |             |
| co_firstlineno      |           | number of first line in Python source code                                                        |             |
| co_flags            |           | bitmap: 1=optimized                                                                               | 2=newlocals |
| co_lnotab           |           | encoded mapping of line numbers to bytecode indices 编码的行号到字节码索引的映射                                |             |
| co_name             |           | name with which this code object was defined 定义此代码对象的名称                                           |             |
| co_names            |           | tuple of names of local variables 局部变量名称的元组                                                       |             |
| co_nlocals          |           | number of local variables 局部变量的数量                                                                 |             |
| co_stacksize        |           | virtual machine stack space required 需要虚拟机堆栈空间                                                    |             |
| co_varnames         |           | tuple of names of arguments and local variables 参数名和局部变量的元组                                       |             |
| __doc__             | builtin   | documentation string 文档字符串                                                                        |             |
| __name__            |           | original name of this function or method 此函数或方法的原始名称                                              |             |
| __self__            |           | instance to which a method is bound, or None                                                      |             |



###### 获取源码

用于获取类和对象应用的源码相关信息

```python
inspect.getdoc(object)# 获取object的documentation信息
inspect.getcomments(object)
inspect.getfile(object)# 返回对象的文件名
inspect.getmodule(object)# 返回object所属的模块名
inspect.getsourcefile(object)# 返回object的python源文件名；object不能使built-in的module, class, mothod
inspect.getsourcelines(object)# 返回object的python源文件代码的内容，行号+代码行
inspect.getsource(object)# 以string形式返回object的源代码
inspect.cleandoc(doc)
```





###### 获取函数参数信息

```python
inspect.getclasstree(classes[, unique])
inspect.getargspec(func)
inspect.getargvalues(frame)
inspect.formatargspec(args[, varargs, varkw, defaults, formatarg, formatvarargs, formatvarkw, formatvalue, join])
inspect.formatargvalues(args[, varargs, varkw, locals, formatarg, formatvarargs, formatvarkw, formatvalue, join])
inspect.getmro(cls)#元组形式返回cls类的基类（包括cls类），以method resolution顺序;通常cls类为元素的第一个元素
inspect.getcallargs(func[, *args][, **kwds])#将args和kwds参数到绑定到为func的参数名；对bound方法，也绑定第一个参数（通常为self）到相应的实例；返回字典，对应参数名及其值；
```



###### 解析堆栈

```python
inspect.getframeinfo(frame[, context])
inspect.getouterframes(frame[, context])
inspect.getinnerframes(traceback[, context])
inspect.currentframe()
inspect.stack([context])
inspect.trace([context])
```



##### 参考文档

- [Python语法学习记录（24）：inspect模块介绍及常用使用方式_呆呆象呆呆的博客-CSDN博客](https://blog.csdn.net/qq_41554005/article/details/109278882)


