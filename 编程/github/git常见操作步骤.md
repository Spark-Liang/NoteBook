### git常见操作步骤

[TOC]



#### 多个commit合并成一个

采用的方式是通过`git rebase -i <所有需要合并的commit的前一个commit>`命令，对多个commit进行编辑。

[「Git」合并多个 Commit - 简书](https://www.jianshu.com/p/964de879904a)

#### 合并部分commit到目标分支

采用`git cherry-pick`命令实现。原理是，`cherry-pick`命令把来源commit的操作直接复制到当前分支上并生成新的commit。所以必须保证commit的顺序<br>[git cherry-pick 教程 - 阮一峰的网络日志](https://www.ruanyifeng.com/blog/2020/04/git-cherry-pick.html)

#### 将github仓库同步到gitlab

以克隆apache spark项目为例

1. **克隆 GitHub 仓库为裸仓库**：

   ```bash
   git clone --bare https://github.com/apache/spark.git
   ```

   这将在本地创建一个裸仓库，其中不包含工作目录，只有 Git 仓库的内容和历史记录。

2. **进入新创建的裸仓库目录**：

   ```bash
   cd spark.git
   ```

3. **添加 GitLab 作为远程仓库**：

   ```bash
   git remote add gitlab <GitLab 项目的 URL>
   ```

4. **将裸仓库推送到 GitLab 项目**：

   ```bash
   git push gitlab --mirror
   ```

5. 将gitlab项目重新克隆到本地

   ```bash
   git clone <GitLab 项目的 URL>
   cd <项目名称>
   git remote add github https://github.com/apache/spark.git
   ```

6. 

这将把 GitHub 仓库的裸镜像推送到 GitLab 的新项目中，包括所有分支、标签和提交历史。请将 `<GitLab 项目的 URL>` 替换为您在 GitLab 上创建的新项目的 URL。

这种方式会将完整的 Git 仓库内容迁移到 GitLab 中，包括所有分支、提交记录和标签信息。

