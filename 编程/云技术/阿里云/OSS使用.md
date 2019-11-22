###### 使用 ossfs 挂载OSS到本地磁盘

**安装**

ossfs的安装比较简单，可以直接按照[官方教程](https://help.aliyun.com/document_detail/32196.html?spm=a2c4g.11186623.6.746.18fb3090D6hash)完成。

在安装的过程中有几处需要注意的地方：

- 如果需要其他人能够这个挂载的目录，需要添加 “-o allow\_other” 参数。
