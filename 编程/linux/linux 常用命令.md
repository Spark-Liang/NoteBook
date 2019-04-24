
### 压缩与解压
常见的在 Linux 中生成压缩文件的方式有两种，一种是 通过 zip 和 unzip 命令，另外一种是通过 tar 和 gzip 的命令。

#### zip 和 unzip：
zip 可以打包压缩指定文件也可以打包压缩指定的目录。
```bash
## 压缩
zip xxx.zip <filename1> <filename2> ##压缩给定文件
zip -r xxx.zip ./* ##压缩指定目录，其中 -r 表示递归添加

## 解压
unzip -o -d /home/sunny myfile.zip 
## 把myfile.zip文件解压到 /home/sunny/
## -o 表示不提示直接覆盖 -d 表示指定的解压目标目录

## 操作压缩文件
zip -d myfile.zip smart.txt
## 删除压缩文件中smart.txt文件
zip -m myfile.zip ./rpm_info.txt
## 向压缩文件中myfile.zip中添加rpm_info.txt文件
```

#### tar 和 gzip 命令
tar 命令本身只是一个打包命令，但是可以通过 z 选项，在打包归档的时候再发送给 gzip 命令进行压缩或者解压。如果想压缩成 .bz2 格式的就使用 j 选项，.Z 格式就使用 Z 选项。
<font color='red'>但是需要主要的是压缩和解压都需要带上相应的选项才能成功操作，否则会报错</font><br>
tar 命令的常用选项：
- c 创建新的档案文件。如果用户想备份一个目录或是一些文件，就要选择这个选项。
- x 从档案文件中释放文件。
- r 把要存档的文件追加到档案文件的未尾。例如用户已经作好备份文件，又发现还有一个目录或是一些文件忘记备份了，这时可以使用该选项，将忘记的目录或文件追加到备份文件中。
- u 更新文件。就是说，用新增的文件取代原备份文件，如果在备份文件中找不到要更新的文件，则把它追加到备份文件的最后。
- t 列出档案文件的内容，查看已经备份了哪些文件。
- f 使用档案文件或设备，<font color='red'>这个选项通常是必选的。这个参数是最后一个参数，后面只能接档案名。</font>
- v 详细报告tar处理的文件信息。如无此选项，tar不报告文件信息。

<font color='red'>上面的选项中，c、x、r、u、t 这五个选项只能单独选一个，因为代表了五个对档案的基本操作。</font><br>

总结：
1. *.tar 用 tar –xvf 解压
2. *.gz 用 gzip -d或者gunzip 解压
3. *.tar.gz和*.tgz 用 tar –xzf 解压
4. *.bz2 用 bzip2 -d或者用bunzip2 解压
5. *.tar.bz2用tar –xjf 解压
6. *.Z 用 uncompress 解压
7. *.tar.Z 用tar –xZf 解压

### 系统变量设置
linux 的系统变量有三种：
- 一种是所有用户共有的永久的生效的，这些变量放在 /etc/profile 文件上.
- 一种是单个用户共有的永久的生效的，这些变量放在对应用户目录的 .bash_profile 文件上.用户目录可以通过 "cd ~" 直接进行跳转。
 
### 权限管理
linux 对每个文件和目录都有相应的权限标识，用于限定 owner，owner group 和 other 这三者对该文件所能进行的操作，以及该文件的 owner 和 owner group 是谁。<font color='red'>这个标识可以通过 “ll” 命令来查看。</font>

#### 文件目录权限管理
对文件目录权限的管理主要就是修改文件的权限修饰符和文件的 owner 和 owner group。<br>
权限管理主要需要用到几个命令: chmod、chown、chgrp，这三个命令分别就是对应 “修改修饰符”，“修改owner 或者 owner group”以及“修改 owner group”。
```bash
# chmod 中修改标识符的时候，分别用 u、g、o 和 a 表示不同范围的用户，分别代表 owner，owner group 和 全部用户
# chmod 中 = 代表赋权，+ 代表添加权限，- 代表移除权限
chmod [Option] <filename>

# chown 主要是修改文件对应的 owner 和 group
chown [Option] [username[:groupname]] <filename>

# chgrp 主要是单独修改文件的 group，这个是和 chown 最大的区别
chgrp [Option] <groupname> <filename>
```

#### 用户和用户组管理
用户和用户组管理主要会影响到用户对每个文件的访问权限，linux 通过结合用户和用户组以及文档权限修饰符的形式实现权限管理。

与用户添加，删除和修改相关的命令有，useradd、userdel 和 usermod。
与组添加，删除和修改相关的命令有，groupadd、groupdel 和 groupmod。
```bash
# useradd 中比较常用的选项有 d,g,G
# 其中 d 代表指定用户目录，g 代表所属用户组，G 代表所属附加用户组
useradd [Option] <username>
# usermod 的常用选项和 useradd 中的比较相似
usermod [Option] <username>

userdel <username>
```
#### 用户密码相关命令
linux 对用户密码的操作主要使用的 passwd 命令。
```bash
#直接调用 passwd 命令就是修改当前用户的用户名密码
passwd
passwd <username> #就是修改对应用户名的密码
```

#### 用户和用户组信息文件查看
用户和用户组的信息可以在以下的文件中查看得到：
1. /etc/group ：存储当前系统中的用户组信息
![来源https://www.cnblogs.com/xs104/p/4510114.html](https://images0.cnblogs.com/blog2015/500720/201505/181507586358755.png)
2. /etc/gshadow : 存储当前系统中用户组的密码信息
![来源https://www.cnblogs.com/xs104/p/4510114.html](https://images0.cnblogs.com/blog2015/500720/201505/181518203223817.png)
3. /ect/passwd : 存储当前系统中所有的用户信息
![来源https://www.cnblogs.com/xs104/p/4510114.html](https://images0.cnblogs.com/blog2015/500720/201505/181523188542454.png)
4. /ect/shadow : 存储当前系统中所有用户的密码信息
![来源https://www.cnblogs.com/xs104/p/4510114.html](https://images0.cnblogs.com/blog2015/500720/201505/181529266194742.png)






