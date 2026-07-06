# `git status`

`git init` 只是打开了开关，接下来这个命令才是整节课最重要的观察工具：`git status`。以后每做一步操作，前后都可以先跑一下它，看看 Git 眼里现在是什么情况——这个习惯值得从第一天就养成。

```bash
git status
```

```
On branch main

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

先说明一件事：`git status` 不会修改任何文件或 Git 历史，它只负责如实汇报当前状态。刚 `git init` 完、什么文件都没有的时候，它会告诉你：在 `main` 分支上，还没有任何 commit，working tree（工作目录）是干净的。

现在造一个文件出来，再看一次：

```bash
echo "hello git" > foobar.txt
git status
```

```
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	foobar.txt

nothing added to commit but untracked files present (use "git add" to track)
```

这里引出这门课第一个核心状态：**untracked**（未跟踪）。意思是这个文件确实存在于 working directory 里，但 Git 还没有把它纳入版本管理。这一节先不用急着搞懂 staging area（暂存区）的完整模型，记住一件事就够：Git 不会自动追踪所有新文件，新文件要不要管，得你自己明确告诉它。

之后每个命令演示前后都尽量跑一下 `git status`——形成"不确定仓库现在是什么状态，就先 `git status`"的反射，比背下每个命令的细节更重要。

顺带认识一个高频参数：

```bash
git status --short
git status -s
```

```
?? foobar.txt
?? foobar.txt
```

`--short`（简写 `-s`）是更简洁的输出格式，`??` 就表示"untracked"。适合熟悉命令之后快速扫一眼状态；第一次学的时候，还是默认的完整输出更容易看懂发生了什么，所以这门课里默认输出优先。

下一步，我们要回答 `git status` 里看到的这个 untracked 状态该怎么处理——也就是 `git add`。
