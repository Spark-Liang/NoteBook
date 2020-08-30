#### git相关概念

- git 文件状态
  - 本地文件状态

##### git 文件状态

###### 本地文件状态

**文件状态类型**

- **Untracked**: 未跟踪, 此文件在文件夹中, 但并没有加入到git库, 不参与版本控制. 通过git add 状态变为Staged
- **Unmodify**: 文件已经入库, 未修改, 即版本库中的文件快照内容与文件夹中完全一致. 这种类型的文件有两种去处, 如果它被修改, 而变为Modified. 如果使用git rm移出版本库, 则成为Untracked文件
- **Modified**: 文件已修改, 仅仅是修改, 并没有进行其他的操作. 这个文件也有两个去处, 通过git add可进入暂存staged状态, 使用git checkout 则丢弃修改过, 返回到unmodify状态, 这个git checkout即从库中取出文件, 覆盖当前修改
- **Staged**: 暂存状态. 执行git commit则将修改同步到库中, 这时库中的文件和本地文件又变为一致, 文件为Unmodify状态. 执行git reset HEAD filename取消暂存, 文件状态为Modified。**Stage中每个文件只会有一个版本，这个版本的内容就是commit对应的内容**

**文件操作**

- add：将工作目录中**Modified**的文件添加到 stage 中，或者把文件最新的内容更新到stage中

- commit：把stage中的文件提交到 repository 中。

- checkout：把某一个文件的某个版本或者某一个版本的程序替换当前工作目录的文件。

- reset：
  
  - --hard：清空stage，把工作目录重置到某一指定版本。同时 HEAD 指针指向指定版本
  
  - --soft：修改 HEAD 指针，保留 stage 和工作目录，并且把因为reset 的变化也添加到stage中。**如何RESET后立即提交，则相当于指定版本和原来最新版本之间的change都会跟这次新提交的change合并在同一个commit中。**
  
  - --mixed（默认选项）：修改HEAD指针，清空stage，把到指定版本的差异合并到工作目录。

- rm：
  
  - --cached：把指定文件从stage中移除
  
  - 没有参数：把指定从 git 跟踪中移除，但是不物理删除文件。**注意，git rm后需要commit 才能提交到repository。**

![](img/file_status_change.jpg)
