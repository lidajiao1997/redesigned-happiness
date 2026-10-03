# 南昌大学本科生毕业论文 LaTeX 模板 —— 统一版 v1.2.4

> **v1.2.4**（在 v1.2.3 基础上）：**“文献不出”从日志警告升级为 PDF 页面上的
> 红框提示 + 一键自检**。
> ① 文献表一个条目都没输出、而正文确有 `\cite` 时，直接在 PDF 的参考文献
>    位置印一个**红框黄底的中文提示框**，写明原因和可照做的解决办法。
>    v1.2.3 只往 `.log` 写一条警告——用户看的是 PDF，日志一眼都不会看，
>    问题因此被反复当成排版 bug 提出；
> ② 新增 `checkbib.bat`（Windows 双击）/ `checkbib.sh`（macOS、Linux）：
>    只读自检 xelatex / biber / latexmk / `.bcf` / `.bbl` 五项，直接给出结论；
> ③ 提示框不再受“首遍保持安静”的门槛限制——用户遇到的恰恰就是首遍
>    干净编译，v1.2.3 在页面上因此什么都没显示。
>    版式零改动：biber 正常时提示框**不会出现**，`[official]` 仍与
>    v1.1.5 基准逐像素一致。
>
> **v1.2.3**（在 v1.2.2 基础上）：**针对“参考文献不出”的自检与兼容**。
> ① 正文里的旧写法 `\bibliography{...}` 会被接管（给中文说明 + 照常输出
>    文献表）——此前它会报 `Can be used only in preamble` 并让文献表整个消失；
> ② 未注册任何 `.bib` 时自动兜底使用同目录的 `references.bib`；
> ③ 文献表若一个条目都没输出，日志里给出中文警告（列出三种常见原因）。
>    版式零改动（`[official]` 仍与 v1.1.5 基准逐像素一致）。
>
> **v1.2.2**（在 v1.2.1 基础上）：
> **`official` 与 `twoside` / `openright` 解耦**。v1.2.1 中三个选项互相清除、
> 后写者优先，导致 `[official,twoside,openright]` 时 `official` 被关闭、
> 章首页退回 plain。现在 `official` 只决定页眉方案，`twoside` / `openright`
> 只决定纸张设置，可自由叠加——双面印刷的规范组合：
>
> ```latex
> \documentclass[official,twoside,openright]{ncubachelor}
> ```
>
> 双面装订、各构成要素奇数开页，但**章首页仍 fancy（有页眉），不用 plain**
> （官方样张本就是"全程有页眉"）；空白填充页仍无页眉页脚。
>
> **v1.2.1**（在 v1.2.0 基础上）：
> ① 新增 **`official` 类选项**：完整复刻 v1.1.5 锁定版的官方样张页式——
>    单面，页眉章名居中 + **0.5pt 单横线**，页码居中页脚，各部分首页
>    （plain）**同样显示页眉**；
> ② 修复 v1.2.0 回归：`\printbibliography` 缺省标题不带目录项，导致
>    **“参考文献”缺席目录**；现默认走 `bibintoc`，目录恢复该条目
>    （仍可用 `\printbibliography[heading=...]` 覆盖）。
>
> **v1.2.0**（合并单面 v1.1.7 与双面另用版 v1.1.8）：
> ① 一套 `ncubachelor.cls`，单/双面由 `ncuhead` 一个开关选择；
> ② 无 `ncuhead` 的单面版页眉改为**章名居中 + 文武线**，章首页 plain（v1.1.6 前
>    单面页眉为 0.5pt 单线且章首页照常显示页眉）；
> ③ `ncuhead` = 双面 twoside + openright（奇数开页）：奇数页页眉当前章、
>    偶数页页眉"南昌大学本科生毕业论文"，页码外侧 LE/RO，文武线，章首页 plain；
> ④ 参考文献弃用 BibTeX + gbt7714 宏包，改用 **biblatex + biber 后端**
>    （gb7714-2015 样式），编译链相应变为 xelatex → biber → xelatex → xelatex。

## 页面方案（同一个类，类选项选择）

| 项目 | 默认（无选项） | `official` | `ncuhead` |
| --- | --- | --- | --- |
| 排版方式 | 单面（oneside） | 单面（可与 `twoside` 叠加） | 双面（twoside，隐含） |
| 页眉 | 当前章标题，**居中** | 当前章标题，**居中** | 奇数页内侧当前章标题；偶数页内侧"南昌大学本科生毕业论文" |
| 页眉线 | **文武线**（上粗 0.9pt、下细 0.3pt） | **0.5pt 单横线**（复刻 v1.1.5 / 官方样张） | 文武线 |
| 页码 | 页脚居中 | 页脚居中 | 外侧：偶数页 LE（左上）、奇数页 RO（右上） |
| 章首页（章、目录、摘要、声明、参考文献、附录、致谢） | **plain**：无页眉，页码居中页脚 | **与正文页相同**：照常显示章名页眉 | **plain**：无页眉，页码居中页脚 |
| 构成要素奇数开页 | 否 | 默认否；叠加 `openright` 后**是** | **是**（隐含 `openright`，`openany` 可关闭） |
| 装订偏移 | 无（可显式 `bindingoffset=`） | 无（`twoside` 下默认 5mm） | 默认 5mm，偶数页自动交替到内侧 |

