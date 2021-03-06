#!/usr/bin/perl

use 5.10.0;
# use CGI;
use POSIX;
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
use utf8::all 'GLOBAL';
use DDP;
use Data::Dumper;
use Bundle::Camelcade;


# РАСШИРЕННЫЕ ВОЗМОЖНОСТИ Perl

{
    # ПЕРЕХВАТ ОШИБОК В БЛОКАХ eval
    # в Perl имеется простой способ перехвата фатальных ошиQ бок – проверяемый код заключается в блок eval:
    my $dino = 0;
    my $barney;
    my $fred = 5;

    # При отсутствии ошибок значение вычисляется по аналогии с функциями: как результат последнего вычисленного
    # выражения или как значение, возвращаемое на более ранней стадии необязательным ключевым словом return.
    # А вот другой способ выполнения вычислений, при котором вам не нужно беспокоиться о делении на нуль:
    $barney = eval {$fred / $dino};
    print "\$barney = ", $barney // "\'uninitialized value\'", "\n";

    eval {$barney = $fred / $dino};
    print $@ if $@;
    print "An error occurred: $@" if $@;

    # $barney = $fred / $dino or $@;

    # Блок eval  является полноценным блоком, поэтому он определяет новую область видимости для
    # лексических (my) переменных. В следующем фрагменте показан блок eval в действии:

    foreach my $person (qw/fred wilma betty barney dino pebbles/) {
        eval {
            open FILE, "<$person"
                or die "Can't open file '$person': $!";
            my ($total, $count);
            while (<FILE>) {
                $total += $_;
                $count++;
            }
            my $average = $total / $count;
            print "Average for file $person was $average\n";
            &do_something($person, $average);
        };
        if ($@) {
            print "An error occurred ($@), continuing\n";
        }
    }

    print "Crash or not the code?\n";
    # Если ошибка происходит в ходе обработки одного из файлов, мы получим сообщение об ошибке,
    # но программа спокойно перейдет к следующему файлу.


    {
        # ОТБОР ЭЛЕМЕНТОВ СПИСКА

        # Допустим, из списка чисел необходимо отобрать только нечетные числа или из текстового файла
        # отбираются только те строки, в которых присутствует подстрока Fred. Как будет показано в этом
        # разделе, задача отбора элементов списка легко решается при помощи оператора grep. Давайте
        # начнем с первой задачи и выделим нечетные числа из большого списка. Ничего нового для этого
        # нам не понадобится:
        my @odd_numbers;
        foreach (1 .. 1000) {
            push @odd_numbers, $_ if $_ % 2;
        }
        print "@odd_numbers\n";

        # В этом фрагменте  используется оператор вычисления остатка (%), который был представлен в главе 2.
        # Для четного числа остаток от делеQ ния на 2  равен 0, а проверяемое условие ложно. Для нечетного
        # числа остаток равен 1; значение истинно, поэтому в массив заносятся только нечетные числа.
        # В этом коде нет ничего плохого, разве что он пишется и выполняется немного медленнее, чем следует,
        # потому что в Perl имеется оператор grep:
        my @odd_numbers_grep = grep {$_ % 2} 1 .. 1000;
        print "@odd_numbers_grep\n";

        # В следующем примере из файла извлекаются только те строки, в которых присутствует подстрока fred:
        open my $find_fred, "<:encoding(UTF-8)", 'examples/sample_files/text_files/sample_text';
        my @matching_lines = grep {/\bfred\b/i} <$find_fred>;
        print "@matching_lines\n";


        # В упрощенной записи предыдущий пример выглядит так:
        open my $find_fred_without_braces, "<:encoding(UTF-8)", 'examples/sample_files/text_files/sample_text';
        my @matching_lines_braces = grep /\bfred\b/i, <$find_fred_without_braces>;
        print "@matching_lines_braces\n";

        close($find_fred_without_braces);
        close($find_fred);
    }

    {
        # ПРЕОБРАЗОВАНИЕ ЭЛЕМЕНТОВ СПИСКА

        # Другая распространенная задача – преобразование элементов списка.
        # Предположим, имеется список чисел, которые необходимо перевести в «денежный формат»
        # для вывода, как в функции &big_money (см. главу 14). Однако исходные данные
        # изменяться не должны; нам нужна измененная копия списка, используемая только для вывода.
        # Одно из возможных решений:

        sub big_money {
            #chomp($_ = <STDIN>);
            # my $number = sprintf "%.2f", shift @_;
            my $number = sprintf "%.2f", $_;
            # При каждой итерации цикла добавляется одна запятая
            1 while $number =~ s/^(-?\d+)(\d\d\d)/$1,$2/;
            # same
            # while ($number =~ s/^(-?\d+)(\d\d\d)/$1,$2/) {
            # 1;
            # }
            # Добавляем знак доллара в нужную позицию
            $number =~ s/^(-?)/$1\$/;
            $number, "\n";
        }

        my @data = (4.75, -5.6, 1.5, 2, 1234, 6.9456, 12345678.9, 29.95);
        my @formatted_data;
        foreach (@data) {
            push @formatted_data, &big_money($_);
        }
        print "@formatted_data";

        # альтернативное решение напоминает первый пример с grep:
        my @data_with_map = (4.75, -5.6, 1.5, 2, 1234, 6.9456, 12345678.9, 29.95);
        my @formatted_data_with_map = map {&big_money($_)} @data_with_map;
        print "@formatted_data_with_map";

        # Результат map и grep представляет собой список, что позволяет напрямую
        # передать его другой функции. В следующем примере отформатированные
        # «денежные величины» выводятся в виде списка с отступами под заголовком:
        print "The money numbers are:\n", map {sprintf("%25s\n", $_)} @formatted_data;

        # У map, как и у grep, существует упрощенная форма синтаксиса. Если в качестве
        # селектора используется простое выражение (вместо полноценного блока), поставьте
        # это выражение, за которым следует запятая, на место блока:
        print "Some powers of two are:\n", map "\t" . (2 ** $_) . "\n", 0 .. 15;
    }

}

