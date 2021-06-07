### IView

- 组件使用

#### 组件使用

##### 项目安装依赖

```bash
npm install view-design --save
cnpm install view-design --save
```

##### 引入组件

###### 全部引入

引入所有ViewUI组件

```javascript
import Vue from 'vue';
import ViewUI from 'view-design';


Vue.use(ViewUI);
```

引入后常用的组件对应标签：

- Button: `i-button`
- Col: `i-col`
- Table: `i-table`
- Input: `i-input`
- Form: `i-form`
- Menu: `i-menu`
- Select: `i-select`
- Option: `i-option`
- Progress: `i-progress`
- Time: `i-time`

###### 部分引入

```javascript
import { Button, Table } from 'view-design';
Vue.component('Button', Button);
Vue.component('Table', Table);
```
