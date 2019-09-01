#### Scala 类和对象

- 类声明
  
  - 构造函数
  
  - 静态成员
  
  - 访问控制

- 方法定义
  
  - 抽象类和接口

- scala object
  
  - 单例对象
  
  - 伴生对象
  
  - 程序入口对象
  
  - 对象的apply方法（工厂模式）
  
  - 对象的unapply方法（提取器模式）
  
  - 对象的update方法

##### 类声明

###### 构造函数

scala 的类型声明和java 类似，但是整个类方法体声明的区域就是主构造函数。在scala 中可以声明辅助构造函数，来实现构造函数的重载

```scala
class Person(nameStr:String){ // 如果声明无参构造函数，则省略括号
    // 在类声明区域内的过程性语句都会被认为是主构造函数的内容
    var name = nameStr // 声明可变变量 
    val immutableName = nameStr // 声明不可变变量
}

// 定义私有构造函数
class Person private (nameStr:String){
    var name = nameStr    
}
```

**注意：如果需要参数名和对象的属性同名，需要使用 var 或者 val 放在参数名前，如 var name:String。**<br>

在scala 中，属性是否可以修改的底层是编译出的java类是否具有setter方法。在scala 中可以通过语法糖实现自定义属性的getter和setter 的方法。由于scala 调用无参方法可以省略括号，所以所有的无参方法并且有返回值的都可以被看作属性的getter。而属性名 + \_ 的方法名会被编译成setter方法

```scala
class Person {
    private var __name = "Test"
    def name = this.__name
    def name_ = (newName:String){
        __name = newName
        println("new name:" + newName)
    }
}
```

###### 静态成员

在scala的类中，没有static 修饰符，所有的成员都是属于每个实例的，无论是变量还是定义的内部类。如果需要使用静态变量则需要通过伴生对象进行定义。

###### 访问控制

**scala 的默认修饰符是 public。**

| 修饰符              | 访问范围                           |
| ---------------- | ------------------------------ |
| 无任何修饰符           | 任何地方都可以使用                      |
| private[scala]   | 在定义的类中可以访问，在scala包及子包中可以访问     |
| private[this]    | 只能在定义的类中访问，即使伴生对象也不能访问团        |
| private          | 在定义的的类及伴生对象中可以访问，其它地方不能访问      |
| protected[scala] | 在定义的类及子类中可以访问，在scala包及子包中可以访问， |
| protected[this]  | 只能在定义的类及子类中访问，即使伴生对象也不能访问      |
| protected        | 在定义的类及子类中访问，伴生对象可以访问，其它地方不能访问  |

##### 方法定义

scala 的 方法定义格式如下，其中方法的返回值可以省略，由系统自动推断：

```scala
def functionName ([参数列表]) : [return type] = {
   function body
   return [expr]
}
// 定义单行方法
def functionName ([参数列表]) : [return type] = < expression >
```

###### 抽象类和接口（在scala中成为特征 trait）

在scala 中用特质 trait 替换了 java 中 interface 中对应的功能。语法如下

```scala
trait Person{
    val name:String //定义抽象方法
    def say(something:String):Unit //定义抽象方法
}

class Student with Person {
    val name:String = "A" // 实现Person中定义的抽象属性
    override def say(something:String):Unit={
        println(something)
    }
}
```

##### scala object

##### 单例对象

scala中通过 object 关键字可以定义一个全局的单例对象。这些对象通常用于一些单例的设计模式，或者作为工具类使用。

```scala
object Obj [with <some trait>]{
    // 定义对象的成员和方法
}
```

###### 伴生对象

在scala中的是没有static修饰符来定义静态变量的，所有的静态成员都需要在伴生对象中进行定义。<br>

**需要注意的是：伴生对象和对应的类要定义在同一个scala文件中。**

```scala
class Person(val name:String){
  Person.nameMap(name) = this //这里访问的静态变量需要带上类名。


  override def toString="class Person(val name:"+name+")"
}

object Person{
  private val nameMap = Map[String,Person]()

  def totalPersons = nameMap.size

  def getAllPerson = nameMap.values
}
```

###### 程序入口对象

scala 中，单例对象的main 方法才是程序的入口。

```scala
object Hello{
    def main(args:Array[String]){
        println("Hello world!")
    }
}
```

或者继承App 类型，则对应的构造函数就是main 方法。

```scala
object Hello extends App{
    if (args.length > 0)
        println("Hello "+ args[0])
    else 
        println("Hello world!")
}
```

###### 对象的apply 方法

对象的apply方法可以通过 Object() 的方式进行调用，通常伴生对象的apply 方法用作工厂方法。

```scala
class Person private(val name:String);
object Person{
    def apply(name:String)= new Person(name)
}
```
