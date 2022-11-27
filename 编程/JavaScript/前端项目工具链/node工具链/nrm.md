### nrm

- 配置nrm

- 常用nrm命令

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

#### 常用nrm命令

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

# 选择仓库
nrm use 

# 添加
nrm add <registry name> <registry url>
# 例子：nrm add registry http://registry.npm.taobao.org/

# 删除
nrm del <registry name>
```
