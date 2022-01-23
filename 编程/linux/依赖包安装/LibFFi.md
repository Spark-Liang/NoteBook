#### LibFFi

- 简介

- 安装依赖

- 安装配置

##### 简介

“FFI” 的全名是 Foreign Function Interface，通常指的是允许以一种语言编写的代码调用另一种语言的代码。而 “Libffi” 库只提供了最底层的、与架构相关的、完整的”FFI”，因此在它之上必须有一层来负责管理两种语言之间参数的格式转换。

[LibFFI首页、文档和下载 - 外部函数接口 - OSCHINA - 中文开源技术交流社区](https://www.oschina.net/p/libffi?hmsr=aladdin1e1)

##### 安装依赖

- 编译环境`gcc g++ make`

##### 安装配置

###### 源码安装

1. 下载源码编译安装
   
   ```bash
   wget ftp://sourceware.org/pub/libffi/libffi-3.3.tar.gz
   cd libffi-3.3
   ./configure --prefix=/usr/local/libffi-3.3
   make
   make install
   ```

2. 在配置文件中`/etc/profile`配置依赖包路径
   
   ```bash
   export LD_LIBRARY_PATH=/usr/local/libffi-3.3:$LD_LIBRARY_PATH
   ```


