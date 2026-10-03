# 南昌大学本科生毕业设计（论文）文档类

> **版本** v1.2.4（2026/10/02）  
> **基础文类** `ctexbook`　|　**引擎** XeLaTeX　|　**文献后端** biblatex + biber  
> **适用范围** 仅本科（学士学位）论文，不含研究生学位类型  
> **编写依据**《南昌大学本科生毕业设计（论文）书写式样》（附件 7）

本文档是 `ncubachelor.cls` 的**接口手册**：类选项、`\ncusetup` 配置键、  
语义化命令、环境与版式参数。模板的版本公告、编译排错与常见问题见同目录的  
[`README.md`](README.md)。

---

## 1. 这是什么

一个把《书写式样》逐条落成代码的 LaTeX 文档类。封面、原创性申明与授权书、  
中英文摘要、目录、正文、参考文献、致谢的**全部版式由类文件自动完成**，  
用户只负责填元信息、写正文。

类文件自身不做任何字体硬编码：中文字体方案外置为 `ncu-font-*.def`，  
由类选项 `fontset` 选择或自动探测（见 §14）。

---

## 2. 文件清单

| 文件                             | 角色                               | 必需  |
| ------------------------------ | -------------------------------- | --- |
| `ncubachelor.cls`              | 文档类本体（本文档的主角）                    | ✅   |
| `ncu-font-windows.def`         | 字体定义：中易宋体 / 黑体 / 楷体 / 仿宋         | 按方案 |
| `ncu-font-mac.def`             | 字体定义：macOS 宋体-简 / 苹方             | 按方案 |
| `ncu-font-founder.def`         | 字体定义：方正字库                        | 按方案 |
| `ncu-font-adobe.def`           | 字体定义：思源宋体 / 黑体                   | 按方案 |
| `ncu-font-fandol.def`          | 字体定义：Fandol（TeX 发行版自带，**兜底**）    | 兜底  |
| `ncu-name.png`                 | 封面**校名**标识（1.88 cm × 6.59 cm，居中） | ✅   |
| `ncu-badge.jpg`                | 封面**校徽**标识（3.33 cm × 3.33 cm，居中） | ✅   |
| `main.tex`                     | 示例文档，可直接当论文骨架                    | 示例  |
| `references.bib`               | 参考文献库                            | 示例  |
| `build.bat` / `build.sh`       | 一键四步编译                           | 推荐  |
| `checkbib.bat` / `checkbib.sh` | 文献环境只读自检                         | 排错  |
| `.latexmkrc`                   | latexmk 配置（自动走 biber）            | 推荐  |

> 字体定义文件必须与 `ncubachelor.cls` **同目录**，或放在 TeX 搜索路径中；  
> 找不到时类会给出警告并**自动退回 Fandol**。

---

## 3. 快速开始

最小可用文档（`mythesis.tex`）：

```latex
\documentclass[official]{ncubachelor}      % 见 §5 选项表
\addbibresource{references.bib}            % 文献库（带扩展名）

\ncusetup{
  info = {
    secret-level    = {公开},
    title           = {你的中文题目},
    title*          = {Your English Title},
    college         = {物理},
    department      = {力学},
    major-class     = {物理学 2023 班},
    major           = {物理学},
    author          = {张三},
    studentid       = {402230220001},
    supervisor      = {李四},
    supervisor-title= {教授},
    start-date      = {23},                 % 只写两位年号，封面自动拼成 (20xx—20xx 年)
    stop-date       = {27},
    start-stop-date = {2023 年 9 月—2027 年 6 月}
  }
}

\begin{document}
\maketitle              % 封面
\makedecaut             % 原创性申明与授权书
\frontmatter            % 页码转罗马数字
  \begin{abstract}
    中文摘要正文……\keywords{关键词一；关键词二}
  \end{abstract}
  \begin{abstract*}
    English abstract……\keywords{keyword one; keyword two}
  \end{abstract*}
  \tableofcontents
\mainmatter             % 页码转阿拉伯数字
  \chapter{引言}
  ……
\backmatter
  \printbibliography
  \begin{acknowledgements}
    致谢正文……\signoff{张三}{2027 年 6 月}
  \end{acknowledgements}
\end{document}
```

