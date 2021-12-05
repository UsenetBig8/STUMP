#!/usr/bin/env perl
#
# Copyright 1999-2000 Igor Chudov
#
# This file is part of STUMP.
# 
# STUMP is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
# 
# STUMP is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with STUMP.  If not, see <https://www.gnu.org/licenses/>.

$MNG_ROOT=$ENV{'MNG_ROOT'} 
	|| die "Newsgroup Root Directory (\$MNG_ROOT) Not Defined!";


sub start {

  my $robomod_pl = "$MNG_ROOT/bin/robomod.pl";
  require "$robomod_pl" if( -f $robomod_pl && -r $robomod_pl );

  my $script = shift @ARGV
	|| die "Syntax: $0 script-name [parameters]\n";
  my $script_file = "$MNG_ROOT/bin/$script";
  if( -f $script_file ) {
    require $script_file;
  } else {
    die "ERROR: $script_file not found and could not be executed.";
  }
}

start;