{ # УПРОЩЕННАЯ ЗАПИСЬ КЛЮЧЕЙ ХЕШЕЙ

    # Эта сокращенная запись чаще всего применяется в самом распространенном
    # месте записи ключей хеша: в фигурных скобках ссылки на элемент хеша.
    # Например, вместо $score{"fred"}  можно написать просто $score{fred}.
    # Так  как многие ключи  хешей  достаточно  просты, отQ каз от кавычек
    # действительно удобен. Но помните: если содержимое фигурных скобок не
    # является тривиальным словом, Perl интерпретирует его как выражение.

    # Ключи хешей также часто встречаются при заполнении всего хеша по списку
    # пар «ключ-значение». Большая стрелка (=>) между ключом и значением в
    # этом случае особенно полезна, потому что она автоматически оформляет
    # ключ как строку (и снова только если ключ является тривиальным словом):
    #
    # # Хеш с результатами партий в боулинг
    my %score = (
        barney => 195,
        fred   => 205,
        dino   => 30,
    ); # тривиальное слово слева от большой стрелки '=>' неявно оформляется как строка
    # (хотя все, что находится справа, остается без изменений).

}

{
    # СРЕЗЫ

    # Perl может индексировать списки по аналогии с массивами. Результат называется срезом (slice) списка.
    # Значение mtime  является элементом с индексом 9  в списке, возвращаемом stat , и его можно получить
    # по соответствующему индексу:
    # my $mtime = (stat $some_file)[9];

    # Список элементов (в данном случае возвращаемое  значение  stat) должен быть заключен в круглые скобки.
    # Если попытаться записать команду в таком виде, она работать не будет:

    open my $some_file, "<", 'libr_names.txt';
    my $mtime = (stat 'libr_names.txt')[9];
    print "\$mtime => $mtime\n\n";
    my ($card_num, $count);
    my @names = qw{zero one two three four five six seven eight nine};
    my ($first, $last);


    foreach (<$some_file>) {
        chomp;
        # my @items = split /:/;

        ($card_num, $count) = (split /:/)[1, 5];
        ($first, $last) = (sort @names)[0, -1];

        printf("%s\n\$card_num = %s\n\$count = %s\n\n", $_, $card_num, $count);
    }

    printf("%s\n\$first = %s\n\$last = %s\n\n", "@names", $first, $last);
    my @numbers = ( @names )[ 9, 0, 2, 1, 0 ];
    print "Bedrock @numbers\n\n";  # Bedrock nine zero two one zero

}


