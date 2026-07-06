---
theme: seriph
background: https://cover.sli.dev
title: Git & GitHub
info: |
  ## Git & GitHub
  从命令行操作，到 Pull Request 协作。
class: text-center
drawings:
  persist: false
transition: slide-left
comark: true
---

# Git & GitHub

<div @click="$slidev.nav.next" class="mt-12 py-1" hover:bg="white op-10">
  <carbon:arrow-right class="inline-block text-2xl" />
</div>

<!--
课程首页。后续每个 topic 的第一页用 layout: section 做分隔。
-->

---
layout: section
---

# 为什么需要 Git

Local Git · 00

<!--
在真正敲下第一条 Git 命令之前，先花几分钟想清楚一件事：Git 到底是用来干什么的，
为什么我们不能就这么随便应付过去。
-->

---
layout: statement
---

<div class="text-2xl leading-relaxed">
你正在写一个小项目，今天改了不少代码。
</div>

<div v-click class="text-2xl leading-relaxed mt-6">
程序突然跑不起来了，但你已经记不清改过哪些地方。
</div>

<div v-click class="text-2xl leading-relaxed mt-6">
想退回昨天能跑的版本，又想留住今天写的一部分东西。
</div>

<div v-click class="text-xl opacity-70 mt-10">
两个人一起改同一份代码呢？谁改了什么、怎么合并？
</div>

<!--
在动手之前，先花十秒钟想这个场景，让学生带着问题往下听。

这些问题靠"手动复制文件夹"是解决不了的——project_final.zip、project_final_v2.zip、
project_final_v2_真的最终版.zip 这种命名迟早会把自己绕晕。停顿一下，留时间让
学生会心一笑（呼应首页那句 tagline）。
-->

---
layout: center
class: text-center
---

# Git 要解决的

# 不是"保存文件"

<div v-click class="text-2xl mt-8">
而是记录项目随时间变化的<b>历史</b>（history）
</div>

<div v-click class="text-lg opacity-70 mt-6">
看差异 · 保存阶段性成果 · 回到过去 · 支持多人协作
</div>

<!--
从场景引出一句关键的话：我们需要一个专门管理代码变化的工具。这个工具真正要
解决的核心问题，不是"保存文件"，而是记录项目随时间变化的历史——让我们随时能
看差异、保存阶段性成果、回到过去的版本，并且支持多人协作。
-->

---

# 版本控制走过的三个阶段

<div v-click class="p-4 rounded border border-main mt-4">
<b>手动复制文件</b>——project_final、project_final_v2……混乱、不可追踪、没法协作
</div>

<div v-click class="p-4 rounded border border-main mt-4">
<b>集中式（centralized）</b>——CVS、SVN，依赖中心服务器 checkout / update / commit
</div>

<div v-click class="p-4 rounded border border-main mt-4">
<b>分布式（distributed）</b>——Git，每个人本地都有完整历史，远程只用来同步协作
</div>

<!--
[click] 最朴素的做法：每次改动前复制一份文件夹。问题很明显：谁改了什么、什么
时候改的、为什么这么改，全靠脑子记，忘了就没了。

[click] 集中式版本控制系统比"复制文件夹"靠谱太多了，但对中心服务器依赖较重
——离线能力和分支体验都比较有限，连不上服务器基本就干不了活。

[click] Git 走的就是分布式这条路：每个开发者本地都有一份完整的仓库历史，可以
离线提交、离线查看日志、随时创建分支；远程仓库更多是用来同步和协作，而不是
唯一的历史来源。讲到这里就够了，不需要展开 Git 内部是怎么实现的——现在没完全
理解也没关系，后面动手敲命令会慢慢建立起真正的直觉。
-->

---
layout: section
---

# `git init`

Local Git · 01

<!--
好，工具都装好、身份也配置好了，上一节也聊清楚了为什么需要 Git。现在正式开始
动手，这门课的第一个 Git 命令，就是 git init。

Git 要管理一个项目的历史，第一步永远是先让它知道"从现在开始，这个目录归我管"
——这正是 git init 要做的事。
-->

---

# 动手写

在 `playground` 目录里，让 Git 开始"盯上"这个目录：

```bash
mkdir playground
cd playground
git init
ls -a
```

<div v-click class="mt-6">

```
Initialized empty Git repository in /path/to/your/playground/.git/

.       ..      .git
```

</div>

<!--
课堂上不会直接在什么正经项目里操作，而是专门开一个 playground 目录，把它当成实验场。

[click] 你自己电脑上跑出来的那行 "Initialized empty Git repository in ..."，
路径部分肯定和我的不一样——那是你自己 playground 文件夹实际所在的位置，这是
正常的，不用怀疑自己哪里操作错了。
-->

---

# 这一步做了什么

<div v-click class="mt-6 text-xl">
把当前目录变成一个 Git repository（仓库）
</div>

<div v-click class="mt-6 text-xl">
多出一个 <code>.git</code> 隐藏目录——仓库的一切都在里面
</div>

<div v-click class="mt-6 text-xl">
不会自动保存文件，也不会自动创建 commit——只是打开了版本管理这个开关
</div>

<!--
[click] git init 的作用很单纯：把当前目录变成一个 Git repository。就这一件事。

[click] 这个 .git 目录保存了这个仓库未来所有的历史记录、配置信息、分支指针……
可以说仓库的一切都在这里面。这一节只需要记住"很重要，千万别手贱删掉它"就够了，
具体里面装了什么，后面讲到内部结构时再展开。

[click] git init 不会自动帮你保存任何文件，也不会自动创建 commit。它只是给这个
目录打开了"Git 版本管理"这个开关，仅此而已——后面的 git add、git commit 才是
真正开始记录内容的动作。
-->

---

# 两个小提醒

<div v-click class="p-4 rounded border border-main mt-4">
不要图省事在家目录 / 桌面根目录这类大目录里 <code>git init</code>——Git 会开始关心这个目录下的一切
</div>

<div v-click class="p-4 rounded border border-main mt-6">
默认分支应该是 <code>main</code>（课前已配置 <code>init.defaultBranch</code>）；如果看到 <code>master</code>，补一句配置就好
</div>

<!--
[click] 一旦执行 git init，Git 理论上会开始关心这个目录下的一切，很容易把一堆
互不相关的文件混进同一个仓库的上下文里，后面清理起来很麻烦。养成习惯：想清楚
"这次要管理的到底是哪个项目"，再在对应的目录里 git init。

[click] 因为课前 Prerequisites 里已经统一配置过 init.defaultBranch main，理论
上大家看到的默认分支都应该叫 main。如果个别学生看到 master，说明那一步课前配置
漏做了，补一句 git config --global init.defaultBranch main 就行，不用纠结为
什么会这样——纯粹是个历史遗留的命名问题，和 Git 的核心概念没关系。
-->

---

# 顺带一提

`git init <directory>` 可以直接创建并初始化目录，不用自己先 `mkdir`

<div v-click class="mt-6 text-lg opacity-80">
课堂上还是优先用 <code>mkdir && cd && git init</code> 三步走——更容易建立"在哪个目录操作，Git 就管哪个目录"的直觉
</div>

<div v-click class="mt-12 pt-6 border-t border-main text-2xl">
下一步：学会读懂 Git 现在的状态 → <code>git status</code>
</div>

<!--
git init my-project 可以直接创建并初始化 my-project 这个目录。这个用法记一下
就行，课堂上我们还是优先用三步走的写法——这样能更直观地感受到"在哪个目录下执行
命令，Git 就初始化的是哪个目录"，这个直觉后面会一直有用。

[click] 下一步，我们要学会读懂 Git 现在到底是什么状态——也就是这门课最重要的
一个命令：git status。
-->

