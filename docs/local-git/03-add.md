# `git add`

上一节 `git status` 告诉我们 `foobar.txt` 是个 untracked file。这一节回答那个自然的下一个问题：这个文件该怎么进入 Git 的管理范围？答案就是 `git add`。

```bash
git add foobar.txt
git status
```

```
On branch main

No commits yet

Changes to be committed:
  (use "git rm --cached <file>..." to unstage)
	new file:   foobar.txt
```

讲解要点：

- `git add` 的作用是把文件的当前变化放进 staging area（暂存区，也叫 index）——也就是"准备提交"的那个区域。
- 对新文件来说，`git add foobar.txt` 意味着让 Git 开始追踪这个文件，并把它此刻的内容放进下一次 commit 的候选集合里。
- `git add` 本身**还不是**保存历史。真正把内容写进历史的是后面的 `git commit`——`add` 只是"准备"这一步。
- 对比一下 `git status` 的输出变化：`foobar.txt` 已经从 `Untracked files` 挪到了 `Changes to be committed`。

这里可以先建立一个简化版模型（完整的三层模型要等 `git log` 之后再总结）：

```plaintext
Staging Area / Index
        ↑  git add

Working Directory / Working Tree
```

现在只需要理解：working directory 里可以同时存在很多变化，但你可以挑其中一部分放进 staging area，作为下一次 commit 的候选内容——这个"挑选"的动作，就是 `git add`。

两个高频用法，第一次接触先记住就好：

```bash
git add foobar.txt
git add .
```

`git add foobar.txt` 用于明确添加某一个文件；`git add .` 会把当前目录下所有的变化一次性加进去，方便是方便，但用之前最好先 `git status` 确认一下，别把不相关的文件也顺手加了进去。

`git add -A` 这类变体这一节先不展开，重点是把 staging area 这个概念立住，不用一次塞太多变体进来。

下一步，staging area 里已经有内容了，是时候把它真正写进历史——也就是 `git commit`。
