package Templates;
use strict;
use warnings;
use utf8;
use Exporter 'import';

our @EXPORT = qw(
   $PREAMBLE
   $POSTAMBLE
   $QUESTION_ITEM
   $ANSWER_ITEM
   %TABULARS
);


# preamble
our $PREAMBLE = <<'END';
\documentclass[a4paper,11pt]{article}

\usepackage{comment}

% no margin
\pagestyle{empty}
\usepackage[margin=0in]{geometry}

% set the fonts
\usepackage{fontspec}
\defaultfontfeatures{Ligatures=TeX}

% uncomment and replace the main font as you want
%\setmainfont{Charis SIL}
% font for the IPA unicode chars
%\newfontfamily\MyIPAFont{Charis SIL}
%\newcommand{\MyIPA}[1]{{\MyIPAFont{}#1}}

% tabular formatting
\usepackage{array}

% use graphic in flash cards
\usepackage{graphicx}

\IfFileExists{preamble}{\input{preamble}}{}

\title{}
\author{}

\begin{document}

END

# postamble
our $POSTAMBLE = <<'END';

\end{document}
END

# question item: the question must be referenced as QUESTION
our $QUESTION_ITEM = <<'END';

   \begin{center}%
      QUESTION%
   \end{center}
END

# answer item: the answer must be referenced as ANSWER
our $ANSWER_ITEM = <<'END';

   \begin{center}%
      ANSWER%
   \end{center}
END



# Now we defined the hash containing the tabular templates (which
# question goes where).  The format is:
#   %TABULARS = (
#      TEMPLATE_NAME => {
#         per_page=>NB, # nbs of fcs per page
#         qpage=>TEX, # the questions page 
#         apage=>TEX, # the answers page
#      }
#   )
#
# All the questions must be referenced as QUESTION_01, QUESTION_02,
# ... until QUESTION_<per_page>.
#
# You can put VLINE and HLINE where you want to plage vert or horiz
# borders (this will be replaced by the correct value)
#
# Note that if you don't want margin, you can write:
# \begin{tabular}{VLINE
#                  @{}m{0cm}@{}VLINE%
#                  @{}m{6.55cm}@{}VLINE%
#                  @{}m{6.55cm}@{}VLINE%
#                  @{}m{6.55cm}@{}VLINE%
#                }
# But the text is too near the border of the fc.


our %TABULARS = (

   # format 18 fcs per pages (7cm*4.8cm)

   '18' => {

      per_page => 18,

      qpage => <<'END',
\noindent
\begin{tabular}{VLINE
                 @{}m{0cm}@{}VLINE%
                 @{\hspace{5mm}}m{6cm}@{\hspace{5mm}}VLINE%
                 @{\hspace{5mm}}m{6cm}@{\hspace{5mm}}VLINE%
                 @{\hspace{5mm}}m{6cm}@{\hspace{5mm}}VLINE%
               }
% LINE 1
\rule{0pt}{4.8cm} & QUESTION_01 & QUESTION_02 & QUESTION_03 \\ HLINE
% LINE 2
\rule{0pt}{4.8cm} & QUESTION_04 & QUESTION_05 & QUESTION_06 \\ HLINE
% LINE 3
\rule{0pt}{4.8cm} & QUESTION_07 & QUESTION_08 & QUESTION_09 \\ HLINE
% LINE 4
\rule{0pt}{4.8cm} & QUESTION_10 & QUESTION_11 & QUESTION_12 \\ HLINE
% LINE 5
\rule{0pt}{4.8cm} & QUESTION_13 & QUESTION_14 & QUESTION_15 \\ HLINE
% LINE 6
\rule{0pt}{4.8cm} & QUESTION_16 & QUESTION_17 & QUESTION_18 \\ HLINE
\end{tabular}

END

      apage => <<'END',
\noindent
\begin{tabular}{VLINE
                 @{}m{0cm}@{}VLINE%
                 @{\hspace{5mm}}m{6cm}@{\hspace{5mm}}VLINE%
                 @{\hspace{5mm}}m{6cm}@{\hspace{5mm}}VLINE%
                 @{\hspace{5mm}}m{6cm}@{\hspace{5mm}}VLINE%
               }
% LINE 1
\rule{0pt}{4.8cm} & ANSWER_03 & ANSWER_02 & ANSWER_01 \\ HLINE
% LINE 2
\rule{0pt}{4.8cm} & ANSWER_06 & ANSWER_05 & ANSWER_04 \\ HLINE
% LINE 3
\rule{0pt}{4.8cm} & ANSWER_09 & ANSWER_08 & ANSWER_07 \\ HLINE
% LINE 4
\rule{0pt}{4.8cm} & ANSWER_12 & ANSWER_11 & ANSWER_10 \\ HLINE
% LINE 5
\rule{0pt}{4.8cm} & ANSWER_15 & ANSWER_14 & ANSWER_13 \\ HLINE
% LINE 6
\rule{0pt}{4.8cm} & ANSWER_18 & ANSWER_17 & ANSWER_16 \\ HLINE
\end{tabular}

END

   },


   # format 12 fcs per pages (10.5cm*4.8cm)

   '12' => {

      per_page => 12,

      qpage => <<'END',
\noindent
\begin{tabular}{VLINE
                 @{}m{0cm}@{}VLINE%
                 @{\hspace{5mm}}m{9.5cm}@{\hspace{5mm}}VLINE%
                 @{\hspace{5mm}}m{9.5cm}@{\hspace{5mm}}VLINE%
               }
% LINE 1
\rule{0pt}{4.8cm} & QUESTION_01 & QUESTION_02 \\ HLINE
% LINE 2
\rule{0pt}{4.8cm} & QUESTION_03 & QUESTION_04 \\ HLINE
% LINE 3
\rule{0pt}{4.8cm} & QUESTION_05 & QUESTION_06 \\ HLINE
% LINE 4
\rule{0pt}{4.8cm} & QUESTION_07 & QUESTION_08 \\ HLINE
% LINE 5
\rule{0pt}{4.8cm} & QUESTION_09 & QUESTION_10 \\ HLINE
% LINE 6
\rule{0pt}{4.8cm} & QUESTION_11 & QUESTION_12 \\ HLINE
\end{tabular}

END

      apage => <<'END',
\noindent
\begin{tabular}{VLINE
                 @{}m{0cm}@{}VLINE%
                 @{\hspace{5mm}}m{9.5cm}@{\hspace{5mm}}VLINE%
                 @{\hspace{5mm}}m{9.5cm}@{\hspace{5mm}}VLINE%
               }
% LINE 1
\rule{0pt}{4.8cm} & ANSWER_02 & ANSWER_01 \\ HLINE
% LINE 2
\rule{0pt}{4.8cm} & ANSWER_04 & ANSWER_03 \\ HLINE
% LINE 3
\rule{0pt}{4.8cm} & ANSWER_06 & ANSWER_05 \\ HLINE
% LINE 4
\rule{0pt}{4.8cm} & ANSWER_08 & ANSWER_07 \\ HLINE
% LINE 5
\rule{0pt}{4.8cm} & ANSWER_10 & ANSWER_09 \\ HLINE
% LINE 6
\rule{0pt}{4.8cm} & ANSWER_12 & ANSWER_11 \\ HLINE
\end{tabular}

END

   },


   # format 08 fcs per pages

   '8' => {

      per_page => 8,

      qpage => <<'END',
\noindent
\begin{tabular}{VLINE
                 @{}m{0cm}@{}VLINE%
                 @{\hspace{5mm}}m{9.5cm}@{\hspace{5mm}}VLINE%
                 @{\hspace{5mm}}m{9.5cm}@{\hspace{5mm}}VLINE%
               }
% LINE 1
\rule{0pt}{7.26cm} & QUESTION_01 & QUESTION_02 \\ HLINE
% LINE 2
\rule{0pt}{7.26cm} & QUESTION_03 & QUESTION_04 \\ HLINE
% LINE 3
\rule{0pt}{7.26cm} & QUESTION_05 & QUESTION_06 \\ HLINE
% LINE 4
\rule{0pt}{7.26cm} & QUESTION_07 & QUESTION_08 \\ HLINE
\end{tabular}

END

      apage => <<'END',
\noindent
\begin{tabular}{VLINE
                 @{}m{0cm}@{}VLINE%
                 @{\hspace{5mm}}m{9.5cm}@{\hspace{5mm}}VLINE%
                 @{\hspace{5mm}}m{9.5cm}@{\hspace{5mm}}VLINE%
               }
% LINE 1
\rule{0pt}{7.26cm} & ANSWER_02 & ANSWER_01 \\ HLINE
% LINE 2
\rule{0pt}{7.26cm} & ANSWER_04 & ANSWER_03 \\ HLINE
% LINE 3
\rule{0pt}{7.26cm} & ANSWER_06 & ANSWER_05 \\ HLINE
% LINE 4
\rule{0pt}{7.26cm} & ANSWER_08 & ANSWER_07 \\ HLINE
\end{tabular}

END

   },


   # format 18 fcs per pages for ruled paper

   '18ruled' => {

      per_page => 18,

      qpage => <<'END',
\noindent
\begin{tabular}{VLINE
                 @{}m{1.3cm}@{}VLINE%
                 @{\hspace{5mm}}m{5.55cm}@{\hspace{5mm}}VLINE%
                 @{\hspace{5mm}}m{5.55cm}@{\hspace{5mm}}VLINE%
                 @{\hspace{5mm}}m{5.55cm}@{\hspace{5mm}}VLINE%
               }
% LINE 1
\rule{0pt}{4.8cm} & QUESTION_01 & QUESTION_02 & QUESTION_03 \\ HLINE
% LINE 2
\rule{0pt}{4.8cm} & QUESTION_04 & QUESTION_05 & QUESTION_06 \\ HLINE
% LINE 3
\rule{0pt}{4.8cm} & QUESTION_07 & QUESTION_08 & QUESTION_09 \\ HLINE
% LINE 4
\rule{0pt}{4.8cm} & QUESTION_10 & QUESTION_11 & QUESTION_12 \\ HLINE
% LINE 5
\rule{0pt}{4.8cm} & QUESTION_13 & QUESTION_14 & QUESTION_15 \\ HLINE
% LINE 6
\rule{0pt}{4.8cm} & QUESTION_16 & QUESTION_17 & QUESTION_18 \\ HLINE
\end{tabular}

END

      apage => <<'END',
\noindent
\begin{tabular}{VLINE
                 @{}m{0cm}@{}VLINE%
                 @{\hspace{5mm}}m{5.55cm}@{\hspace{5mm}}VLINE%
                 @{\hspace{5mm}}m{5.55cm}@{\hspace{5mm}}VLINE%
                 @{\hspace{5mm}}m{5.55cm}@{\hspace{5mm}}VLINE%
               }
% LINE 1
\rule{0pt}{4.8cm} & ANSWER_03 & ANSWER_02 & ANSWER_01 \\ HLINE
% LINE 2
\rule{0pt}{4.8cm} & ANSWER_06 & ANSWER_05 & ANSWER_04 \\ HLINE
% LINE 3
\rule{0pt}{4.8cm} & ANSWER_09 & ANSWER_08 & ANSWER_07 \\ HLINE
% LINE 4
\rule{0pt}{4.8cm} & ANSWER_12 & ANSWER_11 & ANSWER_10 \\ HLINE
% LINE 5
\rule{0pt}{4.8cm} & ANSWER_15 & ANSWER_14 & ANSWER_13 \\ HLINE
% LINE 6
\rule{0pt}{4.8cm} & ANSWER_18 & ANSWER_17 & ANSWER_16 \\ HLINE
\end{tabular}

END

   },

);

1;
