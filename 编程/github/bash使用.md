

### 乱码问题

#### git bash 中

出现乱码的原因是 cmd的字符集和 bash的字符集不匹配

cmd 字符集查看方法：chcp命令。

cmd修改字符集：chcp 936 (转成gbk)，chcp 65001 (转成 utf-8)



bash 修改字符集的方式 export LANG 变量。

设置为 utf8： export LANG=zh_CN.UTF-8



设置 git log 编码

设置 commit log 提交时使用 utf-8 编码，可避免服务器上乱码，同时与linux上的提交保持一致！

git config --global i18n.commitencoding utf-8

git config --global i18n.logoutputencoding  utf-8



设置 git gui 界面字符集

git config --global gui.encoding utf-8



git status 乱码

git config --global core.quotepath false
