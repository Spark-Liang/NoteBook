#### 字符串区别

python2 中 str 是 ascii编码。unicode 是另外一个单独的类型

而在python3 中 str 是 unicode 编码。具有特定编码内容的是 byte

python2 代码中指出中文通过在代码开头添加

```python
# -*- coding : utf-8 -*-

# 当添加了上述注释之后在处理中文出现如下错误时：
UnicodeDecodeError: 'ascii' codec can't decode byte 0x?? in position 1: ordinal not in range(128)
# 需要添加如下代码：
import sys
reload(sys)
sys.setdefaultencoding('utf8')
```

#### 除法运算

python2 的除法运算类似 c语言 和 java。整数相除只保留整数，并且舍去小数部分。

python3 的除法运算当结果是小数时返回浮点型。
