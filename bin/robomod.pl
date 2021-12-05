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
# Collection of common functions
#

$MNG_ROOT = $ENV{'MNG_ROOT'} || die "Root dir for moderation not specified";

###################################################################### checkAck
# checks if poster needs ack
sub nameIsInList {
  local( $listName ) = pop( @_ );
  local( $address ) = pop( @_ );

  local( $item );

  $Result = 0;

  open( LIST, "$MNG_ROOT/data/$listName" );

  while( $item = <LIST> ) {

    chop $item;

    next if $item =~ /^ *$/;

    if( eval { $address =~ /$item/i; } || "\L$address" eq "\L$item" ) {
      $Result = $item;
    }
  }

  close( LIST );

  return $Result;
}

sub logAction {
  my $msg = pop( @_ );

  print STDERR $msg . "\n";
}


######################################################################
# Setting variables

if( defined( $ENV{'STUMP_PARANOID_PGP'} ) ) {
  $paranoid_pgp = $ENV{'STUMP_PARANOID_PGP'}  eq "YES";
} else {
   $paranoid_pgp = 0;
}

1;
