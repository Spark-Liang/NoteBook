#### shell变量及表达式操作

- 变量操作
  
  - 读取变量值
  
  - 字符串操作
  
  - 变量的作用域
  
  - shell 特殊变量

- 表达式操作
  
  - 运算符

##### 变量操作

**在shell中，没有数据类型的概念，所有的变量存储的都是字符串**

###### 读取变量值

| **表达式**         | **含义**                                   |
| --------------- | ---------------------------------------- |
| ${var}          | 变量var的值, 与$var相同                         |
| ${var-DEFAULT}  | 如果var没有被声明, 那么就以$DEFAULT作为其值 *           |
| ${var:-DEFAULT} | 如果var没有被声明, 或者其值为空, 那么就以$DEFAULT作为其值 *   |
| ${var=DEFAULT}  | 如果var没有被声明, 那么就以$DEFAULT作为其值 *           |
| ${var:=DEFAULT} | 如果var没有被声明, 或者其值为空, 那么就以$DEFAULT作为其值 *   |
| ${var+OTHER}    | 如果var声明了, 那么其值就是$OTHER, 否则就为null字符串      |
| ${var:+OTHER}   | 如果var被设置了, 那么其值就是$OTHER, 否则就为null字符串     |
| ${var?ERR_MSG}  | 如果var没被声明, 那么就打印$ERR_MSG *               |
| ${var:?ERR_MSG} | 如果var没被设置, 那么就打印$ERR_MSG *               |
| ${!varprefix*}  | 匹配之前所有以varprefix开头进行声明的变量，返回的是空格分隔的变量名集合 |
| ${!varprefix@}  | 匹配之前所有以varprefix开头进行声明的变量，返回的是空格分隔的变量名集合 |

动态获取变量：

核心思路是通过 echo 拼接出“获取变量值”的代码，然后使用 eval 命令执行它，再把这个返回值替换到命令里。例子：

```bash
var=`eval echo '$'"${i}"`
echo ${var}
```

###### 字符串操作（长度，截取，替换）

