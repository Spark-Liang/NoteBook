sql server 中sql_variant 有一下使用规则

1. 其他普通类型可以隐式转换成 sql_variant 进行比较。但是与 sql_variant 进行比较时，由于是隐式转换成 sql_variant，所以除了检查值之外还会检查数据类型。但是对于varchar，char，nvarchar,nchar 这4个类型主要字符串内容相同，就会判断成想等。

2. 
