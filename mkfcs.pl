#!/usr/bin/perl
use warnings;
use strict;
use open ':utf8';
use utf8;
use POSIX;

$0 = 'mkfcs';

BEGIN {
   unshift @INC, ".";
}


########################################################################
# Global variables.
########################################################################

# insert the templates for the tex code
use Templates;

# config: show fcs border lines?
my $SHOW_BORDERS = '';

# the output file
my $OUTPUT_FILE = '';

# input files
my @INPUT_FILES = ();

# tex template name (must be a key of %TABULARS)
my $TABULAR = '';

# all the data, in the format @DATA = ( [ Q, A ], ... )
my @DATA = ();


########################################################################
# Get the command line parameters.
# Only with the format -o=foo, where o is the option code and foo the
# parameter.
########################################################################

my $HELP_TEXT = << "END";
USAGE
   $0 OPTIONS input_file_1 input_file_2 ...

DESCRIPTION
   Make a set of flashcards on A4 paper.  The script reads some input files
   of the format described below and output a .tex file.

   Name of input files that begin with '#' are ignored, so you can use
   paths from a file: 'cat file-list | xargs perl mkfcs.pl'.

   You can (but are not required to) create a 'preamble.tex' file containing
   settings that you want to save between calls of 'mkfcs.pl' script.  For
   example, if you want to set the same font for all the flashcards you create
   with this script:

      \\setmainfont{MyFont}

OPTIONS (only allowed with the format -o=param)
   -o=FILE         Output file.  "out.tex" by default.
   -t=NB           Number of flashcards per page: 18, 12, 8.
   -b              Show the borders.
   -h              This help.
   -H              A bigger help text.
END

my $HELP_DESCRIPTION = << "END";
USAGE
   $0 OPTIONS input_file_1 input_file_2 ...