| **表达式**                          | **含义**                                                                    |
| -------------------------------- | ------------------------------------------------------------------------- |
| ${#string}                       | $string的长度                                                                |
| ${string:position}               | 在\$string中, 从位置$position开始提取子串                                            |
| ${string:position:length}        | 在\$string中, 从位置\$position开始提取长度为$length的子串                                |
| ${string#substring}              | 从变量\$string的开头,删除最短匹配\$substring的子串。其中\$substring可以使用\*进行通配               |
| ${string##substring}             | 从变量\$string的开头,删除最长匹配\$substring的子串。其中\$substring可以使用\*进行通配               |
| ${string%substring}              | 从变量\$string的结尾,删除最短匹配\$substring的子串。其中\$substring可以使用\*进行通配               |
| ${string%%substring}             | 从变量\$string的结尾,删除最长匹配\$substring的子串。其中\$substring可以使用\*进行通配               |
| ${string/substring/replacement}  | 使用\$replacement, 来代替第一个匹配的\$substring                                     |
| ${string//substring/replacement} | 使用\$replacement, 代替*所有*匹配的\$substring                                     |
| ${string/#substring/replacement} | 如果\$string的**前缀(即从左往右)**匹配\$substring,那么就用\$replacement来代替匹配到的\$substring |
| ${string/%substring/replacement} | 如果\$string的*后缀*匹配\$substring,那么就用\$replacement来代替匹配到的\$substring          |

###### 变量的作用域

shell有三种类型的变量：

- 全局变量：
  
  - shell默认声明的变量
  
  - 作用范围是当前进程。即不受function 调用的影响
  
  - 例子：
    
    ```bash
    #定义函数
    function func(){
        a=99
    }
    #调用函数
    func
    #输出函数内部的变量
    echo $a # 99
    ```
  
  - 

- 局部变量:
  
  - shell 通过local 前缀默认声明的局部变量。如 local test='a'
  
  - 声明了 local 之后，对应名称的变量的作用范围在对应的代码块中。
  
  - 例子：
    
    下面的例子中，我们注意到 test_outer 在test\_local 和 最外层调用时输出的结果是不同的。这证明 local 声明的变量，对应的作用域是当前代码块及内嵌的代码块。
    
    ```bash
    a='A'
    function test_outer(){
            echo $a
    }
    function test_local() {
            local a='a'
            echo $a
            function test_nest_local(){
                    echo $a
            }
            test_nest_local
            test_outer
    }
    
    test_local
    test_outer
    # a
    # a
    # a
    # A
    ```

- 环境变量
  
  - shell 通过export 前缀默认声明的局部变量。如 export test='a'
  
  - 环境变量的作用域是，当前进程及其子进程。
    
    - 使用source 调用脚本时，是把脚本的内容读入到当前进程中进行执行。所以能够共享当前进程的全局变量和环境变量
    
    - 使用 sh 或者 ./ 进行调用时，是创建子进程执行脚本，所以只能共享环境变量。

###### shell 特殊变量

| $0  | 当前脚本的文件名                                                                   |
| --- | -------------------------------------------------------------------------- |
| $n  | 传递给脚本或函数的参数。n 是一个数字，表示第几个参数。例如，第一个参数是\$1，第二个参数是\$2。                        |
| $#  | 传递给脚本或函数的参数个数                                                              |
| $*  | 传递给脚本或函数的所有参数                                                              |
| \$@ | 传递给脚本或函数的所有参数。被双引号(" ")包含时，与 \$* 稍有不同，下面将会讲到                               |
| $?  | 上个命令的退出状态，或函数的返回值                                                          |
| $-  | 显示Shell使用的当前选项,参看[set命令](https://www.runoob.com/linux/linux-comm-set.html) |
| $$  | 当前Shell进程ID。对于 Shell 脚本，就是这些脚本所在的进程ID                                      |
| $!  | 后台运行的最后一个进程的ID号                                                            |

**\$* 和 \$@ 的区别**

\$* 和 \$@ 都表示传递给函数或脚本的所有参数，不被双引号(" ")包含时，都以\$1 \$2 … \$n 的形式输出所有参数。<br>

但是当它们被双引号(" ")包含时，"\$*" 会将所有的参数作为一个整体，以"\$1 \$2 … \$n"的形式输出所有参数；"\$@" 会将各个参数分开，以"\$1" "\$2" … "\$n" 的形式输出所有参数。

##### 表达式操作

对于逻辑表达式运算，使用 \[\[\]\] 的兼容性比 \[\] 更高。同时 \[\[\]\] 还支持 =\~ 进行正则表达式匹配

###### 运算符

**关系运算符**

| 运算符 | 说明                            | 举例                        |
| --- | ----------------------------- | ------------------------- |
| -eq | 检测两个数是否相等，相等返回 true。          | [ \$a -eq \$b ] 返回 false。 |
| -ne | 检测两个数是否不相等，不相等返回 true。        | [ \$a -ne \$b ] 返回 true。  |
| -gt | 检测左边的数是否大于右边的，如果是，则返回 true。   | [ \$a -gt \$b ] 返回 false。 |
| -lt | 检测左边的数是否小于右边的，如果是，则返回 true。   | [ \$a -lt \$b ] 返回 true。  |
| -ge | 检测左边的数是否大于等于右边的，如果是，则返回 true。 | [ \$a -ge \$b ] 返回 false。 |
| -le | 检测左边的数是否小于等于右边的，如果是，则返回 true。 | [ \$a -le \$b ] 返回 true。  |

**布尔运算符**

| 运算符 | 说明                                 | 举例                                      |
| --- | ---------------------------------- | --------------------------------------- |
| !   | 非运算，表达式为 true 则返回 false，否则返回 true。 | [ ! false ] 返回 true。                    |
| -o  | 或运算，有一个表达式为 true 则返回 true。         | [ \$a -lt 20 -o \$b -gt 100 ] 返回 true。  |
| -a  | 与运算，两个表达式都为 true 才返回 true。         | [ \$a -lt 20 -a \$b -gt 100 ] 返回 false。 |

**逻辑运算符**

| 运算符  | 说明      | 举例                                         |
| ---- | ------- | ------------------------------------------ |
| &&   | 逻辑的 AND | [[ \$a -lt 100 && \$b -gt 100 ]] 返回 false  |
| \|\| | 逻辑的 OR  | [[ \$a -lt 100 \|\| \$b -gt 100 ]] 返回 true |

**字符串运算符**

| 运算符 | 说明                          | 举例                      |
| --- | --------------------------- | ----------------------- |
| =   | 检测两个字符串是否相等，相等返回 true。      | [ \$a = \$b ] 返回 false。 |
| !=  | 检测两个字符串是否相等，不相等返回 true。     | [ \$a != \$b ] 返回 true。 |
| -z  | 检测字符串长度是否为0，为0返回 true。      | [ -z \$a ] 返回 false。    |
| -n  | 检测字符串长度是否不为 0，不为 0 返回 true。 | [ -n "\$a" ] 返回 true。   |
| \$  | 检测字符串是否为空，不为空返回 true。       | [ \$a ] 返回 true。        |

**文件测试运算符**

| 操作符     | 说明                                            | 举例                      |
| ------- | --------------------------------------------- | ----------------------- |
| -b file | 检测文件是否是块设备文件，如果是，则返回 true。                    | [ -b \$file ] 返回 false。 |
| -c file | 检测文件是否是字符设备文件，如果是，则返回 true。                   | [ -c \$file ] 返回 false。 |
| -d file | 检测文件是否是目录，如果是，则返回 true。                       | [ -d \$file ] 返回 false。 |
| -f file | 检测文件是否是普通文件（既不是目录，也不是设备文件），<br/>如果是，则返回 true。 | [ -f $file ] 返回 true。   |
| -g file | 检测文件是否设置了 SGID 位，如果是，则返回 true。                | [ -g \$file ] 返回 false。 |
| -k file | 检测文件是否设置了粘着位(Sticky Bit)，如果是，则返回 true。        | [ -k \$file ] 返回 false。 |
| -p file | 检测文件是否是有名管道，如果是，则返回 true。                     | [ -p \$file ] 返回 false。 |
| -u file | 检测文件是否设置了 SUID 位，如果是，则返回 true。                | [ -u \$file ] 返回 false。 |
| -r file | 检测文件是否可读，如果是，则返回 true。                        | [ -r \$file ] 返回 true。  |
| -w file | 检测文件是否可写，如果是，则返回 true。                        | [ -w \$file ] 返回 true。  |
| -x file | 检测文件是否可执行，如果是，则返回 true。                       | [ -x \$file ] 返回 true。  |
| -s file | 检测文件是否为空（文件大小是否大于0），不为空返回 true。               | [ -s \$file ] 返回 true。  |
| -e file | 检测文件（包括目录）是否存在，如果是，则返回 true。                  | [ -e \$file ] 返回 true。  |
