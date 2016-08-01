#!/usr/bin/perl

$ARGV[0] =~ /(.*)\/(.*).dat/;

print $2;

open IN, "< freq_5.csv";
@words = <IN>;
close IN;

map { chomp; $wordhash{$_}=0 } @words;

while (<>) {
  chomp;
  if (exists($wordhash{$_})) { $wordhash{$_}++; }
}

foreach $k (sort {$b cmp $a} keys %wordhash) {
  print ",$wordhash{$k}";
}

print "\n";
