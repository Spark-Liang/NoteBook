### Vue文件

- 基本内容

- 模块化设计
  
  - 模块导入
  
  - 模块导出
  
  - 模块路径

#### 基本内容

#### 模块化设计

##### 模块导入

import 有两种语法：

- `import <import 后的名字> from '<模块路径>'`：导入default中的对象，并且命名成新的名字。

- `import {<来源模块中的export 的名字> [as <import 后的名字>],...} from '<模块路径>'`，导入指定名字的对象。

##### 模块导出

`.js`文件通过 `export` 关键字把文件中的某些资源公开，使得其他js文件能通过import 导入引用。

###### export 和 export default

export default 是 export 命令的特殊形式，相当于把某个对象作为模块的默认export，使得其他模块可以通过 `import <import 后的名字> from '<模块路径>'`导入。

##### 模块路径

有`.vue`最终是被 Webpack 做前处理的，所以`import ... from ... ` 的行为受 webpack 配置的影响。

###### 绝对路径和相对路径

**from是在编译文件时使用的路径，所以绝对路径和相对路径都是项目文件对应的本地路径。**

```javascript
// 绝对路径。这里的绝对路径通常用 webpack 的alias特性替换。
// 需要在webpack中配置 alias，如 alias: {'@': resolve('src')}
import test from '@/test.vue'

// 相对当前文件所在目录
import test from './test.vue'
```

###### 拓展名省略

在webpack中配置了`resolve.extensions`，则webpack会自动尝试添加对应的extension查找文件。查找的顺序与 extensions 中定义的顺序有关。

```javascript
module.exports = {
 resolve: {
  extensions: ['.js', '.vue', '.json']
}

import test from './test'
// import 顺序如下：
// test
// test.js
// test.vue
```

###### 从文件夹导入

从文件夹导入的优先级如下：

1. 根据 `package.json` 的定义导入。**注意，`package.json`需要定义main字段，并且main指定的 js 文件要存在。**

2. 如果存在`index.js`，则从`index.js` 导入。

3. 如果存在`index.vue`，则从`index.vue` 导入。
