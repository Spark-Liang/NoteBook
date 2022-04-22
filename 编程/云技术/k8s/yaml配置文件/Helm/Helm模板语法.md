### Helm模板语法

- 基础简介

- 变量使用
  
  - 访问内置对象
  
  - 设置变量

- 函数使用

- 流程控制

- 模板定义和引用

#### 基础简介

一个Helm模板的目录结构如下：

- `Chart.yaml`：描述模板的版本等基础信息。

- `values.yaml`：描述模板的默认值

- `requirements.yaml`：描述模板依赖的其他模板

- `templates`：模板

- `charts`：存放下载好的其他chart

#### 变量使用

Helm中包含两个变量上下文，`$` 代表当前chart中的根上下文对象，`.`代表当前chart中的当前上下文对象，`.`的上下文对象会在`with`语句和`range`中发生变化。<br>

##### 访问变量

helm使用`{{ 表达式 }}`实现对yaml文件的文本替换。<br>**由于yaml是对缩进敏感的配置文件语言，所以helm在变量替换的时候有包含处理前后空白的语法。注意“\t”," ","\n"都属于空白。**

- `{{- 表达式 }}`表示去除占位符之前的空白

- `{{ 表达式 -}}`表示去除占位符之后的空白

变量有不同的数据类型。而所有类型都会在变量替换时，都会格式化成yaml，包括复杂数据类型map和list。**如果缩进不合适，就需要`indent`或者`nindent`进行缩进补全**

##### 内置对象

根上下文对象包含下列内置对象，连接参考每种内置对象的属性列表[Helm | 内置对象](https://docs.helm.sh/zh/docs/chart_template_guide/builtin_objects/)

- Release对象：存放当前部署或者更新的实例的信息。如name和namespace等

- Values对象：包含`values.yaml`和用户在运行install命令传递的参数

- Chart对象：`Chart.yaml`文件包含的内容

- Files对象：用于在模板中和本地文件交互的对象。

- Capabilities对象：获取k8s集群的资源

- Template：获取当前模板对象信息

##### 设置变量

通过`{{ $变量名 := 表达式 }}`可以对变量进行赋值。

#### 函数使用

在helm中没有操作符，所有的操作符都是通过函数实现。<br>

函数的语法：

- 支持管道`|`语法。**helm会把管道上一个函数的输出传到下一个函数的最后一个参数中**

- 函数支持通过`()`括号改变管道组合的优先级

常用替代操作符的函数：

- [布尔函数](https://docs.helm.sh/zh/docs/chart_template_guide/function_list/#logic-and-flow-control-functions)如：and,or, coalesce, default, empty, eq, fail, ge, gt, le, lt, ne, not, 

- [数学函数](https://docs.helm.sh/zh/docs/chart_template_guide/function_list/#math-functions) 如： add, sub, ceil, div, floor, len, max, min, mod, mul, round

- [日期函数](https://docs.helm.sh/zh/docs/chart_template_guide/function_list/#date-functions)

- [列表函数](https://docs.helm.sh/zh/docs/chart_template_guide/function_list/#lists-and-list-functions)

#### 流程控制

helm支持`if`,`with`和`range`三个流程控制命令。

##### if

用于判断某个条件是否满足而是否渲染指定内容，语法为：

```go
{{ if PIPELINE }}
  # Do something
{{ else if OTHER PIPELINE }}
  # Do something else
{{ else }}
  # Default case
{{ end }}
```

如果是以下值时，PIPELINE会被设置为 *false*：

- 布尔false
- 数字0
- 空字符串
- `nil` (空或null)
- 空集合(`map`, `slice`, `tuple`, `dict`, `array`)

##### with

用于临时修改当前上下文对象

```go
{{ with PIPELINE }}
  # restricted scope
{{ end }}
```

##### range

用于循环迭代list或者map，迭代的时候会将当前上下文设置成每个item的value，对于map是value，对于list就是item。

```go
{{- range tuple "small" "medium" "large" }}
- {{ . }}
{{- end }}

# 输出 
- smail
- medium 
- large 
```

当迭代时需要index或者key时，使用下面语法

```go
{{- range $idx,$value := tuple "small" "medium" "large" }}
- {{ $value }}
{{- end }}
```

#### 模板定义和引用

helm支持命名模板定义，为某个模板片段命名，然后在其他地方引用模板。相关的命令有`define`和`template`，以及函数`include`。

- **在模板定义和使用时，需要注意当前上下文对象是什么，否则容易出错**

- 模板的定义是全局的，需要注意避免命名冲突。

##### define

`define`命令用于，定义模板

```go
{{ define "模板名称" }}
# 模板内容
{{ end }}
```

##### template

用于直接引用模板内容 ，按照传递的上下文对象，把占位符替换为渲染后的yaml内容。

```
{{ template "模板名称" 上下文对象表达式 }}
```

##### include

由于`template`命令只能将占位符替换为yaml内容，所以当需要处理缩进问题时，需要使用include函数将yaml文件按照每一行的方式处理缩进。

```
{{ include "模板名称" 上下文对象表达式 }}
```
