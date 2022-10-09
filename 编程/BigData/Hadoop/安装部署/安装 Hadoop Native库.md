### 安装Hadoop Native库

- 简介

- 源码编译

- 配置环境变量

#### 简介

#### 源码编译

##### 编译相关文件下载

- [hadoop源码包](https://archive.apache.org/dist/hadoop/common/hadoop-2.7.7/hadoop-2.7.7-src.tar.gz)

- [snappy-1.1.3源码包](https://github.com/google/snappy/archive/refs/tags/1.1.3.tar.gz)

- [cmake-3.23.1源码包](https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1.tar.gz)

- [googletest-1.5.0源码包](https://github.com/google/googletest/archive/refs/tags/release-1.5.0.tar.gz)

- [protobuf-2.5.0源码包](https://github.com/protocolbuffers/protobuf/archive/refs/tags/v2.5.0.tar.gz)

- [maven-3.5.4](https://archive.apache.org/dist/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz)

- [ant-1.9.16](https://dlcdn.apache.org//ant/binaries/apache-ant-1.9.16-bin.tar.gz)

- [findbugs-3.0.1](https://sourceforge.net/projects/findbugs/files/findbugs/3.0.1/findbugs-3.0.1.tar.gz/download)

##### centos docker环境

1. 启动构建hadoop镜像的docker容器，建议挂载本地的maven仓库以提高编译速度
   
   ```bash
   docker run -d --rm --name hadoop-builder \
   -v /usr/local/src/hadoop-builder:/mnt/hadoop-builder \
   -v /data/maven-repository/:/data1/maven-repository/ \
   -e JAVA_HOME=/opt/java            \
   -e MAVE_HOME=/opt/maven           \
   -e ANT_HOME=/opt/ant              \
   -e FINDBUGS_HOME=/opt/findbugs    \
   -e PROTOBUF_HOME=/opt/protobuf    \
   -e SNAPPY_HOME=/opt/snappy        \
   -e PATH="/opt/java/bin:/opt/maven/bin:/opt/ant/bin:/opt/findbugs/bin:/opt/protobuf/bin:/opt/snappy/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"        \
   centos:7 sleep infinity
   ```

2. 安装依赖环境，依赖软件包有`gcc gcc-c++ autoconf automake libtool cmake 
   zlib-devel openssl-devel lzo-devel`
   
   ```bash
   docker exec -it hadoop-builder bash -c '
   mv -f /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.bak
   curl http://mirrors.aliyun.com/repo/Centos-7.repo -o /etc/yum.repos.d/CentOS-Base.repo
   yum makecache 
   yum install -y --nogpgcheck gcc gcc-c++ autoconf automake libtool make unzip patch \
   zlib-devel openssl-devel lzo-devel bzip2-devel ncurses-devel 
   '
   ```

3. 安装依赖的java软件如：java，maven、ant和findbug
   
   ```bash
   docker exec -it hadoop-builder bash -c '
   set -e
   
   mkdir -p $JAVA_HOME
   mkdir -p $MAVE_HOME
   mkdir -p $ANT_HOME
   mkdir -p $FINDBUGS_HOME
   
   tar -xzf /mnt/hadoop-builder/jdk-8u202-linux-arm64-vfp-hflt.tar.gz -C $JAVA_HOME --strip-components=1 
   tar -xzf /mnt/hadoop-builder/apache-maven-3.5.4-bin.tar.gz -C $MAVE_HOME --strip-components=1 
   tar -xzf /mnt/hadoop-builder/apache-ant-1.9.16-bin.tar.gz -C $ANT_HOME --strip-components=1 
   tar -xzf /mnt/hadoop-builder/findbugs-3.0.1.tar.gz -C $FINDBUGS_HOME --strip-components=1 
   
   cat /mnt/hadoop-builder/settings.xml > $MAVE_HOME/conf/settings.xml
   
   '
   ```

4. 安装 cmake
   
   ```bash
   docker exec -it hadoop-builder bash -c '
   set -e
   
   build_path=/usr/local/src/cmake-build
   mkdir -p "$build_path"
   tar -xzf /mnt/hadoop-builder/cmake-3.23.1.tar.gz -C "$build_path" --strip-components=1 
   cd "$build_path"
   
   ./bootstrap --parallel=8
   make -j 8
   make install
   '
   ```

5. 安装 `protobuf-2.5.0`，hadoop强依赖这个版本，所以只能使用这个版本编译。并且这个版本只支持x64，需要下载补丁包然后才能编译
   
   ```bash
   docker exec -it hadoop-builder bash -c '
   set -e
   
   build_path=/usr/local/src/protobuf-build
   mkdir -p "$build_path"
   tar -xzf /mnt/hadoop-builder/protobuf-2.5.0.tar.gz -C "$build_path" --strip-components=1 
   
   mkdir -p "$build_path/gtest" 
   tar -xzf /mnt/hadoop-builder/googletest-release-1.5.0.tar.gz -C "$build_path/gtest" --strip-components=1 
   
   cd "$build_path"
   ./autogen.sh
   curl -L -O https://gist.githubusercontent.com/liusheng/64aee1b27de037f8b9ccf1873b82c413/raw/118c2fce733a9a62a03281753572a45b6efb8639/protobuf-2.5.0-arm64.patch
   patch -p1 < protobuf-2.5.0-arm64.patch
   ./configure --prefix=$PROTOBUF_HOME --disable-shared
   make -j 8 
   make install
   '
   ```

6. 安装 snappy
   
   ```bash
   docker exec -it hadoop-builder bash -c '
   set -e
   
   build_path=/usr/local/src/snappy-build
   mkdir -p "$build_path"
   tar -xzf /mnt/hadoop-builder/snappy-1.1.3.tar.gz -C "$build_path" --strip-components=1 
   
   cd "$build_path"
   ./configure
   make -j 8 
   make install
   '
   ```

7. 编译hadoop
   
   ```bash
   docker exec -it hadoop-builder bash -c '
   set -e
   
   build_path=/usr/local/src/hadoop-build
   mkdir -p "$build_path"
   tar -xzf /mnt/hadoop-builder/hadoop-2.7.7-src.tar.gz -C "$build_path" --strip-components=1 
   
   cd "$build_path"
   export MAVEN_OPTS="-Xms512m -Xmx512m"
   export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib:/lib64
   mvn clean package -DskipTests -Pdist,native -Dtar \
   -Dbundle.snappy=true -Dsnappy.lib=/usr/local/lib  \
   -Dbundle.openssl=true -Dopenssl.lib=/lib64 
   '
   ```

8. 从docker容器中拷贝hadoop编译包
   
   ```bash
    docker cp hadoop-builder:/usr/local/src/hadoop-build/hadoop-dist/target/hadoop-2.7.7.tar.gz /tmp
   ```

9. 

参考文档：

- https://hadoop.apache.org/docs/r2.7.7/hadoop-project-dist/hadoop-common/NativeLibraries.html
