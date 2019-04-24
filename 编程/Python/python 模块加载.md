python中的模块搜索范围是 sys.path 中的所有路径。影响 sys.path 的有两个因素，一个是本身 python 安装时所包含的包路径，这个在运行时会默认添加到 sys.path 中。另一个是配置 PYTHONPATH 变量。在 windows中通过 set PYTHONPATH 进行配置，在 Linux 中通过 export PYTHONPATH 进行配置。另外需要注意的是，windows 中不能用双引号把多个路径包含起来，这样会使得多个路径被当做一个导入到 sys.path 中。<br>
python 模块的搜索顺序是按照 sys.path 中的顺序进行搜索。

##### \_\_init\_\_.py对 python 模块搜索的影响：
只有存在 \_\_init\_\_.py 的目录才会被 python 当做一个 package 来导入。但是在python 3.4 之后不需要 \_\_init\_\_.py 也能把目录中的 python 当做模块导入。但是，与存在 \_\_init\_\_.py 的目录不同的是。当 python 把某个目录当做 package 进行导入之后， 所有以该目录为前缀的模块都会从这个目录下进行导入，如果不存在就直接报错。而目录不存在 \_\_init\_\_.py 的时候，python 只会当该目录作为搜寻模块的路径，当该目录不含只能模块时，python 继续从 sys.path 中的下一个目录进行查找。
