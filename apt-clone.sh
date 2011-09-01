#!/bin/bash

#################################################################################
# apt-clone, a simple way to duplicate package selection across multiple hosts. #
#################################################################################
#
# Copyright (C) 2005-2011 Chris Olstrom
#

echo Collecting data about installed packages...
dpkg --get-selections | perl -pe 's/[\t]*install$//' > .clone

echo Building parser script...
echo \#!/usr/bin/perl				> clone.pl
echo open \(list, \'.clone\'\)\;		>> clone.pl
echo 	my @packages = \<list\>\;		>> clone.pl
echo close \(list\)\;				>> clone.pl
echo print \"#!/bin/bash\\n\"\;			>> clone.pl
echo print \'apt-get install\'\;		>> clone.pl
echo foreach my \$package \( @packages \) {	>> clone.pl
echo 	chomp \( \$package \)\;			>> clone.pl
echo 	print \" \" . \$package\;		>> clone.pl
echo }						>> clone.pl

echo Parsing package lists, and generating clone-script...
perl clone.pl > output.sh

echo Cleaning up...
rm -f .clone
rm -f clone.pl

echo Done!
