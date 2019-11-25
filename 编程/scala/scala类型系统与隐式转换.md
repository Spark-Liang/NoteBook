#### 类型系统与隐式转换

- 类型系统
  
  - 泛型
  
  - 协变与逆变
  
  - 边界

- 隐式转换
  
  - 类型隐式转换
  
  - 隐式类（相当于隐式包装）
  
  - 参数隐式转换

##### 隐式转换

scala中的隐式转换和自动转换不同，scala中的自动类型转换是通过基本类型中定义了对于其他基本类型的运算方法，通过重载来实现的。隐式转换相当于在编译时候，增加了编译器寻找方法或者变量的可选项。隐式转换的限制如下：

- implicit 只能用于修饰方法，变量，类和伴生对象。

- **隐式转换只能影响当前范围。当前包，当前类或者对象。**

- 可以通过定义或者import的方法使得某个隐式转换在当前范围生效。

- 如果没有找到合适的隐式转换会报错，**如果找到多个合适的隐式转换也会报错**。

###### 类型隐式转换

隐式转换的方法名不影响隐式转换的查找。

```scala
// 定义
implicit def a2B(a:A) = new B()

class A{  println("new A") }
class B{ println("new B") }

def getB(b:B){ println("get B") }

getB(new A())
// new A
// new B
// get B
```

###### 隐式类（相当于隐式包装）

定义隐式类可以动态地给某些类添加一些方法包装。**在定义构造函数是必须包含被包装的类型的参数。**

```scala
implicit class TestImplicit(i:Int) {
    def getImplicitClass()={
      println(this.getClass)
    }
  }

1.getImplicitClass
// TestImplicit
```

###### 参数隐式转换

主要用于定义公共的默认参数。**参数的命名不影响查找**

```scala
implicit val str :String = "implicit value"
  def getImplicitValue(implicit str_value:String)={
    println(str_value)
  }

  getImplicitValue
```
