# `git checkout`

这一节不需要展开太多，因为前面已经分别讲过 `git switch` 和 `git restore`。这里的重点是认识 `git checkout`：一个历史更久、职责更混合的命令，过去同时承担了"切换分支"和"恢复文件"这两件事。

先看它和 `git switch` 的关系：

```bash
git checkout experiment
git branch
git checkout main
git branch
```

```
Switched to branch 'experiment'
* experiment
  main
Switched to branch 'main'
  experiment
* main
```

效果和 `git switch experiment` / `git switch main` 完全一样——`git checkout <branch>` 就是旧式的切换分支命令。

再看它和 `git restore` 的关系：

```bash
echo "temp edit" >> foobar.txt
git checkout -- foobar.txt
git status
```

```
On branch main
nothing to commit, working tree clean
```

`git checkout -- foobar.txt` 把刚才那行临时改动丢掉了，效果和 `git restore foobar.txt` 一样——这是旧式的恢复文件命令。

讲解要点：

- `git checkout <branch>` 是旧式切换分支命令，现在课堂主线优先用 `git switch <branch>`。
- `git checkout -b <branch>` 是旧式创建并切换分支命令，对应现在的 `git switch -c <branch>`（这里不重复演示，原理和上一节的 `-c` 一样）。
- `git checkout -- <file>` 是旧式恢复文件命令，现在课堂主线优先用 `git restore <file>`。
- 你需要认识 `checkout`，因为很多老教程、博客、项目文档仍然大量在用它。但初学阶段不建议把它当主线命令，否则会把"切换分支"和"恢复文件"这两个本来清晰分开的概念又混回一起。

`git checkout <commit>` 和 detached HEAD 这个概念很重要，但需要你对 commit、branch、HEAD 有更稳定的理解之后再看会更清楚，这门课先不展开。

下一步，我们要把 `experiment` 分支上的实验成果，真正合并回 `main`——也就是 `git merge`。
