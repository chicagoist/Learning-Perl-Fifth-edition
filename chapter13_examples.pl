#!/usr/bin/perl -w

use 5.10.0;
# use CGI;
# use POSIX;
# use Encode qw(decode_utf8);
# use Encode qw(decode encode);
# BEGIN{@ARGV=map Encode::decode($_,1),@ARGV;}
# BEGIN{@ARGV = map decode_utf8($_, 1), @ARGV;}
# use open qw(:std :encoding(UTF-8));
# use utf8::all 'GLOBAL';
# use Encode::Locale;
# use Encode;
# use diagnostics;


use strict;
use warnings FATAL => 'all';
use utf8;
binmode(STDIN, ':utf8');
binmode(STDOUT, ':utf8');
use DDP;
use Data::Dumper;


# ОПЕРАЦИИ С КАТАЛОГАМИ
#


{ # ПЕРЕМЕЩЕНИЕ ПО ДЕРЕВУ КАТАЛОГОВ

    chdir "/etc" or die "cannot chdir to /etc: $!";

    # Некоторые командные процессоры позволяют включать в
    # команду cd путь с префиксом ~, чтобы использовать в
    # качестве отправной точки домашний каталог другого
    # пользователя (например, cd ~merlyn). Это функция командного
    # процессора, а не операционной системы, а Perl вызывает
    # функции операционной системы напрямую, поэтому
    # префикс ~ не работает с chdir.

}

{ # ГЛОБЫ
    sub show_args {
    foreach my $arg (@ARGV) {
        print "one arg is $arg\n";
    }
}
show_args();
}