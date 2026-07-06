# GitHub CLI：网页之外的 GitHub 操作方式

这一节轻量讲一下 GitHub CLI，也就是 `gh`。重点不是背命令，而是知道一件事：GitHub 上很多网页操作，其实也能在命令行里完成。

先划清边界：

- `git` 主要操作 Git 版本历史——commit、branch、merge、push、pull。
- `gh` 主要操作 GitHub **平台**对象——repo、issue、Pull Request、workflow。
- 有些命令看起来重合，比如 `git clone` 和 `gh repo clone`，但 `gh` 更多是在 GitHub 平台语境下做包装和提效。
- 如果 `gh` 命令记不住，完全可以回到 GitHub 网页操作——网页流程仍然是最适合初学者理解概念的方式。

顺带提一句 AI 时代的实际价值：`gh` 很适合让 Claude Code、Codex 这类 AI coding agent 在终端里帮你操作 GitHub——查看 issue、读取 PR、创建 PR、检查 CI 结果，都可以直接在终端里完成。网页适合人看，CLI 适合脚本和 agent 操作（这份讲义本身也是用 `gh` 建的仓库和 issue）。

## 认证相关

```bash
gh auth status
```

```
github.com
  ✓ Logged in to github.com account ukeSJTU (keyring)
  - Active account: true
  - Git operations protocol: https
  - Token: ghp_************************************
  - Token scopes: 'admin:org', 'notifications', 'project', 'read:packages', 'repo', 'user', 'workflow'
```

`gh auth login` 用来登录 GitHub；`gh auth setup-git` 会把 GitHub CLI 配置成 Git 的 credential helper，让后续 HTTPS push 能复用 `gh` 的登录状态。

## repo 相关

```bash
gh repo view ukeSJTU/hello-github
```

```
name:	ukeSJTU/hello-github
description:	A tiny Python project for learning Git and GitHub.
--
# hello-github

A tiny Python project for learning Git and GitHub.

## Usage

Run `python hello.py`.

## Development

Notes on how this project is organized.
```

`gh repo clone owner/repo` 能直接 clone；`gh repo view --web` 能在浏览器里打开这个仓库；`gh repo create` 很方便，但初学阶段前面已经手动走过创建 repo + remote + push 的完整流程，这里只作为提效工具记一下。

## issue 相关

```bash
gh issue list --repo SingularityCoding/first-contributions
gh issue view 1 --repo SingularityCoding/first-contributions
```

```
1	OPEN	Add your name to CONTRIBUTORS.md		2026-07-06T13:31:18Z
```

```
title:	Add your name to CONTRIBUTORS.md
state:	OPEN
author:	ukeSJTU
labels:
comments:	0
assignees:
projects:
milestone:
number:	1
--
Add your own GitHub username to `CONTRIBUTORS.md` and open a Pull Request.
...
```

`gh issue list`、`gh issue view <number>`、`gh issue create` 分别对应列出、查看、创建 issue——效果和网页上一模一样。

## PR 相关

```bash
gh pr list --repo ukeSJTU/hello-github --state all
```

```
3	Add development notes	improve-readme	MERGED	2026-07-06T15:47:05Z
2	Add development notes	improve-readme	CLOSED	2026-07-06T15:46:24Z
1	Add development notes	improve-readme	MERGED	2026-07-06T15:41:16Z
```

`gh pr create`、`gh pr view --web` 分别对应创建 PR、在浏览器里打开某个 PR。这里最值得记住的是 `gh pr checkout <number>`：它能把某个 PR 的分支直接拉到本地，方便你在本地跑测试、review 或者继续修改——不用先去网页上找到分支名再手动 checkout。

## Actions 相关，先提一嘴

```bash
gh run list
gh run view
```

这两个下一节讲 Actions/CI 的时候再展开。

课堂上的建议：主线仍然用 GitHub 网页讲 issue 和 PR 的概念，因为网页流程更直观；`gh` 作为熟练之后的效率工具，也是 AI agent 操作 GitHub 最自然的入口。

下一步，我们看看 GitHub 怎么在特定事件发生时，自动帮我们跑一组命令——GitHub Actions。
