#### npm install

npm install 会默认把依赖的包安装到当前目录的 node_modules 下。

如果需要设置全局的安装默认路径可以通过如下代码：

```batch
npm config set prefix "<path to place>"

:: 安装时候的缓存路径。
npm config set cache "<path to cache>"

:: 配置全局包路径
NODE_PATH = "<global path of the modules>"
```


