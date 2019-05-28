**需要注意的是：当 column 名包含“%”会造成dataframe 操作失效。**

#### sql like 操作

##### select

```python
column_to_select = ['col1','col2'...]
df[column_to_select]
# 需要注意的是：这里只能采用字符串，而不能采用索引
```

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
