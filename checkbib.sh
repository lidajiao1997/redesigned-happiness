#!/usr/bin/env sh
# ---------------------------------------------------------------------
# 参考文献编译环境自检（v1.2.4）
# 用法：sh checkbib.sh [文件名，不含扩展名]    默认 main
#
# 本脚本只读文件、只报告缺什么，不修改、不删除任何东西。
# ---------------------------------------------------------------------
JOB="${1:-main}"

say() { printf '%s\n' "$*"; }
hr()  { say "----------------------------------------------------------"; }

hr
say " 南昌大学毕业论文模板 —— 参考文献编译环境自检（只读）"
hr
say ""

say "[1/5] xelatex"
if command -v xelatex >/dev/null 2>&1; then
  say "      OK  -  $(xelatex --version 2>/dev/null | head -1)"
else
  say "      缺失 —— 请先安装 TeX Live / MacTeX"
fi

say "[2/5] biber   （本模板必需的文献后端）"
if command -v biber >/dev/null 2>&1; then
  say "      OK  -  $(biber --version 2>/dev/null | head -1)"
else
  say "      缺失  <==  这就是文献表为空的原因"
  say "      解决：安装完整版 TeX Live / MacTeX（自带 biber）"
fi

say "[3/5] latexmk （可选，可自动跑完整条编译链）"
if command -v latexmk >/dev/null 2>&1; then
  say "      OK"
else
  say "      未找到（可选组件）"
fi

say "[4/5] $JOB.bcf  （xelatex 写出，biber 读取）"
if [ -f "$JOB.bcf" ]; then
  say "      OK —— 存在"
else
  say "      不存在 —— 请先至少跑一遍 xelatex"
fi

say "[5/5] $JOB.bbl  （biber 写出，xelatex 读取）"
if [ ! -f "$JOB.bbl" ]; then
  say "      缺失 —— biber 没有跑过，这正是文献表为空的直接原因"
elif [ ! -s "$JOB.bbl" ]; then
  say "      0 字节  <==  说明跑的是 bibtex 而不是 biber"
  say "      解决：删掉 $JOB.bbl 后改用 biber"
else
  say "      OK —— $(wc -c < "$JOB.bbl" | tr -d ' ') 字节"
fi

say ""
hr
say " 结论"
hr
if ! command -v biber >/dev/null 2>&1; then
  say " biber 不可用。请安装完整 TeX Live / MacTeX，然后编译："
  say "   xelatex -> biber -> xelatex -> xelatex"
  say " 最简单：在本目录运行  sh build.sh"
elif [ ! -f "$JOB.bbl" ]; then
  say " biber 存在但还没对 $JOB 跑过。最简单：在本目录运行  sh build.sh"
  say " 或依次执行："
  say "   xelatex $JOB  ->  biber $JOB  ->  xelatex $JOB  ->  xelatex $JOB"
elif [ ! -f "$JOB.bcf" ]; then
  say " 没找到 $JOB.bcf，请先跑一遍 xelatex"
elif [ ! -s "$JOB.bbl" ]; then
  say " $JOB.bbl 是 0 字节：编译链里用了 bibtex，请改用 biber"
else
  say " 环境看起来正常。请用 build.sh / latexmk 编译。"
  say " 若编完文献还是不出，检查 \\cite{...} 里的键是否存在于 references.bib。"
fi
say ""
say " 以上都正常但文献仍不出现时，见 README.md「常见问题」一节。"
