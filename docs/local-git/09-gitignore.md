# `.gitignore`

这一节的主角不是命令，而是一个特殊文件：`.gitignore`。它的作用是告诉 Git：哪些文件不需要出现在 `git status` 里，也不应该被提交进仓库。

先制造一些不应该提交的文件：

```bash
echo "debug log" > debug.log
echo "SECRET_KEY=dev-secret" > .env
git status
```

```
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	.env
	debug.log

nothing added to commit but untracked files present (use "git add" to track)
```

这时候可以想一下：这些文件应该提交吗？`debug.log` 通常是程序运行时产生的日志，不该进版本历史；`.env` 里往往放着本地配置、密钥、token 之类的东西，更不该提交。

创建 `.gitignore` 来解决这个问题：

```bash
echo "*.log" > .gitignore
echo ".env" >> .gitignore
git status
```

```
On branch main
Untracked files:
  (use "git add <file>..." to include in what will be committed)
	.gitignore

nothing added to commit but untracked files present (use "git add" to track)
```

讲解要点：

- `.gitignore` 里的规则会影响 Git 怎么看待 untracked files——`*.log` 忽略所有 `.log` 结尾的文件，`.env` 忽略这个仓库里的 `.env` 文件。
- 被忽略的 untracked files，默认不会出现在 `git status` 里——你看，`debug.log` 和 `.env` 这次都不见了，只剩下 `.gitignore` 自己作为新文件出现。
- `.gitignore` 本身应该提交进仓库，因为它是团队共享的规则。

提交 `.gitignore`：

```bash
git add .gitignore
git commit -m "Add gitignore"
git status
```

```
[main 197bc9e] Add gitignore
 1 file changed, 2 insertions(+)
 create mode 100644 .gitignore
On branch main
nothing to commit, working tree clean
```

顺带认识一个查看 ignored files 的参数：

```bash
git status --ignored
```

```
On branch main
Ignored files:
  (use "git add -f <file>..." to include in what will be committed)
	.env
	debug.log

nothing to commit, working tree clean
```

它会显示被忽略的文件，适合排查"为什么 Git 看不到这个文件"这类问题。常见的忽略清单一般会有 `.DS_Store`、`*.log`、`.env`、`__pycache__/`、`node_modules/`、`dist/` 这些，不用一次记全，用到再查就行。

这里要强调一个常见误区：**`.gitignore` 只影响还没有被 Git 追踪的文件**。如果一个文件已经 commit 进仓库了，后来才把它写进 `.gitignore`，Git 仍然会继续追踪它的变化——这个误区正好可以顺势展开两个相关命令。

先看 `git add -A`：

```bash
echo "content" > extra.txt
rm foobar.txt
git status
git add -A
git status
```

```
On branch main
Changes not staged for commit:
  (use "git add/rm <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	deleted:    foobar.txt

Untracked files:
  (use "git add <file>..." to include in what will be committed)
	extra.txt

no changes added to commit (use "git add" and/or "git commit -a")
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	new file:   extra.txt
	deleted:    foobar.txt
```

讲解要点：

- 前面用过的 `git add <file>` 和 `git add .`，主要处理新增和修改的文件。
- `git add -A` 会把整个仓库里的新增、修改、删除都一并纳入 staging area，包括用 `rm` 删除、但还没告诉 Git 的文件——这里 `foobar.txt` 被删除、`extra.txt` 是新文件，`git add -A` 一次性把两者都staged 了。
- 这个例子只是演示效果，不需要真的提交——用完记得把示例文件恢复干净，保持后续演示环境不受影响。

再讲 `git rm --cached`，用来处理"文件已经被 commit，现在想让 Git 不再追踪它"这种情况。先制造这个场景——正常提交一个文件（这一步还没想起来要 ignore 它）：

```bash
echo "some local content" > local-only.txt
git add local-only.txt
git commit -m "Accidentally commit local-only file"
```

```
[main b4002ea] Accidentally commit local-only file
 1 file changed, 1 insertion(+)
 create mode 100644 local-only.txt
```

现在意识到这个文件其实是本地专属内容，不该进仓库，于是补上 `.gitignore` 规则，并用 `git rm --cached` 真正让 Git 停止追踪它：

```bash
echo "local-only.txt" >> .gitignore
git rm --cached local-only.txt
git add .gitignore
git status
git commit -m "Stop tracking local-only file"
```

```
rm 'local-only.txt'
On branch main
Changes to be committed:
  (use "git restore --staged <file>..." to unstage)
	modified:   .gitignore
	deleted:    local-only.txt

[main 3138887] Stop tracking local-only file
 2 files changed, 1 insertion(+), 1 deletion(-)
 delete mode 100644 local-only.txt
```

讲解要点：

- `git rm --cached <file>` 会把文件从 Git 的追踪和下一次 commit 中移除，但**保留**本地磁盘上的文件内容——对比一下普通的 `git rm <file>`：那个会连本地文件一起删掉，`--cached` 只解除追踪，文件还在。
- 这正好修复前面提到的误区：文件已经进了 Git 历史，光改 `.gitignore` 不够，还得靠 `git rm --cached` 主动让 Git 停止追踪它。
- 需要注意：这个操作只是在历史里新增了一次"删除"记录，之前的 commit 里仍然能看到这个文件曾经存在过；如果文件内容涉及密钥等敏感信息，光 `git rm --cached` 并不能把它从历史里彻底抹掉，更彻底的处理方式这门课不展开。

下一步，我们回过头看看课前配置过的那些身份信息到底是怎么运作的——也就是 `git config`。
