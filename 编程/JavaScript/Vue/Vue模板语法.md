### Vue模板语法

- v-bind 指令
- v-if 指令
- v-for 指令
- v-model 指令
- v-on 指令
  - 参数传递
  - 事件修饰符
- v-slot 指令
- 自定义指令
- 表达式语法
- - 页面插值
  - 管道过滤器
  - 

#### v-bind 指令

`v-bind` 指令用于动态给 html 标签的属性赋值。支持完全的JavaScript表达式。<br>

例子：

```html
<!-- 使用 JavaScript 表达式 -->
<div v-bind:id="'list-' + id">菜鸟教程</div>

<!-- v-bind 指令简写是 ":" -->
<div :id="'list-' + id">菜鸟教程</div>
```

#### v-if 指令

通过表达式的真假控制标签是否显示。相关指令有`v-if`和`v-else-if`和`v-else`。例子：

```html
<div id="app">
    <div v-if="type === 'A'">
      A
    </div>
    <div v-else-if="type === 'B'">
      B
    </div>
    <div v-else-if="type === 'C'">
      C
    </div>
    <div v-else>
      Not A/B/C
    </div>
</div>
```

#### v-for 指令

按照列表循环生成标签。**循环迭代的对象必须是数组。**

`v-for`指令的三种迭代方式：

```html
<!-- 只迭代数组中的元素 -->
<ul>
    <li v-for="value in object">
    {{ value }}
    </li>
  </ul>


<!-- 迭代数组中的元素和key -->
<ul>
    <li v-for="(value, key) in object">
    {{ key }} : {{ value }}
    </li>
  </ul>


<!-- 迭代数组中的元素，key和索引 -->
<ul>
    <li v-for="(value, key, index) in object">
     {{ index }}. {{ key }} : {{ value }}
    </li>
  </ul>
```

**注意点：**

- 这里的value，key，index都是局部变量名，变量名可自定义。其作用范围只在该标签集齐字标签。

#### v-model 指令

实现对某个数据标签的双向数据绑定，**当数据发生变化时更新视图，当标签对应的value发生变化时，自动同步数据到绑定的变量上。本质上是v-bind和v-on的结合。**

```html
<!-- 标准写法 -->
<input v-model="name">

<!-- 等价写法 -->
<input :value="name" @input="name = $event.target.value">
```

**每个组件标签只有能有一个v-model**

#### v-on 指令

v-on指令用于绑定html节点发生的事件。语法是`v-on:<事件名称>:"<调用的函数或者JavaScript语句>"`，简写为`@<事件名称>:"<调用的函数或者JavaScript语句>"`。例子：

```html
<!-- 使用JavaScript表达式 -->
<div id="app">
  <button v-on:click="counter += 1">增加 1</button>
  <p>这个按钮被点击了 {{ counter }} 次。</p>
</div>

<!-- 使用JavaScript表达式 -->
<div id="app">
  <button v-on:click="say">增加 1</button>
  <p>这个按钮被点击了 {{ counter }} 次。</p>
</div>
```

##### 参数传递

参数传递规律：

- 当函数调用没有传参时，可以省略括号

- 在没有声明参数的情况下，默认第一个参数时原生事件对象。

- 当使用括号传入参数时，需要通过\$event引用事件对象。

- 如果是执行JavaScript语句，也可宏\$event引用事件对象。

##### 事件修饰符

事件修饰符主要是对DOM事件的处理作额外的修饰，比如说是否禁用原生事件行为，比如`<a>`的跳转。

###### 事件修饰符语法

```html
<!-- 阻止单击事件冒泡 -->
<a v-on:click.stop="doThis"></a>
<!-- 提交事件不再重载页面。因为prevent是指禁用原生行为。 -->
<form v-on:submit.prevent="onSubmit"></form>
<!-- 修饰符可以串联。指禁用事件冒泡和原生事件行为  -->
<a v-on:click.stop.prevent="doThat"></a>
<!-- 添加事件侦听器时使用事件捕获模式。即有几个组件都由某个事件触发，该原生的事件函数优先执行 -->
<div v-on:click.capture="doThis">...</div>
<!-- 只当事件在该元素本身（而不是子元素）触发时触发回调 -->
<div v-on:click.self="doThat">...</div>
```

常见事件修饰符：

- `.stop`：停止事件冒泡，即向上层传递

- `.prevent`或者`.preventDefault`：禁止原生html行为

- `.capture`：多个回调函数需要执行时，优先执行该回调函数。如果有多个，则由外到内执行。

- `.self`：只在自身触发时，才调用回调函数。

- `.once`：事件只触发一次。

常见按键事件修饰符：

```html
<!-- 同上 -->
<input v-on:keyup.enter="submit">
<!-- 缩写语法 -->
<input @keyup.enter="submit">
```

#### v-slot指令

该指令用于配置对应某个template节点属于父节点的哪个插槽。**v-slot指令只能用于template节点。**

**v-slot的指令简写是`#`。**

#### 自定义指令

自定义指令用于自定义组件发生变化时需要额外调用的函数。

参考文档：[Vue.js 自定义指令 | 菜鸟教程](https://www.runoob.com/vue2/vue-custom-directive.html)

#### 表达式语法

##### 页面插值

数据绑定最常见的形式就是使用 {{...}}（双大括号）的文本插值：

```html
<div id="app">
  <p>{{ message }}</p>
</div>
```

##### 管道过滤器

Vue.js 允许你自定义过滤器，被用作一些常见的文本格式化。由"管道符"指示, 格式如下：

```html
<!-- 在两个大括号中 -->
{{ message | capitalize }}

<!-- 在 v-bind 指令中 -->
<div v-bind:id="rawId | formatId"></div>
```

**过滤器需要在filters中注册才能用。**

```html

```
