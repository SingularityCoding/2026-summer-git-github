# Git & GitHub

本节课带学生学习使用 git 和 github，同时初步理解背后的概念

## Prerequisites

> 学生课前需要完成的课前准备。目标不是提前学会 Git，而是确保课堂上可以顺利完成本地提交、推送到 GitHub、创建 PR。

建议顺序：

1. 注册 GitHub 账号
   - 确认可以正常登录 GitHub
   - 记住自己的 GitHub username，后面会用于 fork、clone、PR 等操作
2. 安装 Git
   - 检查安装结果，同时确认版本足够新：

```bash
git --version
```

   - 课程主线会用到 `git switch`、`git restore`（Git 2.23+ 才有）和 `init.defaultBranch` 配置（Git 2.28+ 才支持），建议版本不低于 **2.30**。如果版本太旧：macOS 用 `brew upgrade git`，Windows 重新安装最新版 Git for Windows，Linux 看发行版的包管理器或从源码/官方仓库升级。
   - **Windows 用户**：安装 Git for Windows 时会自带 **Git Bash**，课程全程请用 Git Bash 作为终端，不要用 `cmd.exe` 或 PowerShell。教案里的命令（`printf`、`mkdir -p` 等）是 POSIX 风格的，cmd/PowerShell 语法不兼容或行为不同；Git Bash 自带一套 coreutils（`ls`、`mkdir`、`cat`、`rm`、`printf`、`echo` 等），行为和 macOS/Linux 基本一致。

3. 统一 Git 环境设置

这一步的目的不是学新概念，而是提前抹平几个和 Git 概念无关、纯粹因为系统环境不同而产生的输出差异，避免课堂上出现"为什么我的和你的不一样"这种和这节课无关的分心点。

先检查 Git 提示信息是不是英文：

```bash
mkdir -p /tmp/git-lang-check && cd /tmp/git-lang-check && git init -q && git status
```

如果看到的是英文（`On branch main` ...），跳过这步。如果看到中文（比如"位于分支 main"），说明系统语言设置影响了 Git 的提示信息；课堂上会用英文术语讲解（working directory、staging area、branch 等），中文提示容易和讲的术语对不上。把下面这行加进 shell 配置文件（macOS/Linux 用 `~/.zshrc` 或 `~/.bashrc`，Windows 用 Git Bash 的 `~/.bash_profile`），然后重启终端：

```bash
export LANG=en_US.UTF-8
```

再统一默认分支名和换行符处理，这两个都是纯环境配置，直接执行：

```bash
git config --global init.defaultBranch main
```

```bash
# macOS / Linux
git config --global core.autocrlf input
# Windows
git config --global core.autocrlf true
```

`init.defaultBranch main` 保证大家 `git init` 出来的默认分支名统一是 `main`，不用等到后面讲 branch 时再解释为什么有人是 `master`。`core.autocrlf` 统一换行符处理方式，避免 Windows 和 macOS/Linux 混合上课时，`git diff`/`git status` 因为换行符不同出现一堆和内容无关的噪音（比如整份文件被标记为修改、或者提示 "LF will be replaced by CRLF"）。

4. 配置 Git 提交身份

```bash
git config --global user.name "Your Name"
git config --global user.email "foobar@example.com"
git config --global --list
```

这里需要说明：`user.name` 和 `user.email` 会写进 commit 作者信息里。建议使用和 GitHub 账号匹配的邮箱；如果不想公开个人邮箱，可以使用 GitHub 提供的 noreply 邮箱。

5. 安装 GitHub CLI，并完成登录认证
   - 检查安装结果：`gh --version`
   - 登录：`gh auth login`
   - 检查登录状态：`gh auth status`
6. （可选）安装图形化工具
   - GitHub Desktop：适合辅助理解 GitHub 工作流
   - lazygit：适合已经熟悉命令行的学生提高效率

我觉得做到这一步就差不多了


## 课程内容

### local-git

在这一部分，我们用 `playground` 文件夹演示 Git 的基本使用。这里的 `playground` 不需要是一个真实项目，它更像课堂实验场：可以优先使用 `foobar.txt`、`notes.md`、`todo.txt` 这类随手构造内容的文件，必要时再加入很小的代码文件。核心目标是方便设计出后续命令需要的状态，例如 untracked、modified、staged、committed、deleted、branch divergence、merge conflict 等。

开场不要先堆命令，而是先用一个具体场景带出问题：

> 你正在写一个小项目，今天改了很多代码。后来发现程序坏了，但你已经不记得哪些地方改过；你想回到昨天能运行的版本，又想保留今天一部分有用的修改。再进一步，如果两个人同时改同一个项目，怎么知道谁改了什么、怎么合并、怎么追踪责任？

从这个场景引出：我们需要一个管理代码变化的工具。Git 要解决的核心问题不是“保存文件”，而是记录项目随时间变化的历史，让我们可以查看差异、保存阶段性成果、回到过去版本，并支持多人协作。

这里可以少量拓展版本控制的历史：

1. 早期最朴素的方式是手动复制文件，例如 `project-final`、`project-final-v2`、`project-really-final`。问题是混乱、不可追踪、难以协作。
2. 后来有集中式版本控制系统，例如 CVS、Subversion。它们通常依赖一个中心服务器，团队成员从服务器 checkout/update/commit。优点是比手动复制强很多，但对中心服务器依赖较重，离线能力和分支体验相对有限。
3. Git 是分布式版本控制系统。每个开发者本地都有完整仓库历史，可以离线提交、查看日志、创建分支；远程仓库主要用于同步和协作，而不是唯一的历史来源。

讲到这里即可，不展开 Git 内部实现。目标是让学生先理解为什么需要 Git，以及 Git 相比“复制文件”和“集中式版本控制”的核心差异。这一部分学生如果不是很理解没关系，这个只是给一个大致的背景，后续的命令和操作会让学生慢慢理解 Git 的工作原理。

> **教学节奏说明**：下面 #1-#16 加上各处"补充"，实际授课不建议每个命令后面都单独停下来给学生练习，太碎。按内容自然的断点分成 6 个教学块，演示时块内一条线连贯讲下去，块与块之间才是完整的练习节点：
>
> - **A. 核心记录循环**：#1-#5（含"阶段性总结：Git 的三层模型"）
> - **B. 查看与撤销**：#6、#7、#8（含补充 `git reset --hard`、`git reset HEAD <file>`）
> - **C. 仓库卫生**：#9（含补充 `git add -A`、`git rm --cached`）、#10
> - **D. 分支基础**：#11、#12、#13
> - **E. 合并与冲突**：#14（含补充 `git branch -D`、`git merge --no-ff`/`--ff-only`）、#15（含补充 `merge.conflictstyle`）
> - **F. 个人效率**：#16（含补充 `git commit -a`）
>
> 块内部演示到**第一次出现的新命令**时，可以停下来让学生跟着敲这一行、确认输出对不对；真正"从头自己完整走一遍这个场景"的练习，放在每块结束时，而不是每个命令后面都来一次。"补充"内容不单独占用练习时间，跟着它所属的主编号一起过。这个分块和文档里已有的两处"阶段性总结"是对应的：A 块结束对应三层模型总结，E 块结束对应四区域模型总结。

#### 1. `git init`

第一个 Git 命令应该是 `git init`。课堂上可以先创建一个实验目录，然后把这个普通目录初始化成 Git 仓库：

```bash
mkdir playground
cd playground
git init
ls -a
```

讲解重点：

1. `git init` 的作用是把当前目录变成一个 Git repository。
2. 执行后会出现一个隐藏目录 `.git`，它保存了这个仓库的历史、配置、分支等信息；这一节只需要知道 `.git` 很重要，不需要展开内部结构。
3. `git init` 不会自动保存文件，也不会自动创建 commit。它只是开启 Git 对这个目录的版本管理能力。
4. 不要随便在家目录、桌面根目录这类大范围目录里执行 `git init`，否则容易把不相关文件都放进同一个仓库上下文里。
5. 因为 Prerequisites 里已经统一配置过 `init.defaultBranch main`，这里所有学生应该都能看到默认分支叫 `main`；如果个别学生还是看到 `master`，说明那一步没配上，让他补一下 `git config --global init.defaultBranch main` 即可，不需要现场展开解释。

第一次介绍时不需要讲太多参数。最多顺带提一句：`git init <directory>` 可以直接创建并初始化一个目录，但课堂上优先使用 `mkdir playground && cd playground && git init`，这样学生更容易理解“在哪个目录执行命令，就初始化哪个目录”。

#### 2. `git status`

第二个命令是 `git status`。它是整节课最重要的观察命令，后续每做一步操作，都可以先运行 `git status` 看 Git 眼里的当前仓库状态。

```bash
git status
```

讲解重点：

1. `git status` 不会修改任何文件或 Git 历史，它只负责告诉我们当前状态。
2. 刚 `git init` 完、没有任何文件时，`git status` 通常会提示当前在某个分支上，还没有 commit，并且 working tree clean。
3. 创建一个文件后再看状态：

```bash
echo "hello git" > foobar.txt
git status
```

这时引出第一个核心状态：`untracked files`。意思是这个文件存在于工作目录里，但还没有被 Git 纳入版本管理。

4. 这一节先不急着讲 staging area 的完整模型，只需要让学生理解：Git 不会自动追踪所有新文件；新文件需要我们明确告诉 Git 是否要管理。
5. 之后每个命令演示前后都尽量运行 `git status`，让学生形成习惯：不知道仓库现在是什么情况，就先 `git status`。

