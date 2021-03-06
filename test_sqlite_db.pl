#!/usr/bin/perl -w

use 5.10.0;
# use CGI;
# use POSIX;
# use Encode qw(decode_utf8);
# use Encode qw(decode encode);
#= BEGIN{@ARGV=map Encode::decode(#\$_,1),@ARGV;}
# BEGIN{@ARGV = map decode_utf8(#\$_, 1), @ARGV;}
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
use Bundle::Camelcade; # for Intellij IDEA


#!/usr/bin/perl
use DBI;
my $db = DBI->connect("dbi:SQLite:dbname=sqlite.db","",""); # Подключаемся к базе данных. Если файла users.db не
# существует, то он будет создан автоматически

$db->do("create table users (user_name text);"); # Создаем новую таблицу в базе данных

$db->disconnect;




