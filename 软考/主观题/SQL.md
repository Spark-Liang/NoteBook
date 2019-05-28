### 易错点：

#### create table 语句中易错点：

- 字段的约束：
  
  - 参照性约束：该约束常出现于为维持多对多关系的关系表中。
  
  - 用户自定义约束：

例子：

员工表: EMP(<u>Eno</u>,Ename,Age,Sex,Title)，其中性别取值“男”，“女”

公司表：COMPANY(<u>Cno</u>,Cname,City)

工作表: WORKS(<u>Eno,Cno</u>,Salary),工资不低于1500

```sql
CREATE TABLE WORKS(
    Eno CHAR(10) references EMP(Eno),
    Cno CHAR(6) references COMPANY(Cno),
    Salary int check(Salary >= 1500),
    primary key (Eno,Cno)
)
```

#### 函数调用注意点

注意函数的输入参数，输出参数类型。类型不符合需要进行类型转换 convert(<type>, <expression>)

#### 触发器注意点

是否需要只针对某个字段进行触发。如果需要则需要添加 for <字段名>

例：员工的工资由职称级别(Title)的修改自动调整，需要用触发器来实现员工工资的自动维护，函数float Salary_value(char(10) Eno)依据员工号计算员工新的工资。请将下面SQL语句的空缺部分补充完整。

```sql
CREATE TRIGGER Salary_TRG AFTER UPDATE FOR Title on EMP
REFERENCING new row as nrow
FOR EACH ROW
BEGIN
    UPDATE WORKS
    SET Salary = CONVERT(int,Salary_Value(Eno))
    where Eno = nrow.Eno
END
```

### 错题收集

1. 

2. 
