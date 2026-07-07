# 分支协作：在自己仓库里走一遍 branch → PR → merge

这一节不需要两人配对——直接在自己的 `hello-github` 仓库里练习一遍完整的分支工作流。真实项目里几乎不会让所有人直接 push 到 `main`；哪怕是自己一个人的项目，也值得养成"改动先开分支、通过 PR 合并"的习惯，这里就在自己的仓库里把这个流程走一遍。

## 从最新的 `main` 开一个分支

```bash
git switch main
git pull
git switch -c improve-readme
```

```
Already on 'main'
Your branch is up to date with 'origin/main'.
Already up to date.
Switched to a new branch 'improve-readme'
```

讲解要点：

- 先 `git switch main` 加 `git pull`，确保基于最新的 `main` 开始改动。这个仓库目前只有你自己在改，`pull` 拉不到新东西，但这是该养成的习惯——多人协作时才不会一上来就基于过时的 `main` 开分支。
- `git switch -c improve-readme` 创建并切换到一个工作分支，分支名描述这次改动，比如 `improve-readme`、`add-tests`、`fix-typo`。

## 在分支上修改、提交、push

macOS + Windows Git Bash（Linux 可自行参考）:

```bash
printf '\n## Development\n\nNotes on how this project is organized.\n' >> README.md
git status
git diff
git add README.md
git commit -m "Add development notes"
git push -u origin improve-readme
```

Windows PowerShell:

```powershell
@'

## Development

Notes on how this project is organized.
'@ | Add-Content -Path README.md
git status
git diff
git add README.md
git commit -m "Add development notes"
git push -u origin improve-readme
```

```
[improve-readme ec221d0] Add development notes
 1 file changed, 4 insertions(+)
remote:
remote: Create a pull request for 'improve-readme' on GitHub by visiting:
remote:      https://github.com/ukeSJTU/hello-github/pull/new/improve-readme
remote:
To https://github.com/ukeSJTU/hello-github.git
 * [new branch]      improve-readme -> improve-readme
branch 'improve-readme' set up to track 'origin/improve-readme'.
```

讲解要点：

- 这里 push 的不是 `main`，而是 `improve-readme` 分支。
- `-u origin improve-readme` 建立本地分支和远程分支的跟踪关系。
- push 完之后，GitHub 通常会像上面这样直接提示可以创建 Pull Request——终端里那个链接点开就是。

顺带提两个能简化"新分支第一次 push"的配置（这里只讲用途，课堂主线仍然建议先手写完整的 `-u origin <branch>`，理解 upstream 是怎么建立的）：

```bash
git config --global push.default current
git config --global push.autoSetupRemote true
```

`push.default current` 让 `git push` 在没指定远程分支时，默认推到与本地同名的远程分支；`push.autoSetupRemote true`（较新版本 Git 支持）能让 `git push` 在分支还没有 upstream 时自动建立跟踪关系，效果上接近每次都自动带上 `-u`。

## 创建 Pull Request

在 GitHub 网页上：

1. 打开自己的 repo 页面。
2. 点击 Compare & pull request。
3. 确认 base branch 是 `main`，compare branch 是 `improve-readme`。
4. 填写 PR title 和 description。
5. 创建 Pull Request。

Pull Request 的本质：它不是 Git 的核心命令，而是 GitHub 提供的协作功能——请求把一个分支的修改合并到另一个分支；同一个仓库内的两个分支之间也能发起 PR，不一定要跨仓库。PR 页面会展示 changed files、commits、conversation、checks 这些信息，给团队提供了 review、讨论、自动化测试和合并入口。

review 并 merge（这里是自己 review 自己的 PR，但流程和团队协作一样）：打开 PR 看一眼 Files changed——即使是自己的改动，也养成合并前看一遍 diff 的习惯；然后点击 Merge pull request；合并后可以顺手删除远程分支 `improve-readme`。

这一整套（也可以用 `gh pr create` / `gh pr merge` 在终端里做完全一样的事，第 6 节会专门讲）产生的效果是：

```
https://github.com/ukeSJTU/hello-github/pull/3
To https://github.com/ukeSJTU/hello-github.git
 - [deleted]         improve-readme
```

## merge 后同步本地

```bash
git switch main
git pull
git branch -d improve-readme
```

```
Switched to branch 'main'
Your branch is up to date with 'origin/main'.
From https://github.com/ukeSJTU/hello-github
   e51cf68..9e861d9  main       -> origin/main
Updating e51cf68..9e861d9
Fast-forward
 README.md | 4 ++++
 1 file changed, 4 insertions(+)
Deleted branch improve-readme (was ec221d0).
```

讲解要点：

- PR merge 发生在 GitHub 远程仓库上，本地仓库不会自动更新，需要 `git pull`。
- 本地工作分支已经合并后，可以用 `git branch -d` 删除。

这一节建立的工作流是：

```plaintext
main 最新状态 -> 新建分支 -> 本地修改 -> commit -> push 分支 -> Pull Request -> review -> merge -> pull 回本地
```

这也是后面讲 Issue、fork + PR、GitHub Actions、code review 的基础。

## 顺手清理：`git fetch --prune`

如果远程分支是在 GitHub 网页上删除的（而不是像我们这次直接用命令删），本地的 remote-tracking branch（也就是 `origin/improve-readme` 这个引用）可能还会留着一段时间——`git branch -r` 或 `git branch -a` 依然能看到它，尽管远程那个分支其实已经不在了。

```bash
git fetch --prune
git branch -r
```

```
  origin/HEAD -> origin/main
  origin/main
```

讲解要点：

- `git fetch` 默认只负责获取远程的新内容，不会主动清理本地这些"过时的远程分支记录"。
- `git fetch --prune` 会额外检查：如果某个 remote-tracking branch 对应的远程分支已经不存在了，就把这个本地记录一并删掉——我们这次因为提前删过了，这里看到的已经是干净状态，但概念是一样的。
- 这不会影响任何本地工作分支或 commit，只是清理"关于远程分支状态"的记录，相对安全。
- 顺带一句：`git config --global fetch.prune true` 能让这个行为在每次 `git fetch`/`git pull` 时自动发生，不用每次手动加 `--prune`。

下一步，我们要处理一个更真实的协作场景：如果你对一个仓库根本没有写权限，该怎么贡献代码？这就要用到 Issue、Fork 和 Pull Request 的组合。
