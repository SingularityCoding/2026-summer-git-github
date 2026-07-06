# `git merge`

`experiment` 分支上已经有了一次提交。现在要把这条分支上的成果，合回 `main`。

先确认当前在 `main`：

```bash
git switch main
git status
git branch
```

```
Already on 'main'
On branch main
nothing to commit, working tree clean
  experiment
* main
```

讲解要点：

- merge 的方向很重要：`git merge experiment` 的意思是把 `experiment` 合入**当前分支**。
- 所以如果要把实验成果合回主线，必须先切到 `main`，再 merge `experiment`——顺序不能反。
- merge 前最好先 `git status`，确认 working directory 是 clean 的。

执行合并：

```bash
git merge experiment
git status
cat foobar.txt
git log --oneline --graph --all
```

```
Updating 7471135..e54cb37
Fast-forward
 foobar.txt | 1 +
 1 file changed, 1 insertion(+)
On branch main
nothing to commit, working tree clean
hello git
second line
experiment idea
* e54cb37 Try experiment idea
* 7471135 Stop tracking local-only file
...
```

讲解要点：

- `git merge experiment` 把 `experiment` 分支包含、但 `main` 还没有的提交合了进来。
- 输出里那行 `Fast-forward` 就是关键：因为 `main` 自从创建 `experiment` 之后没有产生任何新 commit，Git 不需要真正"合并"两条不同的历史，只是把 `main` 这个指针直接往前挪到 `experiment` 指向的位置——没有产生额外的 merge commit。
- 合并后，`git log --oneline --graph --all` 显示的是一条完全线性的历史，`main` 和 `experiment` 现在指向同一个 commit。
- `foobar.txt` 里能看到之前只在 `experiment` 上新增的 `experiment idea` 这一行。

合并完成后，删除已经不需要的本地分支：

```bash
git branch -d experiment
git branch
```

```
Deleted branch experiment (was e54cb37).
* main
```

讲解要点：

- 删除分支不会删除 commit，只是删除这个分支名字——`experiment` 指向的那些 commit 依然在 `main` 的历史里。
- 因为 `experiment` 已经合入 `main`，所以 `git branch -d experiment` 是安全的；这也说明分支只是指针，不是把代码复制了一份。
- 如果分支还没有合并，`git branch -d` 会拒绝删除并提示。这时候可以用 `git branch -D branch-name`（大写）强制删除，即使里面的提交还没合并到任何地方——`-d` 是"确认安全才删"，`-D` 是"我确定要删，不管有没有合并"。底层的 commit 短期内通常还能通过 reflog 找回（这个概念这里不展开），但初学阶段只在确实想放弃这个分支时才用 `-D`。

这一节先只讲 fast-forward。下一节我们专门设计一个冲突场景，去理解为什么多人协作时需要处理合并冲突——也就是 merge conflict。
