### gcc编译器

- 编译安装

#### 编译安装

| 模块名称 | 描述           | 安装方式                                                                                                                                        |
| ---- | ------------ | ------------------------------------------------------------------------------------------------------------------------------------------- |
| gmp  | c语言处理大数字的函数库 | [源码](https://gmplib.org/)编译，参考文档[Linux 下安装GMP库](https://blog.csdn.net/just_h/article/details/82667787)                                      |
| mpfr |              | [源码](https://www.mpfr.org/mpfr-current/)编译，参考文档[Linux MPFR源码安装](https://www.jianshu.com/p/bc909ce2e424)                                     |
| mpc  |              | [源码](http://ftp.gnu.org/gnu/mpc/mpc-1.0.2.tar.gz)编译，参考文档[Centos7环境下gcc由4.8升级到6.4](https://blog.csdn.net/zhuyunfei/article/details/81290764) |

**注意点**：

- mpfr必须使用`3.1.x`版本，因为gcc中使用了`mpfr_add_one_ulp` 函数，该函数在4.x的版本中会被移除

##### 编译

常用选项：

- `--enable-checking=xxx`：编译时启动一下检查
  
  - 常用check：release

- `--enable-languages=c,c++`：配置gcc支持的语言

- `--disable-multilib`：取消生成交叉编译器，用于生成支持运行32和64位的编译器

- `--enable-threads=posix`

- `--enable--long-long`

##### 安装

1. 备份原始的gcc命令你

```bash
original_version=4.8.5
mv c++         c++.$original_version
mv cpp         cpp.$original_version
mv g++         g++.$original_version
mv gcc         gcc.$original_version
mv gcc-ar      gcc-ar.$original_version
mv gcc-nm      gcc-nm.$original_version
mv gcc-ranlib  gcc-ranlib.$original_version
mv gcov        gcov.$original_version
```

2. 在安装目录的`bin`下创建`.redirected`目录，创建`redirect.sh`用于统一配置环境变量

```bash
#!/usr/bin/env sh

real_path_of_script_file=`readlink -f "$0"`
while [[ ! "$real_path_of_script_file" == "`readlink -f "$real_path_of_script_file"`" ]]
do
  real_path_of_script_file=`readlink -f "$real_path_of_script_file"`
done 

readonly BASE_DIR=$(cd "`dirname "$real_path_of_script_file"`"/../../; pwd)
readonly REQUEST_FILE_NAME=`basename "$0"`


export PATH="$BASE_DIR/bin:$PATH"
export LD_LIBRARY_PATH="$BASE_DIR/lib64:$BASE_DIR/lib:$LD_LIBRARY_PATH"
export C_INCLUDE_PATH="$BASE_DIR/include:$C_INCLUDE_PATH"
export CPLUS_INCLUDE_PATH="$BASE_DIR/include:$CPLUS_INCLUDE_PATH"

"$BASE_DIR/bin/$REQUEST_FILE_NAME" "$@"
```

3. 创建软连接

```bash
ln -s  redirect.sh   c++
ln -s  redirect.sh   cpp
ln -s  redirect.sh   g++
ln -s  redirect.sh   gcc
ln -s  redirect.sh   gcc-ar
ln -s  redirect.sh   gcc-nm
ln -s  redirect.sh   gcc-ranlib
ln -s  redirect.sh   gcov
ln -s  redirect.sh   gcov-dump
ln -s  redirect.sh   gcov-tool
ln -s  redirect.sh   lto-dump
ln -s  redirect.sh   x86_64-pc-linux-gnu-c++
ln -s  redirect.sh   x86_64-pc-linux-gnu-g++
ln -s  redirect.sh   x86_64-pc-linux-gnu-gcc
ln -s  redirect.sh   x86_64-pc-linux-gnu-gcc-11.2.0
ln -s  redirect.sh   x86_64-pc-linux-gnu-gcc-ar
ln -s  redirect.sh   x86_64-pc-linux-gnu-gcc-nm
ln -s  redirect.sh   x86_64-pc-linux-gnu-gcc-ranlib
```

参考文档：

- [linux下安装gcc详解 - Hxinguan - 博客园](https://www.cnblogs.com/Hxinguan/p/5016305.html)