第一次介绍可以顺带讲一个高频参数：

```bash
git status --short
git status -s
```

`--short` / `-s` 是简洁输出，适合熟悉后快速查看状态。课堂第一次讲时以默认输出为主，因为默认输出里的提示文字更适合初学者理解。

#### 3. `git add`

第三个命令是 `git add`。它回答前面 `git status` 里看到的 `untracked files` 应该怎么进入 Git 管理。

```bash
git add foobar.txt
git status
```

讲解重点：

1. `git add` 的作用是把文件的当前变化放进 staging area，也就是准备提交的区域。
2. 对新文件来说，`git add foobar.txt` 表示让 Git 开始追踪这个文件，并把它当前的内容放进下一次 commit 的候选集合里。
3. `git add` 本身还不是保存历史。真正写入历史的是后面的 `git commit`。
4. 运行 `git add` 之后再看 `git status`，可以看到文件从 `Untracked files` 进入 `Changes to be committed`。

这里可以第一次引入一个简化版模型：

```plaintext
Staging Area / Index
        ↑  git add

Working Directory / Working Tree
```

先不要急着讲完整三层模型。此时学生只需要理解：工作目录里可以有很多变化，但我们可以选择其中一部分放进 staging area，准备组成下一次 commit。

第一次介绍可以顺带讲两个高频用法：

```bash
git add foobar.txt
git add .
```

`git add foobar.txt` 适合明确添加某个文件；`git add .` 会添加当前目录下的所有变化，使用方便但需要先 `git status` 确认没有把无关文件加进去。

可以暂时不讲 `git add -A`。这一节重点是让学生理解 staging area 的作用，不要太早引入更多 `git add` 变体。

#### 4. `git commit`

第四个命令是 `git commit`。它把 staging area 里的内容保存成 Git 历史中的一个版本。

```bash
git commit -m "Add foobar file"
git status
```

讲解重点：

1. `git commit` 才是真正创建历史记录的命令。`git add` 只是准备，`git commit` 才是保存。
2. 一次 commit 可以理解为项目在某个时刻的一张快照，同时带有 commit message、作者、时间、commit hash 等信息。
3. `git commit` 默认只提交 staging area 里的内容，不会自动提交所有工作目录里的变化。
4. commit 之后再运行 `git status`，如果没有新的修改，应该看到 working tree clean。
5. 如果没有先 `git add` 就直接 `git commit`，通常会看到 `nothing to commit`。这可以反过来加深学生对 staging area 的理解。

第一次介绍时重点讲这个高频参数：

```bash
git commit -m "message"
```

`-m` 用于直接写 commit message。课堂上建议先使用 `-m`，避免学生第一次 commit 时进入不熟悉的命令行编辑器。如果不加 `-m`，Git 会打开默认编辑器（由 `$GIT_EDITOR`、`$EDITOR` 或 `git config core.editor` 决定）等待输入 commit message；这个编辑器具体是什么、怎么配置，放到后面 `git config` 部分再展开。

这里可以顺带讲一点 commit message 的基本要求：

1. message 要说明这次提交做了什么，不要写成 `update`、`fix`、`aaa`。
2. 一次 commit 尽量对应一个清晰的小变化，例如 `Add foobar file`、`Update todo list`。
3. 对初学者不必一开始讲复杂规范，先养成“提交小而清楚”的习惯。

暂时不讲 `git commit --amend` 和 `git commit -a`。`--amend` 涉及改写历史，适合学生理解 commit hash 和 push 之后再补；`-a` 会跳过显式 `git add` 的一部分流程，初学阶段容易削弱对 staging area 的理解。

#### 5. `git log`

第五个命令是 `git log`。前面创建了 commit，现在需要查看 Git 保存下来的历史。

```bash
git log
```

讲解重点：

1. `git log` 用来查看 commit 历史，默认按时间倒序显示，最新的 commit 在最上面。
2. 默认输出里重点看四个信息：commit hash、Author、Date、commit message。
3. commit hash 是 Git 给每次 commit 生成的唯一标识。课堂上先把它理解成“版本号”，后面讲内部对象模型时再解释它来自内容寻址。
4. 如果 `git log` 打开了分页界面，按 `q` 退出。这个细节要现场提醒，否则很多初学者会卡住。

为了让 `git log` 更有意义，可以马上制造第二个 commit：

```bash
echo "second line" >> foobar.txt
git status
git add foobar.txt
git commit -m "Update foobar file"
git log
```

这时让学生观察：历史里有两条 commit，新的在上面，旧的在下面。每条 commit 都有自己的 hash 和 message。

第一次介绍可以顺带讲一个高频参数：

```bash
git log --oneline
```

`--oneline` 会把每条 commit 压缩成一行，通常显示短 hash 和 message，适合快速浏览历史。

暂时不讲 `git log --graph --all --decorate`。这些参数很有用，但最好等讲到 branch 之后再出现，因为那时学生才真正需要“看分支图”。

#### 阶段性总结：Git 的三层模型

学完 `git init`、`git status`、`git add`、`git commit`、`git log` 之后，可以正式总结 Git 在本地的三个核心区域：

```plaintext
Local Repository
        ↑  commit
        ↓  checkout / reset

Staging Area / Index
        ↑  git add
        ↓  git restore --staged / reset

Working Directory / Working Tree
```

讲解重点：

1. Working Directory / Working Tree：当前目录里真实可见、可编辑的文件。
2. Staging Area / Index：准备进入下一次 commit 的变化集合。
3. Local Repository：已经通过 commit 保存下来的本地历史。
4. `git add` 把变化从 working directory 放进 staging area。
5. `git commit` 把 staging area 里的内容保存到 local repository。
6. `git status` 是观察当前文件处在哪个状态的命令。
7. `git log` 是观察 local repository 里 commit 历史的命令。

这里不需要把模型讲成抽象定义。最好配合刚才 `foobar.txt` 的例子，让学生把每一步命令和状态变化对应起来。

#### 6. `git diff`

第六个命令是 `git diff`。前面 `git status` 可以告诉我们“哪些文件变了”，但它不会直接显示“具体改了什么”。`git diff` 就是用来看具体差异的。

先制造一个已经被 Git 追踪的文件修改：

```bash
echo "third line" >> foobar.txt
git status
git diff
```

讲解重点：

1. `git diff` 默认显示 working directory 中尚未进入 staging area 的修改。
2. 它回答的是：相比上一次 Git 已知的版本，当前文件内容具体发生了什么变化。
3. 输出里 `-` 开头的行表示删除或旧内容，`+` 开头的行表示新增或新内容。
4. 对初学者不需要解释 diff header 的每个字段，先让学生能看懂哪几行变了。
5. 如果 `git diff` 打开分页界面，同样按 `q` 退出。

接着演示 staging 之后的差异变化：

```bash
git add foobar.txt
git status
git diff
git diff --staged
```

这里的关键观察是：`git add` 之后，默认 `git diff` 可能没有输出，因为 working directory 和 staging area 已经一致；但 `git diff --staged` 会显示 staging area 里准备提交的变化。

第一次介绍建议讲两个用法：

```bash
git diff
git diff --staged
```

`git diff` 看尚未 staged 的修改；`git diff --staged` 看已经 staged、准备进入下一次 commit 的修改。

可以顺带提一句：`git diff --cached` 和 `git diff --staged` 基本等价，但课堂上统一使用 `--staged`，因为这个名字更贴近 staging area 的概念。

暂时不讲复杂比较方式，例如 `git diff <commit>`、`git diff <commit1> <commit2>`、`git diff branchA..branchB`。这些适合等学生理解 commit hash 和 branch 之后再讲。

#### 7. `git restore`

第七个命令是 `git restore`。刚才用 `git diff` 看到了修改，接下来要回答一个很实际的问题：如果发现改错了，怎么撤销？

`git restore` 第一次建议只讲两个最高频场景：

1. 把已经 staged 的修改从 staging area 拿回来。
2. 丢掉 working directory 里尚未 staged 的修改。

延续上一节的状态，`foobar.txt` 的修改已经被 `git add` 放进 staging area。先演示取消 staged：

```bash
git status
git restore --staged foobar.txt
git status
git diff
```

讲解重点：

1. `git restore --staged foobar.txt` 的意思是：把 `foobar.txt` 从 staging area 拿出来。
2. 它不会删除文件内容，修改还留在 working directory 里。
3. 所以执行后再看 `git diff`，仍然能看到刚才那行修改。
4. 这个命令对应三层模型里的这条路：

```plaintext
Staging Area / Index
        ↓  git restore --staged

Working Directory / Working Tree
```

接着演示丢掉 working directory 里的修改：

```bash
git restore foobar.txt
git status
```

讲解重点：

1. `git restore foobar.txt` 会把 working directory 里的 `foobar.txt` 恢复到 Git 当前记录的版本。
2. 这会丢掉尚未 commit 的本地修改，需要谨慎使用。
3. 执行前应该先用 `git status` 和 `git diff` 确认自己确实不要这些修改。
4. 对初学者要反复强调：`git restore --staged` 是取消 staging，修改还在；`git restore <file>` 是丢掉工作目录修改，内容会消失。

第一次介绍可以顺带提一个批量用法：

```bash
git restore .
```

它会丢掉当前目录下所有尚未 staged 的修改。这个命令很方便，但也更危险，课堂上可以展示含义，不建议学生在不看 `git status` / `git diff` 的情况下使用。