结构顺序是**约定好的**：封面 → 声明与授权书 → `\frontmatter` → 中英文摘要 →  
目录 → `\mainmatter` → 正文 → `\backmatter` → 参考文献 → 致谢。  
（`\frontmatter` / `\mainmatter` / `\backmatter` 均被类文件重定义，  
会在编号切换前做**纸张奇偶校准**，不要绕开它们自行 `\pagenumbering`。）

---

## 4. 编译与依赖

**必须用 XeLaTeX**（类加载时检查引擎；非 XeTeX/LuaTeX 直接 `\msg_fatal`）。  
参考文献自 v1.2.0 起改用 **biblatex + biber**，编译链为四步：

```
xelatex main        # 第一遍：生成 .bcf / .aux（引用仍是 ?）
biber   main        # 生成 .bbl
xelatex main        # 第二遍：读入 .bbl 与编号
xelatex main        # 第三遍：交叉引用稳定
```

三种执行方式任选：

| 方式       | 操作                                                    |
| -------- | ----------------------------------------------------- |
| 一键脚本（推荐） | Windows 双击 `build.bat`；macOS / Linux 执行 `sh build.sh` |
| latexmk  | 直接 `latexmk`（仓库已配 `.latexmkrc`，自动含 biber）             |
| 手工       | 按上面四条命令顺序执行                                           |

> **两个必须记住的设置**
>
> 1. 编译器选 **XeLaTeX**（pdfLaTeX 会直接报错）。
> 2. 文献工具选 **biber，不是 BibTeX**。biblatex 的信息写在 `.bcf`，  
>    bibtex 只读 `.aux`，读不懂就写出 0 字节的 `.bbl`，文献表整页消失。
>
> TeXstudio：`选项 → 设置 → 构建 → 默认文献工具 → biber`；  
> VS Code（LaTeX Workshop）：选含 biber 的 recipe，或用 latexmk。

**依赖宏包**（TeX Live / MiKTeX 完整版均自带）：  
`ctexbook`、`expl3` / `l3keys2e`、`geometry`、`graphicx`、`fancyhdr`、`tocloft`、  
`tocbibind`、`enumitem`、`caption`、`subcaption`、`amsmath`、`amssymb`、  
`mathtools`、`bm`、`booktabs`、`array`、`multirow`、`longtable`、`tabularx`、  
`biblatex` + `biblatex-gb7714-2015`、`comment`、`xcolor`、`hyperref`。

---

## 5. 类选项

```latex
\documentclass[<选项>,<选项>,...]{ncubachelor}
```

### 5.1 页眉方案（二选一，**后写者优先**）

| 选项          | 纸张                           | 页眉                          | 页眉线           | 页码         | 章首页             |
| ----------- | ---------------------------- | --------------------------- | ------------- | ---------- | --------------- |
| **（无选项）默认** | 单面                           | 当前章标题，**居中**                | 文武线           | 页脚居中       | `plain`（无页眉）    |
| `official`  | 单面（可叠加 `twoside`）            | 当前章标题，**居中**                | **0.5pt 单横线** | 页脚居中       | **同正文页**（照常有页眉） |
| `ncuhead`   | 双面（隐含 `twoside`+`openright`） | 奇页内侧＝当前章；偶页内侧＝「南昌大学本科生毕业论文」 | 文武线           | 外侧 LE / RO | `plain`（无页眉）    |

- `official` 复刻 v1.1.5 锁定版，即官方样张的「**全程有页眉**」。
- `official` **只决定页眉方案，不动纸张设置**，故可与 `twoside` / `openright`  
  自由叠加；双面印刷的规范组合是  
  `\documentclass[official,twoside,openright]{ncubachelor}`。