`official` 与 `ncuhead` 都是页眉方案，二选一、**后写者优先**
（如 `[official,ncuhead]` 等价于 `[ncuhead]`）；`twoside` / `openright` /
`openany` 只管纸张与开页方式，可与任一页眉方案叠加。
`blindreview` 可与任一方案叠加。

版面其余要素（页面尺寸、行距、封面、信息栏、摘要、目录点线、图表、文献表、
致谢等）各种模式完全一致。`official` 已用 v1.1.5 原版示例文档做过 150dpi
逐页像素比对：除文献表页（biblatex 与 gbt7714 宏的条目排版差异）与正文
`\cite` 上标引发的个别断行外，**其余各页逐像素一致**。

## 构成要素奇数开页（`ncuhead` 下）

**声明、中文摘要、英文摘要、目录、正文各章、结论、参考文献、附录、致谢**
一律"视为章"：每个要素另起**纸张正面（奇数物理页）**；上一要素恰好结束在
正面时，自动补一张**不编页码、无页眉页脚**的空白页。以本目录 `main.tex`
为例（`ncuhead`）的实际页面安排：

| 物理页 | 内容 | 物理页 | 内容 |
| --- | --- | --- | --- |
| 1 | 封面（纸张正面） | 2 | 空白（封面背面） |
| 3 | 原创性申明与授权书 | 4 | 空白 |
| 5 | 中文摘要（罗马 I） | 6 | 空白 |
| 7 | 英文摘要（III） | 8 | 空白 |
| 9 | 目录（V） | 10 | 空白 |
| 11 | 正文第一章（阿拉伯 1） | 14 | 空白 |
| 15 | 第二章 | 20 | 空白 |
| 21 | 结论 | 24 | 空白 |
| 25 | 附录 A | 29 | 参考文献 |
| 31 | 致谢 | | |

若封面单独用封面纸打印，封面后的空白页恰好就是封面纸的背面，无须处理；
希望省去空白页时加 `openany`。

## 编译

**必须使用 XeLaTeX**；参考文献用 **biber** 后端，完整流程四步：

```
xelatex main.tex      # 第一遍：生成 .bcf 与 .aux（此时引用还是 ?）
biber   main          # 生成参考文献 .bbl
xelatex main.tex      # 第二遍：读入 .bbl 与编号
xelatex main.tex      # 第三遍：交叉引用稳定
```

三种执行方式，任选其一：

| 方式 | 操作 |
| --- | --- |
| 一键脚本（推荐） | Windows 双击 `build.bat`；macOS / Linux / Git Bash 执行 `sh build.sh` |
| latexmk | 直接运行 `latexmk`（本目录已配好 `.latexmkrc`，自动走完四步含 biber） |
| 手工 / 编辑器 | 按上面四条命令顺序执行 |

编不出文献时先用 `checkbib.bat`（Windows 双击）/ `sh checkbib.sh` 自检，
它会直接告诉你缺的是 xelatex、biber，还是 `.bbl` 没生成。

> **两个必须记住的设置**
>
> 1. 编译器选 **XeLaTeX**（选 pdfLaTeX 会直接报错）。
> 2. **文献后端是 biber，不是 BibTeX**（v1.2.0 起）。biblatex 把引用与
>    数据库信息写进 `.bcf` 控制文件，**bibtex 读的是 `.aux`，看不到这些信息**，
>    于是报 `I found no \citation commands / \bibdata command / \bibstyle command`
>    三条错并写出一个 **0 字节的 `.bbl`**——文献表因此整页消失。
>    把编辑器的文献工具改成 bibtex 只会让它更糟。
>    TeXstudio：`选项 → 设置 → 构建 → 默认文献工具 → biber`；
>    VS Code (LaTeX Workshop)：选择含 biber 的 recipe。不确定时直接用
>    `build.bat` / `build.sh` / `latexmk`，可完全绕开编辑器设置。
>
> 依赖宏包：`biblatex` 与 `biblatex-gb7714-2015`（TeX Live / MiKTeX 均自带）。

## 参考文献的写法（相对旧版的变化）

```latex
%% 导言区（不再用 \bibliography{...}）：
\addbibresource{references.bib}    % 带扩展名

%% 正文引用（用法不变）：
我们知道 lshort\cite{lshortcn} 是入门 \LaTeX{} 的必读文献。

%% 文献列表（放在 \backmatter 之后，取代旧的 \bibliography{references}）：
\printbibliography
```