DESCRIPTION:
   The input files must be as follows:
     - white lines at the beginning and the end are ignored.
     - Q and A are separated by a line containing a single colon ':'
       (spaces before/after allowed), or by a double colon '::' anywhere
       on a line.
     - Q/A pairs are separated by white lines.  That means that there must
       be no white line in a Q/A pairs (use the LaTeX comment sign, if you
       want).
     - Lines beginning by % are ignored.

   You can use some formatting options in the format '%%option-name:value'.
   The options are as follows:
     - question-size: the size (normalsize, large, Large, etc.) for all
       the following questions in the file.  The default value is 'Large',
       and this value is reset for each new file.
     - answer-size: same as above, but for answers.
     - question-font: if not empty, a command \\<MyFont>{...} is added
       around all the following questions in the file.  The default value
       is nothing, and this value is reset for each new file.
     - answer-font: same as above, but for answers
     - define: define a macro which can be use later (in a option only)
       with the syntax '\$macroname'.  The value of the option is
       'macroname=value'.

   Here is an example of a file:

      %%define:default-question-size:large
      %%question-size:\\\$default-question-size

      ***
      one
      :
      eins

      %%question-size:Huge
      ***two::zwei
      %%question-size:\$default-question-size

      What is 'three' in german?
      ::drei
      (question ignored, cause it doesn't start with '***')
END


sub get_options {

   # default:
   $OUTPUT_FILE = 'out.tex';
   $TABULAR = '18';
   $SHOW_BORDERS = '';

   for (@ARGV) {

      if (m/^\-o=(.*+)$/) {
         $OUTPUT_FILE = $1 or die "$0: *** error -o ***\n";
      } elsif (m/^\-t=(.*+)$/) {
         $TABULAR = $1 or die "$0: *** error -t ***\n";
      } elsif (m/^\-b$/) {
         $SHOW_BORDERS = 1;
      } elsif (m/^\-h$/) {
         print $HELP_TEXT;
         exit;
      } elsif (m/^\-H$/) {
         print $HELP_DESCRIPTION;
         exit;
      } elsif (m/^\-(.*+)/) {
         die "$0: *** bad option '$1' ***\n";
      } else {
         push @INPUT_FILES, $_ unless m/^\s*+#/;
      }

   }

   die "$0: *** no input files ***\n" unless @INPUT_FILES;

   die "$0: *** no template '$TABULAR' ***\n"
      unless exists $TABULARS{$TABULAR};

   @ARGV = ();

}



########################################################################
# Read the input file and fill @DATA.  Die on error.
#
# ARG: INPUT_FILE
########################################################################

sub _save_qa {

   my ($q, $a, %options) = @_;

   $q =~ s/^\s++//s; chomp $q;
   $a =~ s/^\s++//s; chomp $a;

   return unless $q;

   $q =~ s/^\*\*\*//;

   die "$0: *** question without answer: '$q' ***\n" unless $a;

   $q = "\\$options{'question-size'}%\n$q";
   $a = "\\$options{'answer-size'}%\n$a";

   if ($options{'question-font'}) {
      $q = "\\$options{'question-font'}\{%\n$q%\n\}";
   }
   if ($options{'answer-font'}) {
      $a = "\\$options{'answer-font'}\{%\n$a%\n\}";
   }

   push @DATA, [ $q, $a ];

}


sub read_file {

   my $file = shift;

   print "$0: Reading $file...\n";

   open my $fh, $file
      or die "$0: *** can't open '$file' ***\n";

   my ($q, $a) = ('', '');
   my $question_flag = 1;
   my %opts = ('question-size'=>'Large', 'answer-size'=>'Large',
      'question-font'=>'', 'answer-font'=>'');
   my %macros = ();
   my $data_before = scalar(@DATA);

   while (<$fh>) {

      chomp;

      # '%%define:macro=value': define a macro
      if (m/^\s*+%%define:([^=]++)=(.++)$/) {

         _save_qa($q, $a, %opts);
         ($q, $a) = ('', '');
         $question_flag = 1;

         $macros{$1} = $2;

      # '%%option=value': formatting option
      } elsif (m/^\s*+%%([^:]++):(.*+)$/) {

         _save_qa($q, $a, %opts);
         ($q, $a) = ('', '');
         $question_flag = 1;

         my ($opt, $val) = ($1, $2);
         if ($val =~ m/^\$(.++)$/) {
            die "$0: *** macro not defined: $1 ***\n"
               unless exists $macros{$1};
            $val = $macros{$1};
         }
         $opts{$opt} = $val;

      # '%...': comment
      } elsif (m/^\s*+%/) {

         # nothing

      # white line: change of fc (and write the current one)
      } elsif (m/^\s*+$/) {

         _save_qa($q, $a, %opts);
         ($q, $a) = ('', '');
         $question_flag = 1;

      # '::' in the middle of a line: before = question, after = answer
      } elsif (m/^((?:[^:]|:(?!:))*+)::(.*+)$/s) {

         $q .= "$1\n"; $a .= "$2\n";
         $question_flag = 0;

      # ':' on the line: from Q to A
      } elsif (m/^\s*+:\s*+$/) {

         $question_flag = 0;

      # otherwise: text to write in the Q or in the A
      } else {

         if ($question_flag) { $q .= "$_\n"; }
         else { $a .= "$_\n"; }

      }

   } # end while

   # save the last question
   _save_qa($q, $a, %opts);

   close $fh or die "$0: *** can't close '$file' ***\n";

   printf "$0: Total: % 3d fcs in the file.\n",
      scalar(@DATA) - $data_before;

}


########################################################################
# Print the @DATA into the $OUTPUT_FILE.
########################################################################

sub write_tex {

   print "$0: Writing to $OUTPUT_FILE...\n";

   open my $fh, '>', $OUTPUT_FILE
      or die "$0: *** can't open '$OUTPUT_FILE' ***\n";

   print $fh $PREAMBLE;

   my ($q_page, $a_page) = ('', '');

   my $c = 1; # q/a counter
   my $pages_cntr = 0;

   for my $r (@DATA) {

      # reset the q/a page template if we start a new page
      if ($c == 1) {
         $q_page = $TABULARS{$TABULAR}->{qpage};
         $a_page = $TABULARS{$TABULAR}->{apage};
      }

      # replace the q/a text in the q/a item
      (my $q = $QUESTION_ITEM) =~ s/QUESTION/$r->[0]/ge;
      (my $a = $ANSWER_ITEM) =~ s/ANSWER/$r->[1]/ge;

      my $c_str = sprintf('%02d', $c++);

      # replace the q/a item in the page (using the counter)
      $q_page =~ s/QUESTION_$c_str/$q/;
      $a_page =~ s/ANSWER_$c_str/$a/;

      # if no more q/a item fit on the page, output it
      if ($c > $TABULARS{$TABULAR}->{per_page}) {
         print $fh $q_page; #, "\n\n\\clearpage\n\n";
         print $fh $a_page; #, "\n\n\\clearpage\n\n";
         $c = 1;
         $pages_cntr++;
      }

   }

   print $fh $POSTAMBLE;

   close $fh or die "$0: *** can't close '$OUTPUT_FILE' ***\n";

   printf "$0: %d x 2 = %d pages written.\n", $pages_cntr,
      $pages_cntr*2;

}


########################################################################
# main()
########################################################################

sub main {

   get_options();

   # read the files

   for (@INPUT_FILES) {
      read_file($_);
   }

   # prepare the templates


   my $hline = ($SHOW_BORDERS ? ' \hline' : '');
   my $vline = ($SHOW_BORDERS ? '|' : '');
   $TABULARS{$TABULAR}->{qpage} =~ s/HLINE/$hline/g;
   $TABULARS{$TABULAR}->{qpage} =~ s/VLINE/$vline/g;
   $TABULARS{$TABULAR}->{apage} =~ s/HLINE/$hline/g;
   $TABULARS{$TABULAR}->{apage} =~ s/VLINE/$vline/g;

   # complete @DATA by some empty fcs to get a multiple of $MAX_FCS

   printf "$0: Total: % 3d significant fcs.\n", scalar(@DATA);

   my $n = scalar(@DATA);
   my $nb_to_add = (floor($n/$TABULARS{$TABULAR}->{per_page})+1) *
      $TABULARS{$TABULAR}->{per_page} - $n;
   $nb_to_add = 0 if $n % $TABULARS{$TABULAR}->{per_page} == 0;
   for (1..$nb_to_add) { push @DATA, [ '', '' ]; }

   printf "$0: Total: % 3d fcs printed.\n", scalar(@DATA);

   # write the tex code

   print "Template is: '$TABULAR'.\n";

   write_tex();

}

main();
print "$0: done!\n";
