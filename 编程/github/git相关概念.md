#### git相关概念

- git 文件状态
  - 本地文件状态
- 本地文件和远程文件交互
  - 常用命令
  - pull 和 push 及冲突处理
  - merge选项
  - 分支合并步骤

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

- checkout：把工作目录替换成指定版本的内容。**一般只是在git中进行了版本控制的文件会受影响**

- reset：
  
  - --hard：清空stage，把工作目录重置到某一指定版本。同时 HEAD 指针指向指定版本
  
  - --soft：修改 HEAD 指针，保留 stage 和工作目录，并且把因为reset 的变化也添加到stage中。**如何RESET后立即提交，则相当于指定版本和原来最新版本之间的change都会跟这次新提交的change合并在同一个commit中。**
  
  - --mixed（默认选项）：修改HEAD指针，清空stage，把到指定版本的差异合并到工作目录。**等价于 undo 了到指定版本之间的commit**

- rm：
  
  - --cached：把指定文件从stage中移除
  
  - 没有参数：把指定从 git 跟踪中移除，但是不物理删除文件。**注意，git rm后需要commit 才能提交到repository。**

![](img/file_status_change.jpg)

##### 本地文件和远程文件交互

###### 常用命令

git本地文件和远程文件交互的方式如下：

<img src="img/git-command.jpg" title="" alt="" data-align="center">

和远端仓库进行交互的命令有：

- pull：把文件从远端仓库拉取到本地仓库和工作目录，如果过程中出现冲突，则需要进行merge

- fetch：把文件从远端仓库拉取到本地仓库

- clone：在一个空文件夹创建新的本地仓库

- push：在处理好pull过程的冲突后，把本地仓库的当前分支的最新版本，推送到远程仓库

###### pull 和 push 及冲突处理

git 进行push时会保证一件事情是，**新的commit一定会在目标分支最新版本上进行commit。**<br>

基于上面的要求，git在push之前会把远端仓库的目标分支对应的所有版本都同步到本地仓库和工作目录。但是同步的过程可能存在冲突，冲突的原因如下：<br>

当远端有比本地更加新的版本时，可能版本D和本地工作目录的版本（假设为E）同时修改了一个文件，此时就发生冲突了。因为版本 D 和 E的共同父版本是C (称为 merge-base commit)，git 无法把在同一个commit中保存一个文件的两个版本，所以就冲突了。

```shell
A---B---C---D(remote)
         
A---B---C---E(local)
```

当存在冲突时，就需要在工作目录中合并冲突，即人工选择冲突文件要保留哪些内容。所以我们需要先**undo E在本地的commit**，然后在工作目录pull版本D到本地进行合并，然后commit 一个新的E1到本地仓库，然后在进行push。如下图所示，在工作目录，合并后，再commit 得到E1，再push。

```shell
A---B---C---D(remote)
         
A---B---C---D---E1(local)
```

**不同分支间的合并和同一个分支不同版本之间的合并大同小异**



###### merge 选项

**通常merge的选项是在pull时进行配置的。**

和commit 行为相关选项

- \-\-ff，\-\-ff\-\-only：进行快速合并，即直接移动HEAD 指针，但是不生成新的commit
  
  - 其中 --ff--only 是指在合并遇到冲突时就失败
  
  - **如果删除分支，则会丢失分支信息。因为在这个过程中没有创建commit**

- --no-ff：关闭快速合并，和 --ff 的区别是**解决完冲突后，no-ff会生成一次commit**

- --squash： 将合并过来的分支的所有不同的提交，当做一次提交，提交过来

和 merge 策略相关：

- Resolve：策略只能合并两个分支，以两个分支的共同祖先（ merge-base commit ）为基础进行合并

- Recursive：当两个分支有多个共同祖先时，需要先把多个共同祖先合并成一个变成 merge-base commit，然后再合并分支

- Octopus：合并多个分支的时候的策略

- Ours：

- Subtree：

分支合并和三个commit有关，merge-base commit，ours commit和theirs commit。ours commit 是当前分支的 HEAD 对应的commit，theirs commit 要 pull 过来进行merge 的分支的 HEAD。merge-base commit就是这两个 commit 的共同祖先commit，是判断文件是否冲突的基础。

常见的 merge-base commit，ours commit和theirs commit 的情况：

- 只有一个共同祖先，下面的例子的 merge-base commit 是 **commit C**
  
  ```shell
  A--B--C--D--F (branch 1)
         \  
           E--G (branch 2)
  ```

- merge-base commit只会是最近的共同祖先commit，所以下面的例子的merge-base commit 是 **commit D**：
  
  ```shell
  A--B--D--E--G (branch 1)
   \   / \  
     C     F--H (branch 2)
  ```

- 当两个分支存在多个共同祖先时，继续递归查找是否有更早的祖先commit，由于 commit D和E都是共同的前驱节点，则需要继续递归查找，直到找到 commit B
  
  ```shell
  A--B--C--E--G--I (branch 1)
      \     X 
        D--F--H--J (branch 2)
  ```

- 当无法递归找到单个共同祖先，并且选择了 recursive 策略时，git先临时合并这些best common ancestor，然后将这个临时产生的commit作为merge-base来合并branch。由于共同祖先是最初的commit，所以认为没有共同祖先。
  
  ```shell
  B--C--E--G--I (branch 1)
   \     X 
     D--F--H--J (branch 2)
  ```

- 

###### 分支合并步骤

假设要把 branch 1 的内容merge 到 branch 2

1. checkout 到 branch 1，**注意checkout后，当前工作目录中未commit 的修改会丢失**

2. pull branch 2到当前工作目录

3. 处理冲突

4. commit

5. push
