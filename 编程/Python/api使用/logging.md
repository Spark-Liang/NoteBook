#### logging

- 基础配置
  
  - 全局logging配置
  
  - 格式配置
  
  - Handler配置

- 日志打印





##### 基础配置

###### 全局logging配置

```python
# 在入口模块中制定日志的级别以及日志的格式
import logging
logging.basicConfig(
    level=logging.DEBUG # 默认级别
    # 设置日志输出格式
    , format='%(asctime)s - %(name)s - %(levelname)s - %(message)s' 
    ,datefmt='%m-%d %H:%M'
    ,filename='/temp/myapp.log'
    ,filemode='w'
)
```

其中`basicConfig`的可选参数如下

| 格式       | 描述                                                                                                                                                             |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| level    | 将根记录器级别设置为指定的级别。默认生成的 root logger 的 level 是 logging.WARNING，低于该级别的就不输出了。级别排序：CRITICAL > ERROR > WARNING > INFO > DEBUG。（如果需要显示所有级别的内容，可将 level=logging.NOTSET） |
| format   | 为处理程序使用指定的格式字符串。                                                                                                                                               |
| datefmt  | 使用 time.strftime() 所接受的指定日期/时间格式。                                                                                                                              |
| style    | 如果指定了格式，则对格式字符串使用此样式。’%’ 用于 printf 样式、’{’ 用于 str.format()、’$’ 用于 string。默认为“%”。                                                                                |
| filemode | 如果指定 filename，则以此模式打开文件(‘r’、‘w’、‘a’)。默认为“a”。                                                                                                                   |
| filename | 指定使用**指定的文件名**而不是 StreamHandler 创建 FileHandler。                                                                                                                |
| stream   | 使用指定的流初始化 StreamHandler。注意，此参数与 filename 不兼容——如果两者都存在，则会抛出 ValueError。                                                                                         |
| handlers | 如果指定，这应该是已经创建的处理程序的迭代，以便添加到根日志程序中。任何没有格式化程序集的处理程序都将被分配给在此函数中创建的默认格式化程序。**注意，此参数与 filename 或 stream 不兼容**——如果两者都存在，则会抛出 ValueError。                             |

###### 格式配置



##### 日志打印





##### 参考文档

- [python标准日志模块logging及日志系统设计 - bamb00 - 博客园](https://www.cnblogs.com/goodhacker/p/3355660.html)

- [logging模块的输出格式怎么自己添加参数？ - SegmentFault 思否](https://segmentfault.com/q/1010000017147583)

- [【Python基础】Python模块之Logging（四）——常用handlers的使用_AnddyWang-CSDN博客](https://blog.csdn.net/wangpengfei163/article/details/80423863)
