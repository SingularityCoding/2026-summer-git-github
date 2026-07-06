# `git commit`

staging area 里已经准备好了 `foobar.txt`。现在要做那件真正重要的事：把它写进 Git 的历史。这就是 `git commit`。

```bash
git commit -m "Add foobar file"
git status
```

```
[main (root-commit) bc3a22a] Add foobar file
 1 file changed, 1 insertion(+)
 create mode 100644 foobar.txt
On branch main
nothing to commit, working tree clean
```

讲解要点：

- `git commit` 才是真正创建历史记录的命令——`git add` 只是准备，`commit` 才是保存。这一前一后两个动作合起来，才完成一次完整的"记录变化"。
- 一次 commit 可以理解为项目在某个时刻的一张快照，同时带着 commit message、作者、时间、commit hash 这些信息（`root-commit` 说明这是这个仓库的第一次 commit，`bc3a22a` 是 Git 给这次 commit 生成的哈希值，可以先当成"版本号"来理解）。
- `git commit` 默认**只**提交 staging area 里的内容，不会自动把工作目录里所有的变化都提交进去——这也是为什么前面要先 `git add` 挑一遍。
- commit 完之后再看 `git status`，如果没有新的修改，就会看到熟悉的 `nothing to commit, working tree clean`。

顺带一提：如果没有先 `git add` 就直接 `git commit`，通常会看到 `nothing to commit`——这其实反过来印证了 staging area 的存在：Git 压根不知道你想提交什么。

这一节重点讲这一个高频参数：

```bash
git commit -m "message"
```

`-m` 用来直接写 commit message。课堂上建议一直用 `-m`，避免第一次 commit 就一头撞进一个不熟悉的命令行编辑器——如果不加 `-m`，Git 会打开默认编辑器（由 `$GIT_EDITOR`、`$EDITOR` 或 `git config core.editor` 决定）等你输入 message，这个编辑器具体是什么、怎么配置，留到后面讲 `git config` 时再展开。

关于 commit message 本身，记住两条就够：message 要说清楚这次改了什么，别写成 `update`、`fix`、`aaa` 这种没有信息量的话；一次 commit 尽量对应一个清晰的小改动，比如 `Add foobar file`，而不是把一堆不相关的修改揉在一起。规范可以以后再学，先养成"提交小而清楚"的习惯更重要。

`git commit --amend` 和 `git commit -a` 这两个先不展开——`--amend` 涉及改写历史，等我们更熟悉 commit hash 和 push 之后再回来讲；`-a` 会跳过显式 `git add` 这一步，初学阶段容易削弱你对 staging area 的理解，等后面用熟了三层模型再解禁。

下一步，我们已经有了第一次 commit，该看看 Git 是怎么记录这些历史的——也就是 `git log`。
