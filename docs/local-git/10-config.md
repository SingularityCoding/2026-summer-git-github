# `git config`

课前 Prerequisites 里已经让你配置过 `user.name` 和 `user.email`。这一节把它放回 Git 的整体模型里正式讲一遍：Git 除了管理文件历史，本身还有一套配置系统，`git config` 就是读写这套配置的命令。

先看看现在有哪些配置：

```bash
git config --list
git config --global --list
```

```
init.defaultbranch=main
user.name=Course Instructor
user.email=instructor@example.com
core.autocrlf=input
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
core.ignorecase=true
core.precomposeunicode=true
init.defaultbranch=main
user.name=Course Instructor
user.email=instructor@example.com
core.autocrlf=input
```

讲解要点：

- `git config` 用来读取和修改 Git 的配置。
- `user.name` 和 `user.email` 会写进每一次 commit 的作者信息里——回头看看前面几节 `git log` 的输出，`Author:` 那一行就是从这里来的。
- `user.email` 不是你的 GitHub 登录密码，也不是 token，只是 commit 作者身份的一部分，别搞混了。
- 如果发现提交作者信息不对，十有八九就是这里配置错了。

回顾一下课前配置的那条命令，顺便体会 `--global` 的含义：

```bash
git config --global user.name "Your Name"
git config --global user.email "foobar@example.com"
```

`--global` 表示这个配置写到当前操作系统用户的全局 Git 配置里——之后你在这台机器上新建的大多数仓库，默认都会用这套身份。

再看一个 `--local` 的例子：

```bash
git config --local user.email "course@example.com"
git config --local --list
```

```
user.email=course@example.com
```

讲解要点：

- `--local` 表示这次修改只对**当前仓库**生效，保存在这个仓库自己的 `.git/config` 里——不会被 commit，也不会推送到 GitHub。
- local 配置会覆盖 global 配置。比如工作项目想用公司邮箱、个人项目想用个人邮箱，这样分开配就行。
- 顺便对比一下：`.gitignore` 是团队共享规则，应该提交进仓库；`.git/config` 是纯个人本地配置，不会提交。这个对比能帮你理清"哪些信息属于项目，哪些信息属于本地环境"。

两个排查命令也一起认识一下：

```bash
git config --get user.name
git config --get user.email
git config --list --show-origin
```

```
Your Name
course@example.com
file:/path/to/your/.gitconfig	init.defaultbranch=main
file:/path/to/your/.gitconfig	user.name=Your Name
file:/path/to/your/.gitconfig	user.email=foobar@example.com
file:/path/to/your/.gitconfig	core.autocrlf=input
file:.git/config	core.repositoryformatversion=0
file:.git/config	core.filemode=true
file:.git/config	core.bare=false
file:.git/config	core.logallrefupdates=true
file:.git/config	core.ignorecase=true
file:.git/config	core.precomposeunicode=true
file:.git/config	user.email=course@example.com
```

`--show-origin` 会显示每条配置具体来自哪个文件——上面 `file:` 后面那段路径在你自己电脑上会是你真实的 `~/.gitconfig` 位置，跟这里显示的不会一样，这很正常。这个参数专门用来排查"为什么我的配置不是我以为的那个"。

还有几个高频、又不太增加理解负担的配置，一起认识一下：

```bash
git config --global core.quotepath false
git config --global core.excludesfile ~/.gitignore_global
git config --global core.editor "vim"
```

- `core.quotepath false` 让 Git 显示中文文件名时更友好，不会把路径显示成转义形式——中文课程尤其实用。
- `core.excludesfile ~/.gitignore_global` 指定一个全局 ignore 文件，专门放"所有项目都不想提交"的本机文件，比如 `.DS_Store`、编辑器临时文件。
- `core.editor` 指定 Git 需要打开编辑器时用哪个程序——比如没带 `-m` 的 `git commit`。如果不配置，Git 会依次参考 `$GIT_EDITOR`、`$EDITOR`、系统默认编辑器；很多人第一次遇到会卡在一个陌生的终端编辑器里出不来。初学阶段尽量用 `-m` 避开这个坑；万一不小心进去了，常见的 `vi`/`vim` 默认模式下按 `Esc` 再输入 `:wq` 保存退出，或者 `:cq` 直接放弃这次 commit。

全局 ignore 可以这样用：

```bash
echo ".DS_Store" >> ~/.gitignore_global
echo ".idea/" >> ~/.gitignore_global
```

要把这个和仓库自己的 `.gitignore` 区分开：`.gitignore` 放在仓库里，应该提交，是团队共享规则；`~/.gitignore_global` 是你自己机器上的规则，不会进入任何仓库，专门用来处理本机系统或编辑器产生的文件。

pager、delta、VS Code difftool/mergetool、rebase、push、credential helper、Git LFS 这类个人效率配置这里先不展开，都很有用，但依赖具体工具或后续场景，留到对应章节再讲更合适。

到这里，本地部分最核心的一批命令都学完了。下一步，我们要认识 Git 真正的杀手锏——分支，也就是 `git branch`。
