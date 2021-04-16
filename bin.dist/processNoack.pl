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
#
# Processes the "No Ack" request
#

use Email::Address 1.910 # Previous versions are vulnerable to DoS attacks

# get the directory where robomod is residing
$MNG_ROOT = $ENV{'MNG_ROOT'} || die "Root dir for moderation not specified";

# common library
require "$MNG_ROOT/bin/robomod.pl";

$NoAckFile = "$MNG_ROOT/data/noack.list";

$Argv = join( ' ', @ARGV );

while( <STDIN> ) {
  $From = $_ if( /^From: / );

  chop;
  last if( /^$/ );
}

my @addresses = Email::Address->parse($From);
if (@addresses) {
  $From = $addresses[0]->address;
} else {
  $From =~ s/^From: //;
  chomp $From;
  print STDERR "From line `$From' is incorrect\n";
  exit 0;
}

if( !&nameIsInList( $From, "noack.list" ) ) { # need to preapprove
  print STDERR "Adding $From to the noack list...\n";
  open( NOACK, ">>$NoAckFile" );
    print NOACK "$From\n";
  close( NOACK );
} else {
  print STDERR "$From already is in noack list\n";
}