### 5.2 纸张与开页

| 选项                   | 含义                                                             |
| -------------------- | -------------------------------------------------------------- |
| `twoside`            | 双面：对称内外侧边距、奇偶页眉位置交替、空偶数页不显示页眉页脚                                |
| `oneside`            | 单面（默认）                                                         |
| `bindingoffset=<长度>` | 装订偏移，交给 `geometry`；`twoside` 下**默认 5 mm**（A4 胶装通用值），写 `0mm` 关闭 |
| `openright`          | 各构成要素从**纸张正面**（奇数物理页）开始，必要时自动补一张不编页码、无页眉页脚的空白页                 |
| `openany`            | 取消奇数开页：要素紧接上一页，不补空白页（后写者优先）                                    |

> **「视为章」约定**：声明、中文摘要、英文摘要、目录、正文各章、结论、  
> 参考文献、附录、致谢在本模板中**一律视同章**——`openright` 一开，  
> 每个要素都另起纸张正面。走 `\chapter` 的要素由 `ctexbook` 处理，  
> 不走 `\chapter` 的（声明、摘要、目录）由类内部的 `\ncu@oddpage` /  
> `\ncu@partstart` 补齐。

### 5.3 内容与字体

| 选项                | 取值                                                                   | 默认      | 含义                                                                    |
| ----------------- | -------------------------------------------------------------------- | ------- | --------------------------------------------------------------------- |
| `fontset=`        | `auto` / `windows` / `mac` / `founder` / `adobe` / `fandol` / `none` | `auto`  | 中文字体方案；`auto` 按 Windows → macOS → 方正 → 思源 → Fandol 依次探测；`none` 表示你自己配 |
| `tocdots`         | `true` / `false`                                                     | `true`  | 目录点线引导符（官方样张无点线，还原请写 `tocdots=false`）                                 |
| `draft` / `final` | —                                                                    | `final` | `draft` 透传给 `ctexbook` 与 `graphicx`：图片变占位框、加快编译                       |

### 5.4 盲审

| 选项            | 含义                                                      |
| ------------- | ------------------------------------------------------- |
| `blindreview` | 封面与摘要信息栏中的**姓名、学号、导师、职称**自动替换为 `***`；同时清空 PDF 元数据中的作者信息 |
| `blindview`   | 常见误拼的**容错别名**，等价于 `blindreview`                         |

> 遮蔽只覆盖类自己排版的字段（封面、摘要信息栏、致谢落款）。  
> 正文里**手写**的姓名不在范围内——请改用 `\thesisauthor` 等语义化命令  
> （§7），这样正式版与盲审版一键切换，源信息不变。

### 5.5 常用组合

```latex
\documentclass{ncubachelor}                             % 单面打印版
\documentclass[official]{ncubachelor}                   % 官方样张版式（示例 main.tex 所用）
\documentclass[official,twoside,openright]{ncubachelor} % 官方样张页式 + 双面 + 奇数开页
\documentclass[ncuhead]{ncubachelor}                    % 双面装订版
\documentclass[ncuhead,openany]{ncubachelor}            % 双面且不补空白页
\documentclass[ncuhead,blindreview]{ncubachelor}        % 双面盲审版
\documentclass[official,blindreview,fontset=mac]{ncubachelor}
```

---

## 6. `\ncusetup` 配置键

统一入口：`\ncusetup{ <组> = { <键> = <值>, ... } }`，可多次调用，后写者覆盖。  
未知键不会报错，只在日志里给一条 `Unknown ... key` 警告。

### 6.1 `info` —— 论文元信息（**必填**）

