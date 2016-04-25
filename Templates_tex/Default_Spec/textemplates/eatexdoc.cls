% Class to create DSPECIALISTS specification documents
%
% valid options are
%  german
%  english

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{eatexdoc}[2013/01/31]

%% define CLASS
\LoadClass[11pt, a4paper, twoside, parskip=half, bibliography=totoc, final, numbers=noenddot]{scrartcl}     %scrreprt    


\DeclareOption{english}{%
	\PassOptionsToPackage{english}{babel}
	\newcommand*{\lang}{en}
}

\DeclareOption{german}{%
	\PassOptionsToPackage{ngerman}{babel}
	\newcommand*{\lang}{de}
}

\ProcessOptions\relax

\RequirePackage{babel}     % switch by \begin{otherlanguage}{english}.. \end{otherlanguage} 
\providecommand\locale{\lang}
\providecommand\dq{"}
\input{textemplates/default_preamble}

% Sprachdefinition muss VOR include der externen Dokumente (in document_config) erfolgen
% Hintergrund: Offenbar bereiten \lang-Kommandos in Labels von Tabellen externer Dokumente Probleme,
% da sie die \en und \de Befehle enthalten. So ganz klar sind die resultierenden Probleme aber nicht.
\localedef{de}{ngerman}
\localedef{en}{english}

\input{document_config}


% % Allgemeine Schalter - Änderung von Standardeinstellungen
\frenchspacing                                                           % keine längeren Leerzeichen nach Satzende/Abkürzungen mit Punkt
\setlength{\parindent}{0pt}                                             % kein Einzug bei neuem Absatz
\setlength{\parskip}{1.5ex plus0.5ex minus 0.5ex}        % Abstand zwischen 2 Absätzen

% Wortabstände optimal einstellen (use instead of \sloppy) - Verhindern von rausragenden Zeilen
\tolerance 1414
\hbadness 1414
\emergencystretch 1.5em
\hfuzz 0.3pt
\widowpenalty=10000
\vfuzz \hfuzz
\raggedbottom
\brokenpenalty=10000                                                            % Trennung bei Seitenumbruch



% Setze Überschriftentiefe
\setcounter{secnumdepth}{5}                                                                                             % Nummerierung der Kapitel
\setcounter{figure}{0}                                                                                                  % Bilder
\setcounter{tocdepth}{\eatexTocDepth}                                                                                                   % Gliederungsebene für Inhaltsverzeichnis

\usepackage{tabulary}
\usepackage[newcommands]{ragged2e}

\pagestyle{fancy}

\fancypagestyle{plain}
{
        \renewcommand{\headrulewidth}{0pt}%
        \fancyhf{}
        \fancyfoot[RE,LO]{\textit{\footnotesize{\eatexTitle{} -- \eatexDoctype{}}}}
        \fancyfoot[LE,RO]{\textit{\footnotesize{\thepage}}}
}

\fancyhead{}
\fancyfoot{}

\fancyfoot[LO,RE]{\textit{\footnotesize{\eatexTitle{} -- \eatexDoctype{}}}}
\fancyfoot[RO,LE]{\textit{\footnotesize{\thepage}}}
\fancyhead[LE,RO]{\textit{\footnotesize{\nouppercase{\leftmark}}}}
\fancyhead[RE,LO]{\textit{\footnotesize{\rightmark}}}


\setlength{\headheight}{0.5cm}                                                  % Höhe der Kopfzeile
\addtolength{\footnotesep}{2pt}                                                 % abstand der Fußnote zur Trennlinie

\usepackage[ragged,flushmargin,bottom,multiple]{footmisc}



\input{textemplates/eatexcmd}


\hypersetup{
		bookmarks=false    % show bookmarks bar?",
		pdftitle={\eatexTitle}    % title",
		pdfauthor={DSPECIALISTS GmbH}                     % author",
		pdfsubject={\eatexDoctype}                        % subject of the document",
		pdfkeywords={}, % list of keywords",
		colorlinks=true,       % false: boxed links; true: colored links",
		linkcolor=MidnightBlue,       % color of internal links",
		citecolor=black,       % color of links to bibliography",
		filecolor=MidnightBlue,        % color of file links",
		urlcolor=MidnightBlue,        % color of external links",
		linktoc=page            % only page is linked",
}%",

%% layout
\RequirePackage[top=2.5cm,left=3.5cm,right=2.5cm,bottom=3cm]{geometry}


%%%%%%%%%%%%%%% DOCUMENT START %%%%%%%%%%%%%%
\begin{document}


	% Titelblatt
	\input{textemplates/titel}										% Füge Titelblatt ein
	\cleardoublepage												% Leere Seite
	\nocite{*}														% einbinden aller Literatureinträge

	% Vorspann

	\thispagestyle{plain}
	\tableofcontents 												% Inhaltsverzeichnis
	\cleardoublepage

	% Hauptteil
	\thispagestyle{fancy}
	\include{./eachapters}

	% das Abbildungsverzeichnis
	\phantomsection % for hyperref
	\addcontentsline{toc}{section}{\listfigurename}
	\listoffigures
	
	\thispagestyle{plain}

	% das Tabellenverzeichnis
	\phantomsection % for hyperref
	\addcontentsline{toc}{section}{\listtablename}
	\listoftables

	\thispagestyle{plain}
	
	% der Index
	%\printindex
	%\addcontentsline{toc}{chapter}{Index}
	

	% Literaturverzeichnis
	%\raggedright													% Literatur im Flattersatz (v.a. wegen URLs)
	%\bibliography{./Literatur/Literatur}
	%\bibliographystyle{alphadin}

\end{document}
%%%%%%%%%%%%%%% END %%%%%%%%%%%%%%%

