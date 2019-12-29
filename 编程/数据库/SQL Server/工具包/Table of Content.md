##### 目录

1. functions:
   
   1. GET_PARTITION_FUNCTION_NAME: 使用递归查询实现生成不冲突的partition function 名称。
   
   2. GET_WRAP_NAME：用于把字符串包围成 sql server 中合法的名称。主要是用于保证包含任何字符的名字都能被sql server 识别
   
   3. IS_TABLE_STRUCTURE_EQUALS：用于判断表结构是否相同。该函数可以通过 CONTROL_STR 控制跳过指定的某些表结构检查项，如果分区，表约束等。

2. store procedures:
   
   1. COPY_TABLE_STRUCTURE: 用于复制表结构。可以通过 COPY_WITH_INDEX 控制是否复制索引。通过ADDITIONAL_CONTROL_STR控制更多的选项，如是否复制约束，是否复制分区等。
   
   2. PRINT_ERROR_MSG：用于打印错误信息。

3. views:
   
   1. TABLE_PARTITION_INFO 和 TABLE_PARTITION_INFO_SIMPLE：主要用于查看分区信息。


