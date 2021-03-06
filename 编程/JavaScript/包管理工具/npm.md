### npm

- 安装配置
  
  - 步骤
  
  - 其他注意项
  
  - 配置registry
  
  - 配置 nrm

- package文件
  
  - 文件内容
  
  - 包依赖管理

- 其他常用命令

#### 安装配置

##### 步骤

1. 安装nodejs。从官网下载安装[Download | Node.js](https://nodejs.org/en/download/)。

2. 更新npm 到最新版本 
   
   ```bash
   npm install npm@latest -g
   ```

3. 如果网络不好可以先安装 cnpm
   
   ```bash
   npm install -g cnpm --registry=https://registry.npm.taobao.org
   ```

##### 其他注意项

###### npm 包安装路径

npm 中 `-g` 选项是全局安装，没有 `-g` 选项默认安装在当前目录的 node_modules 下。<br>

全局安装路径相关命令:

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

##### 配置 registry 和 nrm

```bash

```

##### 配置nrm

nrm是npm管理registry的工具

###### 安装命令

```shell
npm install -g nrm
```

**nrm报错处理**：

- `The "path" argument must be of type string. Received undefined`
  
  - 解决方案：
    
    - 修改 nrm 的 `cli.js`文件。
      
      将第17行
      
      ```typescript
      const NRMRC = path.join(process.env.HOME, '.nrmrc'); 
      ```
      
      修改成
      
      ```typescript
      const NRMRC = path.join(process.env[(process.platform == 'win32') ? 'USERPROFILE' : 'HOME'], '.nrmrc');
      ```

###### 常用nrm命令

```shell
# 查看已配置的可以仓库
nrm ls                                                                                                                                   
# 结果：
#   npm -------- https://registry.npmjs.org/
#  yarn ------- https://registry.yarnpkg.com/
#  cnpm ------- http://r.cnpmjs.org/
# *taobao ----- https://registry.npm.taobao.org/
#  nj --------- https://registry.nodejitsu.com/
# 
# 前面带* 代表默认使用该registry

# 添加
nrm add <registry name> <registry url>
# 例子：nrm add registry http://registry.npm.taobao.org/

# 删除
nrm del <registry name>
```

#### package文件

`package.json` 文件是npm描述项目各个选项文件。主要包含以下内容：

- 作为一个描述文件，描述了你的项目依赖那些包
- 描述项目其他相关的配置项，如常用的启动脚本等。

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

##### 包依赖管理

**通过 `npn install` 可以直接安装package中描述的所有依赖**<br>

项目安装依赖包相关命令：

```bash
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
