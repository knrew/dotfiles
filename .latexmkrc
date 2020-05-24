#!/bin/perl
$latex         = 'platex -synctex=1 -halt-on-error -shell-escape %O %S';
#$latex         = 'platex -kanji=euc-jp -synctex=1 -halt-on-error -shell-escape %O %S'; #euc-jp
$xelatex       = 'xelatex -synctex=1 %O %S';
$bibtex        = 'pbibtex %O %B';
$dvipdf        = 'dvipdfmx %O %S';
$pdf_mode      = 3; # use dvipdf
$pdf_previewer = "start zathua";
$pdf_update_method = 0;
$ENV{TEXINPUTS} = "$ENV{PWD}:";

$aux_dir          = "build/";
$out_dir          = "build/";
