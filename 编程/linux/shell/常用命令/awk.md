### awk

#### awk中的脚本

```bash
awk '<script>' <file path>
# 其中<script>的格式为 BEGIN{<commands before main script>} /<regex pattern>/ {main script} END{<commands after main script>}

# 在awk 中，常用的命令有 print,printf,system()
```

#### awk script 中的流程控制

##### IF-ELSE

```bash
awk 'BEGIN {
a=30;
if (a==10)
  print "a = 10";
else if (a == 20)
  print "a = 20";
else if (a == 30)
  print "a = 30";
else
  print "error"

}'

# 单行 awk 命令
awk '{if(NR > 1) print $1,$2; else print 'header';}'
```

[AWK 条件语句与循环](http://www.runoob.com/w3cnote/awk-if-loop.html)

#### awk 中使用外部变量

格式

```bash
awk -v "<var name>=<var value>" '<script>'
# 需要注意的是 awk 的选项参数需要放在 script 之前
```

#### 内建变量

| 变量          | 描述                              |
| ----------- | ------------------------------- |
| $n          | 当前记录的第n个字段，字段间由FS分隔             |
| $0          | 完整的输入记录                         |
| ARGC        | 命令行参数的数目                        |
| ARGIND      | 命令行中当前文件的位置(从0开始算)              |
| ARGV        | 包含命令行参数的数组                      |
| CONVFMT     | 数字转换格式(默认值为%.6g)ENVIRON环境变量关联数组 |
| ERRNO       | 最后一个系统错误的描述                     |
| FIELDWIDTHS | 字段宽度列表(用空格键分隔)                  |
| FILENAME    | 当前文件名                           |
| FNR         | 各文件分别计数的行号                      |
| FS          | 字段分隔符(默认是任何空格)                  |
| IGNORECASE  | 如果为真，则进行忽略大小写的匹配                |
| NF          | 一条记录的字段的数目                      |
| NR          | 已经读出的记录数，就是行号，从1开始              |
| OFMT        | 数字的输出格式(默认值是%.6g)               |
| OFS         | 输出记录分隔符（输出换行符），输出时用指定的符号代替换行符   |
| ORS         | 输出记录分隔符(默认值是一个换行符)              |
| RLENGTH     | 由match函数所匹配的字符串的长度              |
| RS          | 记录分隔符(默认是一个换行符)                 |
| RSTART      | 由match函数所匹配的字符串的第一个位置           |
| SUBSEP      | 数组下标分隔符(默认值是/034)               |
