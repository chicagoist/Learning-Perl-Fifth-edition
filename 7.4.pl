#!/usr/bin/perl -w

use 5.10.0;
use strict;
use open qw(:std :encoding(UTF-8));
use Encode qw(decode_utf8);
BEGIN{@ARGV = map decode_utf8($_, 1), @ARGV;}
binmode(STDIN, ':utf8');
binmode(STDOUT, ':utf8');
use utf8;
use warnings;
#use POSIX;
#use utf8::all 'GLOBAL'; # пробую этот модуль вместо закомментированных выше строк

# File 7.4.pl
# https://github.com/chicagoist/Exercises_From_LearningPerl.git
# https://www.learning-perl.com/
# https://www.linkedin.com/in/legioneroff/


# Напишите программу, которая выводит каждую строку со словом, содержащим буквы верхнего регистра
# (но не состоящим из них ПОЛНОСТЬЮ!) Будет ли она находить совпадение в строке Fred, но не в строках fred и FRED?


sub find_a_string {
    my $index_dots = 0; # индекс для подсчёта строк с именем fred
    my $index_all = 0;  # индекс подсчёта общих строк

    chomp(@_);
    foreach (@_) # запускаем цикл по массиву
    {

        if ($_ =~ /[\p{Lu}]{1}[\p{Ll}+]/) {

            print "$_\n";
            $index_dots++

        }


    }
    # блок разделения между тестами. просто для наглядности
    print "\n";
    foreach (0 .. 40) {
        printf("%s", "##");
    }
    print "\n\n";
    # блок разделения между тестами. просто для наглядности

    foreach (@_) {
        if (/(.)*/) # проходим все строки подряд без ограничений
        {
            #print "$_\n"; # печатаем текст
            $index_all++; # добавляем в счетчик
        }
    }

    say "\$index_dots = $index_dots"; # сравниваем разницу индексов
    say "\$index_all = $index_all";

}


find_a_string(<>);
# $ perl 7.4.pl examples/sample_files/text_files/sample_text


# Верный ответ из книги:

#Here’s one way to do it:
#Here’s one way to do it: change the pattern used in the first exercise’s answer to /[fF]red/.
# You could also have tried /(f|F)red/  or /fred|Fred/, but the character class is more efficient.
