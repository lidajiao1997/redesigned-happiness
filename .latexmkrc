# ---------------------------------------------------------------------
# .latexmkrc —— 南昌大学本科生毕业论文模板（统一版 v1.2.0）
#
# 用法：
#   latexmk            完整编译 main.tex（xelatex -> biber -> xelatex -> xelatex）
#   latexmk -pvc       连续预览模式（保存即自动重编译）
#   latexmk -c         清理中间文件（保留 PDF）
#   latexmk -C         清理全部生成物（含 PDF）
#
# 说明：本模板必须用 XeLaTeX 编译（ctex + fontspec）。参考文献自
#       v1.2.0 起用 biblatex + biber 后端（gb7714-2015 样式），
#       latexmk 会自动检测 .bcf 并调用 biber，直接 latexmk 即可。
# ---------------------------------------------------------------------

$pdf_mode   = 5;    # 5 = xelatex 生成 PDF
$xelatex    = 'xelatex -interaction=nonstopmode -synctex=1 %O %S';

# 参考文献：biber 后端（biblatex + gb7714-2015 样式，由 ncubachelor.cls 指定）
$bibtex_use = 1;                    # 必要时自动运行文献后端
$biber      = 'biber %O %S';

@default_files = ('main.tex');

# 清理时一并删除的中间文件
$clean_ext = 'synctex.gz run.xml bbl bcf blg out toc aux';
