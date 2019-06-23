### numpy.array

在numpy中array相对于python中的list 和 array 有以下的优点：

- 运行效率更高

- 相对于 list，是类型限定的

#### numpy.array中的类型限定

```python
import numpy as np
nparr = np.array([1,2,3])
nparr.dtype # 在numpy.array中可以通过 .dtype 属性查看对应存放的数据类型
>>> dtype('int32') 
nparr[2] = 'abc' # numpy.array 是类型限定的
>>>---------------------------------------------------------------------------
ValueError                                Traceback (most recent call last)
<ipython-input-5-ebae5c21df86> in <module>
----> 1 nparr[2]='abc'

ValueError: invalid literal for int() with base 10: 'abc'
```

在 numpy.array中会存在类型截断的现象：

```python
nparr = np.array([1,2,3])
nparr[2] = 4.1
nparr
>>> array([1,2,4]) # numpy会自动把数据截断或者转换成 array对应的类型。
```

#### array的生成

array常用的生成方式主要用两种：

- 生成固定值：
  
  - np.zeros(shape, dtype=None, order='C')
  
  - np.ones(shape, dtype=None, order='C')
  
  - np.full(shape, fill_value, dtype=None, order='C')
  
  - arange([start,] stop[, step,], dtype=None)
    
    - 该方法的step可以是浮点数
  
  - np.linspace(start, stop,  num=50,  endpoint=True,  retstep=False, dtype=None, axis=0)
    
    - 该方法是生成在 start，stop 之间 num 个等差数值。需要注意的是 linspace 是包含 start 和 stop 在内的等差数列。

- 生成随机值：
  
  - np.random.randint(low, high=None, size=None, dtype='l')
  
  - np.random.random(size=None) # 返回 0-1之间的浮点数 array
  
  - np.random.normal(loc=0.0, scale=1.0, size=None)  #返回 均值为 loc 方差为 scale 的正态分布的随机数组。

#### array 的读写操作

numpy的array可以直接通过 [] 进行读写，当对应的array 存在多维时则直接输入多个index作为参数进行读写

```python
nparr[1,2] # 直接读取位置为（1，2）的元素
nparr[:1,:3] # 读取前两行前三列的子矩阵。
nparr[::-1,::-1] # 按行和列反向读取
```

需要注意的是读取出的子矩阵实际上是引用原矩阵，所以会存在以下问题：

```python
subNpArr = nparr[:1,:1]
subNpArr[1,1] = 1 # 该语句会同时修改原矩阵 nparr 中，位于(1,1) 中的值
subNpArr = nparr[:1,:1].copy() # 使用该方法可以创建新的矩阵
```

array 的索引操作也支持类似dataframe 的索引操作，这类操作被称为 fancy indexing：

```python
# 通过 list of index 提取数据
arr[[1,2,3]] # 提取 index 为1，2，3 的值成为一个数列
arr[np.array(4).reshape(2,-1)] # 接收一个二维矩阵，范围一个二维矩阵。包含array对应索引的值

arr = np.array(16).reshape(4,-1)
arr[[1,2,3],[4,5,6]] # 取 (1,4),(2,5),(3,6) 位置上的值成为一个一维向量
arr[((1,2),(3,4))] # 取 (1,2),(3,4) 位置上的值成为一个一维向量

# 通过 接收一个 list of bool 筛选符合条件的数据
# 需要注意的是，如果二维矩阵接收向量，则是对行进行少选
arr[arr > 2 | arr < 0] # 筛选小于0 或 大于2 的值
```

#### array 的矩阵操作

##### universal function

```python
# 数学运算
arr + 2 或者 2 + arr # 返回arr的每个元素和2相加的结果。
arr1 + arr2
# 使用该方式需要两个array在共有的维度的长度相同
# array 和 array 的算法如下：
for x in len(arr1): # 遍历第0维度
    arr1_dim0 = arr1[x]
    arr2_dim0 = arr2[x]
        for y in len(arr1_dim0) if is_array(arr1_dim0) else len(arr2_dim0):
            arr1_dim1 = arr1_dim1[y] if is_array(arr1_dim0) else arr1_dim0
            arr2_dim1 = arr1_dim1[y] if is_array(arr1_dim0) else arr1_dim0
            ...
                # 最高维度
                result[x,y,...] = opr(arr1_dim_n,arr2_dim_n)
```

##### 矩阵乘法

```python
A.dot(B) # 矩阵A X 矩阵B
```

#### array 的拼接和切分

numpy 拼接矩阵主要采用 concatenate方法

```python
# concatenate((a1, a2, ...), axis=0, out=None)
np.concatenate((A,B)) # 在行这个维度进行拼接
np.concatenate((A,B),axis=1) # 在列这个维度进行拼接
```

numpy切分矩阵主要采用 split方法

```python
# np.split(ary, indices_or_sections, axis=0)
up,down = np.split(A,[-1]) # 按照给定的切分点，按照行索引切分
left,right = np.split(A,[-1],axis=1) # 按照给定的切分点，按照列索引切分
```

#### array 的聚合运算

numpy 提供了 sum，max，min，mean，median,std, prod 等众多聚合函数

```python
np.sum(A) # 对所有元素进行求和
np.sum(A,axis=2) # 对 A 的第二个维度进行求和
#例 A 是一个三维矩阵
A=np.arange(60).reshape(3,4,5)
np.sum(A,axis=2)
>>> array([[ 10,  35,  60,  85],
       [110, 135, 160, 185],
       [210, 235, 260, 285]])
# 进行sum范围的是一个二维矩阵，shape和元三维矩阵的第一二维的子矩阵的shape相同
```

#### array排序

```python
np.sort(a, axis=-1, kind='quicksort', order=None)
np.sort(A) # 返回对所有维度排序之后的结果
A.sort() # A 自身按照所有维度进行排序
np.sort(A,axis=1) # 返回对第1个维度内的元素进行排序之后的结果
```

#### array 众多运算的 axis 理解

numpy函数中的axis代表的是对矩阵的第几个维度进行运算，即遍历其他维度的所有索引，在每一次遍历中，对axis代表的维度的所有元素进行运算。比如split 和 concatenate中的axis就代表，对第几个维度的索引进行切分或者拼接，比如聚合函数的axis就是代表对第n个维度的所有元素进行聚合