{ # СРЕЗЫ МАССИВОВ
    # Предыдущий пример можно сделать еще проще. При создании срезов на базе массивов (вместо списков)
    # круглые скобки необязательны. Следовательно, срез может выглядеть так:
    my @names = qw{zero one two three four five six seven eight nine};
    my @numbers = @names[ 9, 0, 2, 1, 0 ];
    print "Bedrock @numbers\n";  # Bedrock nine zero two one zero

    # Ранее мы говорили, что символ @ в @names означает «все  элементы». В Perl символ $  означает
    # отдельное значение, а символ @ – список значений.
    # Срез всегда является списком, и в синтаксисе среза массивов на это обстоятельство указывает знак @.
    # Когда  вы встречаете в программе Perl конструкцию вида @names[ ... ], сделайте то, что делает Perl,
    # и обратите внимание на знак @ в начале и на квадратные скобки в конце. Квадратные скобки означают,
    # что происходит индексирование массива, а знак @ – что вы получаете список элементов вместо одного
    # значения (на которое бы указывал знак $).
    # Знак перед ссылкой на переменную ($  или @) определяет контекст индексного выражения. С префиксом $
    # выражение вычисляется в скалярном контексте. Но если в начале стоит знак @, индексное выражение
    # вычисляется в списочном контексте для получения списка индексов. Таким образом, @names[ 2, 5 ]
    # означает то же самое, что ($names[2], $names[5]). Если вам нужен список значений, используйте
    # запись со срезом массива. Везде, где требуется использовать список, вы можете использовать более
    # простой срез массива.

    # Однако срезы также могут использоваться в одном месте, где простые списки использоваться не могут, –
    # срезы могут интерполироваться прямо в строку:
    my @namesS = qw{ zero one two three four five six seven eight nine };
    print "\nBedrockK @namesS[ 9, 0, 2, 1, 0 ]\n\n";
    print "@namesS[ 9, 0, 2, 1, 0 ]\n\n";
    print "@namesS\n\n";

    # Вернемся к примеру с библиотекой. Допустим, программа обновляет адрес и телефон одного из читателей,
    # потому что он толь-ко что переехал в новый дом. Если информация о нем поставляется в виде списка @items,
    # обновление двух элементов массива может выполняться примерно так:
    my $new_home_phone = "555-6099";
    my $new_address = "99380 Red Rock West";

    my @items;

    open my $some_file, "+<", 'libr_names.txt' or die "Can't open file : $!";
    foreach (<$some_file>) {

        push @items, split /:/;
        if(/fred/) {
            @items[2, 3] = ($new_address, $new_home_phone);
        }

    }

    print "@items\n"; # fred flintstone 2168 301 Cobblestone Way 555-1212 555-2121 3
                      # barney rubble 709918 3128 Granite Blvd 555-3333 555-3438 0
                        # NEW @items[2, 3] = ($new_address, $new_home_phone);
                      # fred flintstone 2168 99380 Red Rock West 555-6099 555-2121 3
                      # barney rubble 709918 3128 Granite Blvd 555-3333 555-3438 0
}

{ # СРЕЗЫ ХЕШЕЙ
        my %score = (
            barney => 195,
            fred   => 205,
            dino   => 30,
        ); # тривиальное слово слева от большой стрелки '=>' неявно оформляется как строка
    #     # (хотя все, что находится справа, остается без изменений).

    # Мы можем извлечь эти результаты как в список элементов хеша, так и в срез.
    # Эти два приема эквивалентны (хотя второй работает эффективнее и занимает меньше места):
    my @three_scores = ($score{"barney"}, $score{"fred"}, $score{"dino"});
    my @three_scoresS = @score{ qw/ barney fred dino/ };

    print "\@three_scores: @three_scores\n";
    print "\@three_scoresS:  @three_scoresS\n";

    # Когда вы  встречаете в программе Perl конструкцию вида @score{ ... }, сделайте то,
    # что делает Perl, и обратите внимание на знак @  в начале и фигурные скобки в конце.
    # Фигурные скобки означают, что происходит выборка из хеша, а знак @ – что вы получаете
    # список элементов вместо одного (на которое бы указывал знак $).

    # Как вы видели со срезами массивов, срезы хешей могут использоваться вместо соответствующего
    # списка элементов хеша во всех синтаксических конструкциях Perl. Таким образом, мы можем
    # задать результаты некоторых партий в хеше (без изменения других элементов хеQ ша) следующим
    # образом:
    my @players = qw/ barney fred dino /;
    my @bowling_scores = (190, 200, 20);
    @score{ @players } = @bowling_scores;

    print "@players :  @score{ @players }\n\n";
    foreach my $player (@players) {
        print "$player => $score{ $player }\n";
    }
    print "\n\n";

    # Срезы хешей тоже могут интерполироваться. В следующем примере выводятся результаты для
    # выбранной нами тройки игроков:
    print "Tonight's players were: @players\n";
    print "Their scores were: @score{@players}\n";

  }




