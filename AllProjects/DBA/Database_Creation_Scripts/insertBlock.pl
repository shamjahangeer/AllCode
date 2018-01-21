#!/usr/bin/perl

$block;
$BLOCK_FILE=@ARGV[0];
$MAIN_FILE=@ARGV[1];
$RESULT_FILE=@ARGV[2];
open(BLOCK, "< $BLOCK_FILE") or die "Cannot open block file: $!\n";
read BLOCK, $block, 10000;
close(BLOCK);

open(MAIN, "< $MAIN_FILE") or die "Cannot open main file: !$\n";
open(OUT, "> $RESULT_FILE") or die "Cannot write to output file: !$\n";

while (<MAIN>) {
 if (/#TAG#/) { print OUT $block; }
 else { print OUT; }
}

close(OUT);
close(MAIN);

