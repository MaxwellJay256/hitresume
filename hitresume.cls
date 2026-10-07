% hitresume.cls
% 哈尔滨工业大学主题简历模板
% 作者: MaxwellJay256
% 版本: 2026.10.07
% 说明: 基于 LaTeX 的个人简历模板，适合哈尔滨工业大学学生使用。
%      图标和颜色参考哈尔滨工业大学视觉识别系统，符合哈工大风格。
%      使用时请参考 demo.tex，或在其基础上修改。
%      README.md 中有对自定义命令和环境的详细说明。

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{hitresume}[2026/10/07 HIT Resume Template]

% 类选项
\RequirePackage{kvoptions}
\SetupKeyvalOptions{family=hitresume,prefix=hitresume@}
\DeclareBoolOption[true]{watermark}
\DeclareDefaultOption{\PassOptionsToClass{\CurrentOption}{ctexart}}
\ProcessKeyvalOptions*

% 基础类默认选项（可被 documentclass 显式选项覆盖）
\PassOptionsToClass{10pt,a4paper,fontset=none}{ctexart}
\LoadClass{ctexart}

% ========== 页面设置 ==========
\RequirePackage[top=1.0in, bottom=1.0in, left=0.7in, right=0.7in]{geometry} % 页边距
\RequirePackage{setspace}
\onehalfspacing % 行间距

% ========== 颜色定义 ==========
\RequirePackage{xcolor}
\definecolor{HITBlueMain}{RGB}{0,83,117}   % 哈工大蓝
\definecolor{HITBlueAux1}{RGB}{10,77,140}  % 辅助色 1
\definecolor{HITBlueAux2}{RGB}{0,99,157}   % 辅助色 2
\definecolor{HITBlueAux3}{RGB}{0,157,224}  % 辅助色 3

% ========== 字体设置 ==========
\RequirePackage[no-math]{fontspec}
\newcommand{\FontDirectory}{fonts/}
\newcommand{\FontMainFilename}{msyh.ttc}
\newcommand{\FontBoldFilename}{msyhbd.ttc}
\setmainfont[ % 英文和数字字体设置
    Path=\FontDirectory,
    BoldFont=\FontBoldFilename,
    AutoFakeSlant=0.2
]{\FontMainFilename}
\setCJKmainfont[ % 中文字体设置
    Path=\FontDirectory,
    BoldFont=\FontBoldFilename,
    AutoFakeSlant=0.2
]{\FontMainFilename}
\setCJKsansfont[ % 无衬线字体设置
    Path=\FontDirectory,
    BoldFont=\FontBoldFilename,
    AutoFakeSlant=0.2
]{\FontMainFilename}
\setCJKmonofont[ % 等宽字体设置
    Path=\FontDirectory,
    BoldFont=\FontBoldFilename,
    AutoFakeSlant=0.2
]{\FontMainFilename}

% 默认正文字号
\renewcommand{\Large}{\fontsize{13pt}{16pt}\selectfont} % {字号}{行距}
\renewcommand{\large}{\fontsize{10pt}{12pt}\selectfont}
\renewcommand{\normalsize}{\fontsize{9pt}{10pt}\selectfont}
\setlength{\parindent}{0pt}   % 段落首行缩进
\setlength{\parskip}{4pt}     % 段落间距

% ========== 页眉页脚 ==========
\RequirePackage{graphicx}
\RequirePackage{eso-pic}
\RequirePackage{tikz}
\pagestyle{empty}

% ========== 水印设置 ==========
\newcommand{\HITWatermarkWidth}{14cm}   % 水印宽度
\newcommand{\HITWatermarkOpacity}{0.1}  % 透明度（0 ~ 1，越小越透明）

