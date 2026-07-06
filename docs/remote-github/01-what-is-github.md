# GitHub 是什么

本地 Git 的部分到上一节正式收尾了。在动手把仓库放到网络上之前，先花几分钟讲清楚一件事：GitHub 到底是什么，它和这几周一直在用的 Git 是什么关系。

一句话说清楚：**Git 负责版本控制，GitHub 负责把 Git 仓库放到网络上，并提供围绕代码协作的一整套平台能力。**

具体展开一下：

- Git 是一个版本控制工具（version control tool），负责记录代码历史、管理分支、合并修改——这些我们已经在本地全部亲手做过一遍了。
- GitHub 是一个基于 Git 的代码托管与协作平台（platform）。它不是 Git 本身，而是在 Git 之上提供了远程仓库托管、网页界面、权限管理、issue、Pull Request、Actions 这些协作能力。
- 本地 Git 仓库完全可以独立存在，不一定需要 GitHub；反过来，GitHub 上的每个仓库，本质上也是一个 Git remote repository。
- remote repository 不一定是 GitHub，也可以是 GitLab、Gitea、公司内网服务器，甚至本机上的一个 bare repository——这里提一嘴就好，bare repo 不展开。
- 这门课接下来统一用 GitHub，因为它最常见，也能自然展示现代软件协作的完整流程：fork、clone、branch、push、Pull Request、code review、CI。

顺便认识几个马上会用到的 GitHub 概念：

- **Repository**（仓库）：一个项目仓库。
- **Owner**（所有者）：仓库所属的个人或组织。
- **README**：仓库首页默认展示的说明文档。
- **Issues**：用于记录问题、任务、讨论。
- **Pull Request**（PR）：请求把一个分支或 fork 里的修改合并到目标仓库。
- **Actions**：GitHub 提供的自动化系统，常用于测试、构建、部署。

从这一节开始，我们会用一个真实存在的代码仓库来学——这样才能真正写 issue、发 PR、跑 workflow，而不是纸上谈兵。

下一步，我们把一个本地项目第一次真正发布到 GitHub 上。
