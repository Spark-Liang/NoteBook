### Vue模板语法

- v-bind 指令
- v-if 指令
- v-for 指令
- v-model 指令
- v-on 指令
- 指令简写

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