\newlength{\HITHeaderFooterHeight}
\setlength{\HITHeaderFooterHeight}{2cm}    % 色带高度
\newcommand{\HITTitleImage}{hit_title}     % 校名图片路径
\newcommand{\HITLogoLarge}{hit_logo_large} % 水印校徽图片路径
\AddToShipoutPictureBG{%
    \begin{tikzpicture}[remember picture, overlay]
        % 顶部和底部色带，按纸张绝对坐标绘制，不受页边距限制
        \fill[HITBlueMain]
            (current page.north west)
            rectangle ([yshift=-\HITHeaderFooterHeight]current page.north east);
        \fill[HITBlueMain]
            (current page.south west)
            rectangle ([yshift=\HITHeaderFooterHeight]current page.south east);
        
        % 左上角校名图片
        \node[anchor=north west, inner sep=0pt]
            at (current page.north west)
            {\includegraphics[height=\HITHeaderFooterHeight]{\HITTitleImage}};

        % 校徽水印（由 documentclass 的 watermark 选项控制）
        \ifhitresume@watermark
            \node[opacity=\HITWatermarkOpacity] at (current page.center)
                {\includegraphics[width=\HITWatermarkWidth]{\HITLogoLarge}};
        \fi
    \end{tikzpicture}%
}

% ========== 个人信息环境 ==========
\newlength{\HITNameInfoGap}
\setlength{\HITNameInfoGap}{10pt} % 个人信息区姓名与信息表格的垂直间距
\ExplSyntaxOn
\cs_new_protected:Npn \hit_personalinfo_rows:n #1
    {
        \hit_personalinfo_rows_aux:w #1 \q_nil \q_nil
    }

\cs_new_protected:Npn \hit_personalinfo_rows_aux:w #1#2
    {
        \quark_if_nil:nTF {#1}
            {}
            {
                \textbf{#1} & #2 \\
                \hit_personalinfo_rows_aux:w
            }
    }
\cs_new_protected:Npn \HITPersonalInfoRows #1
    {
        \hit_personalinfo_rows:n {#1}
    }
\ExplSyntaxOff

\NewDocumentEnvironment{personalinfo}{m m m +b}{%
    \noindent\begin{minipage}[t]{#1}%
        \vspace{0pt}%
        \includegraphics[width=\linewidth]{#2}%
    \end{minipage}%
    \hfill%
    \begin{minipage}[t]{\dimexpr\linewidth-#1-0.5cm\relax}%
        \vspace{0pt}%
        {\textcolor{HITBlueAux1}{\fontsize{20pt}{40pt}\selectfont #3}} \par
        \vspace{\HITNameInfoGap}%
        \begin{tabular}[t]{@{}ll@{}}%
            \HITPersonalInfoRows{#4}
        \end{tabular}%
    \end{minipage}%
}{}

% ========== 自定义标题命令（section） ==========
\RequirePackage[explicit]{titlesec}

% section 标题样式
\titleformat{\section}
  {\Large\raggedright\color{HITBlueMain}}
  {}{0pt}
  {#1\hspace{0.6em}\leaders\hrule height 0.5pt\hfill\kern0pt} % 行内填充分割线
% 前后间距：左缩进、标题前、标题后
\titlespacing*{\section}{0pt}{*0}{*0}

% subsection 标题样式
\titleformat{\subsection}
  {\large\raggedright}
  {}{0pt}
  {#1}
\titlespacing*{\subsection}{0pt}{*0}{*0}

% 不显示章节编号
\setcounter{secnumdepth}{0}

% ========== 通用经历环境（项目/学术/实习等） ==========
% 标题左对齐，起止年月右对齐
\newcommand{\datedsubsection}[2]{%
  \subsection[#1]{#1 \hfill #2}%
}

% ========== 页面优化 ==========
\RequirePackage{hyperref}
\hypersetup{
    colorlinks=true,
    linkcolor=black,
    urlcolor=black,
    citecolor=black
}

% ========== 列表样式 ==========
\RequirePackage{enumitem}
\setlist{leftmargin=*, nosep}
\setlist[itemize]{label=\textcolor{HITBlueMain}{$\bullet$}} % itemize 使用蓝色实心圆作为项目符号
\setlist[enumerate]{label=\textcolor{HITBlueMain}{\arabic*.}} % enumerate 使用蓝色数字加点作为项目符号

\endinput