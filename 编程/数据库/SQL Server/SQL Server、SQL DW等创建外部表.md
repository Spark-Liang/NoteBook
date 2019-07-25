外部表是SQL server全家桶与外部数据进行交互的方式。使用外部表需要PolyBase 提供支持，所以SQL Server需要在2016版本之后才能支持外部表的特性。<br>

## 外部表的创建

外部表的简历需要进行如下的步骤：

1. 定义外部表首先要定义外部数据源。
   1. 创建能够访问外部数据源的认证记录。
   2. 根据不同类型的外部数据源使用 create external source 语句进行创建。
2. 定义外部表结构，并且根据数据源进行额外的一些定义。比如说使用外部文件作为源就需要定义文件路径和分隔符等等，使用外部数据表则需要定义使用的表。
   1. 根据数据源的类型创建相应的文件格式。
   2. 通过 create external table 语句定义外部表的字段，定义使用的文件格式以及定义数据行读取失败时的行为。

### 1. 外部数据源定义

外部数据源支持下面几种类型：

1. Hadoop 的 HDFS
2. Azure SQL 数据库的弹性数据库
3. SQL Server数据源
4. Azure 的 Blob存储系统

创建外部数据源的基本语法是：

```SQL
create external data source [数据源名称]
with(<数据源定义>)
```

下面主要介绍创建从 ADLS 到 SQL DW 的外部数据源，<a href='https://docs.microsoft.com/zh-cn/sql/t-sql/statements/create-external-data-source-transact-sql?view=sql-server-2017#syntax'>其余的数据源参考此链接</a>。

从 ADLS 到 SQL DW 数据源的创建语句例子如下：

```SQL
-- ADSL GEN2 的例子
CREATE EXTERNAL DATA SOURCE ABFS 
WITH
(
    TYPE=HADOOP,
    LOCATION='abfs://<container>@<AzureDataLake account_name>.dfs.core.windows.net',
    CREDENTIAL=ABFS_Credemt
);

-- ADSL GEN1 的例子
CREATE EXTERNAL DATA SOURCE AzureDataLakeStore
WITH (
    TYPE = HADOOP,
    LOCATION = 'adl://<AzureDataLake account_name>.azuredatalake.net',
    CREDENTIAL = AzureStorageCredential
);
```

在数据源的定义当中有部分是涉及到需要进行身份验证的，即选项中的 credential 选项。SQL DW 中的 credential 可用通过 create credential 语句进行创建。

#### 定义数据源的 credential

在 SQL DW 中，主要是通过 create credential 语句创建认证记录。不同数据源有不同的认证方式，下面列举几种主要的数据源的认证方式。

##### ADLS 数据源的认证方式

```SQL
CREATE DATABASE SCOPED CREDENTIAL <credential_name>    
WITH IDENTITY = '<client_id>@<OAuth_2.0_Token_EndPoint>',
SECRET = '<key>';
```

上面的代码中的 &lt;client_id&gt; 和 &lt;key&gt; 可以在 AAD 中获取到，<a href='https://docs.microsoft.com/zh-cn/azure/active-directory/develop/howto-create-service-principal-portal#get-values-for-signing-in'>详细的步骤请看此链接，其中 "client_id" 对应 AAD 中的 "Application ID"</a>。<a href='https://docs.microsoft.com/zh-cn/azure/data-lake-store/data-lake-store-service-to-service-authenticate-using-active-directory#step-4-get-the-oauth-20-token-endpoint-only-for-java-based-applications'>&lt;OAuth_2.0_Token_EndPoint&gt;可以按照此链接来获取</a>。

##### 数据库数据源的认证方式

```SQL
CREATE DATABASE SCOPED CREDENTIAL <credential_name>    
WITH IDENTITY = '<username>', SECRET = '<password>'; 
```

### 2. 定义外部表结构

定义外部表的语法如下所示：

```SQL
CREATE EXTERNAL TABLE [ database_name ].[ schema_name ].[ table_name ]
    ( <column_definition> [ ,...n ] )  
    WITH (<表数据来源定义>) 
```

在定义外部表中根据来源不同主要分成两种，一种是直接从文件中得到表数据，另一种是从外部数据库表中得到数据。

#### 在 SQL DW 中创建来源于文件的外部表

```SQL
--从文件读取数据的语句模板如下
CREATE EXTERNAL TABLE [ database_name ].[ schema_name ].[ table_name ]   
( <column_definition> [ ,...n ] )  
WITH
(   
    LOCATION = '<folder_or_filepath>',  
    DATA_SOURCE = <external_data_source_name>,  
    FILE_FORMAT = <external_file_format_name  >
    [ , <reject_options> [ ,...n ] ]  
)  
<reject_options> ::=  
{  
    | REJECT_TYPE = [value | percentage]
    | REJECT_VALUE = reject_value  
    | REJECT_SAMPLE_VALUE = reject_sample_value
    | REJECTED_ROW_LOCATION = '\REJECT_Directory'
}
```

<a href='https://docs.microsoft.com/zh-cn/sql/t-sql/statements/create-external-table-transact-sql?view=sql-server-2017#examples-includesssdwfullincludessssdwfull-mdmd-and-includesspdwincludessspdw-mdmd'>详细的在 SQL DW 中创建外部表的例子查看此链接。</a>

