# `git init`

好，工具都装好、身份也配置好了，上一节也聊清楚了为什么需要 Git。现在正式开始动手，这门课的第一个 Git 命令，就是 `git init`。

Git 要管理一个项目的历史，第一步永远是先让它知道"从现在开始，这个目录归我管"——这正是 `git init` 要做的事。

## 动手写

课堂上不会直接在什么正经项目里操作，而是专门开一个 `playground` 目录，把它当成实验场：

```bash
mkdir playground
cd playground
git init
ls -a
```

在我这边实际跑出来是这样的：

```
$ git init
Initialized empty Git repository in /path/to/your/playground/.git/

$ ls -a
.       ..      .git
```

你自己电脑上跑出来的那行 `Initialized empty Git repository in ...`，路径部分肯定和我的不一样——那是你自己 `playground` 文件夹实际所在的位置，这是正常的，不用怀疑自己哪里操作错了。

## 这一步到底发生了什么

1. `git init` 的作用很单纯：把当前目录变成一个 Git repository（仓库）。就这一件事。
2. 执行完之后，目录里多出来一个叫 `.git` 的隐藏文件夹，`ls -a` 才能看到它。这个 `.git` 目录保存了这个仓库未来所有的历史记录、配置信息、分支指针……可以说仓库的一切都在这里面。这一节只需要记住"`.git` 很重要，千万别手贱删掉它"就够了，具体里面装了什么，我们后面讲到内部结构时再展开。
3. `git init` **不会**自动帮你保存任何文件，也**不会**自动创建 commit。它只是给这个目录打开了"Git 版本管理"这个开关，仅此而已——后面的 `git add`、`git commit` 才是真正开始记录内容的动作。

## 两个小提醒

- 不要图省事在家目录、桌面根目录这类"什么都往里塞"的大目录里执行 `git init`。一旦执行，Git 理论上会开始关心这个目录下的一切，很容易把一堆互不相关的文件混进同一个仓库的上下文里，后面清理起来很麻烦。养成习惯：想清楚"这次要管理的到底是哪个项目"，再在对应的目录里 `git init`。
- 因为课前 Prerequisites 里已经统一配置过 `git config --global init.defaultBranch main`，理论上大家看到的默认分支都应该叫 `main`。如果你现在敲 `git branch` （下一个大块内容会讲到）发现自己是 `master`，说明那一步课前配置漏做了，补一句 `git config --global init.defaultBranch main` 就行，不用纠结为什么会这样——这纯粹是个历史遗留的命名问题，和 Git 的核心概念没关系。

## 顺带一提

`git init` 其实还可以带一个目录参数，比如 `git init my-project` 可以直接创建并初始化 `my-project` 这个目录，不用自己先 `mkdir`。这个用法记一下就行，课堂上我们还是优先用 `mkdir playground && cd playground && git init` 这个"三步走"的写法——这样你能更直观地感受到"在哪个目录下执行命令，Git 就初始化的是哪个目录"，这个直觉后面会一直有用。

下一步，我们要学会读懂 Git 现在到底是什么状态——也就是这门课最重要的一个命令：`git status`。
