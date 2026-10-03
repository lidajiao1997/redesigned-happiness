#!/usr/bin/env sh
# ---------------------------------------------------------------------
# 南昌大学本科生毕业论文模板（统一版 v1.2.0）—— 一键完整编译
# 用法：sh build.sh [文件名，不含扩展名]     默认 main
#
# 流程：xelatex -> biber -> xelatex -> xelatex
#   只跑一遍 xelatex 时，\cite 与 \ref 会显示为 ? 或 ??，属正常现象。
#   v1.2.0 起参考文献用 biblatex + biber 后端（gb7714-2015 样式），
#   不要用 bibtex（它读不了 biblatex 的 .bcf 控制文件）。
# ---------------------------------------------------------------------
set -e

JOB="${1:-main}"

if ! command -v xelatex >/dev/null 2>&1; then
  echo "[错误] 找不到 xelatex。请先安装 TeX Live（需含 biblatex 与 biblatex-gb7714-2015 宏包）。"
  exit 1
fi

echo "[1/4] XeLaTeX 第一遍（生成 .bcf 与 .aux）..."
xelatex -interaction=nonstopmode "$JOB.tex" >/dev/null

echo "[2/4] biber（生成参考文献 .bbl）..."
biber "$JOB" >/dev/null

echo "[3/4] XeLaTeX 第二遍（读入 .bbl 与编号）..."
xelatex -interaction=nonstopmode "$JOB.tex" >/dev/null

echo "[4/4] XeLaTeX 第三遍（稳定交叉引用）..."
xelatex -interaction=nonstopmode "$JOB.tex" >/dev/null

echo "编译完成： $JOB.pdf"