---
layout: section
---

# `git status`

Local Git · 02

<!--
git init 只是打开了开关，接下来这个命令才是整节课最重要的观察工具。以后每做
一步操作，前后都可以先跑一下它，看看 Git 眼里现在是什么情况——这个习惯值得
从第一天就养成。
-->

---

# 先看看现在是什么状态

```bash
git status
```

<div v-click class="mt-4">

```
On branch main

No commits yet

nothing to commit (create/copy files and use "git add" to track)
```

</div>

<!--
git status 不会修改任何文件或 Git 历史，它只负责如实汇报当前状态。刚 git init
完、什么文件都没有的时候，它会告诉你：在 main 分支上，还没有任何 commit，
working tree 是干净的。
-->

---

# 第一个核心状态：untracked

```bash
echo "hello git" > foobar.txt
git status
```

<div v-click class="mt-4">

```
Untracked files:
	foobar.txt
```

</div>

<div v-click class="mt-6 text-lg opacity-80">
Git 不会自动追踪所有新文件——新文件要不要管，得自己明确告诉它
</div>

<!--
untracked 的意思是：这个文件确实存在于 working directory 里，但 Git 还没有
把它纳入版本管理。这一节先不用急着搞懂 staging area 的完整模型，记住这一件
事就够。

[click] 之后每个命令演示前后都尽量跑一下 git status——形成"不确定仓库现在是
什么状态，就先 git status"的反射，比背下每个命令的细节更重要。
-->

---

# 顺带认识

```bash
git status --short
git status -s
```

<div v-click class="mt-4">

```
?? foobar.txt
```

</div>

<div v-click class="mt-6 text-lg opacity-80">
第一次学的时候，默认输出更容易看懂——这门课默认输出优先
</div>

<!--
?? 就表示 untracked。--short/-s 适合熟悉命令之后快速扫一眼状态。

[click] 下一步，我们要回答这个 untracked 状态该怎么处理——也就是 git add。
-->

---
layout: section
---

# `git add`

Local Git · 03

<!--
上一节 git status 告诉我们 foobar.txt 是个 untracked file。这一节回答那个
自然的下一个问题：这个文件该怎么进入 Git 的管理范围？
-->

---

# 把变化放进 staging area

```bash
git add foobar.txt
git status
```

<div v-click class="mt-4">

```
Changes to be committed:
	new file:   foobar.txt
```

</div>

<!--
git add 的作用是把文件的当前变化放进 staging area（暂存区，也叫 index）——
也就是"准备提交"的那个区域。对新文件来说，意味着让 Git 开始追踪它，并把此刻
的内容放进下一次 commit 的候选集合里。git add 本身还不是保存历史，真正写进
历史的是后面的 git commit。
-->

---
layout: center
class: text-center
---

# Staging Area / Index

<div class="text-lg opacity-70 mt-4">↑ git add</div>

# Working Directory / Working Tree

<!--
先建立一个简化版模型，完整的三层模型要等 git log 之后再总结。现在只需要理解：
working directory 里可以同时存在很多变化，但你可以挑其中一部分放进 staging
area，作为下一次 commit 的候选内容。
-->

---

# 两个高频用法

```bash
git add foobar.txt
git add .
```

<div v-click class="mt-6 text-lg opacity-80">
git add . 方便，但用之前最好先 git status 确认一下
</div>

<!--
git add foobar.txt 用于明确添加某一个文件；git add . 会把当前目录下所有的
变化一次性加进去。git add -A 这类变体先不展开，重点是把 staging area 这个
概念立住。

[click] 下一步，staging area 里已经有内容了，是时候把它真正写进历史——也就
是 git commit。
-->

---
layout: section
---

# `git commit`

Local Git · 04

<!--
staging area 里已经准备好了 foobar.txt。现在要做那件真正重要的事：把它写进
Git 的历史。
-->

---

# 写进历史

```bash
git commit -m "Add foobar file"
git status
```

<div v-click class="mt-4">

```
[main (root-commit) bc3a22a] Add foobar file
 1 file changed, 1 insertion(+)
```

</div>

<!--
git commit 才是真正创建历史记录的命令——git add 只是准备，commit 才是保存。
一次 commit 可以理解为项目在某个时刻的一张快照，带着 message、作者、时间、
commit hash。commit 默认只提交 staging area 里的内容，不会自动提交所有工作
目录里的变化。
-->

---

# 一句话记住 `-m`

```bash
git commit -m "message"
```

<div v-click class="mt-6 text-lg opacity-80">
不加 -m 会打开一个陌生的命令行编辑器——课堂上先一直用 -m
</div>

<!--
不加 -m，Git 会打开默认编辑器（由 $GIT_EDITOR、$EDITOR 或 git config
core.editor 决定）等你输入 message；具体怎么配置留到 git config 那一节。

message 要说清楚这次改了什么，别写 update/fix/aaa 这种没有信息量的话；一次
commit 尽量对应一个清晰的小改动。

--amend 和 -a 先不展开，等更熟悉 commit hash、staging area 之后再解禁。

[click] 下一步，我们已经有了第一次 commit，该看看 Git 是怎么记录这些历史
的——也就是 git log。
-->

---
layout: section
---

# `git log`

Local Git · 05

<!--
现在已经有了一次 commit。是时候看看 Git 到底把历史记成了什么样。
-->

---

# 查看历史

```bash
git log
```

<div v-click class="mt-4">

```
commit bc3a22a...
Author: Course Instructor <instructor@example.com>
Date:   Mon Jul 6 22:40:55 2026 +0800

    Add foobar file
```

</div>

<!--
默认按时间倒序排列，最新的 commit 在最上面。重点看四样东西：commit hash、
Author、Date、commit message。hash 先当成"版本号"理解就够，后面讲内部对象
模型时再回来解释。如果 git log 打开分页界面卡住，按 q 退出。
-->

---

# 制造第二次 commit，历史才有意义

```bash
echo "second line" >> foobar.txt
git add foobar.txt
git commit -m "Update foobar file"
git log --oneline
```

<div v-click class="mt-4">

```
e9d380a Update foobar file
bc3a22a Add foobar file
```

</div>

<!--
现在历史里有两条 commit，新的在上面，旧的在下面，各自带着自己的 hash 和
message。--oneline 把每条 commit 压缩成一行，历史一多起来比默认输出好扫视
得多。--graph --all --decorate 这类参数留到讲 branch 之后再用。
-->

---
layout: section
---

# 阶段性总结

Git 的三层模型

<!--
学完 init/status/add/commit/log 这一路下来，现在有足够的素材，可以正式把
Git 在本地的三个核心区域串起来看了。
-->

---
layout: image
image: ./assets/diagrams/local-git/05-recap-three-layers.svg
backgroundSize: contain
---

<!--
Working Directory：当前真实可编辑的文件。Staging Area：准备进入下一次
commit 的变化集合。Local Repository：已经通过 commit 保存下来的历史。
git add 把变化从 working directory 挪进 staging area；git commit 把
staging area 的内容保存进 local repository；反方向的 restore --staged 和
checkout/reset 我们还没正式学，图上先放着，后面讲到时回头对照。
-->

---

# 把命令和搬运对应起来

<div class="text-lg leading-relaxed mt-4">
foobar.txt 一开始 untracked，待在 working directory；<br/>
git add 之后挪进 staging area；<br/>
git commit 之后进了 local repository——两次 commit，两张快照。
</div>

<!--
这套模型不需要死记成抽象定义，最好的办法是回头对着 foobar.txt 的例子过一遍，
把命令和这三层之间的搬运对应起来，比背图本身更有用。

下一步，我们接着看一个 git status 还没完全回答的问题：具体改了什么内容？
这就是 git diff。
-->

