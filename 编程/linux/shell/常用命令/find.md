#### find

find 命令的语法大致如下:

```bash
find   path   -option   [   -print ]   [ -exec   -ok   command ]   {} \;
```

find 根据下列规则判断 path 和 expression，在命令列上第一个 - ( ) , ! 之前的部份为 path，之后的是 expression。所以上面的命令中，所有的option都应该写到第一个 -() 内。<br>

其中 path 表示需要搜索文件的路径，当没有提供path 时，默认从当前目录下进行搜索。而expression表示设置搜索过程的一些行为。<br>

常用的 expression 的选项：

- -name name, -iname name : 文件名称符合 name 的文件。iname 会忽略大小写
  
  - name 或者 iname 还支持通配符查询，比如 -name "\*.c" 或者 -name "\*[0-9].c"

- -type : 表示限定查询到的文件的类型
  
  - d:目录
  
  - c: 字型装置文件
  
  - b: 区块装置文件
  
  - p: 具名贮列
  
  - f: 一般文件
  
  - l: 符号连结
  
  - s: socket

- -perm:  限定查询到的文件对象的权限标识符

- -size: 限定查询到的文件长度
  
  - 格式时 -size n\<单位\> ,其中 \<单位\> 可以是 b代表区块，c代表字符，k代表KB
