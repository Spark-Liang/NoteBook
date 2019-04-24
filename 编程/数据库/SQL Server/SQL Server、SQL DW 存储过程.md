## 存储过程的创建
在SQL Server 和 SQL DW 中存储过程创建的语法如下
```SQL
create procedure <存储过程名称>
(
    <参数列表>
)
with <存储过程的选项> --逗号分隔,并且SQL DW 不支持设置存储过程选项
as
    <存储过程的语句>
```
### 参数列表设置
```SQL
--例
    @bookAuth varchar(20),--输入参数,无默认值
    @bookAuth varchar(20)='abc',--输入参数,有默认值
    @bookId int output,--输出参数
```
上面是定义存储过程参数的例子，其中有几点需要注意 
1. 参数名前需要有 '@' 作为前缀
2. 如果设置output时，在调用存储过程的时候需要在对应output 的参数标注上 'output' 才能够取得出返回值。
```SQL
exec <存储过程名> @abc output
```
在存储过程中添加 'output' 标签相当于 c++ 中的引用传递。只有把输出参数的引用传到存储过程里才能在执行完存储过程后获得返回值。

### 存储过程语句
存储过程语句主要分为一下几个部分：
1. 变量声明与赋值
2. 判断语句
3. 循环语句
4. 错误处理语句
5. 

#### 变量声明与赋值
变量声明：
```SQL
declare @<变量名> 
```
变量赋值
```SQL
--通过set语句赋值
set @<变量名> = <value>
--通过select赋值
select @<变量名> = <value>
```
#### 判断语句
```SQL
if <条件>
begin
    <sql语句>
end
else
begin
    <sql语句>
end
```

#### 循环语句
```SQL
while <条件> --条件为真执行
begin
    <sql语句>
end
```

## 存储过程调用