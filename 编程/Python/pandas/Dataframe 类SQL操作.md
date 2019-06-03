**需要注意的是：当 column 名包含“%”会造成dataframe 操作失效。**

#### sql like 操作

##### select

```python
column_to_select = ['col1','col2'...]
df[column_to_select]
# 需要注意的是：这里只能采用字符串，而不能采用索引
```

在pandas中可以通过赋值的方法实现对列的添加或者修改

```python
df['col1'] = df['col1'] + 1
# 等价为如下SQL
# select col1 + 1 as col1 from df
df['col3'] = df['col1'] + df['col2']
# select col1 + col2 as col3 from df
```

实现该功能的原理是 pandas 重写了 dataframe 和 series 的算符重载方法和赋值方法，使得series 在调用 + 时右侧如果是单个对象就对所有值添加该对象，如果是series 就按照 series 顺序相加。

##### where

例子

```python
# SELECT *

# FROM tips

# WHERE time = 'Dinner'

# LIMIT 5;
tips[tips['time'] == 'Dinner'].head(5)

# 多条件
# SELECT *
# FROM tips
# WHERE time = 'Dinner' AND tip > 5.00;
 tips[(tips['time'] == 'Dinner') & (tips['tip'] > 5.00)]

# & 相当于 and，| 相当于 or
```

where 的实现原理是，pandas 重载了 == 操作符，tip['time'] 返回的是 series，pandas 重载了 == ，使得 series 调用 == 返回的是一个 series[bool] 的结果，接着 DataFrame 编写了 \__geitem__ 函数，当输入是 series 是返回的是 DataFrame。

另外在pandas 中还有一个where函数，该函数是接受筛选条件和<font color='red'>不</font>满足条件对应的结果组为输入参数，来得到替换之后的值。

where 函数的例子:

```python
# 默认不满足条件替换为 NaN
>>> s = pd.Series(range(5))
>>> s.where(s > 0)
0    NaN
1    1.0
2    2.0
3    3.0
4    4.0
# 与where 方法对应的mask 方法：
>>> s.mask(s > 0)
0    0.0
1    NaN
2    NaN
3    NaN
4    NaN

# where 的第二参数可以接受 Series 或者 DataFrame，表示对应的位置替换成各个指定的值。
>>> df = pd.DataFrame(np.arange(10).reshape(-1, 2), columns=['A', 'B'])
>>> m = df % 3 == 0
>>> df.where(m, -df)
   A  B
0  0 -1
1 -2  3
2 -4 -5
3  6 -7
4 -8  9
```

[where 方法官方文档](http://pandas.pydata.org/pandas-docs/stable/reference/api/pandas.DataFrame.where.html#pandas-dataframe-where)

##### Union

在pandas中union通过append来实现。

```python
df1.append(df2,sort=False) # 需要显式指定是否需要重新根据index来排序。
```