| 键                                 | 说明                                               |
| --------------------------------- | ------------------------------------------------ |
| `secret-level`                    | 密级（封面右上角）                                        |
| `title`                           | 中文题目（封面大标题 + 中文摘要页眉上方）                           |
| `title*`                          | 英文题目（英文摘要页眉上方，可含 `\\` 手动断行）                      |
| `college` / `department`          | 学院 / 系（封面同一行两个下划线字段）                             |
| `major-class`                     | 专业班级                                             |
| `major`                           | 专业（中文摘要信息栏）                                      |
| `author`                          | 学生姓名                                             |
| `studentid`                       | 学号                                               |
| `supervisor` / `supervisor-title` | 指导教师 / 职称                                        |
| `start-date` / `stop-date`        | 封面年份行的**两位年号**（如 `23`、`27`，模板拼成 `（20xx—20xx 年）`） |
| `start-stop-date`                 | 封面「起讫日期」下划线内容（完整写法，如 `2023 年 9 月—2027 年 6 月`）    |

### 6.2 `style` —— 可替换的图片

| 键             | 默认              | 说明     |
| ------------- | --------------- | ------ |
| `name-image`  | `ncu-name.png`  | 封面校名标识 |
| `badge-image` | `ncu-badge.jpg` | 封面校徽标识 |

### 6.3 `blind` —— 盲审细节（配合 `blindreview` 类选项）

| 键                      | 默认      | 说明                                     |
| ---------------------- | ------- | -------------------------------------- |
| `text`                 | `***`   | 遮蔽占位文本                                 |
| `hide-acknowledgement` | `false` | `true` 时**整页排除致谢**（内部用 `comment` 宏包实现） |

```latex
\ncusetup{ blind = { text = {×××}, hide-acknowledgement = true } }
```

### 6.4 `theorem` / `proof` —— 定理环境样式

| 键                     | 默认                 | 可选值                                  |
| --------------------- | ------------------ | ------------------------------------ |
| `theorem/header-font` | `\songti\bfseries` | 任意命令序列                               |
| `theorem/within`      | `chapter`          | `chapter` / `section` / `none`（编号锚点） |
| `proof/qed`           | `$\blacksquare$`   | 任意符号                                 |

```latex
\ncusetup{ theorem = { header-font = \heiti, within = section },
           proof   = { qed = $\square$ } }
```

---

## 7. 语义化信息命令

正文、封面、摘要一律通过**语义化命令**取元信息，不要硬编码：

| 命令                                     | 内容        | 盲审下    |
| -------------------------------------- | --------- | ------ |
| `\thesistitle` / `\thesisentitle`      | 中 / 英文题目  | 不遮蔽    |
| `\thesiscollege` / `\thesisdepartment` | 学院 / 系    | 不遮蔽    |
| `\thesismajorclass` / `\thesismajor`   | 专业班级 / 专业 | 不遮蔽    |
| `\thesisauthor`                        | 学生姓名      | **遮蔽** |
| `\thesisstudentid`                     | 学号        | **遮蔽** |
| `\thesissupervisor`                    | 指导教师      | **遮蔽** |
| `\thesissupervisortitle`               | 导师职称      | **遮蔽** |
| `\thesisdates`                         | 起讫日期      | 不遮蔽    |

---

## 8. 结构命令

| 命令                        | 功能                                                                     |
| ------------------------- | ---------------------------------------------------------------------- |
| `\maketitle`              | 输出**封面**（无页眉页脚）：密级、校名标识、校名外文、学士学位论文、THESIS OF BACHELOR、年份行、校徽、题目、五行信息栏 |
| `\makedecaut`             | 输出**原创性申明与学位论文版权使用授权书**（同页，无页眉页脚）                                      |
| `\frontmatter`            | 前置部分：页码转**罗马数字**（重定义版，先做纸张奇偶校准）                                        |
| `\mainmatter`             | 正文：页码转**阿拉伯数字**（同上）                                                    |
| `\backmatter`             | 后置部分：取消章节编号模式                                                          |
| `\unnumberedchapter{标题}`  | 无编号章（结论、附录外的自定义章）：**进目录、进页眉**，`openright` 下从纸张正面开始                     |
| `\appendix`               | 标准 LaTeX 命令，附录编号自动变 `附录 A`、`附录 B`                                      |
| `\addbibresource{xx.bib}` | 导言区注册文献库（**须带扩展名**）                                                    |
| `\printbibliography`      | 输出文献表（默认 `heading=bibintoc`，自动进目录并置于纸张正面）                              |

