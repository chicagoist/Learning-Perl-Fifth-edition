#!/usr/bin/perl -w

use 5.10.0;
# use CGI;
# use Encode qw(decode_utf8);
# use Encode qw(decode encode);
# BEGIN{@ARGV=map Encode::decode($_, 1),@ARGV;}
# BEGIN{@ARGV = map decode_utf8($_, 1), @ARGV;}
# use open qw(:std :encoding(UTF-8));
# use Encode::Locale;
# use Encode;
# use Time::Moment;
# use diagnostics;


use strict;
use warnings FATAL => 'all';
use utf8;
binmode(STDIN, ':utf8');
binmode(STDOUT, ':utf8');
use utf8::all 'GLOBAL';
use DDP;
use Data::Dumper;
use Bundle::Camelcade;



# File 16.2.pl
# https://github.com/chicagoist/Exercises_From_LearningPerl.git
# https://www.learning-perl.com/
# https://www.linkedin.com/in/legioneroff/


# Измените предыдущую программу так, чтобы выходные данные команды сохранялись в файле ls.out  текущего каталога.
# Информация об ошибках должна сохраняться в файле ls.err. (Любой из этих файлов может быть пустым, никакие
# специальные действия по этому поводу не требуются.)

sub ls_l_out {
    my $dir;

        if (defined $ARGV[0]) {
            $_ = $ARGV[0];
            /^\/.*$/;
            chomp($dir = $ARGV[0]);
        }
        elsif (!defined $ARGV[0]) {
            print "Enter your disared directory : ";
            chomp($dir = <STDIN>);
        }


    open my $fh_ls_out, '+>', 'ls.out' or die "cannot open or create file ls.out: $!";
    # open my $fh_ls_err, '+>', 'ls.err' or die "cannot open or create ls.out: $!"; # some like variant
    # open my $fh_ls, '-|', "ls -l $dir 2>ls.err" or die "cannot launch ls -l: $!"; # some like variant

    # while(<$fh_ls>){ # some like variant
    #     print $fh_ls_out "$_\n";
    # }

    open my $fh_ls, '-|', "ls -l $dir 1>ls.out 2>ls.err"
        or die "cannot launch ls -l or create files ls.out, ls.err: $!";

    # system "cat ls.out && cat ls.err"; # for checking files

    close($fh_ls_out);
    close($fh_ls);
}
&ls_l_out;


=begin text

 $ perl 16.1.pl

=end text

=cut


# Верный ответ из книги:

# Here’s one way to do it:

#  chdir '/' or die "Can't chdir to root directory: $!";
#  exec 'ls', '-l' or die "Can't exec ls: $!";

# The first line changes the current working directory to the root directory,
# as our particular hardcoded directory. The second line uses the multiple-argument
# exec function to send the result to standard output. We could have used the
# single-argument form just as well, but it doesn’t hurt to do it this way.