样式为 **GB/T 7714—2015 顺序编码制**，连续编号自动压缩为 [1-3]；
电子资源用 `@online` 条目类型（配 `url` / `urldate` 字段）著录更规范，
普通 `@misc` / `@article` / `@book` 等照旧可用。

## 常见问题：正文里的 `?`、图表公式的 `??`、文献显示不出来

这是 LaTeX 分遍编译机制所致（编号由辅助文件在后续遍回填），按三步排查：

1. **看 `main.blg`**：应有 `This is Biber` 开头的日志。若报
   `Cannot find 'main.bcf'`，说明跑的是旧式 bibtex 或文献工具没跑；
   若 `main.bbl` 是 0 字节或不存在，文献表为空、`\cite` 永远是 `?`。
2. **看 `main.log` 里的 `undefined` 警告**：`Citation ... undefined` 指向文献，
   `Reference ... undefined` 指向图表公式编号，都说明编译遍数不够。
3. **直接重跑一键脚本**，它会完整走完四步。

## 常见问题：参考文献只有标题、没有条目（或整页不出）

**v1.2.0 起本模板的文献后端是 biber，不是 bibtex**（v1.1.x 及更早恰好相反）。
下面三种情况都会让文献表整个消失，而且通常不报错：

| 现象 | 原因 | 解决 |
| --- | --- | --- |
| 只有“参考文献”标题，一个条目都没有；`\cite` 显示为原始键名 | 编译链里用 **bibtex** 代替了 biber（bibtex 读不了 `.bcf`，写出的 `.bbl` 是 0 字节） | 改用 `build.bat` / `sh build.sh` / `latexmk`；编辑器里把文献工具设为 **biber** |
| 文献表整页不出现，日志里有 `Can be used only in preamble` | 正文仍在写旧写法 `\bibliography{references}`（biblatex 里该命令只能在导言区用） | 导言区写 `\addbibresource{references.bib}`，正文改用 `\printbibliography` |
| 文献表是空的，日志提示未注册文献库 | 忘了在导言区注册 `.bib` | 加 `\addbibresource{你的库.bib}` |

**v1.2.3 起模板会主动兜底与提示；v1.2.4 起提示直接写在 PDF 上**，不再静默：

- 正文里的旧写法 `\bibliography{...}` 会被接管：给出中文说明，并照常输出文献表；
- 若全文没有注册任何 `.bib`，自动使用同目录的 `references.bib`（会写一条 `[ncubachelor] NOTE` 到日志）；
- 若文献表没有输出任何条目而正文确有 `\cite`，**PDF 的参考文献位置会直接印出一个
  红框中文提示框**，写明原因与解决办法——biber 一旦跑通该框即自动消失，不会混进正式论文；
- 同时日志里仍保留一条中文警告；

`\cite` 显示为原始键名（如 `lshortcn` 而不是 `[1]`）同样是文献后端没跑对的表现——
biber 成功运行时会渲染成 `[1]`。

### 30 秒自查：文献为什么不出来

不确定缺什么时，运行本目录的自检脚本（只读，不改任何文件）：

| 系统 | 操作 |
| --- | --- |
| Windows | 双击 `checkbib.bat` |
| macOS / Linux | `sh checkbib.sh` |

它会依次检查 `xelatex`、`biber`、`latexmk`、`main.bcf`、`main.bbl` 五项，
最后一行直接给出结论（例如“biber 没装 / biber 没跑 / `.bbl` 是 0 字节说明用了 bibtex”）。

## 常用选项组合

```latex
\documentclass{ncubachelor}                % 单面打印版（页眉章名居中，文武线，章首页 plain）
\documentclass[official]{ncubachelor}      % 官方样张版式（复刻 v1.1.5：章名居中，0.5pt 单线，章首页同页眉）
\documentclass[official,twoside,openright]{ncubachelor} % 官方样张页式 + 双面装订 + 奇数开页（章首页仍 fancy）
\documentclass[ncuhead]{ncubachelor}       % 双面装订版（含奇数开页）
\documentclass[ncuhead,openany]{ncubachelor} % 双面，取消奇数开页
\documentclass[ncuhead,blindreview]{ncubachelor} % 盲审版（双面）
\documentclass[official,blindreview]{ncubachelor} % 盲审版（单面官方样张）
```

其余选项（`fontset=`、`tocdots`、`blindreview`、`bindingoffset=`、
`\ncusetup` 高级键、语义化命令、定理环境等）见模板 `ncubachelor.cls`
头部的注释说明。

> **注意**：盲审选项拼写为 **`blindreview`**（常见误拼 `blindview` /
> `blindrereview` 也已作容错别名接受）。开启后，封面与致谢落款中的
> 姓名、学号、导师、职称自动替换为 `***`，并清除 PDF 元数据中的作者
> 信息；正文其他位置**手写**的姓名不在遮蔽范围内，请自行使用
> `\thesisauthor` 等语义化命令代替硬编码。