---

## 9. 环境

### 9.1 摘要

| 环境          | 说明                                                                          |
| ----------- | --------------------------------------------------------------------------- |
| `abstract`  | 中文摘要：页眉「摘要」、进目录、标题小二宋体加粗、信息栏五号、正文小四；行内用 `\keywords{...}` 给关键词（自动加粗「关键词：」）   |
| `abstract*` | 英文摘要：页眉「Abstract」、进目录、标题小二、行距单独调为 1.29；行内用 `\keywords{...}`（渲染为 `Keyword:`） |

`abstract` / `abstract*` 内部自带 `\thispagestyle{plain}`，且在 `openright`  
下「视为章」从纸张正面开始。

### 9.2 致谢

```latex
\begin{acknowledgements}
  致谢正文……
  \signoff{张三}{2027 年 6 月}   % 右对齐的两行落款（姓名行受盲审遮蔽）
\end{acknowledgements}
```

### 9.3 定理类环境（14 个）

`theorem` 定理、`law` 定律、`principle` 原理、`axiom` 公理、`lemma` 引理、  
`inference` 推论、`conclusion` 结论、`proposition` 命题、`definition` 定义、  
`assumption` 假设、`property` 性质、`remark` 注解、`condition` 条件、  
`example` 例。

```latex
\begin{theorem}[可编译性]    % 方括号内为附加说明，可省略
  ……
\end{theorem}
```

编号格式 `章.序`（如 `2.1`），锚点可用 `\ncusetup{theorem={within=...}}` 改为  
`section` 或 `none`。

### 9.4 证明

```latex
\begin{proof}        % 可选参数改头部文字，默认「证明」
  …… 由上一节即得。
\end{proof}          % 自动以 \qed 符号（默认 ■）右对齐收尾
```

---

## 10. 实用命令

| 命令                                  | 用途                                     |
| ----------------------------------- | -------------------------------------- |
| `\keywords{...}`                    | 摘要关键词（仅在 `abstract` / `abstract*` 内有效） |
| `\signoff{姓名}{日期}`                  | 致谢落款（仅 `acknowledgements` 内有效）         |
| `\thickhline`                       | 三线表的**粗横线**（配合 `booktabs` 风格使用）        |
| `\freeze`                           | 证毕符号 `■`，文字模式与数学模式均可用                  |
| `\blfootnote{...}`                  | **无编号**脚注（标注科研项目来源等），不占脚注计数            |
| `\ncufield{最小宽度}{内容}`               | 带下划线的字段盒；内容超宽时线自动加长，**不溢出**            |
| `\thispagestyle{plain}` / `{empty}` | 单页取消页眉 / 完全空白（插图页、整页表格常用）              |

---

## 11. 版式参数速查

### 11.1 页面（书写式样·第一条）

```
a4paper  上 2.54cm  下 2.54cm  左 3.67cm  右 2.67cm
headheight 15pt   headsep 14.5pt   footskip 7mm   \raggedbottom
正文：小四号（12bp），行距 linespread = 1.56（实测 8.0mm/行）
```

### 11.2 语义化字号宏（可 `\renewcommand` 整体改版式）

| 宏                       | 字号     | 用途      |
| ----------------------- | ------ | ------- |
| `\ncufontcover`         | 四号     | 封面信息栏   |
| `\ncufonttitle`         | 三号     | 封面题目    |
| `\ncufontchapter`       | 四号     | 章 / 节标题 |
| `\ncufontbody`          | 小四     | 正文      |
| `\ncufontheader`        | 五号宋体   | 页眉页脚    |
| `\ncufontcaption`       | 五号宋体   | 图表标题    |
| `\ncufontabstracttitle` | 小二     | 摘要标题    |
| `\ncufonttoctitle`      | 小三宋体加粗 | 目录标题    |