---
layout: section
---

# `git diff`

Local Git · 06

<!--
git status 能告诉我们"哪些文件变了"，但它不会直接给你看"具体改了什么"。
-->

---

# 看具体差异

```bash
echo "third line" >> foobar.txt
git diff
```

<div v-click class="mt-4">

```
--- a/foobar.txt
+++ b/foobar.txt
@@ -1,2 +1,3 @@
 hello git
 second line
+third line
```

</div>

<!--
git diff 默认显示的是 working directory 里尚未进入 staging area 的修改。
- 开头的行表示删除或旧内容，+ 开头的行表示新增或新内容。不需要逐字解释
diff header 里的每个字段，先能看懂哪几行变了就够。分页界面同样按 q 退出。
-->

---

# staging 之后，diff 去哪了

```bash
git add foobar.txt
git diff
git diff --staged
```

<div v-click class="mt-6 text-lg opacity-80">
git add 之后，working directory 和 staging area 已经一致——git diff 什么都不显示
</div>

<!--
这是个关键观察：git add 之后默认 git diff 可能没有输出，因为工作目录和
staging area 已经一致；但 git diff --staged 会显示 staging area 里准备
提交的变化，这次才是我们真正想看的那段 diff。git diff --cached 和
--staged 基本等价，课堂上统一用 --staged。

[click] 下一步，如果发现改错了想撤销，该怎么办？这就是 git restore。
-->

---
layout: section
---

# `git restore`

Local Git · 07

<!--
刚才用 git diff 看到了修改。接下来要回答一个很实际的问题：如果发现改错了，
怎么撤销？这一节先只讲两个最高频的场景。
-->

---

# 取消 staged，但修改还在

```bash
git restore --staged foobar.txt
git diff
```

<div v-click class="mt-4">

```
+third line
```

</div>

<!--
git restore --staged foobar.txt 把文件从 staging area 拿出来，不会删除文件
内容，修改还留在 working directory 里——执行完再看 git diff，仍然能看到
third line。对应三层模型里 staging area 退回 working directory 这条路。
-->

---

# 丢掉工作目录里的修改

```bash
git restore foobar.txt
git status
```

<div v-click class="mt-4">

```
nothing to commit, working tree clean
```

</div>

<!--
这次是真的丢了——third line 不见了。这会丢掉尚未 commit 的本地修改，需要
谨慎使用，执行前最好先 git status / git diff 确认。一定要区分：
restore --staged 是取消 staging，修改还在；restore <file> 是丢掉工作目录
修改，内容真的没了。git restore . 会一次性丢掉所有尚未 staged 的修改，
更方便也更危险。

[click] 下一步，我们要学一个和"撤销"关系更密切、但也更容易用错的命令——
git reset。
-->

---
layout: section
---

# `git reset`

Local Git · 08

<!--
git reset 比前面几个命令更容易用错，这一节只围绕"撤销最近一次本地 commit"
这一个场景展开。HEAD 表示当前所在的 commit，HEAD~1 就是上一个。
-->

---

# `--soft`：退指针，修改留在 staging area

```bash
git commit -m "Bad experiment"
git reset --soft HEAD~1
git status
```

<div v-click class="mt-4">

```
Changes to be committed:
	modified:   foobar.txt
```

</div>

<!--
git reset --soft HEAD~1 把当前分支退回到上一个 commit——"Bad experiment"
那条确实不见了，但那次 commit 里的修改没有丢，留在 staging area。适合用在
刚 commit 完发现 message 写错了，但修改本身还要留着。
-->

---

# `--mixed`（默认）：退指针，修改回到工作目录

```bash
git commit -m "Bad experiment"
git reset HEAD~1
git status
```

<div v-click class="mt-4">

```
Changes not staged for commit:
	modified:   foobar.txt
```

</div>

<!--
git reset HEAD~1 等价于 --mixed HEAD~1，是默认模式。同样撤销最近一次
commit，但这次修改回到的是 working directory，不在 staging area 里了。
适合用在：撤销 commit，并且想重新决定这次到底要不要 add。reset 更适合
移动"当前 commit 指针"的位置；restore 更适合文件级别的撤销。reset 会直接
影响历史指针，适合处理还没有 push 给别人的本地 commit。
-->

---

# `--hard`：退指针，工作目录也一并清空

```bash
git reset --hard HEAD~1
cat foobar.txt
```

<div v-click class="mt-4 text-lg opacity-80">
staging area 和 working directory 里的相关修改都被一并丢弃，基本找不回来
</div>

<!--
三种模式一句话总结：--soft 只退指针，修改留在 staging area；--mixed（默认）
退指针并把修改退回 working directory；--hard 退指针，同时把 staging area
和 working directory 里的相关修改都清空——这是唯一会直接改动 working
directory 内容的模式，执行前一定要确认没有不想丢的修改。

[click] 下一步，我们要处理一类"根本不该进 Git"的文件——用 .gitignore 告诉
Git 该忽略什么。
-->

---
layout: section
---

# `.gitignore`

Local Git · 09

<!--
这一节的主角不是命令，而是一个特殊文件。它的作用是告诉 Git：哪些文件不需要
出现在 git status 里，也不应该被提交进仓库。
-->

---

# 有些文件根本不该提交

```bash
echo "SECRET_KEY=dev-secret" > .env
git status
```

<div v-click class="mt-4">

```
Untracked files:
	.env
	debug.log
```

</div>

<!--
debug.log 通常是程序运行时产生的日志，不该进版本历史；.env 里往往放着本地
配置、密钥、token 之类的东西，更不该提交。
-->

---

# 用 `.gitignore` 解决

```bash
echo "*.log" > .gitignore
echo ".env" >> .gitignore
git status
```

<div v-click class="mt-4 text-lg opacity-80">
debug.log 和 .env 这次都不见了——被忽略的 untracked files 默认不出现在 git status 里
</div>

<!--
.gitignore 里的规则会影响 Git 怎么看待 untracked files。它本身应该提交进
仓库，因为是团队共享的规则。git status --ignored 可以专门查看被忽略的文件，
适合排查"为什么 Git 看不到这个文件"。
-->

---

# 一个常见误区

<div class="text-xl leading-relaxed mt-4">
.gitignore 只影响还没有被 Git 追踪的文件
</div>

<div v-click class="text-lg opacity-80 mt-6">
文件已经 commit 过？光改 .gitignore 不够，还需要 <code>git rm --cached</code>
</div>

<!--
如果一个文件已经 commit 进仓库了，后来才把它写进 .gitignore，Git 仍然会
继续追踪它的变化。

[click] git add -A 会把整个仓库里的新增、修改、删除都一并纳入 staging
area，包括用 rm 删除、但还没告诉 Git 的文件——这个先演示效果，不需要真的
提交。
-->

---

# `git rm --cached`

```bash
git rm --cached local-only.txt
git add .gitignore
git commit -m "Stop tracking local-only file"
```

<div v-click class="mt-6 text-lg opacity-80">
从追踪里移除，但保留本地磁盘上的文件内容
</div>

<!--
对比普通的 git rm：那个会连本地文件一起删掉，--cached 只解除追踪，文件还在。
需要注意：这个操作只是在历史里新增一次"删除"记录，之前的 commit 里仍然能
看到这个文件曾经存在过——如果内容涉及密钥，光 rm --cached 并不能把它从
历史里彻底抹掉。

[click] 下一步，我们回过头看看课前配置过的那些身份信息到底是怎么运作的——
也就是 git config。
-->

---
layout: section
---

# `git config`

Local Git · 10

<!--
课前 Prerequisites 已经让你配置过 user.name 和 user.email。这一节把它放回
Git 的整体模型里正式讲一遍：Git 本身还有一套配置系统。
-->

