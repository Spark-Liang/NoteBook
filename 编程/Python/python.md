### 安装

##### windows

在python 官网上下载相应的exe或者msi安装包直接安装运行

##### Linux

###### python依赖库

<style>
</style>

| 缺少库名称    | centos包名                       | alpine包名     |
| -------- | ------------------------------ | ------------ |
| _uuid    | libuuid-devel                  | libuuid      |
| readline | readline-devel                 | readline-dev |
| _tkinter | tk-devel                       | tk-dev       |
| _ffi     | libffi-devel                   | libffi-dev   |
| _curses  | ncurses-libs                   | ncurses-libs |
| _sqlite  | sqlite-devel                   | sqlite-dev   |
| _bz2     | bzip2-devel                    | bzip2-dev    |
| _ssl     | openssl-devel                  | openssl-dev  |
| _gdbm    | gdbm-devel                     | gdbm-dev     |
| _dbi     | libdbi-devel                   | libdbi-dev   |
| _zlib    | zlib-devel                     | zlib-dev     |
| _lzma    | xz-devel python-backports-lzma | xz-dev       |

1. 

2. 在官网上下载对应版本的源码包，并解压。[源码包网址](https://www.python.org/ftp/)

3. 安装对应的依赖包 ：zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel

4. 使用 configure 配置，并使用 make 和make install 安装

5. 建立软连接，使得可以使用 “python3" 命令调用 python3.

```bash
ln -s $PYTHON3_HOME/bin/python3.7 /usr/bin/python3 
ln -s $PYTHON3_HOME/bin/pip3.7 /usr/bin/pip3   
```

### os 模块

python中主要是通过 os 模块来实现常用的系统交互功能。

os 模块中获取系统参数的变量有：

```python

```

#### 时间日期处理

##### 时间日期格式化

| 格式化符号 | 含义                                                                                           |
|:-----:|:-------------------------------------------------------------------------------------------- |
| %y    | 两位数的年份表示（00-99）                                                                              |
| %Y    | 四位数的年份表示（000-9999）                                                                           |
| %m    | 月份（01-12）                                                                                    |
| %d    | 月内中的一天（0-31）                                                                                 |
| %H    | 24小时制小时数（0-23）                                                                               |
| %I    | 12小时制小时数（01-12）                                                                              |
| %M    | 分钟数（00=59）                                                                                   |
| %S    | 秒（00-59）                                                                                     |
| %a    | 本地简化星期名称                                                                                     |
| %A    | 本地完整星期名称                                                                                     |
| %b    | 本地简化的月份名称。<br>Jan, Feb, …, Dec (en_US);<br>  Jan, Feb, …, Dez (de_DE)                        |
| %B    | 本地完整的月份名称<br>January, February, …, December (en_US);<br>Januar, Februar, …, Dezember (de_DE) |
| %c    | 本地相应的日期表示和时间表示                                                                               |
| %j    | 年内的一天（001-366）                                                                               |
| %p    | 本地A.M.或P.M.的等价符                                                                              |
| %U    | 一年中的星期数（00-53）星期天为星期的开始                                                                      |
| %w    | 星期（0-6），星期天为星期的开始                                                                            |
| %W    | 一年中的星期数（00-53）星期一为星期的开始                                                                      |
| %x    | 本地相应的日期表示                                                                                    |
| %X    | 本地相应的时间表示                                                                                    |
| %Z    | 当前时区的名称                                                                                      |
| %%    | %号本身                                                                                         |

[完整的表格请看此链接](https://docs.python.org/3/library/datetime.html#strftime-and-strptime-behavior)

##### 日期计算

日期加减：

```python
from datetime import datetime,timedelta
dt # type: datetime
# dt 加上时间差
dt + timedelta(days=1)
```

### 日志

```python
# 在各个模块中获取logger
import logging
logger = logging.getLogger(__name__)

# 在入口模块中制定日志的级别以及日志的格式
import logging
logging.basicConfig(level=logging.DEBUG, format='%(asctime)s - %(name)s - %(levelname)s - %(message)s')
```

#### 日志格式配置

| Attribute name | Format         | Description                                                                                                                                                                     |
| -------------- | -------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| asctime        | %(asctime)s    | Human-readable time when the LogRecord was created. By default this is of the form ‘2003-07-08 16:49:45,896’ (the numbers after the comma are millisecond portion of the time). |
| levelname      | %(levelname)s  | Text logging level for the message ('DEBUG', 'INFO', 'WARNING', 'ERROR', 'CRITICAL').                                                                                           |
| name           | %(name)s       | Name of the logger used to log the call.                                                                                                                                        |
| message        | %(message)s    | The logged message, computed as msg % args. This is set when Formatter.format() is invoked.                                                                                     |
| thread         | %(thread)d     | Thread ID (if available).                                                                                                                                                       |
| threadName     | %(threadName)s | Thread name (if available).                                                                                                                                                     |

[日志格式配置详细表格](https://docs.python.org/3/library/logging.html?highlight=logging#logrecord-attributes)

#### 日志handler

##### FileHandler

用于把日志写入到文件中。

例子：

```python
handler = logging.FileHandler("log.txt")
handler.setLevel(logging.INFO)
formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
handler.setFormatter(formatter)
logger.addHandler(handler
```

### 异常处理

#### 打印栈信息

```python
try:
    1 / 0 # 触发异常
except BaseException as e:
    msg = traceback.format_exc() # 方式1
    print (msg)
    logging.exception(e) # 方式2
finally:
    pass
```

#### 官方文档链接

- [python3](https://docs.python.org/3.7/)
