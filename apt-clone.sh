#!/bin/bash

#################################################################################
# apt-clone, a simple way to duplicate package selection across multiple hosts. #
#################################################################################
#
# Copyright (C) 2005 Chris Olstrom
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
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
