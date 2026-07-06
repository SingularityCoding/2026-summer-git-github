# `git reset`

`git reset` 比前面几个命令更容易用错，所以第一次接触要非常收敛：这一节只围绕"撤销最近一次本地 commit"这一个场景展开。

先制造一个待会儿要撤销的 commit：

```bash
echo "bad experiment" >> foobar.txt
git add foobar.txt
git commit -m "Bad experiment"
git log --oneline
```

```
[main 5f4a487] Bad experiment
 1 file changed, 1 insertion(+)
5f4a487 Bad experiment
185f477 Update foobar file
54639f3 Add foobar file
```

在往下走之前，先轻量认识两个概念：`HEAD` 表示"当前所在的 commit"，可以先理解成"当前版本"；`HEAD~1` 就是当前 commit 的上一个。

现在演示第一种撤销方式：撤销 commit，但把修改保留在 staging area。

```bash
git reset --soft HEAD~1
git status
git log --oneline
```

```
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   foobar.txt

185f477 Update foobar file
54639f3 Add foobar file
```

讲解要点：

- `git reset --soft HEAD~1` 把当前分支退回到上一个 commit——`git log --oneline` 里"Bad experiment"那一条确实不见了。
- 但那次 commit 里的修改并没有丢，仍然留在 staging area，`git status` 显示的是 `Changes to be committed`。
- 这个场景适合用在：刚 commit 完发现 message 写错了，或者这次 commit 暂时还不该存在，但修改本身还要留着。

接着演示默认的 reset 模式，也就是 `--mixed`：

```bash
git commit -m "Bad experiment"
git reset HEAD~1
git status
```

```
[main 5f4a487] Bad experiment
 1 file changed, 1 insertion(+)
Unstaged changes after reset:
M	foobar.txt
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   foobar.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

讲解要点：

- `git reset HEAD~1` 等价于 `git reset --mixed HEAD~1`，是默认模式。
- 同样撤销了最近一次 commit，但这次修改回到的是 working directory，不在 staging area 里了。
- 适合用在：撤销 commit，并且想重新决定这次到底要不要 `git add`。

第一次介绍就讲这两个模式：

```bash
git reset --soft HEAD~1
git reset HEAD~1
```

这里要把 `git reset` 和 `git restore` 区分清楚：`git restore` 更适合文件级别的撤销（取消 staged、丢掉某个文件的工作区修改）；`git reset` 更适合移动"当前 commit 指针"的位置，最常见的场景就是撤销本地 commit。`reset` 会直接影响历史指针，每一步都要配合 `git status` 和 `git log --oneline` 一起看。和 `--amend` 类似，`reset` 适合处理还没有 push 给别人的本地 commit——已经分享出去的历史不要随便 reset。

（老一点的教程里还会看到 `git reset HEAD <file>` 这种写法，效果和 `git restore --staged <file>` 差不多，只是更早期的写法；课堂主线继续用 `git restore --staged`，因为语义更直白。）

`--soft` 和默认的 `--mixed` 都见过之后，补上第三种、也是最危险的一种：`--hard`。

```bash
echo "another bad experiment" >> foobar.txt
git add foobar.txt
git commit -m "Another bad experiment"
git log --oneline

git reset --hard HEAD~1
git status
git log --oneline
cat foobar.txt
```

```
[main f580214] Another bad experiment
 1 file changed, 2 insertions(+)
f580214 Another bad experiment
185f477 Update foobar file
54639f3 Add foobar file
HEAD is now at 185f477 Update foobar file
On branch main
nothing to commit, working tree clean
185f477 Update foobar file
54639f3 Add foobar file
hello git
second line
```

讲解要点：

- `git reset --hard HEAD~1` 同样撤销最近一次 commit，但比前两种更彻底：staging area 和 working directory 里对应的修改都被一并丢弃，`cat foobar.txt` 可以看到，连"another bad experiment"这行也没了，文件内容直接回到了两次 commit 之前的样子。
- 执行前一定要先确认没有不想丢的修改——这是三种模式里唯一会直接改动 working directory 内容的，一旦执行，靠 Git 常规命令基本找不回来。
- 一句话总结三种模式：`--soft` 只退指针，修改留在 staging area；`--mixed`（默认）退指针并把修改退回 working directory；`--hard` 退指针，同时把 staging area 和 working directory 里的相关修改都清空。

演示到这里，working tree 已经是干净的了，正好可以继续下一节。

下一步，我们要处理一类"根本不该进 Git"的文件——用 `.gitignore` 告诉 Git 该忽略什么。
