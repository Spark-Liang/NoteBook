### nodejs

- 简介

- 安装配置

- 内置模块

#### 简介

Node.js 是一个基于 Chrome JavaScript 运行时建立的一个平台，即将Chrome浏览器变成了一个JavaScript命令行工具，所以Chrome支持的JavaScript语法和api，nodejs都支持。

#### 安装配置

##### nodejs目录结构

- `node安装目录`：放置二进制文件和常用的命令文件如npm和npx

- `node安装目录/node_modules`：放置全局模块

##### 步骤

###### 安装包安装

1. 安装nodejs。从官网下载安装[Download | Node.js](https://nodejs.org/en/download/)。

2. 更新npm 到最新版本
   
   ```bash
   npm install npm@latest -g
   ```

3. 如果网络不好可以先安装 cnpm
   
   ```bash
   npm install -g cnpm --registry=https://registry.npm.taobao.org
   ```

###### 压缩包安装

当需要一台设备安装多个版本的nodejs最好采用压缩包安装，然后设置环境变量

##### 安装包下载

[Previous Releases | Node.js](https://nodejs.org/en/download/releases/)

##### 安装

#### 内置模块