---

# `--global` vs `--local`

```bash
git config --global user.name "Your Name"
git config --local user.email "course@example.com"
```

<div v-click class="mt-6 text-lg opacity-80">
--global 影响这台机器上大多数仓库；--local 只对当前仓库生效，会覆盖 global
</div>

<!--
user.name 和 user.email 会写进每一次 commit 的作者信息里——回头看看前面
git log 的输出，Author 那一行就是从这里来的。local 配置保存在仓库自己的
.git/config 里，不会 commit、不会推送。.gitignore 是团队共享规则应该提交；
.git/config 是个人本地配置不会提交——这个对比能帮你理清哪些信息属于项目，
哪些属于本地环境。
-->

---

# 排查配置来源

```bash
git config --list --show-origin
```

<div v-click class="mt-4 text-lg opacity-80">
显示每条配置具体来自哪个文件——排查"为什么我的配置不是我以为的那个"
</div>

<!--
git config --get user.name / --get user.email 可以单独查某一项。
--show-origin 后面那段路径在你自己电脑上会是真实的 ~/.gitconfig 位置。
-->

---

# 几个顺手的配置

```bash
git config --global core.quotepath false
git config --global core.excludesfile ~/.gitignore_global
git config --global core.editor "vim"
```

<div v-click class="mt-6 text-lg opacity-80">
quotepath 让中文文件名显示更友好；excludesfile 指定个人的全局 ignore 规则
</div>

<!--
core.editor 指定 Git 需要打开编辑器时用哪个程序——没配置的话会依次参考
$GIT_EDITOR、$EDITOR、系统默认编辑器，很多人第一次遇到会卡在陌生的终端
编辑器里出不来。初学阶段尽量用 -m 避开这个坑；万一进去了，vi/vim 默认模式
按 Esc 再输入 :wq 保存退出，或 :cq 放弃这次 commit。

~/.gitignore_global 是个人机器上的规则，不会进入任何仓库，专门处理本机
系统或编辑器产生的文件，和仓库自己的 .gitignore 是两回事。pager、delta、
difftool/mergetool、credential helper 这类效率配置先不展开，留到对应场景
再讲。

[click] 到这里，本地部分最核心的一批命令都学完了。下一步，我们要认识 Git
真正的杀手锏——分支，也就是 git branch。
-->

---
layout: section
---

# `git branch`

Local Git · 11

<!--
到这里为止，我们做的所有操作——add、commit、diff、restore、reset、.gitignore、
config——其实都发生在同一条历史线上，一路直着往前走。从这一节开始，我们要认识
Git 真正的杀手锏：分支。有了分支，你才能一边保留能跑的主线，一边放心大胆地做
实验、开发新功能，也才谈得上后面多人协作时"各自开工、互不干扰"。
-->

---

# 先看看现在有哪些分支

```bash
git branch
```

<div v-click class="mt-6">

```
* main
```

</div>

<!--
不带参数的 git branch 用来列出本地分支。这里只有一个 main，前面带的 * 表示
"当前所在的分支"。

[click] 分支本质上就是一个指针，指向某一个 commit，仅此而已——不是复制了一份
代码，只是一个"指向哪里"的标签。
-->

---
layout: center
class: text-center
---

# HEAD → 当前分支 → 某个 commit

<div v-click class="text-lg opacity-70 mt-8">
在 main 上产生新 commit，main 这个指针跟着往前挪，HEAD 还是指向 main
</div>

<!--
HEAD 表示"你当前所在的位置"；通常情况下，HEAD 指向当前分支，当前分支再指向某个
commit。如果你现在在 main 上，产生了新的 commit，main 这个指针就会跟着往前挪，
HEAD 还是指向 main，只是 main 指向的位置变了。
-->

---

# 创建一个新分支

```bash
git branch experiment
git branch
```

<div v-click class="mt-6">

```
  experiment
* main
```

</div>

<!--
git branch experiment 会基于当前 commit 创建一个新分支，就这一件事。

[click] 它只创建，不切换——* 还留在 main 上，这为下一节的 git switch 埋了个
伏笔：创建分支和切换分支，是两个独立的动作。此时 main 和 experiment 指向的是
同一个 commit，还没有产生任何分叉。要等切换到 experiment 上并提交新内容之后，
两条线才会真正分开。
-->

---
layout: image
image: ./assets/diagrams/local-git/11-branch-create.svg
backgroundSize: contain
---

<!--
用图来看会更直观——这也是这门课第一次需要画图的地方。main 和 experiment 两个
指针，此刻指向同一个 commit。
-->

---

# 两个顺带一提的管理命令

```bash
git branch -m old-name new-name
git branch -d branch-name
```

<div v-click class="mt-6 text-lg opacity-80">
记一下用途就行，不用对着真实分支名操作
</div>

<!--
git branch -m old-name new-name 用来重命名分支——如果没配好 init.defaultBranch，
默认分支叫 master，理论上也能用这个改成 main。git branch -d branch-name 用来
删除一个已经合并、不再需要的本地分支。

git branch -D（大写，强制删除，哪怕分支还没合并）先不展开，容易一不小心把还没
合并的工作丢掉，等讲到 merge 的时候再回来说。远程分支相关的东西——origin/main、
git branch -r、git branch -a——现在也先不提，等进入 Remote GitHub 部分再讲才
有意义。

[click] 下一步，我们要真正切换到 experiment 分支上，在上面提交一次新内容——
这时候 main 和 experiment 才会第一次真正分叉，也就是 git switch。
-->

---
layout: section
---

# `git switch`

Local Git · 12

<!--
git branch experiment 只是创建了分支，并没有切换过去。git switch 才负责真正
切换你当前所在的分支。
-->

---

# 真正切换过去

```bash
git switch experiment
git branch
```

<div v-click class="mt-4">

```
Switched to branch 'experiment'
* experiment
  main
```

</div>

<!--
从指针模型看，切换分支就是让 HEAD 指向另一个分支。此时两个分支仍然指向同一个
commit，只是当前所在分支变了。
-->

---

# 在 experiment 上提交

```bash
echo "experiment idea" >> foobar.txt
git commit -am "Try experiment idea"
```

<div v-click class="mt-4 text-lg opacity-80">
main 落在原地，experiment 往前走了一步
</div>

<!--
当前在 experiment 分支上，所以新的 commit 会让 experiment 指针向前移动，main
仍然停留在原来的位置。这就是分支的核心价值：可以在不影响主线的情况下做实验。
-->

---
layout: image
image: ./assets/diagrams/local-git/12-switch-diverge.svg
backgroundSize: contain
---

<!--
新的这个 commit 的父提交，就是 main 和 experiment 分开之前共同指向的那个
commit——experiment 是从那个位置长出来的一条新线。
-->

---

# 切回 main，观察变化

```bash
git switch main
cat foobar.txt
git log --oneline --graph --all
```

<div v-click class="mt-6 text-lg opacity-80">
experiment idea 消失了——working directory 会跟随当前分支切换
</div>

<!--
三件事：* 回到了 main；foobar.txt 里刚才在 experiment 上新增的内容消失了；
git log --oneline 在 main 上看不到 experiment 的最新 commit，因为当前分支
没有指向那条历史。--graph --all 能同时看到所有分支，很适合观察是否分叉。

git switch -c feature-name 等价于先 branch 再 switch；git switch - 能切回
上一个所在分支，类似 cd -，好用但不是主线重点。切换分支前最好先确认working
directory 是 clean 的。

[click] 下一步，我们要认识一个历史更久、职责更混合的命令——git checkout。
-->

---
layout: section
---

# `git checkout`

Local Git · 13

