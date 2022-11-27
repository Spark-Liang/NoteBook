### maven-antrun-plugin

- 使用配置

#### 使用配置

##### 参考文档

- [Apache Maven AntRun Plugin 官方文档](https://maven.apache.org/plugins/maven-antrun-plugin/index.html)

- [Ant task配置](https://ant.apache.org/manual/index.html)



#### 配置实例

```xml
<plugin>
    <artifactId>maven-antrun-plugin</artifactId>
    <version>3.0.0</version>
    <executions>
        <execution>
            <id>ant-execute</id>
            <phase>clean</phase>
            <configuration>
                <target>
                    <echo message="abc"/>
                </target>
            </configuration>
            <goals>
                <goal>run</goal>
            </goals>
        </execution>
    </executions>
</plugin>
```


