###### 使用 ossfs 挂载OSS到本地磁盘

**安装**

ossfs的安装比较简单，可以直接按照[官方教程](https://help.aliyun.com/document_detail/32196.html?spm=a2c4g.11186623.6.746.18fb3090D6hash)完成。

在安装的过程中有几处需要注意的地方：

- 如果需要其他人能够这个挂载的目录，需要添加 “-o allow_other” 参数。

###### 配置hadoop 使用 oss

1. 下载支持包。http://gosspublic.alicdn.com/hadoop-spark/hadoop-oss-2.7.2.tar.gz

2. 解压并复制 hadoop-aliyun-2.7.2.jar复制到$HADOOP_HOME/share/hadoop/tools/lib/目录下；

3. 修改​​$HADOOP_HOME/libexec/hadoop-config.sh文件，在文件的327行加下代码：
   
   ```
   CLASSPATH=$CLASSPATH:$TOOL_PATH
   ```
   
   注意备份原文件

4. 在core-site.xml中添加OSS 相关配置
   
   | 配置项                              | 值                                                   | 说明                                        |
   | -------------------------------- | --------------------------------------------------- | ----------------------------------------- |
   | fs.oss.endpoint                  | 如 oss-cn-zhangjiakou-internal.aliyuncs.com          | 要连接的endpoint                              |
   | fs.oss.accessKeyId               |                                                     | access key id                             |
   | fs.oss.accessKeySecret           |                                                     | access key secret                         |
   | fs.oss.impl                      | org.apache.hadoop.fs.aliyun.oss.AliyunOSSFileSystem | hadoop oss文件系统实现类，目前固定为这个                 |
   | fs.oss.buffer.dir                | /tmp/oss                                            | 临时文件目录                                    |
   | fs.oss.connection.secure.enabled | false                                               | 是否enable https, 根据需要来设置，enable https会影响性能 |
   | fs.oss.connection.maximum        | 2048                                                | 与oss的连接数，根据需要设置                           |

5. 重启hadoop 集群