<!--
这一节不需要展开太多，因为前面已经分别讲过 git switch 和 git restore。这里
的重点是认识 checkout：一个历史更久、职责更混合的命令，过去同时承担了"切换
分支"和"恢复文件"这两件事。
-->

---

# 旧式切换分支

```bash
git checkout experiment
git checkout main
```

<div v-click class="mt-6 text-lg opacity-80">
效果和 git switch experiment / git switch main 完全一样
</div>

<!--
git checkout <branch> 是旧式切换分支命令，git checkout -b <branch> 对应
git switch -c <branch>，原理和上一节一样，这里不重复演示。
-->

---

# 旧式恢复文件

```bash
git checkout -- foobar.txt
```

<div v-click class="mt-6 text-lg opacity-80">
效果和 git restore foobar.txt 一样
</div>

<!--
你需要认识 checkout，因为很多老教程、博客、项目文档仍然大量在用它。但初学
阶段不建议把它当主线命令，否则会把"切换分支"和"恢复文件"这两个本来清晰分开
的概念又混回一起。git checkout <commit> 和 detached HEAD 这门课先不展开。

[click] 下一步，我们要把 experiment 分支上的实验成果，真正合并回 main——
也就是 git merge。
-->

---
layout: section
---

# `git merge`

Local Git · 14

<!--
experiment 分支上已经有了一次提交。现在要把这条分支上的成果，合回 main。
merge 的方向很重要：git merge experiment 的意思是把 experiment 合入当前
分支，所以必须先切到 main，再 merge experiment。
-->

---

# Fast-forward merge

```bash
git switch main
git merge experiment
```

<div v-click class="mt-4">

```
Updating 7471135..e54cb37
Fast-forward
 foobar.txt | 1 +
 1 file changed, 1 insertion(+)
```

</div>

<!--
Fast-forward 就是关键：因为 main 自从创建 experiment 之后没有产生任何新
commit，Git 不需要真正"合并"两条不同的历史，只是把 main 这个指针直接往前挪
到 experiment 指向的位置——没有产生额外的 merge commit。合并后 main 和
experiment 指向同一个 commit。
-->

---
layout: image
image: ./assets/diagrams/local-git/14-merge-ff.svg
backgroundSize: contain
---

<!--
mermaid 用一个节点画出这个"汇合"，但因为是 fast-forward，Git 实际上不会
创建这个 merge commit，main 只是指针直接跳过去。
-->

---

# 删掉已经合并的分支

```bash
git branch -d experiment
```

<div v-click class="mt-4 text-lg opacity-80">
删除分支不会删除 commit，只是删除这个名字——分支只是指针，不是复制了一份代码
</div>

<!--
因为 experiment 已经合入 main，所以 -d 是安全的。如果分支还没合并，-d 会
拒绝删除；这时候 -D（大写）会强制删除，哪怕提交还没合并到任何地方——-d 是
"确认安全才删"，-D 是"我确定要删"。这一节先只讲 fast-forward。

[click] 下一步，我们专门设计一个冲突场景，去理解为什么多人协作时需要处理
合并冲突。
-->

---
layout: section
---

# Merge conflict

Local Git · 15

<!--
真实工作里冲突经常发生在多人协作、git pull、Pull Request 里，但第一次学
最好先在本地构造一个冲突——状态可控、命令少。先说清楚一个观点：merge
conflict 不是 GitHub 独有的问题，只要两条历史分支修改了同一段内容，Git
就无法自动判断该保留哪一边；remote、GitHub 只是让多人更容易产生分叉。
-->

---

# 两条分支，改了同一行

```bash
git switch -c conflict-a
printf "hello from conflict-a\n..." > foobar.txt
git commit -am "Update greeting on conflict branch"

git switch main
printf "hello from main\n..." > foobar.txt
git commit -am "Update greeting on main"
```

<div v-click class="mt-6 text-lg opacity-80">
main 和 conflict-a 都改了 foobar.txt 的第一行，但改成了不一样的内容
</div>

<!--
先从 clean 的 main 开始，创建一个会产生冲突的分支，改同一行；再回到 main，
把同一行改成另一个内容。这样两条历史真正分叉，且修改了同一处内容。
-->

---

# 冲突发生了

```bash
git merge conflict-a
```

<div v-click class="mt-4">

```
<<<<<<< HEAD
hello from main
=======
hello from conflict-a
>>>>>>> conflict-a
```

</div>

<!--
Git 不知道该保留哪一边，所以暂停 merge，让人来决定。git status 会显示
unmerged paths，提示 both modified。HEAD 这一边表示当前分支（正在接收
合并的 main）；======= 是分隔线；>>>>>>> conflict-a 这一边是被合并进来的
分支。解决冲突不是删掉某一边，而是根据真实意图编辑成最终想要的内容。

顺带一提 git config --global merge.conflictstyle zdiff3：会额外显示两边
分叉之前的共同祖先内容（多一段 ||||||| base），对复杂冲突更容易看懂，属于
效率优化，看时间决定是否演示。
-->

---

# 解决冲突

```bash
git add foobar.txt
git commit -m "Resolve greeting conflict"
```

<div v-click class="mt-4 text-lg opacity-80">
git add 在这里的意思是：这个文件的冲突已经解决了
</div>

<!--
步骤是：编辑文件、删除 conflict markers、保留最终想要的内容；git add
告诉 Git 冲突已解决；git commit 完成这次 merge——这次真的产生了一个 merge
commit，log --graph 上能看到分叉再汇合的形状，和 fast-forward 的直线完全
不同。逃生命令 git merge --abort 能放弃这次 merge，回到合并前的状态。
-->

---
layout: image
image: ./assets/diagrams/local-git/15-merge-conflict.svg
backgroundSize: contain
---

<!--
两条分支改了同一行，merge 产生了真正的 merge commit——分叉再汇合的形状。
-->

---

# `--no-ff`：强制产生 merge commit

```bash
git merge --no-ff feature-note
```

<div v-click class="mt-4 text-lg opacity-80">
本来可以 fast-forward，但 --no-ff 强制留下一次"这里合并过"的记录
</div>

<!--
这次 main 没有新的 commit，本来会是 fast-forward，但 --no-ff 强制 Git 创建
一个 merge commit。好处是历史里能清楚看到"这里发生过一次分支合并"。一些
团队的分支策略会统一要求 --no-ff，方便回溯每个 feature 分支的边界。
-->

---

# `--ff-only`：只允许快进，否则拒绝

```bash
git merge --ff-only feature-two
```

<div v-click class="mt-4 text-lg opacity-80">
如果 main 有新的、不在对方分支里的 commit，这条命令会直接失败
</div>

<!--
适合希望保持线性历史、不想意外产生 merge commit 的场景，属于团队分支策略的
一种选择。这两个参数不影响冲突本身的处理方式，只是决定"什么情况下产生 merge
commit、以及是否允许 Git 自动决定"。

[click] 下一步，我们把本地这一路学到的东西收个尾——认识 Git aliases，顺便
补上一个之前刻意没提的高频简写：git commit -a。
-->

---
layout: section
---

# Git aliases

Local Git · 16

<!--
alias 就是通过 git config 配置出来的命令缩写。
-->

---

# 配几个顺手的缩写

```bash
git config --global alias.st status
git config --global alias.lg "log --oneline --graph --all"
```

<div v-click class="mt-6 text-lg opacity-80">
课堂讲解仍然优先用完整命令——避免没配置 alias 就跟不上
</div>

<!--
alias 是个人效率工具，不是团队协作的必要条件。git lg 这类 alias 特别适合
把长命令固定下来。不建议一开始配置太多，先熟悉原始命令，再逐步加自己真正
高频用到的缩写。alias 存在于个人 Git 配置里，不会被 commit，也不会影响
别人。删除用 git config --global --unset alias.st。
-->

