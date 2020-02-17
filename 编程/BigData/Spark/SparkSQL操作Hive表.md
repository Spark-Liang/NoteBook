##### SparkSQL操作Hive Table

- 基础配置

###### 基础配置

- 在对应的项目中添加 spark-hive 的依赖比如maven 的项目添加如下依赖
  
  ```<dependency>xml
  <dependency>
        <groupId>org.apache.spark</groupId>
  
        <artifactId>spark-hive_2.11</artifactId>
  
        <version>${spark.version}</version>
  
  </dependency>
  ```

- 在对应的代码中，保证获得的