### 11.3 标题层级（书写式样·第五条）

| 层级                               | 格式              | 编号                  |
| -------------------------------- | --------------- | ------------------- |
| `\chapter`                       | 宋体四号**居中**（不加粗） | 「第一章」（中文数字）         |
| `\section`                       | 宋体四号**居左**      | `1.1`（阿拉伯章号）        |
| `\subsection` / `\subsubsection` | 宋体小四**加粗**      | `1.1.1` / `1.1.1.1` |

`secnumdepth = 3`，`tocdepth = 2`（目录收录到小节）。

### 11.4 编号与标题（书写式样·第二条、第六条）

- 图 / 表 / 公式编号均为 **`章-序`**：`图1-1`、`表1-1`、`式(1-1)`，子图 `(a)`。
- 图表标题：**五号宋体加粗居中**；序与名之间空**一个汉字宽**；  
  **表题在上**（`skip=6bp`）、**图题在下**（`skip=6bp`）；浮动体内容五号宋体。
- 目录：标题「目　录」小三宋体加粗居中，条目小四宋体，点线默认开启。
- 脚注：小五号宋体（9bp/11bp），脚注线宽 0.25 栏宽。
- 文献表：小四号宋体，条目间距 2bp plus 1bp。

### 11.5 行距微调点

| 位置      | 行距   | 依据                   |
| ------- | ---- | -------------------- |
| 正文      | 1.56 | 官方样张实测 8.0 mm/行      |
| 声明与授权书页 | 1.76 | 该页实测 9.0 mm/行        |
| 英文摘要页   | 1.29 | Times 字体下实测 6.6 mm/行 |

---

## 12. 页眉线三态

类内部用三个宏显式切换，避免 `fancyhdr` 的全局残留：

| 宏                      | 效果                   | 用于                   |
| ---------------------- | -------------------- | -------------------- |
| `\ncu@headrule@single` | 0.5pt 单横线            | `official`、`twoside` |
| `\ncu@headrule@wenwu`  | 文武线（上 0.9pt、下 0.3pt） | 默认、`ncuhead`         |
| `\ncu@headrule@none`   | 无横线                  | 各 `plain` 页          |

页眉/页码内容取自 `\leftmark`（章标题由 `\chaptermark` 设入），  
所以结论、致谢、参考文献等**无编号章**的标题也会自动进页眉，无需手工设置。  
`\sectionmark` 被置空——节标题不参与页眉。

---

## 13. 参考文献机制（v1.2.0 起）

样式：**GB/T 7714—2015 顺序编码制**（`biblatex` 的 `gb7714-2015` 样式），  
连续编号自动压缩为 `[1-3]`。改版对用户的影响：

```latex
%% 导言区（取代旧的 \bibliography{references}）：
\addbibresource{references.bib}     % 带 .bib 扩展名

%% 正文引用：用法不变
……\cite{lshortcn}……\cite{pew}……

%% 文献列表（取代旧的 \bibliography{references}）：
\printbibliography                  % 已默认 heading=bibintoc（进目录、奇数开页）
```

**类的三层防护**：

1. **旧写法兼容**——正文里写 `\bibliography{...}` 不再导致文献表消失，  
   改为给出中文说明并照常 `\printbibliography`  
   （biblatex 把该命令标为 preamble-only，类挂在 `begindocument/end` 钩子上接管）。
2. **自动兜底**——全文没有 `\addbibresource` 而同目录存在 `references.bib` 时，  
   类会在 `\AtEndPreamble` 自动注册它，并向日志写一条 `[ncubachelor] NOTE`。
