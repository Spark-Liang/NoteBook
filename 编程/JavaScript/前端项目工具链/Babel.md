### Babel

- 简介

- 使用说明

- 常用配置

#### 简介

- Babel是JavaScript转译器，将最新的JavaScript语法或者Api转换为旧版本JavaScript语法，从而支持大多数浏览器。

- Babel是插件化的转译器，需要不同的转译特性只需要添加对应的插件。

#### 使用说明

##### 安装依赖

```bash
# 下载babel的命令行工具，这些工具只会在构建项目时使用，所以只作为dev-dependencies
npm install --save-dev @babel/core @babel/cli 
# @babel/preset-env 是babel的转译配置预设集合
npm install --save-dev @babel/preset-env
# core-js3、 regenerator-runtime所以需要作为运行时依赖
npm install --save core-js@3 regenerator-runtime 
# polyfill也是是用于补充新api的库，但是由于core-js2停止维护，所以不推荐使用
npm install --save @babel/polyfill
```

##### 运行转译命令

使用babel转译出的文件可以使用nodejs直接运行。

```bash
npx babel [源文件或者路径] [--out-dir 输出路径] [--out-file 输出文件]
```

其他选项：

- `--watch`：babel监听文件变化，实时进行转译

##### 配置

###### 配置优先级

- 当前目录下的`babel.config.json`

- `npx babel`转递的`--config-file`指定的配置文件路径

###### 配置项

配置文件主要包含`presets`和`plugins`

- `presets`提供了预设好的转译配置

- `plugins`提供了配置单独支持某种特定语法的转译的方式。

###### presets配置使用

需要先安装`@babel/preset-env`，示例配置

```json
module.exports = {
  presets: [
    [
      // 设置使用@babel/preset-env预设配置
      "@babel/preset-env", {
        // 控制对模块导入语法的转译方式
        // false 是不转译
        // "auto" 是根据目标环境进行转译
        "modules": false,
        // 自动引入api的方式
        // "entry" 是在每个转译后的文件全量引入新api的依赖文件
        // "usage" 是在每个转译后的文件按需引入新api的依赖文件
        "useBuiltIns": "entry",
        // 配置提供新api库的方式，现在使用core-js3提供新的JS api
        "corejs": "3",
        // 配置目标环境信息，支持ie8，直接使用iOS浏览器版本7
        'targets': {
          'browsers': ['not ie >= 8', 'iOS 7'] 
        }
      }
    ]
  ],
}
```

#### 参考文档

- [Babel 配置用法解析 - 渴望成为大牛的男人 - 博客园](https://www.cnblogs.com/bai1218/p/12392180.html)
- [使用指南 · Babel 中文网](https://www.babeljs.cn/docs/usage)
