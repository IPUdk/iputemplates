\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ipureport}[2015/04/13 v1.0 - class for IPU reports in Latex]
%======================================================================
%===  ipureport - a class to make reports that comply with the IPU designguide
%
% Written and maintained in 2015--
% by Jorrit Wronski (jowr@ipu.dk)
%
%
%======================================================================
%===  Setting up the class and defining the options
\RequirePackage{trace}
\newcommand\stdout[1]{\ClassInfo{ipureport}{#1}}
%\newcommand\stdout[1]{\ClassWarningNoLine{ipureport}{#1}}
%
% title, author, keywords exist already, strictly speaking, these are not options (but almost)
% {\ifx\@subtitle\@empty\else\usekomafont{subtitle}{\@subtitle\par}\fi}
%\def\subtitle#1{\gdef\@subtitle{#1}}
%\let\@subtitle\@empty
\def\projectid#1{\gdef\@projectid{#1}}
\let\@projectid\@empty
\def\keywords#1{\gdef\@keywords{#1}}
\let\@keywords\@empty
%
\def\covertext#1{\gdef\@covertext{#1}}
\let\@covertext\@empty
\def\coverpicture#1{\gdef\@coverpicture{#1}}
\let\@coverpicture\@empty
\def\coverpicturewidth#1{\gdef\@coverpicturewidth{#1}}
\let\@coverpicturewidth\textwidth
%
% Standard options that you should pass to the class, use only kvoptions 
% to avoid problems.
%\RequirePackage{kvoptions-patch}
\RequirePackage{kvoptions}
\DeclareStringOption[ipugrey]{bgcolor}                 % default background colour
\DeclareStringOption[ipugreen]{highlight}              % default highlight colour
\DeclareStringOption[IPU-Logo-RGB]{toplogo}            % default institute logo
\DeclareStringOption[a4paper]{papersize}               % default paper size
%
\DeclareBoolOption[false]{crop}
\DeclareComplementaryOption{nocrop}{crop}
%
\DeclareBoolOption[false]{arial}
\DeclareComplementaryOption{helvet}{arial}
%
% Default option rule
\DeclareDefaultOption{%
  \ifx\CurrentOptionValue\relax
    \ClassWarningNoLine{ipureport}{%
      You provided and unknown option '\CurrentOption '. I will pass it on to 'scrartcl' without further processing}
    \expandafter\PassOptionsToClass
    \expandafter{\CurrentOption}{scrartcl}%
  \else
    \ClassWarningNoLine{ipureport}{%
      You provided and unknown option '\CurrentOptionKey ' with value '\CurrentOptionValue '.
      I will pass it on to 'scrartcl' without further processing}%
    \expandafter\PassOptionsToClass{\expandafter\CurrentOptionKey = \expandafter\CurrentOptionValue}{scrartcl}%  
  \fi
}
%
\ProcessKeyvalOptions{ipureport}\relax
%
%
%======================================================================
%===  Define functions to be called according to the options
\InputIfFileExists{dtucolours}{
  \ClassInfo{ipureport}{Successfully loaded the DTU colours}
}{
  \ClassInfo{ipureport}{DTU colours not installed, defining colours here instead}
  % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Define colours for IPU related documents, from IPU Designguide (16.09.2008)
  % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  \providecolor{ipugreen}     {rgb}{0.00, 0.40, 0.20} % Dark green, 1st  standard colour  - CMYK: 088/000/095/026 - RGB: 000/102/051
  \providecolor{ipugrey}      {rgb}{0.45, 0.47, 0.49} % Dark grey, 2nd standard colour    - CMYK: 015/000/000/075 - RGB: 114/121/126
  \providecolor{ipulightgreen}{rgb}{0.36, 0.67, 0.15} % Light green, 1sr secondary colour - CMYK: 070/000/100/000 - RGB: 091/172/038
  \providecolor{ipulightgrey} {rgb}{0.85, 0.86, 0.87} % Light grey, 2nd secondary colour  - CMYK: 003/000/003/020 - RGB: 217/220/222
}%
%
\RequirePackage{etoolbox}
\long\def\ifequal#1#2#3#4{\expandafter\ifstrequal\expandafter{#1}{#2}{#3}{#4}}
%
%
%======================================================================
%===  Default paper and font sizes
\RequirePackage{calc,fp,tikz}
\usetikzlibrary{shapes,calc,positioning,backgrounds,shadings}
%
%% Convert mm to pt
\FPset{\ipureport@mmpt}{2.83464567}
\FPdiv{\ipureport@ptmm}{1}{\ipureport@mmpt}
\FPmul{\ipureport@refsize}{\ipureport@mmpt}{297}
\FPdiv{\ipureport@whratio}{210}{297} % Based on A4
%
\newcommand{\getlengthmm}[1]{\strip@pt\dimexpr\ipureport@ptmm\dimexpr#1\relax\relax}
\newcommand{\getlengthpt}[1]{\strip@pt\dimexpr1.0\dimexpr#1\relax\relax}
%
\ifequal{\ipureport@papersize}{a2paper}{%
    \stdout{papersize switch: detected a2paper, A2 420 x 595 mm}
    \FPmul\ipureportheight{595}{\ipureport@mmpt}}{%
    \ifequal{\ipureport@papersize}{a3paper}{%
        \stdout{papersize switch: detected a3paper, A3 297 x 421 mm}
        \FPmul\ipureportheight{421}{\ipureport@mmpt}}{%
        \ifequal{\ipureport@papersize}{a4paper}{%
            \stdout{papersize switch: detected a4paper, A4 210 x 297 mm}
            \FPmul\ipureportheight{297}{\ipureport@mmpt}}{%
            \ifequal{\ipureport@papersize}{a5paper}{%
                \stdout{papersize switch: detected a5paper, A5 148 x 210 mm}
                \FPmul\ipureportheight{210}{\ipureport@mmpt}}{%
                \ClassError{ipureport}{
                    value '\ipureport@papersize'< unkown \MessageBreak
                    possible values are: a2paper, a3paper, a4paper or a5paper}
            }
        }
    }
}
%
\PassOptionsToClass{\ipureport@papersize}{scrartcl}
\PassOptionsToPackage{\ipureport@papersize}{geometry}
\FPmul\ipureportwidth{\ipureportheight}{\ipureport@whratio}
\FPdiv\ipureport@sizeratio{\ipureportheight}{\ipureport@refsize}
%
%======================================================================
%===  Define margins according to "IPU Designguide 16/06/2008"
\FPmul\ipureport@tmp{  22.5}{\ipureport@sizeratio}
\newlength{\bgmarginleftright}%
\setlength{\bgmarginleftright}{\ipureport@tmp mm}
\stdout{background margin side: \ipureport@tmp mm}
\FPmul\ipureport@tmp{   7.5}{\ipureport@sizeratio}
\newlength{\bgmargintop}%
\setlength{\bgmargintop}{\ipureport@tmp mm}
\stdout{background margin top: \ipureport@tmp mm}
%
\FPmul\ipureport@tmp{  25}{\ipureport@sizeratio}
\newlength{\textmarginleftright}%
\setlength{\textmarginleftright}{\ipureport@tmp mm}
\stdout{text margin side: \ipureport@tmp mm}
\FPmul\ipureport@tmp{  45}{\ipureport@sizeratio}
\newlength{\textmargintop}%
\setlength{\textmargintop}{\ipureport@tmp mm}
\stdout{text margin top: \ipureport@tmp mm}
\FPmul\ipureport@tmp{17.5}{\ipureport@sizeratio}
\newlength{\textmarginbottom}%
\setlength{\textmarginbottom}{\ipureport@tmp mm}
\stdout{text margin bottom: \ipureport@tmp mm}
%
\FPmul\ipureport@tmp{  40}{\ipureport@sizeratio}
\newlength{\headertop}%
\setlength{\headertop}{\ipureport@tmp mm}
\stdout{header top: \ipureport@tmp mm}
%
\newlength{\ipulogoright}%
\setlength{\ipulogoright}{\textmarginleftright} 
\FPmul\ipureport@tmp{7.5}{\ipureport@sizeratio}
\newlength{\ipulogotop}%
\setlength{\ipulogotop}{\ipureport@tmp mm} 
\FPmul\ipureport@tmp{ 10}{\ipureport@sizeratio}
\newlength{\ipulogoheight}%
\setlength{\ipulogoheight}{\ipureport@tmp mm}
%
\PassOptionsToPackage{%
  centering,%
  pdftex,%
  paperwidth=\ipureportwidth pt,%
  paperheight=\ipureportheight pt,%
  bindingoffset=0.0pt,
  footskip=0.0in,
  left=\textmarginleftright,%
  right=\textmarginleftright,%
  top=\textmargintop,%
  bottom=\textmarginbottom,%
  }{geometry}
%
%
%======================================================================
%===  Default cropping for oversize paper
\newlength{\cropleftright}%
\newlength{\croptopbottom}%  
%
\ifipureport@crop%
  \FPdiv\ipureport@camwidth{\ipureportwidth}{\ipureport@mmpt} % back to mm
  \FPadd\ipureport@camwidth{\ipureport@camwidth}{30}%
  \FPdiv\ipureport@camheight{\ipureportheight}{\ipureport@mmpt} % back to mm
  \FPadd\ipureport@camheight{\ipureport@camheight}{40}%
  \PassOptionsToPackage{cam,axes,info,width=\ipureport@camwidth truemm,height=\ipureport@camheight truemm,pdflatex,center}{crop}%
  %
  \FPmul\ipureport@tmp{\ipureport@camwidth}{\ipureport@mmpt} % width in points
  \FPsub\ipureport@tmp{\ipureport@tmp}{\ipureportwidth}%
  \FPdiv\ipureport@tmp{\ipureport@tmp}{2}%
  \setlength{\cropleftright}{\ipureport@tmp pt}%
  %
  \FPmul\ipureport@tmp{\ipureport@camheight}{\ipureport@mmpt} % height in points
  \FPsub\ipureport@tmp{\ipureport@tmp}{\ipureportheight}%
  \FPdiv\ipureport@tmp{\ipureport@tmp}{2}%
  \setlength{\croptopbottom}{\ipureport@tmp pt}%
%  }
\else%
 \setlength{\cropleftright}{0pt}%
 \setlength{\croptopbottom}{0pt}%
\fi%
%
%
%======================================================================
%===  Use tikz to draw the background 
\newcommand{\ipureport@drawbg}{ %
  \begin{tikzpicture}[remember picture,overlay] %
    \begin{pgfonlayer}{background}%
        % set base node as marker
        \node [inner sep=0pt,above right] at (current page.north west){ %
            \begin{tikzpicture}[remember picture,overlay]
                \draw (\paperwidth-\ipulogoright,-\ipulogotop) node[inner sep=0pt, below left] {\includegraphics[height=\ipulogoheight]{\ipureport@toplogo}}; %
            \end{tikzpicture}
        }; %
    \end{pgfonlayer} %
  \end{tikzpicture} %
}%
\RequirePackage[all]{background}
%\SetBgContents{\MyGraphicLogo}% Select included image
\SetBgContents{\ipureport@drawbg}% Select tikz picture
\SetBgPosition{current page.north west}% Select location
\SetBgOpacity{1.0}% Select opacity
\SetBgAngle{0.0}% Select roation of logo
\SetBgScale{1.0}% Select scale factor of logo
%
%
%======================================================================
%===  Load the class and set the paper size
\PassOptionsToPackage{english,french,ngerman,danish,british}{babel}%
\RequirePackage{babel}
\RequirePackage{lastpage}
\newcommand{\pageofpages}{%
  \@ifundefined{pageof@\languagename}
    {page \thepage\ of \pageref{LastPage}} % a default
    {\@nameuse{pageof@\languagename}}%
 }
% English is already default
% \newcommand{\pageof@english}{page \thepage\ of \pageref{LastPage}}
% French
\newcommand{\pageof@french}{page \thepage\ sur \pageref{LastPage}}
\newcommand{\pageof@danish}{side \thepage\ af \pageref{LastPage}}
\newcommand{\pageof@german}{Seite \thepage\ von \pageref{LastPage}}
\newcommand{\pageof@ngerman}{Seite \thepage\ von \pageref{LastPage}}
%
\LoadClass{scrartcl}
\RequirePackage{scrlayer-scrpage}
\pagestyle{scrheadings}
\renewcommand*{\sectionmarkformat}{}
\automark{section}
%\renewcommand{\sectionmark}[1]{\markright{ {\thesection}.\ {#1}}{} }
\ihead{\headmark}
\ohead{\small\pageofpages}
%\ihead{\MakeUppercase{\headmark}}
%\ohead{\MakeUppercase{\pageofpages}}
\chead{}
\cfoot[]{}
%\setheadsepline[1.1\textwidth]{0.5pt}
\setheadsepline[1.087\textwidth]{0.5pt}
\setkomafont{pageheadfoot}{\normalfont\sffamily\bfseries}
%\setkomafont{pagenumber}{\normalfont\sffamily\small\bfseries}
\RequirePackage{geometry}%
\RequirePackage{crop}%
%
%\AtBeginDocument{\ipureport@drawbg}
%\AtBeginDocument{\ipureport@setfonts} 
%
%======================================
%==  Details for pdf files
\RequirePackage[pdftex,       % hyper-references for pdflatex
    bookmarks=false,           % generate bookmarks ...
%    bookmarksnumbered=true,   % ... with numbers
%    bookmarksopen=false,      %
    colorlinks=false,         %
    linkcolor=black,          %
    hypertexnames=false,      % needed for correct links to figures !!!
    breaklinks=true,%         % break links if exceeding a single line
%    linkbordercolor={0 0 1}  %
    pdfborder={0 0 0},        % no red border for links
    pdfpagelayout=SinglePage  % display one page per view
]{hyperref}
\pdfminorversion=5
%\pdfcompresslevel=0
%\pdfadjustspacing=1
%
\AtBeginDocument{
\hypersetup{
    pdfauthor = {\@author},
    pdftitle = {\@title},
    pdfsubject = {\@projectid},
    pdfkeywords = {\@keywords},
    pdfcreator = {LaTeX with ipureport class},
    pdfproducer = {pdfTex}
}
%%%%%%%%% PDF/X-3 stuff, necessary for Blurb IF USING pdflatex %%%%%%%%%
% ICC color profiles are embedded in the images
\pdfinfo{
/Title (\@title)   % set your title here
/Author (\@author)       % set author name
/Subject (\@projectid)          % set subject
/Keywords (\@keywords) % set keywords
/Trapped (False)
/GTS_PDFXVersion (PDF/X-3:2002)
}
% must have a trim box,
%\pdfpageattr{%/MediaBox [0 0 693.36000 594.00000]
%/TrimBox [0.00000 9.00000 684.36000 585.00000]}
%\pdfminorversion=5
\pdfcatalog{
/OutputIntents [ <<
/Info (none)
/Type /OutputIntent
/S /GTS_PDFX
/OutputConditionIdentifier (ipu.dk)
/RegistryName (http://www.color.org/)
>> ]
}%
}
%
%======================================================================
%===  New title page and fonts
\RequirePackage[T1]{fontenc}
%\RequirePackage{mathptmx}
%\RequirePackage{cmbright}
%\RequirePackage{arevmath}
%\RequirePackage{eulervm}
%\RequirePackage[math]{iwona}
%\RequirePackage[scaled]{uarial}
%
\ifipureport@arial%
  \RequirePackage{cmbright}
  \RequirePackage[scaled]{uarial}
\else%
  \RequirePackage{cmbright}
  \RequirePackage[scaled]{helvet}
  %\RequirePackage[EULERGREEK]{sansmath}
  %\sansmath
\fi%
%
\renewcommand*{\familydefault}{\sfdefault}
%
\setkomafont{title}{\raggedright\normalfont\sffamily\bfseries\Huge}
\setkomafont{subtitle}{\raggedright\normalfont\sffamily\mdseries\Large}
%
\tikzstyle{titleNode} = [inner ysep = 3ex, inner xsep = 0ex]
\def\maketitle{%
\thispagestyle{empty}
\begin{tikzpicture}[remember picture,overlay] %
\node[titleNode,minimum height=\headertop] (baseAnchor) at (current page.south) {};
\node[titleNode,minimum width=1.05\textwidth,rectangle,above] (rectBox) at (baseAnchor.north) {
  \tikz\node[minimum width=\@coverpicturewidth,circle,draw=\ipureport@bgcolor,text=\ipureport@highlight,path picture={
    \ifx\@coverpicture\@empty
      \node[minimum width=\@coverpicturewidth,circle,fill=\ipureport@bgcolor!10] at (path picture bounding box.south) {};
    \else
      \node at (path picture bounding box.south) {\includegraphics[width=\@coverpicturewidth]{\@coverpicture}};
    \fi
  }] {\@covertext};
};
\draw[thick,color=\ipureport@bgcolor] (rectBox.south west) -- (rectBox.south east) ;
\draw[thick,color=\ipureport@bgcolor] (rectBox.north west) -- (rectBox.north east) ;
\ifx\@subtitle\@empty{\node[inner sep=0pt, minimum width=0pt,above right] (subTitleNode) at (rectBox.north west) {};} % a default
\else{\node[titleNode, text width=0.9\textwidth,above right] (subTitleNode) at (rectBox.north west) {
\scalebox{1.4}{\begin{minipage}{0.65\textwidth}\usekomafont{subtitle}\@subtitle\end{minipage}}};}%
\fi
%
\node[titleNode,above right] (titleNode) at (subTitleNode.north west) {%
\scalebox{1.4}{\begin{minipage}{0.65\textwidth}\usekomafont{title}\@title\end{minipage}}%
};%
\end{tikzpicture}
\par\clearpage\setcounter{page}{1}%
}
% 
%
%\newenvironment{synopsis}[1][Synopsis]{%
\newenvironment{synopsis}[1][\@title]{%
\ihead[]{\ifx\@projectid\@empty\relax\else{\unskip\mdseries\LARGE\@projectid\\}\fi{\unskip\bfseries\LARGE#1}}%
\ohead[]{}%
}{%
\par\clearpage\setcounter{page}{1}%
}
%
%
\endinput