暂时不讲 `git restore --source=<commit>`。它可以从某个 commit 恢复文件，和后面 commit hash、checkout、reset 的概念有关，放到后面更合适。

#### 8. `git reset`

第八个命令是 `git reset`。这个命令比前面的命令更容易误用，所以第一次讲要非常收敛：只围绕“撤销最近一次本地 commit”这个场景展开。

先制造一个可以撤销的 commit：

```bash
echo "bad experiment" >> foobar.txt
git add foobar.txt
git commit -m "Bad experiment"
git log --oneline
```

这里先轻量引入两个概念：

1. `HEAD`：当前所在的 commit，可以先理解为“当前版本”。
2. `HEAD~1`：当前 commit 的上一个 commit。

然后演示撤销最近一次 commit，但保留修改在 staging area：

```bash
git reset --soft HEAD~1
git status
git log --oneline
```

讲解重点：

1. `git reset --soft HEAD~1` 会把当前分支退回到上一个 commit。
2. 最近一次 commit 不再出现在 `git log` 里。
3. 但是那次 commit 里的文件修改没有丢，仍然保留在 staging area，`git status` 会显示 `Changes to be committed`。
4. 这个场景适合演示：刚 commit 完发现 message 写错了、或者这个 commit 暂时还不该存在，但修改本身还要保留。

接着可以演示默认 reset，也就是 `--mixed`：

```bash
git commit -m "Bad experiment"
git reset HEAD~1
git status
```

讲解重点：

1. `git reset HEAD~1` 等价于 `git reset --mixed HEAD~1`。
2. 它同样会撤销最近一次 commit。
3. 不同的是，修改会回到 working directory，不在 staging area 里。
4. 这适合演示：撤销 commit，并且重新决定哪些修改要 `git add`。

第一次介绍建议只讲两个模式：

```bash
git reset --soft HEAD~1
git reset HEAD~1
```

这里要明确和 `git restore` 区分：

1. `git restore` 更适合文件级别的撤销，例如取消 staged、丢掉某个文件的工作区修改。
2. `git reset` 更适合移动当前 commit 位置，常见场景是撤销本地 commit。
3. `git reset` 会影响历史指针，讲课时必须每一步都配合 `git status` 和 `git log --oneline` 观察。
4. 和 `--amend` 类似，`reset` 适合处理还没有 push 给别人的本地 commit；已经分享出去的历史不要随便 reset。

还可以顺带提一个更老的写法：`git reset HEAD <file>`。它在早期教程里常用来取消 staging，效果和 `git restore --staged <file>` 接近。课堂主线继续优先用 `git restore --staged`，因为语义更清楚；但学生看到旧教程里的 `git reset HEAD <file>` 时应该知道这是同一件事的另一种写法。

等 `--soft` 和默认 `--mixed` 都演示清楚之后，可以补上第三种模式 `--hard`，并强调它的危险性：

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

讲解重点：

1. `git reset --hard HEAD~1` 同样会撤销最近一次 commit，但比 `--soft`、`--mixed` 更彻底：staging area 和 working directory 里对应的修改都会被丢弃，不会留在任何地方。
2. 执行前必须先确认没有不想丢的修改，建议先 `git status` / `git diff` 检查一遍。
3. 这是三种模式里唯一会直接改动 working directory 内容的，一旦执行，修改基本无法通过 Git 常规命令找回。
4. 可以用一句话总结三种模式的差异：`--soft` 只退指针，修改留在 staging area；`--mixed`（默认）退指针并把修改退回 working directory；`--hard` 退指针，并把 staging area 和 working directory 里的相关修改都清空。

演示结束后可以清理现场，让仓库回到 clean 状态，方便继续后面的课程：

```bash
git restore foobar.txt
git status
```

#### 9. `.gitignore`

第九个主题是 `.gitignore`。它不是 Git 命令，而是一个特殊文件，用来告诉 Git：哪些文件不需要出现在 `git status` 里，也不应该被提交进仓库。

先制造一些不应该提交的文件：

```bash
echo "debug log" > debug.log
echo "SECRET_KEY=dev-secret" > .env
git status
```

这时可以提问：这些文件应该提交吗？

1. `debug.log` 通常是程序运行产生的日志，不应该进入版本历史。
2. `.env` 里可能放本地配置、密钥、token，更不应该提交。

然后创建 `.gitignore`：

```bash
echo "*.log" > .gitignore
echo ".env" >> .gitignore
git status
```

讲解重点：

1. `.gitignore` 里的规则会影响 Git 如何看待 untracked files。
2. `*.log` 表示忽略所有 `.log` 结尾的文件。
3. `.env` 表示忽略当前仓库里的 `.env` 文件。
4. 被 ignore 的 untracked files 默认不会出现在 `git status` 里。
5. `.gitignore` 本身应该提交进仓库，因为它是团队共享的规则。

提交 `.gitignore`：

```bash
git add .gitignore
git commit -m "Add gitignore"
git status
```

可以顺带演示一个查看 ignored files 的参数：

```bash
git status --ignored
```

它会显示被忽略的文件，适合排查“为什么 Git 看不到这个文件”。

第一次介绍时可以列几个常见 ignore 例子，但不要试图讲完整语法：

```gitignore
.DS_Store
*.log
.env
__pycache__/
node_modules/
dist/
```

这里要强调一个常见误区：`.gitignore` 只会影响还没有被 Git 追踪的文件。如果一个文件已经 commit 进仓库，后来再把它写进 `.gitignore`，Git 仍然会继续追踪它的变化。这个误区正好可以顺势展开，接着讲两个相关命令。

先补上 `git add -A`：

```bash
echo "content" > extra.txt
rm foobar.txt
git status
git add -A
git status
```

讲解重点：

1. 前面已经用过 `git add <file>` 和 `git add .`，它们主要处理新增和修改的文件。
2. `git add -A` 会把整个仓库里的新增、修改、删除都纳入 staging area，包括用 `rm` 删除但还没告诉 Git 的文件。
3. `git add .` 在较新版本 Git 里默认行为已经和 `-A` 很接近，但课堂上先讲清楚 `-A` 明确覆盖"删除"这个场景，避免学生遇到 `rm` 之后 `git status` 显示 `deleted` 却不知道怎么处理。
4. 用完记得把示例文件恢复（例如重新创建 `foobar.txt`、删掉 `extra.txt`），保持后续演示环境干净。

再讲 `git rm --cached`，用来处理"文件已经被 commit，现在想让 Git 不再追踪它"这种情况：

```bash
echo "local-only.txt" >> .gitignore
echo "some local content" > local-only.txt
git add local-only.txt
git commit -m "Accidentally commit local-only file"

git rm --cached local-only.txt
git status
git commit -m "Stop tracking local-only file"
```

讲解重点：

1. `git rm --cached <file>` 会把文件从 Git 的追踪和下一次 commit 中移除，但保留本地磁盘上的文件内容。
2. 这正好用来修复前面提到的误区：文件已经进了 Git 历史，光靠改 `.gitignore` 不够，还需要 `git rm --cached` 主动让 Git 停止追踪它。
3. 需要注意：这个操作只是在历史里新增一次"删除"记录，之前的 commit 里仍然能看到这个文件曾经存在过；如果文件内容涉及密钥等敏感信息，光 `git rm --cached` 并不能把它从历史里彻底抹掉，更彻底的处理方式不在这里展开。
4. 对比普通的 `git rm <file>`：普通 `git rm` 会同时删除本地文件；`git rm --cached` 只解除追踪，本地文件还在。

#### 10. `git config`

第十个命令是 `git config`。课前已经让学生配置过 `user.name` 和 `user.email`，这里把它放回 Git 的整体模型里解释：Git 除了管理文件历史，也有一套配置系统。

先查看当前配置：

```bash
git config --list
git config --global --list
```

讲解重点：

1. `git config` 用来读取和修改 Git 配置。
2. `user.name` 和 `user.email` 会写进 commit 作者信息里。
3. `user.email` 不是 GitHub 登录密码，也不是 token，只是 commit 作者身份的一部分。
4. 如果学生发现提交作者不对，通常就是这里配置错了。

回顾课前配置：

```bash
git config --global user.name "Your Name"
git config --global user.email "foobar@example.com"
```

这里解释 `--global`：它表示配置写到当前操作系统用户的全局 Git 配置里，之后这个用户创建的大多数仓库都会使用这套配置。

再讲一个 local 配置的例子：

```bash
git config --local user.email "course@example.com"
git config --local --list
```

讲解重点：

1. `--local` 表示只对当前仓库生效。
2. local 配置保存在当前仓库的 `.git/config` 里，不会被 commit，也不会推送到 GitHub。
3. local 配置会覆盖 global 配置。比如某个工作项目要用公司邮箱，个人项目用个人邮箱，就可以用 local 配置。
4. `.gitignore` 是团队共享规则，应该 commit；`.git/config` 是个人本地配置，不会 commit。这个对比可以帮助学生理解 Git 哪些信息属于项目，哪些信息属于本地环境。

可以顺带讲两个排查命令：

```bash
git config --get user.name
git config --get user.email
git config --list --show-origin
```

`--show-origin` 可以显示配置来自哪个文件，适合排查“为什么我的配置不是我以为的那个”。

这里可以顺带讲几个高频好用、不会明显增加理解负担的配置：

```bash
git config --global core.quotepath false
git config --global core.excludesfile ~/.gitignore_global
git config --global core.editor "vim"
```

讲解重点：

