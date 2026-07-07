# Git aliases

学完这一大批高频命令之后，顺手认识一下 Git aliases。alias 就是通过 `git config` 配置出来的命令缩写。

先看看现在有没有配置过 alias：

```bash
git config --global --get-regexp '^alias\.'
```

第一次跑这条命令通常什么都不会输出（没有 alias 就没有匹配），配几个适合课堂用的 alias：

```bash
git config --global alias.st status
git config --global alias.br branch
git config --global alias.sw switch
git config --global alias.lg "log --oneline --graph --all"
```

之后就可以这样用：

```bash
git st
git br
git sw main
git lg
```

```
On branch main
nothing to commit, working tree clean
  feature-two
* main
Already on 'main'
* 9e93934 Add feature two
*   dc9b8ab Merge branch 'feature-note'
...
```

讲解要点：

- alias 是个人效率工具，不是团队协作的必要条件。
- 课堂讲解和教程正文里仍然优先写完整命令，比如 `git status`——这样不会因为没配置 alias 就跟不上。
- `git lg` 这类 alias 特别适合把长命令固定下来，比如 `git log --oneline --graph --all`。
- 不建议一开始配置太多 alias。先熟悉原始命令，再逐步加自己真正高频用到的缩写。
- alias 存在于个人 Git 配置里，不会被 commit，也不会影响别人。

如果想删除 alias：

```bash
git config --global --unset alias.st
```

## 顺手补一个：`git commit -a`

前面讲 `git add` 和 `git commit` 的时候，故意没提这个——为的是先让你扎实理解 staging area。现在三层模型和 alias 都讲完了，可以补上这个高频简写了。

macOS + Windows Git Bash（Linux 可自行参考）:

```bash
echo "quick fix" >> foobar.txt
git status
git commit -a -m "Quick fix"
git status
```

Windows PowerShell:

```powershell
Add-Content -Path foobar.txt -Value "quick fix"
git status
git commit -a -m "Quick fix"
git status
```

```
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   foobar.txt

no changes added to commit (use "git add" and/or "git commit -a")
[main 75340e4] Quick fix
 1 file changed, 1 insertion(+)
On branch main
nothing to commit, working tree clean
```

讲解要点：

- `git commit -a` 会自动把所有**已经被 Git 追踪、且有修改**的文件先 `add`，再执行 commit，相当于省略了中间手动 `git add` 的步骤。
- 关键限制：它只处理已经被追踪文件的修改，不会把 untracked files 加进来——如果有新文件，仍然需要显式 `git add`。
- 好处是日常小改动可以少打一条命令；代价是容易在没注意的情况下把不想提交的修改也一起提交进去，更适合已经养成"提交前看一眼 `git status`/`git diff`"习惯的阶段。
- 一句话总结：`-a` 不是必须掌握的技巧，`git add` + `git commit` 分开写永远是更清楚、更不容易出错的写法。

本地 Git 最核心的一批内容，到这里就学完了。下一步，我们回顾一下从三层模型到四区域模型的这段旅程，然后正式进入 Remote GitHub。
