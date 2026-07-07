# `git log`

现在已经有了一次 commit。是时候看看 Git 到底把历史记成了什么样——这就是 `git log`。

```bash
git log
```

```
commit bc3a22acd0a4d60fab4d68c947992f010a7bec9e
Author: Course Instructor <instructor@example.com>
Date:   Mon Jul 6 22:40:55 2026 +0800

    Add foobar file
```

讲解要点：

- `git log` 用来查看 commit 历史，默认按时间倒序排列，最新的 commit 在最上面。
- 默认输出里重点看四样东西：commit hash、Author、Date、commit message。
- commit hash 就是 Git 给每次 commit 生成的唯一标识，这一节先把它当成"版本号"来理解就够，后面讲到内部对象模型时再回来解释它其实来自内容寻址（content-addressed）。
- 如果 `git log` 打开了分页界面卡住不动，按 `q` 退出——这个细节很多人第一次会卡住，提前说一句就好。

为了让 `git log` 更有意义，马上制造第二次 commit：

macOS + Windows Git Bash（Linux 可自行参考）:

```bash
echo "second line" >> foobar.txt
git status
git add foobar.txt
git commit -m "Update foobar file"
git log
```

Windows PowerShell:

```powershell
Add-Content -Path foobar.txt -Value "second line"
git status
git add foobar.txt
git commit -m "Update foobar file"
git log
```

```
On branch main
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git restore <file>..." to discard changes in working directory)
	modified:   foobar.txt

no changes added to commit (use "git add" and/or "git commit -a")
[main e9d380a] Update foobar file
 1 file changed, 1 insertion(+)
commit e9d380af46f8ae7c2185b8ba1855532ff8858af3
Author: Course Instructor <instructor@example.com>
Date:   Mon Jul 6 22:40:55 2026 +0800

    Update foobar file

commit bc3a22acd0a4d60fab4d68c947992f010a7bec9e
Author: Course Instructor <instructor@example.com>
Date:   Mon Jul 6 22:40:55 2026 +0800

    Add foobar file
```

现在历史里有两条 commit了，新的在上面，旧的在下面，各自带着自己的 hash 和 message。这就是 `git log` 存在的意义：让你能回头看清楚"项目是怎么一步步变成现在这样的"。

顺带认识一个高频参数：

```bash
git log --oneline
```

```
e9d380a Update foobar file
bc3a22a Add foobar file
```

`--oneline` 把每条 commit 压缩成一行（短 hash + message），历史一多起来，这个格式比默认输出好扫视得多。

`git log --graph --all --decorate` 这类参数先不展开——等讲到 branch 之后再用，那时候才真正需要"看分支图"这件事。

两次 commit 也够我们回头总结一下 Git 本地到底是怎么运作的了——见下一节的阶段性总结。