---

# 顺手补一个：`git commit -a`

```bash
echo "quick fix" >> foobar.txt
git commit -a -m "Quick fix"
```

<div v-click class="mt-6 text-lg opacity-80">
只处理已经被追踪、且有修改的文件——新文件仍然需要显式 git add
</div>

<!--
前面讲 add 和 commit 时故意没提这个，为的是先让你扎实理解 staging area。
-a 会自动把已追踪文件的修改先 add 再 commit，省了手动 add 这一步，但容易
在没注意的情况下把不想提交的修改也一起提交进去。-a 不是必须掌握的技巧，
add + commit 分开写永远是更清楚、更不容易出错的写法。

[click] 本地 Git 最核心的一批内容，到这里就学完了。下一步，我们回顾一下
从三层模型到四区域模型的这段旅程，然后正式进入 Remote GitHub。
-->

---
layout: section
---

# 从三层模型到四区域模型

<!--
在正式进入 GitHub 之前，先回顾一次前面建立起来的本地三层模型：Working
Directory、Staging Area、Local Repository。然后引入第四个区域：Remote
Repository。
-->

---
layout: image
image: ./assets/diagrams/local-git/16-recap-four-areas.svg
backgroundSize: contain
---

<!--
git push 把本地 commit 同步到 remote repository；git fetch / git pull 从
remote repository 获取别人或远程上的新变化。
-->

---
layout: center
class: text-center
---

# remote 不等于 GitHub

<div v-click class="text-lg opacity-70 mt-6">
GitHub、GitLab、Gitea、公司内网服务器，甚至本机的 bare repository，都可以是 remote
</div>

<div v-click class="mt-12 pt-6 border-t border-main text-2xl">
课堂接下来统一用 GitHub——最常见，也能自然承接 Issue、PR、Actions
</div>

<!--
remote repository 指的是另一个 Git 仓库地址，不一定是 GitHub——这一点提
一嘴就好，bare repo 不展开。

[click] 到这里，本地 Git 的部分正式收尾。下一步，我们要把这些本地的历史，
第一次真正同步到网络上——认识 GitHub。
-->

---
layout: section
---

# GitHub 是什么

Remote GitHub · 01

<!--
本地 Git 的部分正式收尾了。在动手把仓库放到网络上之前，先花几分钟讲清楚一件
事：GitHub 到底是什么，它和这几周一直在用的 Git 是什么关系。
-->

---
layout: center
class: text-center
---

# Git 负责版本控制

# GitHub 负责把仓库放到网络上

<div v-click class="text-lg opacity-70 mt-8">
外加围绕代码协作的一整套平台能力：issue、PR、Actions、权限管理
</div>

<!--
Git 是版本控制工具，负责记录代码历史、管理分支、合并修改——这些我们已经在
本地全部亲手做过一遍了。GitHub 是基于 Git 的代码托管与协作平台，不是 Git
本身。本地 Git 仓库完全可以独立存在，不一定需要 GitHub；反过来，GitHub 上
的每个仓库，本质上也是一个 Git remote repository。remote 不一定是 GitHub，
也可以是 GitLab、Gitea、公司内网服务器，甚至本机的 bare repository——提
一嘴就好，不展开。这门课接下来统一用 GitHub，因为它最常见，也能自然展示
fork、clone、branch、push、PR、code review、CI 这套完整流程。
-->

---

# 几个马上会用到的概念

<div class="grid grid-cols-2 gap-x-8 gap-y-3 mt-6 text-lg">
<div><b>Repository</b> —— 一个项目仓库</div>
<div><b>Owner</b> —— 仓库所属的个人或组织</div>
<div><b>README</b> —— 首页默认展示的说明文档</div>
<div><b>Issues</b> —— 记录问题、任务、讨论</div>
<div><b>Pull Request</b> —— 请求合并修改</div>
<div><b>Actions</b> —— 自动化系统，测试/构建/部署</div>
</div>

<!--
从这一节开始，我们会用一个真实存在的代码仓库来学——这样才能真正写 issue、
发 PR、跑 workflow，而不是纸上谈兵。

[click] 下一步，我们把一个本地项目第一次真正发布到 GitHub 上。
-->

---
layout: section
---

# 把本地项目发布到 GitHub

Remote GitHub · 02

<!--
这一节从"把本地已有项目 push 到自己的 GitHub 仓库"开始，能顺便复习一遍
local-git 学过的东西，同时自然引出 remote、origin、push、upstream branch
这几个新概念。
-->

---

# 先在本地把项目建起来

```bash
mkdir hello-github && cd hello-github
# hello.py / README.md / .gitignore
git init && git add . && git commit -m "Initial commit"
```

<div v-click class="mt-4">

```
Hello, GitHub!
[main (root-commit) c4cfba2] Initial commit
 3 files changed, 10 insertions(+)
```

</div>

<!--
这一步完全没有 GitHub 参与，只是在本地建了一个正常的 Git repository，和这
几周做的事情一模一样。用一个小的 Python 项目而不是空文本文件，是为了后面
能自然扩展到测试、Actions、CI。
-->

---

# 在 GitHub 网页上建一个空仓库

<div class="text-lg leading-relaxed mt-4">
登录 → New repository → 填名字 hello-github
</div>

<div v-click class="mt-6 text-lg opacity-80">
不要勾选 README / .gitignore / LICENSE——本地已经有了，勾了会产生额外分叉
</div>

<!--
public 还是 private 都行，课堂上 public 更方便展示。这一步是唯一需要在
网页上做的事，接下来的命令都在终端里。
-->

---

# 连上远程，第一次 push

```bash
git remote add origin https://github.com/<username>/hello-github.git
git branch -M main
git push -u origin main
```

<div v-click class="mt-4">

