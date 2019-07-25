#### 模块管理（ES6语法）

##### 导入导出

导入语法例子：

```jsx
// 导入
import React,{Component,Fragment} from "react" // 从模块中导入，默认从node_modules/react.js导入

import App from "./App.js" //从本地模块文件中导入
import App from "./App" //从本地模块中导入，实际上从 ./App.js中导入

//整个模块导入并且重命名
import * as example from "./exportExample.js"
```

需要注意的是，如果只是从源模块中import一个对象也需要使用{}，如果不使用{}代表import的是源模块中的export default 对应的对象。<br>

```jsx
//下面两个语句等价
import { default as xxx } from 'modules';
import xxx from 'modules';
```

导出语法的例子：

```jsx
//下面两个语句等价
export var a=1;

var a=1;
export a;

//下面两个语句等价
export default a
export {a as default}
```

#### 类继承

```jsx
class clazz extends super_clazz{
    constructor(){} //构造函数，实例创建时一定会调用该函数
}
```

#### 箭头函数

```jsx
() => 1+1

()=>{}
```
