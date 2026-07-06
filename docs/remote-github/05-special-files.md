# GitHub repo 里的特殊文件

放在 issue 和 PR 后面讲这个话题很自然——你已经实际创建过 issue 和 PR 了，现在再看这些"模板文件"，会立刻明白它们是用来解决什么问题的。

## 最常见的几个文件

- **`README.md`**：仓库首页默认展示的项目说明。
- **`.gitignore`**：告诉 Git 哪些文件不应该被追踪。
- **`LICENSE`**：说明别人可以怎么使用、修改、分发这个项目。
- **`CONTRIBUTING.md`**：说明如何参与贡献，比如怎么提 issue、怎么发 PR、代码风格、测试要求。
- **`CODE_OF_CONDUCT.md`**：社区行为准则，开源项目里常见。

讲解要点：

- 这些文件不是 Git 的特殊文件，而是 **GitHub** 会识别、并在网页上特殊展示或链接的文件——比如 `LICENSE` 会显示在仓库信息栏，`README.md` 会直接渲染在首页。
- `.gitignore` 同时会影响 Git 的实际行为；其他几个主要影响的是 GitHub 页面展示和协作流程，不影响 Git 本身怎么工作。
- 对课程项目来说，至少应该有 `README.md`、`.gitignore`、`CONTRIBUTING.md`。

## Issue template

```plaintext
.github/
  ISSUE_TEMPLATE/
    bug_report.md
    feature_request.md
```

示例内容可以很简单：

```markdown
## What happened?

## What did you expect?

## Steps to reproduce

## Extra context
```

issue template 用来引导提 issue 的人提供足够信息，能减少"只有一句话但没法处理"的 issue。对课程来说，也可以设计"作业反馈"、"bug report"、"feature request"这类模板。

## PR template

```plaintext
.github/
  PULL_REQUEST_TEMPLATE.md
```

示例内容：

```markdown
## Summary

## Changes

## Checklist

- [ ] I tested my changes locally.
- [ ] I linked the related issue.
```

PR template 用来提醒提交者说明改了什么、为什么改、怎么验证，能让 review 更高效——配合 issue 里的 `Closes #1`，正好形成一个完整的任务闭环：issue 描述任务，PR 说明怎么解决，两者通过关键字关联起来。

## 一个小练习

回到 [`first-contributions`](https://github.com/SingularityCoding/first-contributions) 这个仓库：它目前故意只有 `README.md` 和 `CONTRIBUTORS.md`，没有 `CONTRIBUTING.md`，也没有任何模板——现在正好可以给它加一个简单的 `CONTRIBUTING.md` 或者 PR template，作为一次小练习，走一遍这一节刚学的完整流程：开分支、改动、发 PR。

下一步，我们看看网页操作之外，还有什么办法能更快地做同样的事——GitHub CLI。
