# 常见mvn命令用法

[TOC]

## 下载jar包依赖

步骤：

1. 创建包含依赖的pom文件

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0" 
   	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
   	<modelVersion>4.0.0</modelVersion>
   	<groupId>utils</groupId>
   	<artifactId>dependencies-download</artifactId>
   	<version>1.0.0</version>
       
       <dependencies>
           <dependency>
               <groupId>junit</groupId>
               <artifactId>junit</artifactId>
               <version>4.12</version>
               <scope>test</scope>
           </dependency>
       </dependencies>
       
   </project>
   ```

   

2. 运行相关命令：

   ```bash
   # 注意：以下几个命令都可以使用，按需使用即可
   # 命令1：
   # 说明：默认会将jar包放在项目中的target下的dependency目录下面
   mvn dependency:copy-dependencies
    
   # 命令2：
   # 说明：-DoutputDirectory=后面可以设置jar包放置路径，比如按照上面的命令来说，jar包会放在C盘下面的test下面的lib目录中
   mvn dependency:copy-dependencies -DoutputDirectory=D:\ideaworkspace\linglong\linglong-qms\lib
   
   # 命令3：
   # 说明：-DincludeScope可以设置依赖级别
   mvn dependency:copy-dependencies -DoutputDirectory=D:\ideaworkspace\linglong\linglong-qms\lib -DincludeScope=compile
   
   ```

3. 