```
* [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

</div>

<!--
origin 不是什么特殊服务器名，只是个默认习惯名，表示"这个本地仓库主要对应的
远程仓库"。git remote -v 能查看当前配置了哪些 remote。-u 是 --set-upstream
的简写，建立本地 main 和远程 origin/main 的跟踪关系——建立之后这个分支上
可以直接 git push，不用每次都写完整参数。

push 完回到 GitHub 页面刷新：README 显示在首页，hello.py 和 .gitignore
出现在文件列表里，commit history 能看到 Initial commit。

如果第一次 push 遇到认证问题，先检查 gh auth status / gh auth login /
gh auth setup-git，不用纠结 token、SSH key 这些细节。
-->

---
layout: center
class: text-center
---

# `git commit` 只到本地

# `git push` 才到 GitHub

<!--
一个常见误区：commit 只是保存到本地仓库，push 才是把本地 commit 真正发送到
远程仓库。如果只 commit 不 push，GitHub 网页上是看不到你的新修改的。
-->

---

# 日常流程：改一点东西，push

```bash
git add README.md
git commit -m "Document usage"
git push
```

<div v-click class="mt-6 text-lg opacity-80">
第一次要写完整的 -u origin main；建立 upstream 之后，通常只需要 git push
</div>

<!--
如果 git status 显示本地分支 ahead of origin/main，意思就是本地有 commit
还没推上去。

顺带一提 gh repo create hello-github --public --source=. --remote=origin
--push 能把"创建仓库、加 remote、push"合并成一步，但初学阶段建议先手动走
一遍完整流程，理解 remote 和 push 在干什么之后，再用 gh 提高效率。

[click] 下一步，我们要在这个仓库里第一次走一遍分支协作的完整流程：开分支、
发 Pull Request、review、merge。
-->

---
layout: section
---

# 分支协作：branch → PR → merge

Remote GitHub · 03

<!--
不需要两人配对——直接在自己的 hello-github 仓库里练习一遍完整的分支工作流。
真实项目里几乎不会让所有人直接 push 到 main；哪怕是自己一个人的项目，也值得
养成"改动先开分支、通过 PR 合并"的习惯。
-->

---

# 从最新的 main 开一个分支

```bash
git switch main && git pull
git switch -c improve-readme
```

<div v-click class="mt-6 text-lg opacity-80">
pull 拉不到新东西也要养成习惯——多人协作时才不会基于过时的 main 开分支
</div>

<!--
git switch -c improve-readme 创建并切换到一个工作分支，分支名描述这次改动，
比如 improve-readme、add-tests、fix-typo。
-->

---

# 改动、提交、push 分支

```bash
git add README.md
git commit -m "Add development notes"
git push -u origin improve-readme
```

<div v-click class="mt-4">

```
* [new branch]      improve-readme -> improve-readme
branch 'improve-readme' set up to track 'origin/improve-readme'.
```

</div>

<!--
这里 push 的不是 main，而是 improve-readme 分支。-u 建立本地分支和远程分支
的跟踪关系。push 完之后，GitHub 通常会直接提示可以创建 Pull Request。

顺带一提 push.default current / push.autoSetupRemote true 这两个配置能省
去第一次 push 新分支的完整参数，但课堂主线建议先手写完整版，理解 upstream
怎么建立的。
-->

---

# 创建 Pull Request

<div class="text-lg leading-relaxed mt-4">
打开 repo 页面 → Compare & pull request → 确认 base 是 main、compare 是 improve-readme → 创建
</div>

<div v-click class="mt-8 text-lg opacity-80">
PR 不是 Git 的核心命令，而是 GitHub 提供的协作功能
</div>

<!--
PR 的意思是：请求把一个分支的修改合并到另一个分支；同一个仓库内的两个分支
之间也能发起 PR，不一定要跨仓库。PR 页面展示 changed files、commits、
conversation、checks，给团队提供 review、讨论、自动化测试和合并入口。

review 并 merge（这里是自己 review 自己的 PR，但流程和团队协作一样）：打开
PR 看一眼 Files changed——即使是自己的改动，也养成合并前看一遍 diff 的习惯；
点击 Merge pull request；合并后可以顺手删除远程分支。这一整套也可以用
gh pr create / gh pr merge 在终端里做完全一样的事，第 6 节会专门讲。
-->

---

# merge 后同步本地

```bash
git switch main
git pull
git branch -d improve-readme
```

<div v-click class="mt-4">

```
Fast-forward
 README.md | 4 ++++
