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
# This script processes the logfile given as it first command argument, 
# and prints a nice report about approved, rejected, etc postings, to
# stdout.
#
# is called from report.sh
#

# get the directory where robomod is residing
$MNG_ROOT = $ENV{'MNG_ROOT'} || die "Root dir for moderation not specified";

# common library
require "$MNG_ROOT/bin/robomod.pl";

$logFile = $ARGV[0]   || die "A log file name must be specified";
open( LOG, $logFile ) || die "Can't open logfile $logFile for reading";

$approvedCount = 0;
$autoCount     = 0;
$rejectedCount = 0;
$preApprovedCount = 0;

while( <LOG> ) {
  $approvedCount++    if( /processApproved/i );
  $autoCount++        if( /PREAPPROVED/ );
  $rejectedCount++    if( /processRejected/i );
#  $approvedCount++    if( /processPreapproved/i );
  $preApprovedCount++ if( /processPreapproved/i );
}

print "

Approved:       $approvedCount 	messages (of them, $autoCount automatically)
Rejected:       $rejectedCount 	messages
Preapproved:    $preApprovedCount	new posters
";
