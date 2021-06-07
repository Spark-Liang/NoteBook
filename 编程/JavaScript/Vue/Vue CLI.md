### Vue CLI

- 安装配置
  
  - 安装cli
  - 安装 cli-service

- vue create 项目创建脚手架
  
  - 目录结构

- vue.config.js 配置文件
  
  - 常见错误

#### 安装配置

##### 安装 cli

###### 安装命令：

```bash
npm install -g @vue/cli
```

##### 

##### 安装 cli-service

###### 安装命令：

```bash
cnpm install -g @vue/cli-service
```

###### 常见报错

Cannot find module 'vue-template-compiler/package.json'：<br>

- 原因：缺少必须模块vue-template-compiler

- 解决方法：
  
  安装 vue-template-compiler。
  
  ```bash
  npm install -g vue-template-compiler 
  # 必须为全局安装，否则无法访问到 vue-template-compiler 命令。
  ```

#### vue create 项目创建脚手架

##### 目录结构

- `public`：任何放置在 `public` 文件夹的静态资源都会被简单的复制，而不经过 webpack。你需要通过绝对路径来引用它们。

- `src`：

#### `vue.config.js` 配置文件

在使用`vue-cli-service`命令编译或者启动vue页面时，会如果存在`vue.config.js`文件，会优先使用`vue.config.js`中的配置项。

##### 常用配置项

`vue.config.js` 通过 `module.exports` 输出配置项。例子：

```javascript
module.exports = {
    // all configuration
}
```

###### Webpack 相关配置项

Webpack 打包相关的配置项可以通过`chainWebpack`传入对config 的处理函数实现对Webpack的配置。

```javascript
// 连接路径并返回
const path = require('path')
function resolve(dir) {
  return path.join(__dirname, '..', dir)
}

// 例子
chainWebpack: config => {
    config.resolve.alias
      .set('@', resolve('src')) // key,value自行定义，比如.set('@@', resolve('src/components'))
      .set('_c', resolve('src/components'))
}
```

[详细的Webpack配置参考官方文档](https://webpack.js.org/configuration/)

##### 常见错误

###### You are using the runtime-only build of Vue where the template compiler is not available

**原因**：<br>

vue 本身有两个版本，一个是 runtime-only，另一个是 runtime + compiler。`runtime` 是必须的，`compiler` 的作用是把html字符串编译成渲染器代码。<br>

**程序编译运行时，只会把`.vue` 文件内的 `template` 标签里面的html编译成渲染器代码。但是 script 中的html 字符串是不会被编译的。所以需要运行时compiler编译成渲染器代码。**<br>

例子：

```javascript
new Vue({
    name:'abc',template:'<div>abc</div>'
})
// 由于 template 中包含了 html 字符串，所以需要运行时使用 runtime + compiler 的vue
```

**解决办法**：

- 方法1：在`vue.config.js` 中添加选项`runtimeCompiler: true`。
