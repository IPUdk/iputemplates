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
% Standard options that you should pass to the class, use only kvoptions 
% to avoid problems.
%\RequirePackage{kvoptions-patch}
\RequirePackage{kvoptions}
\DeclareStringOption[This is the Report Title]{title}  % default title
\DeclareStringOption[Project 12345]{projectid}         % default project ID
\DeclareStringOption[This Ismyname]{author}            % default author
\DeclareStringOption[report, IPU, LaTex]{keywords}     % default keywords
\DeclareStringOption[ipugrey]{bgcolor}                 % default background colour
\DeclareStringOption[ipugreen]{highlight}              % default highlight colour
\DeclareStringOption[IPU-Logo-RGB]{toplogo}            % default institute logo
\DeclareStringOption[a4paper]{papersize}               % default paper size
\DeclareStringOption[1column]{colcount}                % default number of columns
%
\DeclareBoolOption[false]{longtitle}
\DeclareBoolOption[false]{largecaption}
\DeclareBoolOption[false]{draft}
\DeclareComplementaryOption{final}{draft}
\DeclareBoolOption[true]{crop}
\DeclareComplementaryOption{nocrop}{crop}
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
%
\newcommand{\getlengthmm}[1]{\strip@pt\dimexpr\ipureport@ptmm\dimexpr#1\relax\relax}
\newcommand{\getlengthpt}[1]{\strip@pt\dimexpr1.0\dimexpr#1\relax\relax}
%\pgfdeclarelayer{background}
%\pgfdeclarelayer{foreground}
%\pgfsetlayers{background,main,foreground}
%
%
\ifequal{\ipureport@papersize}{a0paper}{%
  \stdout{papersize switch: detected a0paper}
  %%A0 paper 841 x 1189 mm
  \FPmul\ipureportwidth{841}{\ipureport@mmpt}
  \FPmul\ipureportheight{1189}{\ipureport@mmpt}
  \FPdiv\ipureport@sizeratio{\ipureportheight}{\ipureport@refsize}
  \PassOptionsToClass{a0paper}{scrartcl}
  \PassOptionsToPackage{a0paper}{geometry}}{
		\ifequal{\ipureport@papersize}{a1paper}{%
		  \stdout{papersize switch: detected a1paper}
		  %%A1 paper 594 x 841 mm
		  \FPmul\ipureportwidth{594}{\ipureport@mmpt}
		  \FPmul\ipureportheight{841}{\ipureport@mmpt}
		  \FPdiv\ipureport@sizeratio{\ipureportheight}{\ipureport@refsize}
		  \PassOptionsToClass{a1paper}{scrartcl}
		  \PassOptionsToPackage{a1paper}{geometry}}{
				\ifequal{\ipureport@papersize}{a2paper}{%
  				\stdout{papersize switch: detected a2paper}
				  %%A4 paper 420 x 595 mm
				  \FPmul\ipureportwidth{420}{\ipureport@mmpt}
				  \FPmul\ipureportheight{595}{\ipureport@mmpt}
				  \FPdiv\ipureport@sizeratio{\ipureportheight}{\ipureport@refsize}
				  \PassOptionsToClass{a2paper}{scrartcl}
				  \PassOptionsToPackage{a2paper}{geometry}}{
						\ifequal{\ipureport@papersize}{a3paper}{%
						 \stdout{papersize switch: detected a3paper}
						  %%A4 paper 297 x 421 mm
						  \FPmul\ipureportwidth{297}{\ipureport@mmpt}
						  \FPmul\ipureportheight{421}{\ipureport@mmpt}
						  \FPdiv\ipureport@sizeratio{\ipureportheight}{\ipureport@refsize}
						  \PassOptionsToClass{a3paper}{scrartcl}
						  \PassOptionsToPackage{a3paper}{geometry}}{
								\ifequal{\ipureport@papersize}{a4paper}{%
  								\stdout{papersize switch: detected a4paper}
								  %%A4 paper 210 x 297 mm
								  \FPmul\ipureportwidth{210}{\ipureport@mmpt}
								  \FPmul\ipureportheight{297}{\ipureport@mmpt}
								  \FPdiv\ipureport@sizeratio{\ipureportheight}{\ipureport@refsize}
								  \PassOptionsToClass{a4paper}{scrartcl}
								  \PassOptionsToPackage{a4paper}{geometry}}{
									   \ClassError{ipureport}{
									     value '\ipureport@papersize'< unkown \MessageBreak
									     possible values are: a0paper, a1paper, a2paper, a3paper or a4paper}
								}
						}
				}
		}
}
%
%======================================================================
%===  Define margins according to "IPU Designguide 16/06/2008"
%\newcommand{\ipureport@setpapersize}{
\FPmul\ipureport@tmp{  22.5}{\ipureport@sizeratio}
\newlength{\bgmarginleftright}%
\setlength{\bgmarginleftright}{\ipureport@tmp mm}
\stdout{background margin side: \ipureport@tmp mm}
\FPmul\ipureport@tmp{   7.5}{\ipureport@sizeratio}
\newlength{\bgmargintop}%
\setlength{\bgmargintop}{\ipureport@tmp mm}
\stdout{background margin top: \ipureport@tmp mm}
%\FPmul\ipureport@tmp{20}{\ipureport@sizeratio}
%\newlength{\bgheight}%
%\setlength{\bgheight}{\ipureport@tmp pt * 0}
%\addtolength{\bgheight}{\paperheight}
%
% \FPmul\ipureport@tmp{ 120}{\ipureport@sizeratio}
% \newlength{\bgfirstline}%
% \setlength{\bgfirstline}{\ipureport@tmp mm}
% \stdout{background first line: \ipureport@tmp mm}
% \FPmul\ipureport@tmp{1080}{\ipureport@sizeratio}
% \newlength{\bgsecondline}%
% \setlength{\bgsecondline}{\ipureport@tmp mm}
% \stdout{background second line: \ipureport@tmp mm}
% \FPmul\ipureport@tmp{   5}{\ipureport@sizeratio}
% \newlength{\bglinewidth}%
% \setlength{\bglinewidth}{\ipureport@tmp pt}
% \stdout{background line width: \ipureport@tmp pt}
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
\FPmul\ipureport@tmp{0.05}{\ipureport@sizeratio}
\newlength{\headerline}%
\setlength{\headerline}{\ipureport@tmp mm}
\stdout{header line: \ipureport@tmp mm}
%
\FPmul\ipureport@tmp{5}{\ipureport@sizeratio}
\newlength{\textintercolumn}%
\setlength{\textintercolumn}{\ipureport@tmp mm}
\stdout{intercolumn space: \ipureport@tmp mm}
%
% \newlength{\toplogoleft}%
% \setlength{\toplogoleft}{\textmarginleftright} 
% \FPmul\ipureport@tmp{50}{\ipureport@sizeratio}
% \newlength{\toplogotop}%
% \setlength{\toplogotop}{\ipureport@tmp mm} 
% \FPmul\ipureport@tmp{43.25}{\ipureport@sizeratio}
% \newlength{\toplogoheight}%
% \setlength{\toplogoheight}{\ipureport@tmp mm} 
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
% \FPmul\ipureport@tmp{1125}{\ipureport@sizeratio}
% \newlength{\footerimagetop}%
% \setlength{\footerimagetop}{\ipureport@tmp mm}
%\FPmul\ipureport@tmp{  40}{\ipureport@sizeratio}
%\newlength{\footerimageleft}%
%\setlength{\footerimageleft}{\ipureport@tmp mm}
%
% \newlength{\footerimagewidth}%
% \setlength{\footerimagewidth}{\ipureportwidth pt}
% \addtolength{\footerimagewidth}{-2\textmarginleftright} % left and right
% \addtolength{\footerimagewidth}{-3\textmarginleftright} % in between the 4 images
% \addtolength{\footerimagewidth}{-0.75\footerimagewidth} % 4 images => 1/4 of length
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
%  nohead%
  }{geometry}
%}
%
%
%======================================================================
%===  Default cropping for oversize paper
\newlength{\cropleftright}%
\newlength{\croptopbottom}%  
\providecommand{\ipureport@setcropsize}{}
%
\ifipureport@crop%
%  \renewcommand{\ipureport@setcropsize}{
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
%===  Default font size, enlarge the font size for less than 3 columns
% \ifequal{\ipureport@colcount}{3columns}{
%   \stdout{colcount switch: detected 3columns}
%   \FPset\ipureport@columncount{3}
% %   \FPset\ipureport@fontsizefactor{1}
%   }{
% 		\ifequal{\ipureport@colcount}{2columns}{
% 		  \stdout{colcount switch: detected 2columns}
% 		  \FPset\ipureport@columncount{2}
% % 		  \FPdiv\ipureport@fontsizefactor{48}{35}
% 		  }{
% 				\ifequal{\ipureport@colcount}{1column}{
% 				  \stdout{colcount switch: detected 1column}
% 				  \FPset\ipureport@columncount{1}
% % 				  \FPdiv\ipureport@fontsizefactor{48}{35}
% 				  }{
% 				    \ClassError{ipureport}{
% 				      You apssed an unknown value '\ipureport@colcount' to
% 				      the 'colcount' options, possible values are: 
% 				      3columns, 2columns or 1column}
% 				}
% 		}
% }
% \stdout{columncount: \ipureport@columncount}
% \stdout{fontsize factor: \ipureport@fontsizefactor}
%
%
% %======================================================================
% %===  Define fonts according to "DTU_Poster_A0_HOEJ_2sp.Skabelon.cs2"
% \newlength\ipureport@tmpfontsize
% \newlength\ipureport@tmplinespace
% \newcommand{\ipureport@fs}[3]{ %
%   \stdout{Setting font size: {#1} {#2} {#3}}
%   \FPmul\ipureport@tmp{\ipureport@sizeratio}{#1} %
%   \FPmul\ipureport@tmp{\ipureport@tmp}{#3} %
%   \setlength{\ipureport@tmpfontsize}{\ipureport@tmp pt} %
%   \FPmul\ipureport@tmp{\ipureport@sizeratio}{#2} %
%   \FPmul\ipureport@tmp{\ipureport@tmp}{#3} %
%   \setlength{\ipureport@tmplinespace}{\ipureport@tmp pt} %
%   \fontsize{\ipureport@tmpfontsize}{\ipureport@tmplinespace}\selectfont %
% }
% %
% \newcommand\ipureport@setfonts{
%   \ifipureport@longtitle%
%     \setkomafont{title}{       \normalfont\ipureport@fs{100}{120}{1}\bfseries\color{\ipureport@highlight}} % used with title
%   \else
%     \setkomafont{title}{       \normalfont\ipureport@fs{160}{170}{1}\bfseries\color{\ipureport@highlight}} % used with title
%   \fi
%   \setkomafont{minisec}{     \normalfont\ipureport@fs{ 60}{ 70}{1}\bfseries} % used for authors
%   \setkomafont{dictum}{      \normalfont\ipureport@fs{ 48}{ 60}{1}} % used for affiliation
%   \setkomafont{section}{     \normalfont\ipureport@fs{ 35}{ 45}{\ipureport@fontsizefactor}\bfseries\color{\ipureport@highlight}} % section
%   \setkomafont{subsection}{  \normalfont\ipureport@fs{ 35}{ 45}{\ipureport@fontsizefactor}\bfseries} % subsection
%   \ifipureport@largecaption%
%     \setkomafont{caption}{     \normalfont\ipureport@fs{ 24}{ 34}{1}} % table and figure caption
%   \else
%     \setkomafont{caption}{     \normalfont\ipureport@fs{ 15}{ 24}{1}\bfseries} % table and figure caption
%   \fi
%   % Dirty hack to center the caption \hspace*{-3.5em}
%   \setkomafont{captionlabel}{\color{\ipureport@highlight}\bfseries}              % label looks the same
% }
%
%
%======================================================================
%===  change the background for drafting
\providecommand\ipureport@drawgrid{}%
%
\ifipureport@draft%
  \renewcommand\ipureport@drawgrid{%
    \begin{tikzpicture}[remember picture,overlay] %
    %\begin{pgfonlayer}{foreground}
      \node [inner sep=0pt,above right] at (current page.north west){ %
        \begin{tikzpicture}[remember picture,overlay] %
          \draw[step=2cm,color=magenta!10] (0,0) grid (\paperwidth,-\paperheight); %
        \end{tikzpicture} %
      }; %
    %\end{pgfonlayer}
    \end{tikzpicture} %
  } %
  \PassOptionsToClass{draft=true}{scrartcl}%
\else
  \renewcommand\ipureport@drawgrid{}%
  \PassOptionsToClass{draft=false}{scrartcl}%

\fi
\AtEndDocument{\ipureport@drawgrid} 
%
%
%======================================================================
%===  Use tikz to draw the background 
\newcommand{\ipureport@drawbg}{ %
  \begin{tikzpicture}[remember picture,overlay] %
    \begin{pgfonlayer}{background}%
	    % set base node as marker
	    \node [inner sep=0pt,above right] at (current page.north west){ %
	      \begin{tikzpicture}[remember picture,overlay]%
% 		      \draw (\toplogoleft,-\toplogotop) node[inner sep=0pt, below right] {\includegraphics[height=\toplogoheight]{\ipureport@toplogo}}; %
		      \draw (\paperwidth-\ipulogoright,-\ipulogotop) node[inner sep=0pt, below left] {\includegraphics[height=\ipulogoheight]{\ipureport@toplogo}}; %
                      \filldraw[inner sep=0pt,color=\ipureport@bgcolor] (\bgmarginleftright,-\headertop) rectangle (\paperwidth-\bgmarginleftright,-\headertop-\headerline); %
% 		      \filldraw[inner sep=0pt,color=\ipureport@bgcolor!10] (\bgmarginleftright,-\bgfirstline-\bglinewidth) rectangle (\paperwidth-\bgmarginleftright,-\bgsecondline); %
% 		      \filldraw[inner sep=0pt,color=\ipureport@bgcolor]    (\bgmarginleftright,-\bgfirstline) rectangle (\paperwidth-\bgmarginleftright,-\bgfirstline-\bglinewidth); %
% 		      \filldraw[inner sep=0pt,color=\ipureport@bgcolor]    (\bgmarginleftright,-\bgsecondline) rectangle (\paperwidth-\bgmarginleftright,-\bgsecondline-\bglinewidth); %
% 		      %
% 		      \draw (1\textmarginleftright+0\footerimagewidth,-\footerimagetop) node[inner sep=0pt, below right] {\includegraphics[width=\footerimagewidth]{\ipureport@botlogo}}; %
% 		      \draw (2\textmarginleftright+1\footerimagewidth,-\footerimagetop) node[inner sep=0pt, below right] {\includegraphics[width=\footerimagewidth]{\ipureport@botlogo}}; %
% 		      \draw (3\textmarginleftright+2\footerimagewidth,-\footerimagetop) node[inner sep=0pt, below right] {\includegraphics[width=\footerimagewidth]{\ipureport@botlogo}}; %
% 		      \draw (4\textmarginleftright+3\footerimagewidth,-\footerimagetop) node[inner sep=0pt, below right] {\includegraphics[width=\footerimagewidth]{\ipureport@botlogo}}; %
	      \end{tikzpicture} %
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
%\RequirePackage{scrpage2}
%\pagestyle{scrheadings}
% \ohead{
% \begin{tikzpicture}[remember picture, overlay]
%  % logo:
%  \ifthispageodd
%    {\node[below left,logo] at (current page.north east)}
%    {\node[below right,logo] at (current page.north west)}
%    {\logo} ;
%  % page number:
%  \ifthispageodd
%    {\node[left,page] at (current page.east)}
%    {\node[right,page] at (current page.west)}
%    {\thepage} ;
%  % chapter mark:
%  \ifthispageodd
%    {\node[anchor=north east,rotate=-90,chapter] at (current page.south east)}
%    {\node[anchor=north west,rotate=90,chapter] at (current page.south west)}
%    {\chaptertitle} ;
%  \ifthispageodd
%    {
%      \draw[mygray,very thin]
%        (current page.south east)++(-.6in,0)--++(0,.6\paperheight) ;
%    }
%    {
%      \draw[mygray,very thin]
%        (current page.south west)++(.6in,0)--++(0,.6\paperheight) ;
%    }
% \end{tikzpicture}
% }
% 
% \documentclass[svgnames]{report}
% \usepackage{tikz}
% \usepackage{kpfonts}
% \usepackage[explicit]{titlesec}
% \newcommand*\chapterlabel{}
% \titleformat{\chapter}
%   {\gdef\chapterlabel{}
%    \normalfont\sffamily\Huge\bfseries\scshape}
%   {\gdef\chapterlabel{\thechapter\ }}{0pt}
%   {\begin{tikzpicture}[remember picture,overlay]
%     \node[yshift=-3cm] at (current page.north west)
%       {\begin{tikzpicture}[remember picture, overlay]
%         \draw[fill=LightSkyBlue] (0,0) rectangle
%           (\paperwidth,3cm);
%         \node[anchor=east,xshift=.9\paperwidth,rectangle,
%               rounded corners=20pt,inner sep=11pt,
%               fill=MidnightBlue]
%               {\color{white}\chapterlabel#1};
%        \end{tikzpicture}
%       };
%    \end{tikzpicture}
%   }
% \titlespacing*{\chapter}{0pt}{50pt}{-60pt}

%
% \documentclass[svgnames]{report}
% \usepackage{tikz}
% \usepackage{kpfonts}
% \usepackage[explicit]{titlesec}
% \newcommand*\chapterlabel{}
% \titleformat{\chapter}
%   {\gdef\chapterlabel{}
%    \normalfont\sffamily\Huge\bfseries\scshape}
%   {\gdef\chapterlabel{\thechapter\ }}{0pt}
%   {\begin{tikzpicture}[remember picture,overlay]
%     \node[yshift=-3cm] at (current page.north west)
%       {\begin{tikzpicture}[remember picture, overlay]
%         \draw[fill=LightSkyBlue] (0,0) rectangle
%           (\paperwidth,3cm);
%         \node[anchor=east,xshift=.9\paperwidth,rectangle,
%               rounded corners=20pt,inner sep=11pt,
%               fill=MidnightBlue]
%               {\color{white}\chapterlabel#1};
%        \end{tikzpicture}
%       };
%    \end{tikzpicture}
%   }
% \titlespacing*{\chapter}{0pt}{50pt}{-60pt}
%
%
%\PassOptionsToClass{headsepline}{scrartcl}
%
%======================================================================
%===  After parsing the options, all variables are populated
\title{\ipureport@title}
\author{\ipureport@author}
%\subject{\ipureport@projectid}
%\keywords{\ipureport@keywords}
%
% \FPmul\ipureport@tmp{\ipureport@sizeratio}{35}
% \FPmul\ipureport@basefontsize{\ipureport@tmp}{\ipureport@fontsizefactor}
% \PassOptionsToClass{fontsize=\expandafter\ipureport@basefontsize pt}{scrartcl}
% \stdout{Loading scrartcl with \ipureport@basefontsize pt}
%
%
%======================================================================
%===  Load the class and call the functions defined above
%\PassOptionsToClass{headsepline}{scrartcl}
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
%\RequirePackage[headsepline]{scrlayer-scrpage}
%\ihead{John Doe}
%\ohead{Outer}
\pagestyle{scrheadings}
\automark[section]{section}
\ihead{\headmark}
\ohead{\pageofpages}
%\ihead{\MakeUppercase{\headmark}}
%\ohead{\MakeUppercase{\pageofpages}}
\chead{}
\cfoot[]{}
%\renewcommand{\headfont}{\normalfont\small\sffamily\bfseries}
%\renewcommand{\headfont}{\normalfont\small\sffamily\bfseries}
%\setkomafont{pageheadfoot}{\normalfont\sffamily\bfseries\scshape\small}
\setkomafont{pageheadfoot}{\normalfont\sffamily\small\bfseries}
%\setkomafont{pagenumber}{\normalfont\sffamily\small\bfseries}
% % \pagestyle{empty}
% %\pagestyle{headings}
% \RequirePackage{scrpage2}%
% \pagestyle{scrheadings}
% \clearscrheadfoot%
% %\ohead{\textbf{\pagemark}}%
% %\renewcommand{\chaptermark}[1]{\markright{\ #1}} % no chapter number
% %\ihead{\textbf{\rightmark}}
% %\setheadsepline{1pt}[\color{blue}]
% %
% \lohead[]{(mytitle)}% Placeholder for \mytitle
% \rehead[]{\leftmark}
% \cfoot[\pagemark]{\pagemark}
% \renewcommand*{\headfont}{\itshape\scshape}% Will equal \scshape for most fonts
% %\renewcommand*{\chaptermarkformat}{\chapapp~\thechapter\autodot\enskip}
%
% \setlength\parindent{0pt}
% %\ipureport@setpapersize
\RequirePackage{geometry}
%\ipureport@setcropsize
\RequirePackage{crop}%
%
%\AtBeginDocument{\ipureport@drawbg}
% \AtBeginDocument{\ipureport@setfonts} 
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
\AtEndOfClass{
  \pdfminorversion=3
  \pdfcompresslevel=0
  \hypersetup{
    pdfauthor = {\ipureport@author},
    pdftitle = {\ipureport@title},
    pdfsubject = {\ipureport@projectid},
    pdfkeywords = {\ipureport@keywords},
    pdfcreator = {LaTeX with ipureport class},
    pdfproducer = {pdfTex}
  }
  \pdfadjustspacing=1
  %%%%%%%%% PDF/X-3 stuff, necessary for Blurb IF USING pdflatex %%%%%%%%%
  % ICC color profiles are embedded in the images
  \pdfinfo{
  /Title (\ipureport@title)   % set your title here
  /Author (\ipureport@author)       % set author name
  /Subject (\ipureport@projectid)          % set subject
  /Keywords (\ipureport@keywords) % set keywords
  /Trapped (False)
  /GTS_PDFXVersion (PDF/X-3:2002)
  }
  % must have a trim box,
  %\pdfpageattr{%/MediaBox [0 0 693.36000 594.00000]
  %/TrimBox [0.00000 9.00000 684.36000 585.00000]}
  \pdfminorversion=5
  \pdfcatalog{
  /OutputIntents [ <<
  /Info (none)
  /Type /OutputIntent
  /S /GTS_PDFX
  /OutputConditionIdentifier (ipu.dk)
  /RegistryName (http://www.color.org/)
  >> ]
  }
}
%
%
%======================================================================
%===  New headlines
%\@startsection{<type>}{<level>}{<indent>}{<beforeskip>}{<afterskip>}{<style>} 
% \renewcommand{\section}{%
%   \@startsection
%     {section}{1}{0pt}{1.25\baselineskip}%
%     {.25\baselineskip}{\usekomafont{section}}%
% }
% \renewcommand{\subsection}{%
%   \@startsection
%     {subsection}{2}{0pt}{0.75\baselineskip}%
%     {-.25\baselineskip}{\usekomafont{subsection}}%
% }
%
%
%======================================================================
%===  Define the new basic environments
% \newenvironment{ipureporthead}{ %
%   \flushleft {\usekomafont{title} \ipureport@title  } \par \vspace*{2\baselineskip} %
% }{ %
%   \vspace*{2\baselineskip} \par %
% } %
% %
% \RequirePackage{xparse}
% \NewDocumentCommand\ipureportauthor{ s m }{%
%   \IfBooleanTF#1%
%     {\vspace*{-0.75\baselineskip}\par\flushleft {\usekomafont{minisec} #2 } \par } % with star
%     {\vspace*{-0.25\baselineskip}\par\flushleft {\usekomafont{minisec} #2 } \par }
% }
% %
% \NewDocumentCommand\ipureportaffil{ s m }{%
%   \IfBooleanTF#1%
%     {\vspace*{-0.75\baselineskip}\par\flushleft {\usekomafont{dictum} #2 } \par } % with star
%     {\vspace*{-0.25\baselineskip}\par\flushleft {\usekomafont{dictum} #2 } \par }
% }
%
% \RequirePackage{etoolbox}
% \RequirePackage{multicol}
% \setlength{\columnsep}{\textintercolumn}
% \ifnumcomp{\ipureport@columncount}{>}{1}{%
% \newenvironment{ipureportcontent}{\begin{multicols}{\ipureport@columncount}}{\end{multicols}}
% }{%
% \newenvironment{ipureportcontent}{}{}%
% }
%
%
% %======================================================================
% %===  Additional new or redefined commands and environments
% \newenvironment{fadebox}%
%   {\begin{lrbox}{\@tempboxa}\begin{minipage}{0.975\linewidth}} %
%   {\end{minipage}\end{lrbox} % box created, now load the rest
%     \begin{tikzpicture} %
%       %\begin{pgfonlayer}{background} %
%       % set base node as marker
%       \node [inner sep=0.5ex,line width=\bglinewidth,outer color=\ipureport@bgcolor!0,inner color=white,draw=\ipureport@bgcolor!5,rounded corners=2\bglinewidth] { %
%         \usebox{\@tempboxa} %
%       }; %
%       %\end{pgfonlayer} %
%     \end{tikzpicture} %\par
%   } %
% %
% %
% %\RequirePackage{caption}
% %
% \renewenvironment{table} %
%   { \par \noindent \def\@captype{table} \begin{center} \begin{minipage}{0.9\linewidth} \begin{center} } %
%   { \end{center} \end{minipage} \end{center} \par } %
% %
% \renewenvironment{figure} %
%   { \par \noindent \def\@captype{figure} \begin{center} \begin{minipage}{0.9\linewidth} \begin{center} } %
%   { \end{center} \end{minipage} \end{center} \par } %
%
%
\endinput