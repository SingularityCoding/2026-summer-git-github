# `git restore`

刚才用 `git diff` 看到了修改。接下来要回答一个很实际的问题：如果发现改错了，怎么撤销？这一节先只讲两个最高频的场景：把已经 staged 的修改拿回来，以及直接丢掉 working directory 里尚未 staged 的修改。

延续上一节的状态：`foobar.txt` 的修改已经被 `git add` 放进了 staging area。先演示取消 staged：

```bash
git status
git restore --staged foobar.txt
git status
git diff
```

```
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   foobar.txt

On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   foobar.txt

no changes added to commit (use "git add" and/or "git commit -a")
diff --git a/foobar.txt b/foobar.txt
index ea111b3..9de32a7 100644
--- a/foobar.txt
+++ b/foobar.txt
@@ -1,2 +1,3 @@
 hello git
 second line
+third line
```

讲解要点：

- `git restore --staged foobar.txt` 的意思是：把 `foobar.txt` 从 staging area 拿出来。
- 它**不会**删除文件内容，修改还好好地留在 working directory 里——所以执行完再看 `git diff`，仍然能看到刚才那行 `third line`。
- 对应三层模型里的这条路：

```plaintext
Staging Area / Index
        ↓  git restore --staged

Working Directory / Working Tree
```

接着演示更彻底的一种：直接丢掉 working directory 里的修改。

```bash
git restore foobar.txt
git status
```

```
On branch main
nothing to commit, working tree clean
```

讲解要点：

- `git restore foobar.txt` 会把 working directory 里的 `foobar.txt` 恢复到 Git 当前记录的版本——也就是说，`third line` 这次真的消失了。
- 这会丢掉尚未 commit 的本地修改，需要谨慎使用。执行前最好先用 `git status` 和 `git diff` 确认一下，自己确实不要这些修改了。
- 一定要把这两个命令区分清楚：`git restore --staged <file>` 是取消 staging，修改还在；`git restore <file>`（不带 `--staged`）是丢掉工作目录的修改，内容真的没了。

顺带认识一个批量用法：

```bash
git restore .
```

它会一次性丢掉当前目录下所有尚未 staged 的修改。方便是方便，但也更危险——不建议在没看过 `git status` / `git diff` 的情况下就直接用它。

`git restore --source=<commit>` 这种从指定 commit 恢复文件的用法先不展开，等你对 commit hash、`checkout`、`reset` 这些概念更熟悉之后再回来看会更顺。

下一步，我们要学一个和"撤销"关系更密切、但也更容易用错的命令——`git reset`。