1. `core.quotepath false` 可以让 Git 在显示中文文件名时更友好，不把路径显示成转义形式。这对中文课程很实用。
2. `core.excludesfile ~/.gitignore_global` 指定一个全局 ignore 文件，适合忽略所有项目都不想提交的本机文件，例如 `.DS_Store`、编辑器临时文件等。
3. `core.editor` 用来指定 Git 需要打开编辑器时使用哪个程序，例如没带 `-m` 的 `git commit`、没带 `-m` 的 `git commit --amend`。如果不配置，Git 通常会依次参考 `$GIT_EDITOR`、`$EDITOR`、系统默认编辑器；很多学生第一次遇到会卡在一个陌生的终端编辑器里退不出来。课堂上可以提醒：初学阶段尽量用 `-m` 避免打开编辑器，如果不小心进去了，常见的 `vi`/`vim` 默认模式下按 `Esc` 再输入 `:wq` 保存退出，或 `:cq` 放弃这次 commit。

全局 ignore 可以这样演示：

```bash
echo ".DS_Store" >> ~/.gitignore_global
echo ".idea/" >> ~/.gitignore_global
```

这里要区分 `.gitignore` 和 global ignore：

1. `.gitignore` 放在仓库里，应该 commit，属于团队共享规则。
2. `~/.gitignore_global` 是个人机器上的规则，不会进入仓库，适合本机系统或编辑器产生的文件。

不建议在这里展开太多个人效率配置。比如 pager、delta、VS Code difftool/mergetool、rebase、push、credential helper、Git LFS 等配置都很有用，但它们依赖具体工具或后续场景，放到对应章节再讲更好。

#### 11. `git branch`

第十一个命令是 `git branch`。前面所有操作都在同一条历史线上进行；从这里开始引入分支，让学生理解 Git 为什么适合做实验、开发新功能和多人协作。

先查看当前分支：

```bash
git branch
```

讲解重点：

1. `git branch` 不带参数时用于列出本地分支。
2. 输出里带 `*` 的分支表示当前所在分支。
3. 分支本质上是一个指针，指向某一个 commit。
4. `HEAD` 表示“当前所在位置”。通常情况下，`HEAD` 指向当前分支，当前分支再指向当前 commit。
5. 所以可以把当前状态理解成：`HEAD -> 当前分支 -> 某个 commit`。

如果当前在 `main` 分支上，新的 commit 产生后，`main` 这个指针会向前移动到新的 commit，`HEAD` 仍然指向 `main`。

创建一个新分支：

```bash
git branch experiment
git branch
```

讲解重点：

1. `git branch experiment` 会基于当前 commit 创建一个新分支。
2. 它只创建分支，不会自动切换过去。
3. 再次运行 `git branch` 时，可以看到 `experiment` 和当前分支同时存在，但 `*` 仍然在原来的分支上。
4. 这为下一节 `git switch` 做铺垫：创建分支和切换分支是两个动作。

此时 `main` 和 `experiment` 暂时指向同一个 commit。等切换到 `experiment` 并提交新 commit 后，两个分支才会开始分叉。后续写具体教程时，可以用 mermaid gitgraph 把这个过程渲染出来；当前大纲里只保留讲解要点。

第一次介绍可以顺带讲两个常用管理操作：

```bash
git branch -m old-name new-name
git branch -d branch-name
```

讲解重点：

1. `git branch -m old-name new-name` 用于重命名分支。如果前面学生的默认分支叫 `master`，这里可以说明之后可以重命名为 `main`，但课堂不一定现场操作。
2. `git branch -d branch-name` 用于删除已经合并、不再需要的本地分支。
3. 暂时不讲 `git branch -D`。它会强制删除分支，容易丢掉还没合并的工作，放到后面再说。

暂时不讲 remote branch，例如 `origin/main`、`git branch -r`、`git branch -a`。这些等进入 Remote GitHub 后再讲，否则学生还没有远程仓库的上下文。

#### 12. `git switch`

第十二个命令是 `git switch`。上一节 `git branch experiment` 只是创建了分支，并没有切换过去；`git switch` 负责切换当前所在分支。

切换到 `experiment`：

```bash
git switch experiment
git branch
git status
```

讲解重点：

1. `git switch experiment` 会把当前分支切换到 `experiment`。
2. 再运行 `git branch`，可以看到 `*` 移到了 `experiment` 前面。
3. 从指针模型看，切换分支就是让 `HEAD` 指向另一个分支。

此时两个分支仍然指向同一个 commit，只是当前所在分支从 `main` 变成了 `experiment`。

接着在 `experiment` 分支上做一次提交：

```bash
echo "experiment idea" >> foobar.txt
git status
git add foobar.txt
git commit -m "Try experiment idea"
git log --oneline
```

讲解重点：

1. 当前在 `experiment` 分支上，所以新的 commit 会让 `experiment` 指针向前移动。
2. `main` 仍然停留在原来的 commit。
3. 这就是分支的核心价值：可以在不影响主线的情况下做实验。

这里要讲清楚：新的 `commit D` 的父提交是 `commit C`，所以 `experiment` 是从 `main` 当时的位置长出来的一条新线。具体分叉效果后续用 mermaid gitgraph 展示。

然后切回 `main`：

```bash
git switch main
git branch
cat foobar.txt
git log --oneline
```

让学生观察：

1. `*` 回到了 `main`。
2. `foobar.txt` 里刚才在 `experiment` 上新增的内容消失了，因为当前 working directory 会跟随当前分支切换。
3. `git log --oneline` 在 `main` 上看不到 `experiment` 的最新 commit，因为当前分支没有指向那条历史。

这时可以第一次引入观察分支历史的命令：

```bash
git log --oneline --graph --all
```

`--graph` 在终端里显示历史结构，`--all` 显示所有分支，`--oneline` 让输出更紧凑。这个命令不需要学生马上背下来，但很适合用来观察分支是否分叉；正式教程里的视觉图可以后续用 mermaid gitgraph 渲染。

第一次介绍可以顺带讲一个高频用法：

```bash
git switch -c feature-name
```

`git switch -c feature-name` 表示创建并切换到新分支，等价于先 `git branch feature-name` 再 `git switch feature-name`。课堂上建议先演示拆开的两个动作，再讲 `-c` 快捷方式。

可以再提一个小快捷方式：

```bash
git switch -
```

它会切回上一个所在分支，类似命令行里的 `cd -`。这个很好用，但不是主线重点。

切换分支前要提醒学生：最好先让 working directory 保持 clean。也就是先 `git status`，确认没有未处理的修改。否则 Git 可能阻止切换，或者切换后学生不知道修改属于哪个分支。

#### 13. `git checkout`

第十三个命令是 `git checkout`。这一节不需要详细展开，因为前面已经分别讲过 `git switch` 和 `git restore`。这里的重点是：`checkout` 是一个历史更久、职责更混合的命令，过去同时承担了“切换分支”和“恢复文件”的工作。

先讲它和 `git switch` 的关系：

```bash
git checkout experiment
git checkout -b feature-name
```

对应现在更清晰的写法：

```bash
git switch experiment
git switch -c feature-name
```

再讲它和 `git restore` 的关系：

```bash
git checkout -- foobar.txt
```

对应现在更清晰的写法：

```bash
git restore foobar.txt
```

讲解重点：

1. `git checkout <branch>` 是旧式切换分支命令，现在课堂主线优先使用 `git switch <branch>`。
2. `git checkout -b <branch>` 是旧式创建并切换分支命令，现在课堂主线优先使用 `git switch -c <branch>`。
3. `git checkout -- <file>` 是旧式恢复文件命令，现在课堂主线优先使用 `git restore <file>`。
4. 学生需要认识 `checkout`，因为很多老教程、博客、项目文档仍然大量使用它。
5. 但初学阶段不建议把 `checkout` 当作主线命令，否则它会把“切换分支”和“恢复文件”两个概念混在一起。

暂时不讲 `git checkout <commit>` 和 detached HEAD。这个概念很重要，但需要学生先对 commit、branch、HEAD 有更稳定的理解，可以后面再安排。

#### 14. `git merge`

第十四个命令是 `git merge`。前面已经创建了 `experiment` 分支，并在上面做了一次提交；现在要把这条分支上的成果合回 `main`。

先确认当前在 `main`：

```bash
git switch main
git status
git branch
```

讲解重点：

1. merge 的方向很重要：`git merge experiment` 的意思是把 `experiment` 合入当前分支。
2. 所以如果要把实验成果合回主线，必须先切到 `main`，再 merge `experiment`。
3. merge 前最好先 `git status`，确认 working directory 是 clean 的。

执行合并：

```bash
git merge experiment
git status
cat foobar.txt
git log --oneline --graph --all
```

讲解重点：

1. `git merge experiment` 会把 `experiment` 分支包含、但当前 `main` 还没有的提交合入 `main`。
2. 在当前课堂状态下，`main` 自从创建 `experiment` 之后没有新的 commit，所以这次通常是 fast-forward merge。
3. fast-forward merge 可以理解为：`main` 指针直接向前移动到 `experiment` 指向的 commit，没有产生额外的 merge commit。
4. 合并后，`main` 和 `experiment` 会指向同一个最新 commit。
5. `foobar.txt` 里应该能看到之前只在 `experiment` 上新增的内容。

合并完成后，可以删除已经不需要的本地分支：

```bash
git branch -d experiment
git branch
```

讲解重点：

