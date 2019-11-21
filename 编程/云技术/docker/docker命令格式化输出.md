#### docker 格式化输出

docker 命令可以用过 --format 对查询到的结果进行格式化，格式化采用的是 GO 的模板语言。

##### 变量的路径表达式

```bash
'{{.}}' # 遍历的当前对象
'{{/*  */}}' # 表示注释
```

##### range 命令遍历

```bash
'{{range <pipeline path>}}{{ <exp1> }}{{end}}'

'{{range <pipeline path>}}{{ <exp1> }}{{else}}{{ <exp1> }}{{end}}'
# example
# 查看容器网络下已挂载的所有容器名称，如果没有挂载任何容器，则输出 "With No Containers"
docker inspect --format '{{range .Containers}}{{.Name}}{{println}}{{else}}With No Containers{{end}}' bridge
brtest
peaceful_brown
test
```

**当 \<pipeline path\> 对应的长度为0，则直接执行 else 的内容，如果没有else 则不执行。**

##### index 命令取值

```bash
'{{index <pipeline path> <index num>}}' 
```

##### 参考文档

- [https://www.cnblogs.com/kevingrace/p/6424476.html](https://www.cnblogs.com/kevingrace/p/6424476.html)
