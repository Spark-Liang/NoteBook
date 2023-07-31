#### 模式匹配

- match 中的模式匹配（或者说switch 中的模式匹配）

- 赋值或者for循环的模式匹配

- 样例类

- 密封类

##### match中的模式匹配

scala中的switch语法如下：

```scala
<var name> match {
    case <pattern> [if <boolean expression>] => <expression>
    case <pattern> [if <boolean expression>] => {
        <statement>
    }
}
```

下面是\<pattern\> 中支持的特性的例子

- 值匹配： "-"，"123"

- 类型匹配：\_:String

- 提取器匹配：Name(firse,last) 

- 提取器指定某个匹配到的部分为具体值：Name("Spark", last)

- 提取器指定某个匹配到的部分为某个类型：Name(firse:String , last)

- 提取器指定某个匹配到的部分匹配某个模式： Name(fisrt, last @ IsVeryLong)  其中其中 IsVaryLong 是返回Boolean 值得提取器。

- 匹配模式但需要引用被匹配的对象：case str @ Name(\_ , \_ ) => println( str )

- 对于数组，列表，元组，可以使用 \_\* 代表余下多个成员：Array("a",\_\*) **需要注意的是，\_\* 只能用来匹配末尾的多个成员。**

scala 的match 中还支持 if 守卫，在if守卫中可以引用\<pattern\> 中定义提取到的变量。

##### 赋值或者for循环的模式匹配

在赋值表达式或者for循环中都可以使用提取器，在for 中更是可以通过模式匹配简化过滤的表达式，如：

```scala
var (a,b) = (1,2)
var Array(a,b,_*) = Array(1,2,3)

// for 使用
val testMap = Map(1 -> Array("a"),2->Array(100))
for ( Array(t:String,_*)<- testMap.values){

    println(t)
}
```

##### 样例类

样例类是scala 中的一个语法糖，声明的样例类编译器会自动为我们定义 apply 和 unapply 方法。这样可以更加方便地在scala中使用模式匹配。