1. 删除分支不会删除 commit，只是删除这个分支名字。
2. 因为 `experiment` 已经合入 `main`，所以 `git branch -d experiment` 是安全的。
3. 这可以帮助学生理解：分支是指针，不是把代码复制了一份。
4. 如果分支还没有合并，`git branch -d` 会拒绝删除并提示。这时可以顺带提一句 `git branch -D branch-name`（大写 `-D`）：它会强制删除分支，即使里面的提交还没有合并到任何地方。可以现场对比：`git branch -d` 是"确认安全才删"，`git branch -D` 是"我确定要删，不管有没有合并"；虽然底层 commit 短期内通常还能通过 reflog 找回（这个概念这里不展开），但初学阶段只在确实想放弃这个分支时才使用 `-D`。

第一次介绍 `git merge` 时先只讲 fast-forward。暂时不讲 non-fast-forward merge、merge commit、merge conflict。下一节可以专门设计一个冲突场景，让学生理解为什么多人协作时需要处理冲突。

#### 15. Merge conflict

`git merge` 之后可以继续讲 merge conflict。虽然真实工作里冲突经常发生在多人协作、`git pull`、Pull Request 里，但第一次教学建议还是先在本地构造冲突。原因是：状态可控、命令少、学生能先看清楚冲突的本质。

这里要先讲清楚一个观点：

1. merge conflict 不是 GitHub 独有的问题。
2. 只要两条历史分支修改了同一个文件的同一段内容，Git 无法自动判断该保留哪一边，就可能产生冲突。
3. remote / GitHub 只是让多人更容易产生分叉；真正检测和解决冲突的动作仍然发生在 Git 合并历史的时候。

先从 clean 的 `main` 开始，创建一个会产生冲突的分支：

```bash
git switch main
git status
git switch -c conflict-a
printf "hello from conflict-a\nsecond line\nexperiment idea\n" > foobar.txt
git add foobar.txt
git commit -m "Update greeting on conflict branch"
```

然后回到 `main`，修改同一行，但改成另一个内容：

```bash
git switch main
printf "hello from main\nsecond line\nexperiment idea\n" > foobar.txt
git add foobar.txt
git commit -m "Update greeting on main"
```

现在把 `conflict-a` 合入 `main`：

```bash
git merge conflict-a
git status
cat foobar.txt
```

讲解重点：

1. 这次 `main` 和 `conflict-a` 都修改了 `foobar.txt` 的第一行。
2. Git 不知道应该保留 `main` 的版本，还是 `conflict-a` 的版本，所以暂停 merge，让人来决定。
3. `git status` 会显示当前有 unmerged paths。
4. 文件里会出现 conflict markers，例如 `<<<<<<<`、`=======`、`>>>>>>>`。

解释 conflict markers：

```plaintext
<<<<<<< HEAD
hello from main
=======
hello from conflict-a
>>>>>>> conflict-a
```

讲解重点：

1. `HEAD` 这一边表示当前分支，也就是正在接收合并的 `main`。
2. `=======` 是两边内容的分隔线。
3. `>>>>>>> conflict-a` 这一边表示被合并进来的分支。
4. 解决冲突不是删除某一边这么简单，而是根据真实意图编辑成最终想要的内容。

这里可以顺带提一个能让冲突更容易看懂的配置：

```bash
git config --global merge.conflictstyle zdiff3
```

讲解重点：

1. 默认的冲突标记只显示"我这边"和"对方那边"两份内容，`zdiff3` 会额外显示两边分叉之前的共同祖先内容，格式类似：

```plaintext
<<<<<<< HEAD
hello from main
||||||| base
hello git
=======
hello from conflict-a
>>>>>>> conflict-a
```

2. 多出来的 `||||||| base` 段能帮助判断"这段内容原本是什么样、两边各自改成了什么"，对复杂冲突尤其有用。
3. 这是个人 Git 配置，属于效率优化，不是解决冲突必须掌握的内容，看时间决定是否现场演示。

课堂上可以把文件改成一个明确的最终版本：

```bash
printf "hello from main and conflict branch\nsecond line\nexperiment idea\n" > foobar.txt
git add foobar.txt
git status
git commit -m "Resolve greeting conflict"
```

讲解重点：

1. 解决冲突的步骤是：编辑文件，删除 conflict markers，保留最终想要的内容。
2. `git add foobar.txt` 在这里的意思是告诉 Git：这个文件的冲突已经解决。
3. `git commit` 完成这次 merge。
4. 解决完后用 `git status` 和 `git log --oneline --graph --all` 检查结果。

如果学生在冲突中途搞乱了，可以讲一个逃生命令：

```bash
git merge --abort
```

它会放弃这次 merge，尽量回到 merge 之前的状态。这个命令很实用，但要提醒学生：真实项目里执行前先确认没有其它重要修改混在工作区里。

这一节不需要把 remote 拉进来。等后面讲 GitHub Pull Request 或 `git pull` 时，再回头说明：远程协作里的冲突，本质上仍然是这里学过的 merge conflict，只是冲突的另一边来自远程仓库或别人的分支。

到这里已经演示过两种 merge 结果：`experiment` 合并到 `main` 时是 fast-forward（没有产生额外 merge commit）；`conflict-a` 合并到 `main` 时因为有冲突，产生了一个真正的 merge commit。可以趁热再讲两个控制 merge 行为的参数。

先看 `--no-ff`：

```bash
git switch main
git switch -c feature-note
echo "feature note" >> foobar.txt
git add foobar.txt
git commit -m "Add feature note"

git switch main
git merge --no-ff feature-note
git log --oneline --graph --all
```

讲解重点：

1. 这次 `main` 没有新的 commit，本来会是 fast-forward，但 `--no-ff` 强制 Git 创建一个 merge commit，即使技术上可以直接快进。
2. 好处是历史里能清楚看到"这里发生过一次分支合并"，`git log --graph` 上会有明显的分叉再汇合，而不是一条直线。
3. 一些团队的分支策略会统一要求 `--no-ff`，方便回溯每个 feature 分支的边界。

再看 `--ff-only`：

```bash
git branch -d feature-note
git switch -c feature-two
echo "feature two" >> foobar.txt
git add foobar.txt
git commit -m "Add feature two"

git switch main
git merge --ff-only feature-two
```

讲解重点：

1. `--ff-only` 表示"只允许 fast-forward，否则拒绝合并"。
2. 如果 `main` 在这期间有新的、不在 `feature-two` 里的 commit，这条命令会直接失败，而不是自动创建 merge commit。
3. 这适合一些希望保持线性历史、不想意外产生 merge commit 的场景，属于团队分支策略的一种选择，课堂上点到为止即可。

这两个参数不影响冲突本身的处理方式，只是决定"什么情况下产生 merge commit、以及是否允许 Git 自动决定"，适合放在学生已经见过 fast-forward 和真正的 merge commit 之后再讲。

#### 16. Git aliases

学完一批高频命令之后，可以顺手讲 Git aliases。alias 通常是通过 `git config` 配置出来的命令缩写。

查看已有 alias：

```bash
git config --global --get-regexp '^alias\.'
```

配置几个适合课堂的 alias：

```bash
git config --global alias.st status
git config --global alias.br branch
git config --global alias.sw switch
git config --global alias.lg "log --oneline --graph --all"
```

之后可以这样使用：

```bash
git st
git br
git sw main
git lg
```

讲解重点：

1. alias 是个人效率工具，不是团队协作的必要条件。
2. 课堂讲解和教程正文里仍然优先写完整命令，例如 `git status`，避免学生因为没有配置 alias 而无法跟上。
3. `git lg` 这类 alias 很适合把长命令固定下来，例如 `git log --oneline --graph --all`。
4. 不建议一开始配置太多 alias。先让学生熟悉原始命令，再逐步加自己真正高频使用的缩写。
5. alias 存在于个人 Git 配置里，不会被 commit，也不会影响别人。

如果想删除 alias，可以这样做：

```bash
git config --global --unset alias.st
```

这一节可以很短。趁着还在本地 Git 收尾，正好补上一个前面刻意没提的命令：`git commit -a`。前面讲 `git add` 和 `git commit` 时没提它，为的是先让学生扎实理解 staging area；走到这里，三层模型已经讲完、alias 也讲过，可以补上这个高频简写。

```bash
echo "quick fix" >> foobar.txt
git status
git commit -a -m "Quick fix"
git status
```

讲解重点：

1. `git commit -a` 会自动把所有已经被 Git 追踪、且有修改的文件先 `add`，再执行 commit，相当于省略了中间手动 `git add` 的步骤。
2. 关键限制：它只处理**已经被追踪**的文件的修改，不会把 untracked files 加进来。如果有新文件，仍然需要显式 `git add`。
3. 好处是日常小改动可以少打一条命令；代价是容易在没注意的情况下把不想提交的修改也一起提交进去，所以更适合已经养成"提交前看一眼 `git status`/`git diff`"习惯的阶段。
4. 课堂上可以明确一句话：`-a` 不是必须掌握的技巧，`git add` + `git commit` 分开写永远是更清楚、更不容易出错的写法。

#### 阶段性总结：从本地三层模型到四区域模型

在进入 GitHub 之前，适合回顾一次前面已经建立起来的本地三层模型：

1. Working Directory / Working Tree：当前真实可编辑的文件。
2. Staging Area / Index：准备进入下一次 commit 的变化。
3. Local Repository：本地已经保存下来的 commit 历史。

然后引入第四个区域：Remote Repository。

```plaintext
Remote Repository
        ↑  push
        ↓  fetch / pull

Local Repository
        ↑  commit
        ↓  checkout / reset

Staging Area / Index
        ↑  git add
        ↓  git restore --staged / reset

Working Directory / Working Tree
```

