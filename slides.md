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
