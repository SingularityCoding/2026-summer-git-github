# 把本地项目发布到 GitHub

这一节从"把本地已有项目 push 到自己的 GitHub 仓库"开始。这个顺序能顺便复习一遍 local-git 学过的东西，同时自然引出这几个新概念：remote、origin、push、upstream branch。

## 先在本地把项目建起来

macOS + Windows Git Bash（Linux 可自行参考）:

```bash
mkdir hello-github
cd hello-github

printf 'def greet(name):\n    return f"Hello, {name}!"\n\nif __name__ == "__main__":\n    print(greet("GitHub"))\n' > hello.py
printf '# hello-github\n\nA tiny Python project for learning Git and GitHub.\n' > README.md
printf '__pycache__/\n*.pyc\n' > .gitignore

python hello.py
```

Windows PowerShell:

```powershell
mkdir hello-github
cd hello-github

@'
def greet(name):
    return f"Hello, {name}!"

if __name__ == "__main__":
    print(greet("GitHub"))
'@ | Set-Content -Path hello.py

@'
# hello-github

A tiny Python project for learning Git and GitHub.
'@ | Set-Content -Path README.md

@'
__pycache__/
*.pyc
'@ | Set-Content -Path .gitignore

python hello.py
```

```
Hello, GitHub!
```

然后走一遍已经很熟悉的本地 Git 流程：

```bash
git init
git status
git add .
git commit -m "Initial commit"
git log --oneline
```

```
Initialized empty Git repository in /path/to/your/hello-github/.git/
On branch main

No commits yet

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	.gitignore
	README.md
	hello.py

nothing added to commit but untracked files present (use "git add" to track)
[main (root-commit) c4cfba2] Initial commit
 3 files changed, 10 insertions(+)
 create mode 100644 .gitignore
 create mode 100644 README.md
 create mode 100644 hello.py
c4cfba2 Initial commit
```

讲解要点：

- 这一步完全没有 GitHub 参与，只是在本地建了一个正常的 Git repository——和你这几周做的事情一模一样。
- `README.md` 待会儿会成为 GitHub 仓库首页默认展示的说明文档。
- `.gitignore` 继续作为团队共享规则进入仓库。
- 这里用一个小的 Python 项目，而不是空文本文件，是为了后面能自然扩展到测试、Actions、CI。

## 在 GitHub 网页上建一个空仓库

1. 登录 GitHub。
2. 点击 New repository。
3. Repository name 填 `hello-github`。
4. public 或 private 都行，课堂上 public 更方便展示。
5. **不要**勾选网页里的 README、`.gitignore`、LICENSE——本地已经有这些文件了，勾了的话远程仓库会先产生一次 commit，第一次 push 时会遇到不必要的分叉。

创建完空仓库后，GitHub 会展示一组命令，重点看这几条：

```bash
git remote add origin https://github.com/<username>/hello-github.git
git remote -v
git branch -M main
git push -u origin main
```

```
https://github.com/ukeSJTU/hello-github
origin	https://github.com/ukeSJTU/hello-github.git (fetch)
origin	https://github.com/ukeSJTU/hello-github.git (push)
To https://github.com/ukeSJTU/hello-github.git
 * [new branch]      main -> main
branch 'main' set up to track 'origin/main'.
```

讲解要点：

- `git remote add origin <url>`：给远程仓库地址起一个本地名字 `origin`。`origin` 不是什么特殊服务器名，只是个默认习惯名，表示"这个本地仓库主要对应的远程仓库"。
- `git remote -v` 查看当前配置了哪些 remote，以及 fetch/push 分别用的是什么 URL。
- `git branch -M main` 把当前分支名改成 `main`——如果前面已经是 `main`，这条命令不会有额外概念负担；如果是 `master`，正好借机统一。
- `git push -u origin main` 把本地 `main` 分支推送到 `origin` 这个远程仓库。`-u` 是 `--set-upstream` 的简写，用来建立本地 `main` 和远程 `origin/main` 的跟踪关系——建立之后，这个分支上就可以直接用 `git push`，不用每次都写完整参数。

push 完之后回到 GitHub 页面刷新，应该能看到：`README.md` 显示在仓库首页；`hello.py` 和 `.gitignore` 出现在文件列表里；commit history 里能看到刚才本地创建的 `Initial commit`——这说明本地的 commit 真的同步到 remote repository 上了。

如果第一次 push 遇到认证问题，先不用纠结 token、SSH key 这些细节，优先检查 GitHub CLI 的登录状态：

```bash
gh auth status
gh auth login
gh auth setup-git
```

`gh auth setup-git` 会把 GitHub CLI 配置成 Git 的 credential helper，让后续 HTTPS push 能复用 `gh` 的登录状态——这里作为排障提示记一下就好，不用打断 remote/push 这条主线。

这里要强调一个常见误区：**`git commit` 只是保存到本地仓库，`git push` 才是把本地 commit 真正发送到远程仓库**。如果只 commit 不 push，GitHub 网页上是看不到你的新修改的。

## 日常流程：改一点东西，push

macOS + Windows Git Bash（Linux 可自行参考）:

```bash
printf '\n## Usage\n\nRun `python hello.py`.\n' >> README.md
git status
git diff
git add README.md
git commit -m "Document usage"
git push
```

Windows PowerShell:

```powershell
@'

## Usage

Run `python hello.py`.
'@ | Add-Content -Path README.md
git status
git diff
git add README.md
git commit -m "Document usage"
git push
```

```
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   README.md

no changes added to commit (use "git add" and/or "git commit -a")
diff --git a/README.md b/README.md
index e87b79c..4ba7f01 100644
--- a/README.md
+++ b/README.md
@@ -1,3 +1,7 @@
 # hello-github

 A tiny Python project for learning Git and GitHub.
+
+## Usage
+
+Run `python hello.py`.
[main e51cf68] Document usage
 1 file changed, 4 insertions(+)
To https://github.com/ukeSJTU/hello-github.git
   c4cfba2..e51cf68  main -> main
```

第一次 push 需要完整写 `git push -u origin main`；建立 upstream 之后，后续通常只需要 `git push` 就够了。如果 `git status` 显示本地分支 ahead of `origin/main`，意思就是本地有 commit 还没推上去。

顺带提一句 GitHub CLI 的快捷方式，但不作为课堂主线：

```bash
gh repo create hello-github --public --source=. --remote=origin --push
```

这条命令很方便，能把"创建 GitHub repo、添加 remote、push"合并成一步。初学阶段建议还是先手动走一遍完整流程，理解 remote 和 push 到底在干什么之后，再用 `gh` 提高效率。

下一步，我们要在这个仓库里第一次走一遍分支协作的完整流程：开分支、发 Pull Request、review、merge。