3. **PDF 页面级提示（v1.2.4）**——若文献表**一个条目都没印出来**而正文确有 `\cite`，  
   类会直接在 PDF 的参考文献位置印一个**红框黄底中文提示框**，写明原因与四条  
   可照做的解决办法；同时日志保留一条中文警告。  
   判据不是探测 `.bbl`（XeTeX 无法可靠判断 0 字节文件），而是  
   `\AtEveryCite` / `\AtEveryBibitem` 的置位标志：**「有引用、无条目」= 后端没跑对**。  
   没有任何 `\cite` 的文档保持安静。**biber 跑通后提示框自动消失**，不会混进正式论文。

排错请用 `checkbib.bat` / `sh checkbib.sh`：只读自检 `xelatex`、`biber`、`latexmk`、  
`main.bcf`、`main.bbl` 五项并直接给结论。

---

## 14. 字体方案与探测顺序

- 类自行管理中文字体，对 `ctexbook` 恒传 `fontset=none`；  
  西文主字体优先 `Times New Roman`，缺失则退回 `TeX Gyre Termes`。
- `fontset=auto` 的探测顺序（用 `fontspec` 的 `\IfFontExistsTF`）：

```
SimSun + SimHei        → windows
Songti SC + Kaiti SC   → mac
FZShuSong-Z01          → founder
Source Han Serif SC    → adobe
（都不存在）            → fandol（兜底）
```

- CJK 字体统一开启 `AutoFakeBold=2.5, AutoFakeSlant`，保证伪粗体可用。
- 命名了四个字体族命令：`\songti`、`\heiti`、`\kaishu`、`\fangsong`。

---

## 15. 其他实现细节（改类文件前必读）

- **引擎检查**：非 XeTeX 时会再看是否 LuaTeX——即代码层面 LuaLaTeX **不会**  
  被拒绝，但模板的字体方案与全部实测均以 **XeLaTeX** 为准，请勿用 LuaLaTeX 交稿。
- `\cleardoublepage` **被重定义**：双面模式下若补空白页，该页为  
  `\thispagestyle{empty}`（无页眉页脚）。
- `\footnotesize` **被重定义**为 9bp/11bp（小五）。
- `\thetable` / `\thefigure` / `\theequation` / `\thesubfigure` / `\thesubtable`  
  均被改写为 `章-序` 形式。
- `hyperref` **最后加载**：`hidelinks`，书签带编号且默认展开；  
  盲审模式下 `pdfauthor` 置空、`pdfcreator` 改为  
  `LaTeX with ncubachelor`。
- 元信息用 `\gdef` 全局存储，故 `\ncusetup` 可写在导言区，也可写在正文之前的分组外；  
  **不要把它放进 `\begin{document}` 之后才开始调整版面**（封面已排版）。
- 类的全部内部宏前缀为 `\ncu@` 或 `\__ncu_`，不自造同名宏以免冲突。
- 未知的类选项 / `info` / `style` / 顶层键只会产生**警告**并忽略，不会中断编译。

---

## 16. 版本沿革（README.md 详述）

| 版本     | 要点                                                             |
| ------ | -------------------------------------------------------------- |
| v1.2.4 | 文献不出的提示从日志升级为 **PDF 页面上的红框提示框**；新增 `checkbib.*` 自检脚本           |
| v1.2.3 | 接管旧写法 `\bibliography{...}`；未注册文献库时自动兜底 `references.bib`；日志中文警告 |
| v1.2.2 | `official` 与 `twoside` / `openright` **解耦**，可自由叠加              |
| v1.2.1 | 新增 `official` 类选项（复刻 v1.1.5 官方样张）；修复「参考文献」缺席目录                 |
| v1.2.0 | 单面 v1.1.7 与双面另用版 v1.1.8 合并为**一个类**；文献改 **biblatex + biber**    |

---

## 17. 许可与致谢

- 本模板依据《南昌大学本科生毕业设计（论文）书写式样》（附件 7）实现；**使用者需自行核对最终版式是否符合当年最新要求**。
- 本模板遵循 [LaTeX Project Public License](http://www.latex-project.org/lppl.txt)（1.3c 或更高版本）。
封面使用的校名标识与校徽标识版权归南昌大学所有，仅限本校学生撰写毕业论文使用。