\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{ipureport}[2015/09/07 v1.2.1 - class for IPU reports in Latex]
%======================================================================
%===  ipureport - a class that complies with the IPU designguide
%
% Written and maintained from March 2015 to now
% by Jorrit Wronski (jowr@ipu.dk)
% 
% -- Changelog -- 
% v1.2.2 - Added an option to remove the dots on top and to change the header 
% v1.2.1 - Added optional paramter to title, author, projectid, sent and keywords commands
% v1.2.0 - Split into subclasses with a common base class
% v1.1.0 - Minor changes to include the short report templates 
% v1.0.0 - Initial release with the long report templates
%
%
%======================================================================
%===  Setting up the class and defining the options
\RequirePackage{trace}
\newcommand\stdout[1]{\ClassInfo{ipureport}{#1}}
%\newcommand\stdout[1]{\ClassWarningNoLine{ipureport}{#1}}
%
% title, author, keywords and date exist already, strictly speaking, these are not options (but almost)
% {\ifx\@subtitle\@empty\else\usekomafont{subtitle}{\@subtitle\par}\fi}
%%\def\subtitle#1{\gdef\@subtitle{#1}}
%%\let\@subtitle\@empty
%\def\projectid#1{\gdef\@projectid{#1}}
%\let\@projectid\@empty
%\def\sent#1{\gdef\@sent{#1}}
%\let\@sent\@empty
%\def\keywords#1{\gdef\@keywords{#1}}
%\let\@keywords\@empty
%
%\def\header{\@ifnextchar[{\header@with}{\header@without}}
%\def\header@with[#1]#2{\gdef\ipu@header@custom{#1}\gdef\@header{#2}}
%\def\header@without#1{\gdef\@header{#1}}
%%\let\ipu@header@custom\@empty
%\let\@header\@empty
%
\def\header#1{\gdef\ipu@header@custom{#1}}
%
\def\title{\@ifnextchar[{\title@with}{\title@without}}
\def\title@with[#1]#2{\gdef\ipu@title@custom{#1}\gdef\@title{#2}}
\def\title@without#1{\gdef\@title{#1}}
%\let\ipu@title@custom\@empty
\let\@title\@empty
%
\def\author{\@ifnextchar[{\author@with}{\author@without}}
\def\author@with[#1]#2{\gdef\ipu@author@custom{#1}\gdef\@author{#2}}
\def\author@without#1{\gdef\@author{#1}}
%\let\ipu@author@custom\@empty
\let\@author\@empty
%
\def\projectid{\@ifnextchar[{\projectid@with}{\projectid@without}}
\def\projectid@with[#1]#2{\gdef\ipu@projectid@custom{#1}\gdef\@projectid{#2}}
\def\projectid@without#1{\gdef\@projectid{#1}}
%\let\ipu@projectid@custom\@empty
\let\@projectid\@empty
%
\def\sent{\@ifnextchar[{\sent@with}{\sent@without}}
\def\sent@with[#1]#2{\gdef\ipu@sent@custom{#1}\gdef\@sent{#2}}
\def\sent@without#1{\gdef\@sent{#1}}
%\let\ipu@sent@custom\@empty
\let\@sent\@empty
%
\def\keywords{\@ifnextchar[{\keywords@with}{\keywords@without}}
\def\keywords@with[#1]#2{\gdef\ipu@keywords@custom{#1}\gdef\@keywords{#2}}
\def\keywords@without#1{\gdef\@keywords{#1}}
%\let\ipu@keywords@custom\@empty
\let\@keywords\@empty
%
\def\covertext#1{\gdef\@covertext{#1}}
\let\@covertext\@empty
\def\coverpicture#1{\gdef\@coverpicture{#1}}
\let\@coverpicture\@empty
\def\coverpicturewidth#1{\gdef\@coverpicturewidth{#1}}
\let\@coverpicturewidth\textwidth
\def\covercirclewidth#1{\gdef\@covercirclewidth{#1}}
\let\@covercirclewidth\textwidth
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
\DeclareBoolOption[false]{short}
\DeclareComplementaryOption{long}{short}
%
%
\DeclareBoolOption[false]{conf}
\DeclareComplementaryOption{hand}{conf}
\DeclareBoolOption[false]{asag}
\DeclareBoolOption[false]{info}
\DeclareBoolOption[false]{comm}
%
\DeclareBoolOption[true]{dots}
\DeclareComplementaryOption{nodots}{dots}
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
\InputIfFileExists{ipucolours}{
    \ClassInfo{ipureport}{Successfully loaded the IPU colours.}
  }{
    \ClassWarning{ipureport}{Could not load the colours from ipucolours.sty. This compilation is likely to fail.}
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
                \ClassError{ipureport}%
                {value '\ipureport@papersize'< unkown \MessageBreak
possible values are: a2paper, a3paper, a4paper or a5paper}
                {You selected an unknown paper size, please choose from the predefined options}
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
\newcommand\ipu@translator[5]{
    %\ifx{#2}\empty\relax\else\@namedef{#1@english}{#2}\fi
    %\ifx{#2}\empty\relax\else\@namedef{#1@british}{#2}\fi
    \@namedef{#1@english}{#2}%
    \@namedef{#1@british}{#2}%
    \@namedef{#1@danish}{#3}%
    \@namedef{#1@ngerman}{#4}%
    \@namedef{#1@german}{#4}%
    \@namedef{#1@french}{#5}%
    \@namedef{#1}{%
        \@ifundefined{#1@custom}{%
            \@ifundefined{#1@\languagename}%
            {#1@english}% a default language
            {\@nameuse{#1@\languagename}}%
        }{%
            {\@nameuse{#1@custom}}% custom settings
        }%
    }%
}%
%
\RequirePackage{lastpage}

\ipu@translator{ipu@pageofpages}
    {Page \thepage\ of \pageref{LastPage}}
    {Side \thepage\ af \pageref{LastPage}}
    {Seite \thepage\ von \pageref{LastPage}}
    {Page \thepage\ sur \pageref{LastPage}}
%
\LoadClass{scrartcl}
\RequirePackage{scrlayer-scrpage}
\pagestyle{scrheadings}
\renewcommand*{\sectionmarkformat}{}
\automark{section}
%\renewcommand{\sectionmark}[1]{\markright{ {\thesection}.\ {#1}}{} }
\ihead{\headmark}
\ohead{\small\ipu@pageofpages}
\chead{}
\cfoot[]{}
\setheadsepline[1.087\textwidth]{0.5pt}
\setkomafont{pageheadfoot}{\normalfont\sffamily\bfseries}
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
\RequirePackage{arevmath}
%\RequirePackage{hvmath}
%\RequirePackage{eulervm}
%\RequirePackage{euler}
%\RequirePackage[math]{iwona}
\ifipureport@arial%
  \RequirePackage[scaled]{uarial}
\else%
  \RequirePackage[scaled]{helvet}
\fi%
%\RequirePackage{inconsolata}
\RequirePackage{sourcecodepro}
\renewcommand*{\familydefault}{\sfdefault}
%
%\RequirePackage{sfmath}
%\RequirePackage[slantedGreek]{sfmath}
%\usepackage[EULERGREEK]{sansmath}
%\sansmath
%
\setkomafont{title}{\raggedright\normalfont\sffamily\bfseries\Huge}
\setkomafont{subtitle}{\raggedright\normalfont\sffamily\mdseries\Large}
%
\tikzstyle{imgNode} = [inner ysep = 3ex, inner xsep = 0ex]
\tikzstyle{txtNode} = [inner ysep = 1ex, inner xsep = 0ex]
%
\def\@drawCoverPicture{\node[anchor=center] at (path picture bounding box.center) {\includegraphics[height=\@coverpicturewidth,width=\@coverpicturewidth,keepaspectratio]{\@coverpicture}}}
%
%
\ipu@translator{ipu@header}{Report}{Rapport}{Bericht}{Rapport}
\ipu@translator{ipu@title}{Project}{Projekt}{Projekt}{Projet}
\ipu@translator{ipu@projectid}{Project no.}{Projektnr.}{Projektnr.}{N\textsuperscript{o} de projet}
\ipu@translator{ipu@author}{Author(s)}{Forfatter(e)}{Verfasser}{Auteur(s)}
\ipu@translator{ipu@sent}{Sent to}{Sendt til}{Gesendet an}{Envoy\'e \`a}
%
\newcommand{\ipu@headleft}{%
    \noindent\begin{minipage}[t]{0.65\textwidth}%
    \flushleft%
    \unskip\noindent\textbf{\ipu@title: \@title}\\%
    \unskip\noindent\textbf{\ipu@projectid: \@projectid}\\%
    \unskip\noindent\textbf{\ipu@author:} \@author\\%
    \ifx\@sent\@empty\relax\else%
    \unskip\noindent\textbf{\ipu@sent:} \@sent\\%
    \fi%
    \end{minipage}%
}
%
%
\ipu@translator{ipu@confidential}{Confidential}{Fortrolig}{Vertraulich}{Confidentiel}
\ipu@translator{ipu@handout}{Hand out freely}{Kan frit udleveres}{\"Offentlich}{Distribu\'e librement}
\ipu@translator{ipu@asagreed}{As agreed upon}{If\o{}lge aftale}{Nach Absprache}{Selon accord}
\ipu@translator{ipu@foryour}{For your information}{Til orientering}{Zur Information}{Pour votre information}
\ipu@translator{ipu@comments}{Comments, please}{Kommentarer udbedes}{Kommentare erbeten}{Commentaires, s.v.p.}
%
%\usepackage{tikz}
\newcommand\@circled[1][none]{%[fill=orange,draw=none]
  \tikz[baseline=(C.south)]\node[draw=black,thick,fill={#1},circle,inner sep=0em,minimum size=0.7em](C){};
  %\tikz\node[draw,circle,minimum size=10pt](C) {g};
}
%
\newcommand{\ipu@headright}{%
    \noindent\begin{minipage}[t]{0.3\textwidth}%
    \flushright%
    \ifipureport@dots{%
        \unskip\noindent\ipu@confidential{} \ifipureport@conf\@circled[\ipureport@highlight]\else\@circled\fi\\
        \unskip\noindent\ipu@handout{} \ifipureport@conf\@circled\else\@circled[\ipureport@highlight]\fi\\
        \unskip\noindent\ipu@asagreed{} \ifipureport@asag\@circled[\ipureport@highlight]\else\@circled\fi\\
        \unskip\noindent\ipu@foryour{} \ifipureport@info\@circled[\ipureport@highlight]\else\@circled\fi\\
        \unskip\noindent\ipu@comments{} \ifipureport@comm\@circled[\ipureport@highlight]\else\@circled\fi\\
    }\else ~ \fi
    \end{minipage}%
}
%
\newsavebox\ipu@headbox
\newlength\ipu@headlen
\newlength\ipu@headhei
\sbox\ipu@headbox{\fontsize{18pt}{25pt}\selectfont{}Bp\small\ipu@pageofpages}
\settowidth\ipu@headlen{\usebox\ipu@headbox}
\settoheight\ipu@headhei{\usebox\ipu@headbox}
%
\ifipureport@short%
    %\newcommand{\negphantom}[1]{\settowidth{\dimen0}{{{\small\pageofpages}}}\hspace*{-\dimen0}}
    \ohead{\small\@date{} ~ \ipu@pageofpages}
    %
    \def\maketitle{%
        \newcommand\shortheadmark{%
            {\fontsize{18pt}{25pt}\selectfont\ipu@header}%
            %\hspace*{2em}\@date%
            %\hfill\@date\hfill\hspace*{\ipu@headlen}%
        }%
        \markboth{\shortheadmark}{\shortheadmark}%
        \vspace*{-2.25em}\par\noindent%
        \unskip\ipu@headleft \hfill \ipu@headright%
        \vspace*{1em}\par\noindent%
        \unskip\rule{1.005\textwidth}{0.5pt}%
    }
    %
    \newenvironment{synopsis}[1][\@title]{%
        \ClassError{ipureport}%
        {A synopsis cannot be used with short reports}%
        {Consider using inline text or switch to the long report option}%
}{}
\else%
    \renewcommand\@dotsep{10000}
\def\maketitle{%
    \thispagestyle{empty}
    \begin{tikzpicture}[remember picture,overlay] %
    \node[imgNode,minimum height=\headertop] (baseAnchor) at (current page.south) {};
    \node[imgNode,minimum width=1.05\textwidth,rectangle,above] (rectBox) at (baseAnchor.north) {
      \ifx\@covercirclewidth\@empty\let\@covercirclewidth\@coverpicturewidth\fi
      \tikz\node[minimum width=\@covercirclewidth,circle,draw=\ipureport@bgcolor,text=\ipureport@highlight,path picture={
        \ifx\@coverpicture\@empty
          \node[minimum width=\@coverpicturewidth,circle,fill=\ipureport@bgcolor!10,anchor=center] at (path picture bounding box.center) {};
        \else
          \@drawCoverPicture;
        \fi
      }] {\@covertext};
    };
    %
    % \node[imgNode,minimum width=1.05\textwidth,rectangle,above] (rectBox) at (baseAnchor.north) {
    %   \ifx\@covercirclewidth\@empty\let\@covercirclewidth\@coverpicturewidth\fi
    %   \tikz\node[inner sep = 0ex,minimum width=\@covercirclewidth,circle,draw=\ipureport@bgcolor,text=\ipureport@highlight] {
    %     \ifx\@coverpicture\@empty
    %       \tikz\node[inner sep = 0ex,minimum width=\@coverpicturewidth,circle,fill=\ipureport@bgcolor!10] {\large\@covertext};%at (path picture bounding box.center) {};
    %     \else
    %       \tikz\node[inner sep = 0ex] {\includegraphics[width=\@coverpicturewidth]{\@coverpicture}};
    %     \fi
    %   };
    % };
    %
    \draw[thick,color=\ipureport@bgcolor] (rectBox.south west) -- (rectBox.south east) ;
    \draw[thick,color=\ipureport@bgcolor] (rectBox.north west) -- (rectBox.north east) ;
    \ifx\@subtitle\@empty{\node[inner sep=0pt, minimum width=0pt,above right] (subTitleNode) at (rectBox.north west) {};} % a default
    \else{\node[txtNode, text width=0.9\textwidth,above right] (subTitleNode) at (rectBox.north west) {
    \scalebox{1.4}{\begin{minipage}{0.75\textwidth}\usekomafont{subtitle}\@subtitle\end{minipage}}};}%
    \fi
    \node[txtNode,above right] (titleNode) at (subTitleNode.north west) {%
    \scalebox{1.4}{\begin{minipage}{0.75\textwidth}\usekomafont{title}\@title\end{minipage}}%
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
\fi%
%
%
\endinput