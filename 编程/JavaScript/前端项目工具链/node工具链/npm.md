### npm

[TOC]

#### 安装配置

##### npm目录结构

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

##### 配置

###### 配置文件

电脑中有多个 .npmrc 文件，在我们安装包的时候，npm按照如下顺序读取这些配置文件

- 项目配置文件: /project/.npmrc，**通常是`package.json`所在目录**
- 用户配置文件：~/.npmrc
- 全局配置文件：$prefix/etc/npmrc
- npm 内置配置文件 /path/to/npm/npmrc

其中`$prefix`是指项目或者用户配置文件中设置的prefix变量

###### 配置命令

```bash
npm config get [-g] <key>
npm config set [-g] <key> <value> 
npm config delete [-g] <key>
```

##### 常用配置项

###### npm 包安装路径

npm 中 `-g` 选项是全局安装，没有 `-g` 选项默认安装在当前目录的 node_modules 下。<br>

全局安装路径相关命令: 其中 prefix 的默认值通常是 `/usr/local/` 在windows上是`%AppData%/npm`

```bash
# 获取 npm 的全局安装路径
npm config get prefix
# 配置 npm 全局安装路径
npm config set prefix "<path to place>"
# 安装时候的缓存路径。
npm config set cache "<path to cache>"
# 临时配置全局包路径
NODE_PATH = "<global path of the modules>"
```

包搜索路径的优先级：

- 本地的node_modules
- `$prefix/node_modules`

#### package文件

`package.json` 文件是npm描述项目各个选项文件。主要包含以下内容：

- 作为一个描述文件，描述了你的项目依赖那些包
- 描述项目其他相关的配置项，如常用的启动脚本等。

##### 文件创建

使用`npm init`命令可以将当前目录初始化成满足npm要求的工程目录结构

##### 文件内容

必须提供的内容：

- name：项目名称。全部小写，没有空格，可以使用下划线或者横线

- version：x.x.x的格式，符合语义化规则

可选内容：

- description：描述信息，有助于搜索
- main：入口文件，一般都是index.js
- scripts：支持的脚本，默认是一个空的test。配置的script可以通过 `npm run <script key>` 运行。
- author：作者信息
- license：默认是MIT
- keywords：关键字，有助于人们使用npm search搜索时候发现你的项目
- dependencies：管理在生产环境中需要用到的依赖
- devDependencies：在开发、测试环境中用到的依赖

实例文件：

```json
{
  "name": "project_x",
  "version": "1.0.0",
  "main": "index.js",
  "scripts": {
    "test": "echo \"Error: no test specified\" && exit 1"
  },
  "author": "",
  "license": "ISC",
  "keywords": [],
  "description": "",
  "dependencies": {},
  "devDependencies": {}
}
```

###### scripts 相关配置

配置要点：

- **运行scripts对应的命令时，会自动将project.json文件所在目录的 `node_modules/.bin`子目录加入PATH变量**

- 传参：通过npm运行命令时，可以使用`--`然后输入传入的参数如`npm run lint -- --reporter checkstyle`

- 脚本钩子：
  
  - npm 默认提供下面这些钩子。
    
    - prepublish，postpublish
    - preinstall，postinstall
    - preuninstall，postuninstall
    - preversion，postversion
    - pretest，posttest
    - prestop，poststop
    - prestart，poststart
    - prerestart，postrestart

##### 包依赖管理

- **通过 `npn install` 可以直接安装package中描述的所有依赖**<br>

- 需要在PATH中添加路径`.\node_modules\bin`，因为当前项目的可执行文件会被安装在此目录

项目安装依赖包相关命令：

```bash
# 安装dependencies和devDependencies中的依赖
npm install
npm install --production # 只按照dependencies的依赖

# 本地安装，但是不修改 package 文件。相当于临时为项目安装依赖。
npm install <pageage_name> # 安装指定的包。
npm install <pageage_name@version> # 安装指定的版本。

# 本地安装并添加到package 文件中
npm install <pageage_name> --save # 安装指定的包，并添加到dependencies 
npm install <pageage_name> --save-dev # 安装指定的包，并添加到devDependencies 
```

更新项目依赖相关命令：

```bash
npm outdataed # 查看，是否有新版本
npm updata <package_name> # 更新指定依赖的版本
npm updata # 不指定包名会，更新指定所有依赖
```

#### npm常用命令

##### config相关命令

```bash
#查看npm的配置
npm config list- l
npm config get <config key> # 获取配置
npm config set <config key> <config value> # 配置config
```

##### init 相关配置。

init 命令用于通过模板创建package 文件。

```bash
#初始化生成package.json文件,可以自定义设置，
#也可以使用默认值安装,-ye后缀直接跳过提问环节，默认安装
npm init
npm init -y


#设置环境变量，为npm init 设置默认值
npm set init-author-name 'you name'
npm set init-author-email 'your email'
npm set init-author-url 'your url'
npm set init-license 'MIT'
```
