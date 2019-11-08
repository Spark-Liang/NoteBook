##### submodule 管理

- 在parenet 中引用 submodule

- submodule 的版本控制

###### 在 parent 中引用submodule

在parent中，使用如下代码 clone 已经创建好的 submodule repository.

```bash
git submodule add <repo url> <submodule path>
```

此处有几个地方需要注意：

- 注意当前目录是否是一个 git repository，如果不是会报错
  
  **fatal: not a git repository (or any of the parent directories): .git**

- 查看需要创建submodule 的 path 是否已经存在，如果已经存在或报错
  
  **already exists and is not a valid git repo**

- 

###### submodule 的版本控制

git 里面，parent 是通过 commit hash 值来决定引用的哪个版本的submodule.在parent中更新对应的submodule是通过cd到submodule 然后git pull拉取对应branch 的代码

以 test 这个 submodule 为例

```bash
cd test

git pull <repo url> <branch>
```

需要注意的是pull完成后需要commit 和 push 到远程仓库才能是更改生效。
