#!/usr/bin/perl

$level = 0;

while (<>) {
  if ($_ =~ /div class="post"/) { $level = 1; print $_; next; }
  if ($level > 0) {
    if ($_ =~ /div class="right"/) { next; }
    print "$_\n";
    if ($_ =~ /\<\/div/) { $level--; }
    if ($_ =~ /\<div/) { $level++; }
  }
}
