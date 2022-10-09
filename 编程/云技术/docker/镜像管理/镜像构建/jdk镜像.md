#### jdk镜像

- 基础依赖

- Dockerfile

##### 基础依赖

jdk环境依赖：

- glibc：GNU Linux的c运行时库，下载地址是[glibc-2.29-rc0.apk](https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.29-r0/glibc-2.29-r0.apk)

##### Dockerfile

```dockerfile
FROM alpine:3.14
ARG JAVA_HOME=/opt/jdk
ENV CLASSPATH=./:$JAVA_HOME/lib:$JAVA_HOME/jre/lib PATH=$JAVA_HOME/bin:$PATH JAVA_HOME=/opt/jdk
COPY jdk-8u192-linux-x64.tar.gz glibc-2.29-r0.apk setup.sh /tmp/
RUN sh /tmp/setup.sh
```

其中setup.sh的内容是：

```bash

```
