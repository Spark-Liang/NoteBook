[TOC]

## 使用场景

通常用于使用profile和变量等机制管理不同环境构建信息的项目。由于profile参数只有在相同的parent工程情况下才能进行传递，所以其他工程依赖具体的叶子项目时会出现依赖解析不正确的问题。

## 配置示例

### 基本用法

```xml
<build>
    <plugins>
        <plugin>
            <groupId>org.codehaus.mojo</groupId>
            <artifactId>flatten-maven-plugin</artifactId>
            <version>1.2.7</version>
            <configuration>
                <updatePomFile>true</updatePomFile>
                <flattenMode>resolveCiFriendliesOnly</flattenMode>
            </configuration>
            <executions>
                <execution>
                    <id>flatten</id>
                    <phase>process-resources</phase>
                    <goals>
                        <goal>flatten</goal>
                    </goals>
                </execution>
                <execution>
                    <id>flatten-clean</id>
                    <phase>clean</phase>
                    <goals>
                        <goal>clean</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

- updatePomFile：是否更新 package、install、deploy阶段使用的pom文件
- flattenMode：依赖展开模式
  - bom：会将项目所有的继承信息解析成实际的值。包括 properties、dependencies等配置
  - resolveCiFriendliesOnly：仅解析变量内容

### 项目实际用法

parent工程：<br>

parent工程配置 flatten-maven-plugin 的基本配置，但是不使用该插件，因为parent工程需要给其他工程提供profile信息。

```xml
<build>
  <pluginManagement>
    <!-- 发布时将pom文件中的继承或者使用参数的依赖解析为实际的值，避免使用profile进行控制的参数不能正常生效 -->
    <plugin>
        <groupId>org.codehaus.mojo</groupId>
        <artifactId>flatten-maven-plugin</artifactId>
        <version>1.2.7</version>
        <configuration>
            <updatePomFile>true</updatePomFile>
            <flattenMode>bom</flattenMode>
        </configuration>
        <executions>
            <execution>
                <id>flatten</id>
                <phase>process-resources</phase>
                <goals>
                    <goal>flatten</goal>
                </goals>
            </execution>
            <execution>
                <id>flatten-clean</id>
                <phase>clean</phase>
                <goals>
                    <goal>clean</goal>
                </goals>
            </execution>
        </executions>
    </plugin>
  </pluginManagement>
</build>
```

其他叶子工程

```xml
<build>
    <plugins>
        <!-- 发布时将pom文件中的继承或者使用参数的依赖解析为实际的值，避免使用profile进行控制的参数不能正常生效 -->
        <plugin>
            <groupId>org.codehaus.mojo</groupId>
            <artifactId>flatten-maven-plugin</artifactId>
        </plugin>
    </plugins>
</build>
```

