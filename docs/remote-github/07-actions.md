# GitHub Actions：让 GitHub 自动跑检查

先从一个问题开始：PR 里别人提交的代码，靠人眼看不够，我们怎么自动确认它至少能运行、测试能通过？

这个问题引出 CI：人会忘记在本地跑测试；不同人的电脑环境不同，本地能跑不代表别人也能跑；PR merge 前应该有自动检查，减少把坏代码合进主分支的概率。CI 的核心目标就是：**自动验证代码是否还正常**。

先分清 CI/CD：CI（Continuous Integration，持续集成）常见内容是自动测试、自动检查、自动构建；CD（Continuous Delivery / Deployment，持续交付/部署）常见内容是自动发布、自动部署。这一节先讲 CI，CD 只提一嘴。

GitHub Actions 的最小模型：

```plaintext
event -> workflow -> job -> step -> command/action
```

- **event**：什么事情触发自动化，比如 `push`、`pull_request`。
- **workflow**：写在 `.github/workflows/*.yml` 里的自动化配置。
- **job**：一组在 runner 上执行的任务。
- **step**：job 里的具体步骤。
- **runner**：GitHub 提供的临时运行环境，比如 `ubuntu-latest`。
- **action**：别人写好的可复用步骤，比如 checkout 代码、安装 Python。

## 先在本地补一个最小测试

继续用前面的 `hello-github` 项目：

macOS + Windows Git Bash（Linux 可自行参考）:

```bash
printf 'from hello import greet\n\n\ndef test_greet():\n    assert greet("GitHub") == "Hello, GitHub!"\n' > test_hello.py
python -m pip install pytest
python -m pytest
```

Windows PowerShell:

```powershell
@'
from hello import greet


def test_greet():
    assert greet("GitHub") == "Hello, GitHub!"
'@ | Set-Content -Path test_hello.py
python -m pip install pytest
python -m pytest
```

```
============================= test session starts ==============================
platform darwin -- Python 3.12.12, pytest-9.1.1, pluggy-1.6.0
rootdir: /path/to/your/hello-github
collected 1 item

test_hello.py .                                                          [100%]

============================== 1 passed in 0.00s ===============================
```

先让测试在本地跑通，再放进 CI——CI 不是魔法，本质上就是在 GitHub 的 runner 里自动执行类似的命令。

提交测试文件：

```bash
git add test_hello.py
git commit -m "Add greeting test"
```

## 创建 workflow

macOS + Windows Git Bash（Linux 可自行参考）:

```bash
mkdir -p .github/workflows
```

Windows PowerShell:

```powershell
New-Item -ItemType Directory -Force -Path .github/workflows | Out-Null
```

`.github/workflows/ci.yml`：

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

讲解要点：

- `name: CI` 是 workflow 的显示名称。
- `on` 定义触发条件：push 到 `main` 或创建/更新 PR。
- `jobs.test` 定义一个名为 `test` 的 job；`runs-on: ubuntu-latest` 表示在 GitHub 提供的 Ubuntu runner 上运行。
- `actions/checkout@v4` 把仓库代码 checkout 到 runner；`actions/setup-python@v5` 安装指定 Python 版本。
- `run` 在 GitHub runner 的默认 shell 里执行命令，概念上类似你在本地终端里敲命令，但真实运行环境是 GitHub 提供的临时 Ubuntu 机器。

提交并 push：

```bash
git add .github/workflows/ci.yml
git commit -m "Add CI workflow"
git push
```

回到 GitHub 页面观察，或者直接用 `gh run watch` 在终端里等它跑完：

```bash
gh run watch <run-id> --exit-status
gh run view <run-id>
```

```
✓ main CI · 28805021238
Triggered via push less than a minute ago

JOBS
✓ test in 6s (ID 85418190152)

View this run on GitHub: https://github.com/ukeSJTU/hello-github/actions/runs/28805021238
```

Actions tab 里出现了这次 CI run；如果是走 PR 流程，PR 页面也会出现 checks。绿色表示通过，红色表示失败——真实项目里经常要求 checks passed 之后才能 merge。

## 故意制造一次失败

把 `test_hello.py` 里的期望字符串改错：

macOS + Windows Git Bash（Linux 可自行参考）:

```bash
python -c 'from pathlib import Path; p = Path("test_hello.py"); p.write_text(p.read_text().replace("Hello, GitHub!", "Hello, World!"))'
git commit -am "Break the test on purpose"
git push
```

Windows PowerShell:

```powershell
python -c 'from pathlib import Path; p = Path("test_hello.py"); p.write_text(p.read_text().replace("Hello, GitHub!", "Hello, World!"))'
git commit -am "Break the test on purpose"
git push
```

```
X main CI · 28805096806

JOBS
X test in 6s (ID 85418451480)
  ✓ Set up job
  ✓ Run actions/checkout@v4
  ✓ Run actions/setup-python@v5
  ✓ Run python -m pip install pytest
  X Run python -m pytest
  ...
X Process completed with exit code 1.
```

用 `gh run view <run-id> --log-failed` 能直接看到失败的具体 log，和本地跑 `pytest` 失败时看到的东西一模一样：

```
    def test_greet():
>       assert greet("GitHub") == "Hello, World!"
E       AssertionError: assert 'Hello, GitHub!' == 'Hello, World!'
E
E         - Hello, World!
E         + Hello, GitHub!

test_hello.py:5: AssertionError
```

讲解要点：

- 本地测试失败长什么样，GitHub Actions 失败就长什么样——CI 只是把这件事自动化、放到一个干净的远程环境里重新做一遍。
- CI 失败时应该先看 log，搞清楚具体是哪一行断言失败，而不是盲目重跑。

改回来，让仓库恢复绿色：

macOS + Windows Git Bash（Linux 可自行参考）:

```bash
python -c 'from pathlib import Path; p = Path("test_hello.py"); p.write_text(p.read_text().replace("Hello, World!", "Hello, GitHub!"))'
git commit -am "Fix the test"
git push
```

Windows PowerShell:

```powershell
python -c 'from pathlib import Path; p = Path("test_hello.py"); p.write_text(p.read_text().replace("Hello, World!", "Hello, GitHub!"))'
git commit -am "Fix the test"
git push
```

一句话记住这一节：**GitHub Actions 让 GitHub 在特定事件发生时，自动帮我们跑一组命令，最常见的用途是 PR 自动测试。**

matrix、cache、secrets、deployment、release automation、self-hosted runner、permissions、reusable workflow 这些 Actions 的进阶能力，这门课第一次讲先不展开——留着以后需要的时候再学。

到这里，这门课的主线内容就都学完了：从本地 Git 的 init/add/commit 一路到 branch、merge，再到 GitHub 上的 fork、PR、Issue、CI，一整套现代软件协作的核心流程，你已经亲手做过一遍了。
