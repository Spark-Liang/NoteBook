#### Hadoop监控

- hadoop metrics



##### hadoop metrics

通过jmx的方式可以访问hadoop的统计信息。通过以下url可以访问所有的hadoop统计信息。

```bash
curl -i http://{namenode hostname}:{namenode http port}/jmx
```

也可通过`qry`参数查看指定某个领域的统计信息。

```bash
curl -i http://localhost:50070/jmx?qry=Hadoop:service=NameNode,name=NameNodeInfo
```

所有的统计信息可参考链接：[Apache Hadoop 2.7.7 metrics](https://hadoop.apache.org/docs/r2.7.7/hadoop-project-dist/hadoop-common/Metrics.html#FSNamesystem)