讲解重点：

1. `git add`：把 working directory 的变化放进 staging area。
2. `git commit`：把 staging area 的内容保存进 local repository。
3. `git restore` / `git reset`：用于撤销或移动本地不同区域里的状态。
4. `git push`：把本地 commit 同步到 remote repository。
5. `git fetch` / `git pull`：从 remote repository 获取别人或远程上的新变化。

这里要用 remote 引出 GitHub，但要讲准确：remote 不等于 GitHub。Remote repository 指的是另一个 Git 仓库地址，可以在 GitHub、GitLab、Gitea 这类平台上，也可以是公司内网服务器，甚至可以是本机上的一个 bare repository。

对初学者只需要提一嘴这一点，不展开 bare repo。课堂后续统一使用 GitHub 作为 remote，因为它最常见，也能自然承接 issue、Pull Request、Actions、协作权限等 GitHub 平台能力。

### Remote GitHub

#### 1. GitHub 是什么

进入远程协作之前，先讲 GitHub 是什么，以及它和 Git 的关系。

讲解重点：

1. Git 是一个版本控制工具，主要负责记录代码历史、管理分支、合并修改。
2. GitHub 是一个基于 Git 的代码托管与协作平台。它不是 Git 本身，而是提供了远程仓库托管、网页界面、权限管理、issue、Pull Request、Actions 等协作能力。
3. 本地 Git 仓库可以独立存在，不一定需要 GitHub；GitHub 上的仓库通常也是一个 Git remote repository。
4. remote repository 不一定是 GitHub，也可以是 GitLab、Gitea、公司内网服务器，甚至本机上的 bare repository。课堂只提一嘴即可，不展开 bare repo。
5. 本课后续使用 GitHub，是因为它最常见，并且能自然展示现代软件协作流程：fork、clone、branch、push、Pull Request、code review、CI。

可以用一句话总结：

> Git 负责版本控制，GitHub 负责把 Git 仓库放到网络上，并提供围绕代码协作的一整套平台能力。

这里还可以简单说明 GitHub 上几个学生马上会看到的概念：

1. Repository：一个项目仓库。
2. Owner：仓库所属的个人或组织。
3. README：仓库首页默认展示的说明文档。
4. Issues：用于记录问题、任务、讨论。
5. Pull Request：请求把一个分支或 fork 里的修改合并到目标仓库。
6. Actions：GitHub 提供的自动化系统，常用于测试、构建、部署。

> 从这里开始，我们用真实的代码 repo 来进行教学，方便我们写 issue/pr/workflow，建议用一个比较简单的 python 代码

#### 2. 把本地项目发布到 GitHub

Remote GitHub 的第二节建议从“把本地已有项目 push 到自己的 GitHub repo”开始。这个顺序可以复习前面 local-git 的知识，同时自然引出 remote、origin、push、upstream branch。

先在本地创建一个极小的 Python 项目：

```bash
mkdir hello-github
cd hello-github

printf 'def greet(name):\n    return f"Hello, {name}!"\n\nif __name__ == "__main__":\n    print(greet("GitHub"))\n' > hello.py
printf '# hello-github\n\nA tiny Python project for learning Git and GitHub.\n' > README.md
printf '__pycache__/\n*.pyc\n' > .gitignore

python hello.py
```

然后复习本地 Git 流程：

```bash
git init
git status
git add .
git commit -m "Initial commit"
git log --oneline
```

讲解重点：

1. 这一步没有任何 GitHub 参与，只是在本地创建了一个正常的 Git repository。
2. `README.md` 会成为 GitHub 仓库首页默认展示的说明文档。
3. `.gitignore` 继续作为团队共享规则进入仓库。
4. 这里用小 Python 项目，而不是空文本文件，是为了后面能自然扩展到测试、Actions、CI。

接着到 GitHub 网页上创建一个空仓库：

1. 登录 GitHub。
2. 点击 New repository。
3. Repository name 使用 `hello-github`。
4. 可以选择 public 或 private，课堂上 public 更方便展示。
5. 不要勾选 GitHub 网页里的 README、`.gitignore`、LICENSE，因为本地已经有这些文件。否则远程仓库会先产生一个 commit，学生第一次 push 时会遇到额外分叉。

创建空仓库后，GitHub 会展示一组命令。课堂上重点讲这几条：

```bash
git remote add origin https://github.com/<username>/hello-github.git
git remote -v
git branch -M main
git push -u origin main
```

讲解重点：

1. `git remote add origin <url>`：给远程仓库地址起一个本地名字 `origin`。
2. `origin` 不是特殊服务器名，只是默认习惯名，表示“这个本地仓库主要对应的远程仓库”。
3. `git remote -v` 用来查看当前配置了哪些 remote，以及 fetch/push 用的 URL。
4. `git branch -M main` 把当前分支名改成 `main`。如果前面已经是 `main`，这条命令不会造成概念负担；如果是 `master`，它可以统一课堂环境。
5. `git push -u origin main` 把本地 `main` 分支推送到 `origin` 这个远程仓库。
6. `-u` 是 `--set-upstream` 的简写，用来建立本地 `main` 和远程 `origin/main` 的跟踪关系。之后在这个分支上可以直接使用 `git push`。

push 完之后，回到 GitHub 页面刷新，让学生观察：

1. `README.md` 显示在仓库首页。
2. `hello.py` 和 `.gitignore` 出现在文件列表里。
3. commit history 里能看到刚才本地创建的 `Initial commit`。
4. 这说明本地的 commit 已经同步到了 remote repository。

如果第一次 push 遇到认证问题，先不要展开 token、SSH key 等细节，优先让学生检查 GitHub CLI 登录状态：

```bash
gh auth status
gh auth login
gh auth setup-git
```

`gh auth setup-git` 会把 GitHub CLI 配置为 Git 的 credential helper，让后续 HTTPS push 可以复用 `gh` 的登录状态。这里作为排障提示即可，不要打断 remote / push 的主线。

这里要强调一个常见误区：

1. `git commit` 只是保存到本地仓库。
2. `git push` 才是把本地 commit 发送到远程仓库。
3. 如果只 commit 不 push，GitHub 网页上不会看到你的新修改。

可以再做一次小修改，演示后续日常流程：

```bash
printf '\n## Usage\n\nRun `python hello.py`.\n' >> README.md
git status
git diff
git add README.md
git commit -m "Document usage"
git push
```

讲解重点：

1. 第一次 push 需要完整写 `git push -u origin main`。
2. 建立 upstream 之后，后续通常只需要 `git push`。
3. `git status` 如果显示本地分支 ahead of `origin/main`，意思是本地有 commit 还没有 push。

可以顺带提 GitHub CLI 的快捷方式，但不要作为课堂主线：

```bash
gh repo create hello-github --public --source=. --remote=origin --push
```

这条命令很方便，但它会把“创建 GitHub repo、添加 remote、push”合并成一步。初学阶段建议先手动走一遍完整流程，理解 remote 和 push 之后再用 `gh` 提高效率。

#### 3. 分支协作：在自己仓库里走一遍 branch → PR → merge

第三节讲"用分支协作"，不需要两人配对——直接在自己的 `hello-github` 仓库里练习一遍完整的分支工作流。真实项目里几乎不会让所有人直接 push 到 `main`；即使是自己一个人的项目，也值得养成"改动先开分支、通过 PR 合并"的习惯，这里就在自己的仓库里把这个流程走一遍。

先确认在 `main` 上，并且是最新状态：

```bash
git switch main
git pull
git switch -c improve-readme
```

讲解重点：

1. 先 `git switch main` 加 `git pull`，确保基于最新的 `main` 开始改动。这个仓库目前只有自己在改，`pull` 不会拉到新东西，但这是应该养成的习惯——多人协作时才不会一上来就基于过时的 `main` 开分支。
2. `git switch -c improve-readme` 创建并切换到一个工作分支，分支名描述这次改动，例如 `improve-readme`、`add-tests`、`fix-typo`。

在分支上修改、提交：

```bash
printf '\n## Development\n\nNotes on how this project is organized.\n' >> README.md
git status
git diff
git add README.md
git commit -m "Add development notes"
```

把这个分支 push 到 GitHub：

```bash
git push -u origin improve-readme
```

讲解重点：

1. 这里 push 的不是 `main`，而是 `improve-readme` 分支。
2. `-u origin improve-readme` 建立本地分支和远程分支的跟踪关系。
3. push 完后，GitHub 通常会提示可以创建 Pull Request。

这里可以顺带提两个能简化"新分支第一次 push"的配置：

```bash
git config --global push.default current
git config --global push.autoSetupRemote true
```

讲解重点：

1. 默认情况下，第一次 push 一个新分支必须写完整的 `git push -u origin <branch-name>`，否则 Git 不知道要推到远程的哪个分支。
2. `push.default current` 让 `git push` 在没有指定远程分支时，默认推送到与本地同名的远程分支。
3. `push.autoSetupRemote true`（较新版本 Git 支持）可以让 `git push` 在分支还没有 upstream 时自动创建并建立跟踪关系，效果上接近每次都自动带上 `-u`。
4. 这两个配置能省去一些重复输入，但课堂主线仍然建议先让学生手写完整的 `git push -u origin <branch>`，理解 upstream 是怎么建立的，再决定要不要配置这些简化项。

接着在 GitHub 网页上创建 Pull Request：

