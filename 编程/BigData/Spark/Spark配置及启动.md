### 安装
下载对应版本的 spark 文件，解压即可完成安装

#### 安装 pyspark
##### 方法1：使用 pip 或者从pipy中下载对应版本的 pyspark 安装
使用该方法，可以不需要另外下载 spark 。spark所需的java文件会包含在 python site-packages 下 pyspark 的目录内
##### 方法2：拷贝 spark 解压目录中的 python/pyspark 文件夹到python 的 site-packages 下
如果在 pycharm中使用 pyspark ，需要配置SPARK_HOME 环境变量。

### 启动

#### linux
```bash
# cd 到 Spark 的安装目录下的 sbin 中
./start-master.sh # 启动 spark master
./start-slaves.sh # 在 slave 节点上启动 spark 进程
```

#### windows
```batch
:: cd 到 spark 安装目录下的 bin
:: 启动 master
spark-class.cmd org.apache.spark.deploy.master.Master -i localhost
:: 其中 -i 表示master所在的ip地址。默认采用本机ip地址作为master地址。
:: 启动worker
spark-class.cmd org.apache.spark.deploy.worker.Worker spark://localhost:7077 -i localhost
:: 其中 -i 表示worker所在的ip地址。默认采用本机ip地址作为worker地址。
```
