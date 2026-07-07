# `git diff`

`git status` 能告诉我们"哪些文件变了"，但它不会直接给你看"具体改了什么"。想看真正的内容差异，要用 `git diff`。

先制造一个已经被 Git 追踪的文件的修改：

macOS + Windows Git Bash（Linux 可自行参考）:

```bash
echo "third line" >> foobar.txt
git status
git diff
```

Windows PowerShell:

```powershell
Add-Content -Path foobar.txt -Value "third line"
git status
git diff
```

```
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

- `git diff` 默认显示的是 working directory 里**尚未进入 staging area** 的修改。
- 它回答的问题是：相比 Git 已知的上一个版本，当前文件内容具体发生了什么变化。
- 输出里 `-` 开头的行表示删除或旧内容，`+` 开头的行表示新增或新内容——这一节不需要逐字解释 diff header 里的每个字段（比如 `index ea111b3..9de32a7`），先能看懂哪几行变了就够。
- 如果 `git diff` 打开了分页界面，同样按 `q` 退出。

接着看 staging 之后差异会怎么变：

```bash
git add foobar.txt
git status
git diff
git diff --staged
```

```
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   foobar.txt

diff --git a/foobar.txt b/foobar.txt
index ea111b3..9de32a7 100644
--- a/foobar.txt
+++ b/foobar.txt
@@ -1,2 +1,3 @@
 hello git
 second line
+third line
```

这里有个关键观察，也是刚才那次 `git diff`"消失"的地方：`git add` 之后，working directory 和 staging area 已经一致了，所以默认的 `git diff` 什么都不显示（上面这段输出其实是 `git status` 加 `git diff --staged` 两条命令拼起来的结果——中间那次单独的 `git diff` 是空的，这正说明了它"没有尚未 staged 的修改"）；而 `git diff --staged` 会显示 staging area 里准备提交的变化，这次就是我们真正想看的那段 diff。

一句话总结这两个高频用法：

```bash
git diff
git diff --staged
```

`git diff` 看的是尚未 staged 的修改；`git diff --staged` 看的是已经 staged、准备进入下一次 commit 的修改。顺带一句：`git diff --cached` 和 `git diff --staged` 基本等价，课堂上统一用 `--staged`，因为这个名字更贴近 staging area 的概念。

`git diff <commit>`、`git diff <commit1> <commit2>`、`git diff branchA..branchB` 这类比较方式先不展开，等你更熟悉 commit hash 和 branch 之后再回来看会更容易懂。

下一步，如果发现改错了想撤销，该怎么办？这就是 `git restore`。