1. 打开自己的 repo 页面。
2. 点击 Compare & pull request。
3. 确认 base branch 是 `main`，compare branch 是 `improve-readme`。
4. 填写 PR title 和 description。
5. 创建 Pull Request。

讲解 Pull Request 的本质：

1. Pull Request 不是 Git 的核心命令，而是 GitHub 提供的协作功能。
2. PR 的意思是：请求把一个分支的修改合并到另一个分支；在同一个仓库内的两个分支之间也可以发起 PR，不一定要跨仓库。
3. PR 页面会展示 changed files、commits、conversation、checks 等信息。
4. PR 给团队提供了 review、讨论、自动化测试和合并入口。

review 并 merge（这里是自己 review 自己的 PR，但流程和团队协作一样）：

1. 打开 PR，查看 Files changed——即使是自己的改动，也养成合并前看一眼 diff 的习惯。
2. 点击 Merge pull request。
3. 合并后可以删除远程分支 `improve-readme`。

merge 后同步本地：

```bash
git switch main
git pull
git branch -d improve-readme
```

讲解重点：

1. PR merge 发生在 GitHub 远程仓库上，本地仓库不会自动更新，需要 `git pull`。
2. 本地工作分支已经合并后，可以用 `git branch -d` 删除。
3. 如果 GitHub 页面删除了远程分支，本地的远程分支引用可能还在，后面可以再讲 `git fetch --prune`。

这一节要建立的工作流是：

```plaintext
main 最新状态 -> 新建分支 -> 本地修改 -> commit -> push 分支 -> Pull Request -> review -> merge -> pull 回本地
```

这也是后面讲 Issue、fork + PR、GitHub Actions、code review 的基础。

顺着"删除远程分支"这件事，可以马上讲一下清理方式：前面提到过，PR merge 之后如果在 GitHub 页面删除了远程分支 `improve-readme`，本地的 remote-tracking branch（也就是 `origin/improve-readme` 这个引用）可能还留着，`git branch -r` 或 `git branch -a` 依然能看到它。

```bash
git fetch --prune
git branch -r
```

讲解重点：

1. `git fetch` 默认只负责获取远程的新内容，不会主动删除本地这些"过时的远程分支记录"。
2. `git fetch --prune` 会额外检查：如果某个 remote-tracking branch 对应的远程分支已经不存在了，就把这个本地记录一并删掉。
3. 这不会影响任何本地工作分支或 commit，只是清理"关于远程分支状态"的记录，相对安全。
4. 可以顺带提一句：`git config --global fetch.prune true` 能让这个行为在每次 `git fetch`/`git pull` 时自动发生，不需要每次手动加 `--prune`。

#### 4. Issue + Fork + Pull Request：没有写权限时怎么贡献

第四节把 Issue 和 Fork + Pull Request 合成一次练习。前面第三节是在自己有写权限的仓库里协作；但在开源项目或课程公共仓库里，学生通常没有原仓库写权限，这时候的标准流程是：先有一个 issue 描述任务，然后 fork 仓库、在自己的 fork 里改，发 PR 请求合并回原仓库。

这里使用一个课程专用的共享仓库 `first-contributions`，老师提前建好并保持是仓库 owner，内容很简单：

```plaintext
README.md
CONTRIBUTORS.md
```

上课前，老师在这个仓库里创建一个 issue：

1. 打开 repo 的 Issues 页面。
2. 点击 New issue。
3. Title 写：`Add your name to CONTRIBUTORS.md`。
4. Description 说明任务：把自己的 GitHub username 加进 `CONTRIBUTORS.md`，通过 PR 提交，并在 PR 里写 `Closes #1` 关联这个 issue。

讲解重点：

1. Issue 用来记录问题、需求、任务或讨论，不一定对应 bug，也可以是文档改进、功能建议、课程练习任务。
2. 一个清楚的 issue 应该说明背景、期望结果、验收标准。
3. Issue 是协作入口，PR 是解决这个 issue 的代码变更入口。
4. 因为全班共用同一个 issue，第一个合并的 PR 会真正触发 GitHub 自动关闭这个 issue，其他同学的 PR 依然可以正常合并，只是不会再触发"关闭"这个动作——这是正常现象，不代表后面同学的贡献无效。

再讲 fork 的含义：

1. fork 是在自己 GitHub 账号下复制一份别人的仓库。
2. 学生对自己的 fork 有写权限，即使对老师的原仓库没有写权限。
3. 通过 PR 请求把 fork 里的修改合回原仓库，这是没有写权限时贡献代码的标准方式。
4. fork 是 GitHub 平台能力，不是 Git 的核心命令。

学生在 GitHub 网页上 fork 老师的 repo：

1. 打开老师的 `first-contributions` repo。
2. 点击 Fork。
3. Owner 选择自己的账号。
4. 创建 fork。

然后 clone 自己的 fork：

```bash
git clone https://github.com/<student>/first-contributions.git
cd first-contributions
git status
git remote -v
git branch -vv
```

讲解 `git clone` 做了几件事——这是这门课第一次真正用到 `git clone`（前面自己的 `hello-github` 仓库是本地 `init` 之后 push 上去的，不是 clone 来的）：

1. 从 remote repository 下载文件。
2. 下载 Git 历史，不只是下载当前文件快照。
3. 自动创建本地 `.git` 目录。
4. 自动添加一个名为 `origin` 的 remote，指向被 clone 的仓库——这里指向的是学生自己的 fork，不是老师的原仓库。
5. 自动 checkout 默认分支，通常是 `main`。
6. 建立本地 `main` 和远程 `origin/main` 的跟踪关系。

到这里可以顺带讲 remote branch 的查看方式：

```bash
git branch
git branch -r
git branch -a
```

讲解重点：

1. `git branch`（不带参数）只列出本地分支。
2. `git branch -r` 列出 remote-tracking branches，例如 `origin/main`，它们是本地对远程分支状态的一份只读记录，会在 `fetch`/`pull`/`push` 时更新。
3. `git branch -a` 同时列出本地分支和 remote-tracking branches。

为了后续同步老师原仓库，添加 `upstream`：

```bash
git remote add upstream https://github.com/<teacher>/first-contributions.git
git remote -v
```

讲解 `origin` / `upstream`：

1. `origin`：自己的 fork，自己有写权限。
2. `upstream`：老师的原仓库，通常只有读权限。
3. 命名不是强制的，但这是 GitHub 协作里的常见约定。

学生创建分支并修改：

```bash
git switch -c add-<github-username>
printf '- <github-username>\n' >> CONTRIBUTORS.md
git status
git diff
git add CONTRIBUTORS.md
git commit -m "Add <github-username> to contributors"
git push -u origin add-<github-username>
```

然后在 GitHub 上创建 PR：

1. 打开学生自己的 fork 页面，GitHub 通常会提示 Compare & pull request。
2. base repository 选择老师的原仓库。
3. base branch 选择 `main`。
4. head repository 选择学生自己的 fork。
5. compare branch 选择 `add-<github-username>`。
6. 填写 PR title 和 description，description 里写上 `Closes #1`。
7. 创建 PR。

讲解重点：

1. fork PR 的目标是"从我的 fork 分支合并到老师的原仓库 main"。
2. `Closes #1` 会把这个 PR 和第一步创建的 issue 关联起来；常见关键字还有 `Fixes #1`、`Resolves #1`，课堂用一个即可。
3. PR 页面仍然可以 review、comment、run checks、merge。
4. 老师 merge 后，学生的 fork 不一定自动同步，需要后续 fetch/pull upstream。

老师 review 并 merge PR 后，让学生观察：

1. PR 显示 merged。
2. 如果是第一个合并的 PR，对应 issue 会自动关闭；后面同学的 PR 正常合并，issue 已经是关闭状态。
3. `CONTRIBUTORS.md` 里出现自己的名字。

PR merge 后，可以简单演示同步 fork：

```bash
git switch main
git fetch upstream
git merge upstream/main
git push origin main
```

讲解重点：

1. `git fetch upstream` 从老师原仓库获取最新历史。
2. `git merge upstream/main` 把老师原仓库的 `main` 合入学生本地 `main`。
3. `git push origin main` 把同步后的本地 `main` 推回学生自己的 fork。
4. 这一段对初学者略难，可以作为 fork 流程的收尾展示，不必要求一次完全掌握。

这一节要建立的完整工作流是：

```plaintext
Issue 描述任务 -> 没有写权限 -> fork 到自己账号 -> clone 自己的 fork -> 建分支改动 -> push 到自己的 fork -> 给原仓库发 PR（Closes #1） -> review -> merge -> Issue 关闭 -> 同步 fork
```

这比第三节"自己仓库里走一遍"更接近真实的开源协作场景，也为后面 issue template 和 PR template 铺垫。

#### 5. GitHub repo 里的特殊文件

第五节再讲 GitHub repo 里的特殊文件。放在 issue 和 PR 后面讲更自然，因为学生已经实际创建过 issue 和 PR，此时再看 templates 会知道它们解决什么问题。

先讲最常见的文件：

1. `README.md`：仓库首页默认展示的项目说明。
2. `.gitignore`：告诉 Git 哪些文件不应该被追踪。
3. `LICENSE`：说明别人如何使用、修改、分发这个项目。
4. `CONTRIBUTING.md`：说明如何参与贡献，例如如何提 issue、如何发 PR、代码风格、测试要求。
5. `CODE_OF_CONDUCT.md`：社区行为准则，开源项目里常见。

讲解重点：