External table 选项的介绍：

- &lt;column_definition&gt; <font color='red'>中需要注意的是不能设置 default 约束。 </font>
- Location : 该选项需要填写文件所在的路径或者文件名。 Data_Source 中的路径。<font color='red'>当填写的是文件夹时，会读取该文件夹下所有的“可见”文件。“可见”是指非隐藏文件或者非隐藏目录下的文件。</font>
- DATA_SOURCE ：该项填写的是文件的来源。
- FILE\_FORMAT : FILE\_FORMAT 对应的 &lt;external\_file\_format\_name&gt; 需要另外使用 create file format 语句进行定义。
- &lt;reject\_options&gt; : 这里重点介绍一下&lt;reject\_options&gt;。 &lt;reject\_options&gt; 是一些比较重要的选项，这些选项主要描述的是当从文件读取的数据不符合表结构定义或者文件格式定义时，需要采取的的措施。其中：
  - REJECT\_TYPE 是指有错误行的数量满足什么标准时，查询失败。该选项需要配合 REJECT\_VALUE 一同使用。该选项中 value 表示“以错误行数量”作为标准，precentage 表示“以错误行的百分比”作为标准。
  - REJECT\_VALUE 配合 REJECT\_TYPE 使用。<font color='red'>需要注意的是当使用 行数时，最大不能超过 int 的最大值。</font>
  - REJECT\_SAMPLE\_VALUE 每加载多少行检查一次导入失败的百分比。比如该选项的值为 1000 时，就是每导入1000 行记录计算失败的数量。<font color='red'>选择 REJECT\_TYPE 为 precentage 时必须要添加该选项。</font>
  - REJECT\_ROW\_LOCATION 该选项表示导入失败的数据行存储的路径。每个查询中导入失败的文件都会在该目录下创建一个。

##### 文件格式的创建

> PolyBase 支持以下文件格式：
> 
> - 带分隔符的文本
> - Hive RCFile
> - Hive ORC
> - Parquet

文件格式创建的语句如下：

```SQL
--基本的文件格式创建语法
create enternal file format [file_format_name]
with(<文件格式定义>)
```

> 比较常用的是带分隔符的文本文档

```SQL
-- 带分隔符的文本
(  
FORMAT_TYPE = DELIMITEDTEXT  
[ , FORMAT_OPTIONS ( <format_options> [ ,...n  ] ) ]  
[ , DATA_COMPRESSION = {  
       'org.apache.hadoop.io.compress.GzipCodec'  
     | 'org.apache.hadoop.io.compress.DefaultCodec'  
    }  
])
<format_options> ::=  
{  
    FIELD_TERMINATOR = '<field_terminator>
    | STRING_DELIMITER = '<string_delimiter>' 
    | First_Row = integer -- ONLY AVAILABLE SQL DW
    | DATE_FORMAT = '<datetime_format>'
    | USE_TYPE_DEFAULT = { TRUE | FALSE } 
    | Encoding = {'UTF8' | 'UTF16'} 
}  
```

其中 FIELD\_TERMINATOR 是指定列的分割符，缺省为'|'；STRING\_DELIMITER 表示字符串包围的符号,缺省为空字符串。DATE\_FORMAT 表示如果字段定义的是日期时间类的数据类型，则采用指定的格式进行解析，<a href='https://docs.microsoft.com/zh-cn/sql/t-sql/statements/create-external-file-format-transact-sql?view=sql-server-2017' >各种日期时间格式请看此链接内的‘示例日期格式’</a>。
USE\_TYPE\_DEFAULT 这个选项是指当字段为空时是按照数据类型的默认值来导入还是直接为null。<font color='red'>注意这里的默认值是数据类型的默认值而不是字段定义的默认值，外部表是不能定义默认值约束的</font>。

> 其他文件格式

```SQL
-- PARQUET格式的文件
(  
FORMAT_TYPE = PARQUET  
 [ , DATA_COMPRESSION = {  
    'org.apache.hadoop.io.compress.SnappyCodec'  
  | 'org.apache.hadoop.io.compress.GzipCodec'      }  
])

-- ORC格式
(  
FORMAT_TYPE = ORC  
 [ , DATA_COMPRESSION = {  
    'org.apache.hadoop.io.compress.SnappyCodec'  
  | 'org.apache.hadoop.io.compress.DefaultCodec'      }  
])

-- RCFILE 格式
(  
FORMAT_TYPE = RCFILE,  
SERDE_METHOD = {  -- 指定记录纵栏表文件格式 (RcFile)。 此选项需要指定 Hive 序列化程序和反序列化程序 (SerDe) 方法。
    'org.apache.hadoop.hive.serde2.columnar.LazyBinaryColumnarSerDe'  
  | 'org.apache.hadoop.hive.serde2.columnar.ColumnarSerDe'  
}  
[ , DATA_COMPRESSION = 'org.apache.hadoop.io.compress.DefaultCodec' ])
```

#### <a href=''>从外部数据库建立外部表请看此链接</a>