Deleted branch improve-readme (was ec221d0).
```

</div>

<!--
PR merge 发生在 GitHub 远程仓库上，本地仓库不会自动更新，需要 git pull。
本地工作分支已经合并后，可以用 git branch -d 删除。

这一节建立的工作流：main 最新状态 -> 新建分支 -> 本地修改 -> commit -> push
分支 -> Pull Request -> review -> merge -> pull 回本地。这也是后面讲
Issue、fork + PR、GitHub Actions、code review 的基础。
-->

---

# 顺手清理：`git fetch --prune`

```bash
git fetch --prune
git branch -r
```

<div v-click class="mt-6 text-lg opacity-80">
如果远程分支是在网页上删的，本地的 remote-tracking 引用可能还会留一阵子
</div>

<!--
git fetch 默认只负责获取远程新内容，不会主动清理本地这些"过时的远程分支
记录"；--prune 会额外检查并清掉已经不存在的远程分支对应的本地记录。这不会
影响任何本地工作分支或 commit，相对安全。git config --global fetch.prune
true 能让这个行为自动发生。

[click] 下一步，我们要处理一个更真实的协作场景：如果对一个仓库根本没有写
权限，该怎么贡献代码？这就要用到 Issue、Fork 和 Pull Request 的组合。
-->

---
layout: section
---

# Issue + Fork + Pull Request

Remote GitHub · 04

<!--
上一节是在自己有写权限的仓库里协作。但在开源项目、或者课程公共仓库里，你
通常对原仓库没有写权限，这时候的标准流程是：先有一个 issue 描述任务，然后
fork 仓库、在自己的 fork 里改，发 PR 请求合并回原仓库。这里用课程专用的
共享仓库 first-contributions，老师提前建好、保持是仓库 owner，内容很简单
——README.md 和 CONTRIBUTORS.md，配一个提前建好的 issue #1。
-->

---

# fork：在自己账号下复制一份

<div class="text-lg leading-relaxed mt-4">
打开 first-contributions → 点击 Fork → Owner 选自己的账号
</div>

<div v-click class="mt-8 text-lg opacity-80">
你对自己的 fork 有写权限，即使对老师的原仓库没有写权限
</div>

<!--
fork 是在自己 GitHub 账号下复制一份别人的仓库，是 GitHub 平台能力，不是
Git 的核心命令。通过 PR 请求把 fork 里的修改合回原仓库，这是没有写权限时
贡献代码的标准方式。

因为全班共用同一个 issue，第一个合并的 PR 会真正触发关闭这个 issue，其他
同学的 PR 依然能正常合并，只是不会再触发"关闭"这个动作——这是正常现象。
-->

---

# clone 自己的 fork

```bash
git clone https://github.com/<your-username>/first-contributions.git
```

<div v-click class="mt-6 text-lg opacity-80">
这门课第一次真正用到 git clone——之前的 hello-github 是 init 之后 push 上去的
</div>

<!--
git clone 从 remote repository 下载文件和完整历史，自动创建 .git 目录，
自动加一个叫 origin 的 remote——这里指向你自己的 fork，不是老师的原仓库；
自动 checkout 默认分支并建立跟踪关系。

git branch 只列本地分支；git branch -r 列 remote-tracking branches；
git branch -a 两者都列。
-->

---
layout: image
image: ./assets/diagrams/remote-github/04-fork-upstream.svg
backgroundSize: contain
---

<!--
加一个 upstream，指向老师的原仓库：git remote add upstream <老师仓库地址>。
origin 是你自己的 fork，你有写权限；upstream 是老师的原仓库，通常只有读
权限——这两个名字不是强制的，但是 GitHub 协作里的常见约定。
-->

---

# 建分支、改动、push 到自己的 fork

```bash
git switch -c add-<your-username>
printf '- <your-username>\n' >> CONTRIBUTORS.md
git commit -am "Add <your-username> to contributors"
git push -u origin add-<your-username>
```

<!--
和上一节在自己仓库里开分支的流程一模一样，区别只是这次 push 的目标是你
自己的 fork，不是原仓库。
-->

---

# PR：从你的 fork 合到老师的原仓库

<div class="text-lg leading-relaxed mt-4">
base repository 选老师的原仓库，compare 选你的 fork 和分支
</div>

<div v-click class="mt-8 text-lg opacity-80">
PR 描述里写 <code>Closes #1</code>，关联前面创建的 issue
</div>

<!--
fork PR 的目标是"从我的 fork 分支合并到老师的原仓库 main"。老师 review、
merge 之后：PR 显示 merged；如果是第一个合并的 PR，issue 会自动关闭；
CONTRIBUTORS.md 里出现你的名字。老师 merge 后，你的 fork 不会自动同步。
-->

---

# merge 后，同步一下自己的 fork

```bash
git switch main
git fetch upstream
git merge upstream/main
git push origin main
```

<!--
fetch upstream 从老师的原仓库获取最新历史；merge upstream/main 合入本地
main；push origin main 把同步后的本地 main 推回自己的 fork。这一段对初学
者略难，当作 fork 流程的收尾展示即可，不必要求一次完全掌握。

[click] 下一步，我们看看 GitHub 仓库里那些"特殊文件"——README、LICENSE、
CONTRIBUTING、issue/PR template——都是干什么用的。
-->

---
layout: section
---

# GitHub repo 里的特殊文件

Remote GitHub · 05

<!--
放在 issue 和 PR 后面讲这个话题很自然——已经实际创建过 issue 和 PR 了，现在
再看这些"模板文件"，会立刻明白它们是用来解决什么问题的。
-->

---

# 最常见的几个文件

<div class="grid grid-cols-2 gap-x-8 gap-y-3 mt-6 text-lg">
<div><b>README.md</b> —— 首页说明</div>
<div><b>.gitignore</b> —— 哪些文件不追踪</div>
<div><b>LICENSE</b> —— 别人能怎么用这个项目</div>
<div><b>CONTRIBUTING.md</b> —— 怎么参与贡献</div>
<div><b>CODE_OF_CONDUCT.md</b> —— 社区行为准则</div>
</div>

<!--
这些文件不是 Git 的特殊文件，而是 GitHub 会识别、并在网页上特殊展示或链接
的文件。.gitignore 同时会影响 Git 的实际行为；其他几个主要影响的是 GitHub
页面展示和协作流程。课程项目至少应该有 README.md、.gitignore、
CONTRIBUTING.md。
-->

---

# Issue template / PR template

```plaintext
.github/ISSUE_TEMPLATE/bug_report.md
.github/PULL_REQUEST_TEMPLATE.md
```

<div v-click class="mt-6 text-lg opacity-80">
减少"只有一句话但没法处理"的 issue；配合 Closes #1 形成完整任务闭环
</div>

<!--
issue template 用来引导提 issue 的人提供足够信息。PR template 用来提醒
提交者说明改了什么、为什么改、怎么验证，能让 review 更高效。

[click] 回到 first-contributions：它目前故意只有 README.md 和
CONTRIBUTORS.md，没有 CONTRIBUTING.md，也没有任何模板——正好可以给它加一个
简单的 CONTRIBUTING.md 或 PR template，作为一次小练习，走一遍开分支、改动、
发 PR 的完整流程。

下一步，我们看看网页操作之外，还有什么办法能更快地做同样的事——GitHub CLI。
-->

---
layout: section
---

# GitHub CLI

Remote GitHub · 06

<!--
重点不是背命令，而是知道一件事：GitHub 上很多网页操作，其实也能在命令行里
完成。git 主要操作 Git 版本历史；gh 主要操作 GitHub 平台对象——repo、
issue、Pull Request、workflow。记不住就回网页操作，网页流程仍然是最适合
初学者理解概念的方式。
-->

---
layout: center
class: text-center
---

# 网页适合人看

# CLI 适合脚本和 agent 操作

<div v-click class="text-lg opacity-70 mt-8">
这份讲义本身就是用 gh 建的仓库和 issue
</div>

<!--
AI 时代的实际价值：gh 很适合让 Claude Code、Codex 这类 AI coding agent 在
终端里帮你操作 GitHub——查看 issue、读取 PR、创建 PR、检查 CI 结果，都可以
直接在终端里完成。
-->

---

# 认证 / repo / issue

```bash
gh auth status
gh repo view ukeSJTU/hello-github
gh issue list --repo SingularityCoding/first-contributions
```

<div v-click class="mt-4">

```
1	OPEN	Add your name to CONTRIBUTORS.md
```

</div>

<!--
gh auth login 登录；gh auth setup-git 把 gh 配置成 git 的 credential
helper。gh repo clone/view --web/create 分别对应 clone、网页打开、创建仓库
——create 很方便，但前面已经手动走过完整流程，这里只作为提效工具。gh issue
list/view/create 效果和网页上一模一样。
-->

---

# PR 相关

```bash
gh pr list --repo ukeSJTU/hello-github --state all
gh pr checkout <number>
```

<div v-click class="mt-6 text-lg opacity-80">
gh pr checkout 能把某个 PR 的分支直接拉到本地——不用先去网页找分支名
</div>

<!--
gh pr create / gh pr view --web 分别对应创建 PR、浏览器打开某个 PR。这里
最值得记住的是 gh pr checkout <number>，方便在本地跑测试、review 或继续
修改。gh run list / gh run view 下一节讲 Actions 时再展开。

[click] 下一步，我们看看 GitHub 怎么在特定事件发生时，自动帮我们跑一组
命令——GitHub Actions。
-->

---
layout: section
---

# GitHub Actions

Remote GitHub · 07

<!--
PR 里别人提交的代码，靠人眼看不够，我们怎么自动确认它至少能运行、测试能
通过？这个问题引出 CI：人会忘记在本地跑测试，不同人的电脑环境不同，PR
merge 前应该有自动检查。CI 的核心目标：自动验证代码是否还正常。
-->

---
layout: center
class: text-center
---

# event → workflow → job → step → action

<!--
event：什么事情触发自动化，比如 push、pull_request。workflow：写在
.github/workflows/*.yml 里的自动化配置。job：一组在 runner 上执行的任务。
step：job 里的具体步骤。runner：GitHub 提供的临时运行环境。action：别人
写好的可复用步骤，比如 checkout 代码、安装 Python。
-->

---

# 先在本地跑通测试

```bash
python -m pytest
```

<div v-click class="mt-4">

```
test_hello.py .                                                 [100%]
============================== 1 passed in 0.00s ===============================
```

</div>

<!--
先让测试在本地跑通，再放进 CI——CI 不是魔法，本质上就是在 GitHub 的 runner
里自动执行类似的命令。
-->

---

# `.github/workflows/ci.yml`

```yaml
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
      - run: python -m pytest
```

<!--
on 定义触发条件：push 到 main 或创建/更新 PR。runs-on: ubuntu-latest 表示
在 GitHub 提供的 Ubuntu runner 上运行。actions/checkout@v4 把仓库代码
checkout 到 runner；actions/setup-python@v5 安装指定 Python 版本；run
执行普通 shell 命令，和本地终端里敲的是同一回事。
-->

---

# push 之后，真的跑起来了

```bash
git push
gh run watch <run-id> --exit-status
```

<div v-click class="mt-4">

```
✓ main CI · 28805021238
JOBS
✓ test in 6s
```

</div>

<!--
Actions tab 里出现了这次 CI run；走 PR 流程的话，PR 页面也会出现 checks。
绿色表示通过，红色表示失败——真实项目里经常要求 checks passed 之后才能
merge。
-->

---

# 故意弄坏一次

```bash
sed -i '' 's/Hello, GitHub!/Hello, World!/' test_hello.py
git commit -am "Break the test on purpose"
git push
```

<div v-click class="mt-4">

```
X main CI · 28805096806
JOBS
X test in 6s
  X Run python -m pytest
```

</div>

<!--
本地测试失败长什么样，GitHub Actions 失败就长什么样——CI 只是把这件事自动
化、放到一个干净的远程环境里重新做一遍。gh run view <run-id> --log-failed
能直接看到失败的具体 log：AssertionError: assert 'Hello, GitHub!' ==
'Hello, World!'。CI 失败时应该先看 log，而不是盲目重跑。改回来就能恢复
绿色。
-->

---
layout: center
class: text-center
---

# GitHub Actions

<div class="text-lg opacity-70 mt-6">
在特定事件发生时，自动帮我们跑一组命令——最常见的用途是 PR 自动测试
</div>

<!--
matrix、cache、secrets、deployment、release automation、self-hosted
runner、permissions、reusable workflow 这些进阶能力，第一次讲先不展开。

到这里，这门课的主线内容就都学完了：从本地 Git 的 init/add/commit 一路到
branch、merge，再到 GitHub 上的 fork、PR、Issue、CI，一整套现代软件协作
的核心流程，都亲手做过一遍了。
-->