1. 这些文件不是 Git 的特殊文件，而是 GitHub 会识别并在网页上特殊展示或链接。
2. `.gitignore` 同时会影响 Git 行为；其他几个主要影响 GitHub 页面和协作流程。
3. 对课程项目来说，至少应该有 `README.md`、`.gitignore`、`CONTRIBUTING.md`。

再讲 issue template：

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

讲解重点：

1. issue template 用来引导提 issue 的人提供足够信息。
2. 它能减少“只有一句话但无法处理”的 issue。
3. 对课程来说，可以设计“作业反馈”、“bug report”、“feature request”等模板。

再讲 PR template：

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

讲解重点：

1. PR template 用来提醒提交者说明改了什么、为什么改、怎么验证。
2. 它能让 review 更高效。
3. 配合 issue 里的 `Closes #1`，可以形成完整任务闭环。

这一节可以让学生给 `first-contributions` repo 添加一个简单的 `CONTRIBUTING.md` 或 PR template，作为一次小练习。

#### 6. GitHub CLI：网页之外的 GitHub 操作方式

这一节轻量讲 GitHub CLI，也就是 `gh`。重点不是让学生背命令，而是让他们知道：GitHub 上很多网页操作也可以在命令行里完成。

先明确边界：

1. `git` 主要操作 Git 版本历史，例如 commit、branch、merge、push、pull。
2. `gh` 主要操作 GitHub 平台对象，例如 repo、issue、Pull Request、workflow。
3. 有些命令看起来重合，例如 `git clone` 和 `gh repo clone`，但 `gh` 更多是在 GitHub 平台语境下做包装和提效。
4. 如果 `gh` 命令记不住，完全可以回到 GitHub 网页操作；网页流程仍然是最适合初学者理解概念的方式。

这里可以提一句 AI 时代的实际价值：`gh` 很适合让 Codex、Claude Code 这类 AI coding agent 在终端里帮助操作 GitHub，例如查看 issue、读取 PR、创建 PR、检查 CI 结果等。网页适合人看，CLI 适合脚本和 agent 操作。

只介绍几个最高频命令：

```bash
gh auth status
gh auth login
gh auth setup-git
```

认证相关：检查登录、登录 GitHub、让 Git push 使用 GitHub CLI 的认证状态。

```bash
gh repo clone owner/repo
gh repo view --web
gh repo create
```

repo 相关：clone GitHub repo、打开网页、创建 repo。`gh repo create` 很方便，但初学阶段前面已经手动走过创建 repo + remote + push 的流程，所以这里只作为提效工具。

```bash
gh issue list
gh issue view 1
gh issue create
```

issue 相关：列出、查看、创建 issue。

```bash
gh pr list
gh pr create
gh pr view --web
gh pr checkout 12
```

PR 相关：列出、创建、查看、checkout 某个 PR。这里最值得强调的是 `gh pr checkout 12`，它可以把某个 PR 拉到本地，方便运行测试、review 或继续修改。

Actions 相关可以先只提一嘴，等下一节 CI 时再展开：

```bash
gh run list
gh run view
```

课堂建议：主线仍然用 GitHub 网页讲 issue 和 PR 的概念；`gh` 作为熟练后的效率工具和 AI agent 友好的操作入口。

#### 7. GitHub Actions：让 GitHub 自动跑检查

第七节讲 GitHub Actions。不要一开始就讲 YAML 语法，而是从一个问题开始：

> PR 里别人提交的代码，靠人眼看不够。我们怎么自动确认它至少能运行、测试能通过？

从这个问题引出 CI：

1. 人会忘记在本地跑测试。
2. 不同人的电脑环境不同，本地能跑不代表别人也能跑。
3. PR merge 前应该有自动检查，减少把坏代码合进主分支的概率。
4. CI 的核心目标是：自动验证代码是否还正常。

先解释 CI/CD：

1. CI 是 Continuous Integration，持续集成。常见内容是自动测试、自动检查、自动构建。
2. CD 可以是 Continuous Delivery / Continuous Deployment，持续交付或持续部署。常见内容是自动发布、自动部署。
3. 这一节先讲 CI，CD 只提一嘴，后续有时间再展开。

再给 GitHub Actions 一个最小模型：

```plaintext
event -> workflow -> job -> step -> command/action
```

讲解重点：

1. event：什么事情触发自动化，例如 `push`、`pull_request`。
2. workflow：写在 `.github/workflows/*.yml` 里的自动化配置。
3. job：一组在 runner 上执行的任务。
4. step：job 里的具体步骤。
5. runner：GitHub 提供的临时运行环境，例如 `ubuntu-latest`。
6. action：别人写好的可复用步骤，例如 checkout 代码、安装 Python。

继续使用前面的 `hello-github` Python 项目，先在本地补一个最小测试：

```bash
printf 'from hello import greet\n\n\ndef test_greet():\n    assert greet("GitHub") == "Hello, GitHub!"\n' > test_hello.py
python -m pip install pytest
python -m pytest
```

讲解重点：

1. 先让测试在本地跑通，再放进 CI。
2. CI 不是魔法，本质上就是在 GitHub 的 runner 里自动执行类似的命令。

提交测试文件：

```bash
git status
git add test_hello.py
git commit -m "Add greeting test"
```

然后创建 workflow 文件：

```bash
mkdir -p .github/workflows
```

文件路径：

```plaintext
.github/workflows/ci.yml
```

workflow 内容：

```yaml
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  test:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: python -m pip install pytest
      - run: python -m pytest
```

讲解重点：

1. `name: CI` 是 workflow 的显示名称。
2. `on` 定义触发条件：push 到 `main` 或创建/更新 PR。
3. `jobs.test` 定义一个名为 `test` 的 job。
4. `runs-on: ubuntu-latest` 表示在 GitHub 提供的 Ubuntu runner 上运行。
5. `actions/checkout@v4` 把仓库代码 checkout 到 runner。
6. `actions/setup-python@v5` 安装指定 Python 版本。
7. `run` 执行普通 shell 命令。

提交并 push workflow：

```bash
git add .github/workflows/ci.yml
git commit -m "Add CI workflow"
git push
```

回到 GitHub 页面观察：

1. Actions tab 里会出现 CI workflow run。
2. PR 页面会出现 checks。
3. 绿色表示通过，红色表示失败。
4. 点进失败的 run 可以看 logs。
5. 真实项目经常要求 checks passed 之后才能 merge。

可以故意制造一次失败来加深理解：

```bash
# 例如临时把 test_hello.py 里的期望字符串改错
```

让学生看到：

1. 本地测试失败是什么样。
2. GitHub Actions 失败是什么样。
3. CI 失败时应该看 log，而不是盲目重跑。

这一节要让学生记住一句话：

> GitHub Actions 让 GitHub 在特定事件发生时，自动帮我们跑一组命令。最常见的用途是 PR 自动测试。

第一次讲不展开 matrix、cache、secrets、deployment、release automation、self-hosted runner、permissions、reusable workflow。这些都是 Actions 的重要能力，但会让初学者在第一遍失去主线。


### 高级 topics

> 这里存放高级的 topics，因为课程时间限制，大概率不会在课堂上展开，但是可以给学生提供必要的指引

1. git us content-addressed object database, commit/tree/blob/branch/tag 的关系，git 的内部数据结构
2. cherry-pick
3. stash
4. git worktree：适合在学生已经理解 branch、HEAD、working tree 之后再讲。它解决的是同一个仓库同时 checkout 多个分支、并行处理多个任务的问题，可以和 `git stash` 放在“上下文切换”场景里对照。
5. github template
6. GitHub Actions 进阶：matrix、cache、secrets、deployment、release automation、self-hosted runner、permissions、reusable workflow。
7. `git commit --amend`：用一个新 commit 替换最近一次 commit（包括内容和/或 message），会改变 commit hash；只适合还没有 push、也没有被人基于它继续工作的本地最新 commit。
8. `git restore --source=<commit>`：从指定 commit 恢复某个文件到 working directory，依赖学生已经理解 commit hash、HEAD、checkout/reset 的关系。
9. `git checkout <commit>` / detached HEAD：直接切到某个 commit，此时 `HEAD` 不再指向任何分支；对理解 Git 内部模型很有帮助，但容易让初学者困惑分支和 commit 的区别。
10. `diff.algorithm = histogram`、`diff.colorMoved = default`：让 `git diff` 输出在移动代码块等场景下更易读，属于 diff 体验优化，不影响核心概念。
11. pager、delta、VS Code difftool/mergetool：能显著改善查看 diff、log、冲突的体验，但依赖额外工具安装配置，适合作为教师个人工作流展示。
12. git hooks：例如本地的 pre-commit、prepare-commit-msg、commit-msg，以及配合 remote 使用的 pre-push；横跨 local-git 和 Remote GitHub 两部分内容，适合单独作为一个专题展开。
13. `git add -p` / `git add --patch`：用于 partial staging，把同一个文件里的修改拆成 hunk 后逐个选择是否加入 staging area。常用按键包括 `y`、`n`、`s`、`q`。它很实用，但需要学生已经理解 `git diff`、`git diff --staged`、staging area 和 commit 边界，适合作为“如何只提交一部分修改”的高级主题。

## 课后练习

学生每个人创建自己的 github profile repo，并将链接发给助教检查

## References

> 参考的资料（教程/文档/其他）

1. mermaid gitghraph <-- 这个用来给教程插图
2. git pro
3. roadmap.sh git+github
4. learngitbranching <-- 这个让学生自己联系
5. conventional commits <-- 这个可以让学生了解 commit message 的规范
