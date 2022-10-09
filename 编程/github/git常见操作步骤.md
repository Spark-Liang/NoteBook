### git常见操作步骤

- 多个commit合并成一个

- 合并部分commit到目标分支

#### 多个commit合并成一个

采用的方式是通过`git rebase -i <所有需要合并的commit的前一个commit>`命令，对多个commit进行编辑。

[「Git」合并多个 Commit - 简书](https://www.jianshu.com/p/964de879904a)

#### 合并部分commit到目标分支

采用`git cherry-pick`命令实现。原理是，`cherry-pick`命令把来源commit的操作直接复制到当前分支上并生成新的commit。所以必须保证commit的顺序<br>[git cherry-pick 教程 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2020/04/git-cherry-pick.html)
