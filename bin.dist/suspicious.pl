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
# this script processes "suspicious" messages. It does basically two things:
#
# 1. Sends an acknowledgment to the author, if necessary (ie if the author did
#    not turn ack mode off), and
# 2. Prepares, signs, and sends the message to a randomly chosen human 
#    moderator for review.
#

$MNG_ROOT = $ENV{'MNG_ROOT'};
$Prefix   = $ENV{'BOT_SUBJECT_PREFIX'};
$tempFile = "$ENV{'TMP'}/signed.$$";

# name of moderator to test
$TestModerator = "eugenez\@mit.edu";

$isTesting = 0; # No testing by default
$TestFlag="test-test";

$needAck = $ARGV[0]; shift @ARGV;

$message = join( " ", @ARGV );

print STDERR "Needack = $needAck\n";


######################################################################
# Getting data
sub readMessage {
  $IsBody = 0;
  
  while( <STDIN> ) {

    $Body .= $_;

    $isKOI8 = $isKOI8 || $_ =~ /[\x80-\xFF]/;
 
    chop;
  
    if( /^$/ ) {
      $IsBody = 1;
    }
  
    if( !$IsBody ) {
  
      if( /^Newsgroups: / ) {
        $Newsgroups = $_;
      } elsif( /^Subject: / ) {
        $Subject = substr( $_, 0, 50 );

        if( $Subject =~ /$TestFlag/i ) { # special subject
          $isTesting = 'y';
        }

      } elsif( /^From: / ) {
        $From = $_;
	if ($From =~ m/([\w-\.]+)@([\w-\.]*)[^\w-\.]/){
	    $From = "From: $1\@$2";}
      } elsif( /^Path: / ) {
        $Path = $_;
      } elsif( /^Keywords: / ) {
        $Keywords = $_;
      } elsif( /^Summary: / ) {
        $Summary = $_;
      } elsif( /^Message-ID: / ) {
        $Message_ID = $_;
      }
  
    }
  }
}

$MNG_ROOT = "$ENV{'MNG_ROOT'}" || die "Root dir for moderation not specified";

&readMessage;

#$Body =~ s/From /_From /g;


if( $isTesting eq 'y' ) {
  $moderator = $From; # $TestModerator;
  $moderator =~ s/^From: //i;

  } else { # get random moderator
  open( MODERATORS, "$MNG_ROOT/etc/moderators" ) 
    || die "can't open moderators file";

  while( <MODERATORS> ) {
    next if( /^#/ );
    next if( /^\s*$/ );
    ($name, $priority, $flags) = split;
  
    if( $priority != 0 && ! ($isKOI8 && $flags =~ /nokoi/i)) { 
    # priority 0 means "on vacation"
      push( @moderators, $name );
    }
  }

  close( MODERATORS );
  srand;

  $randNum = rand 100 + time;

  $moderator = $moderators[ $randNum % ($#moderators + 1) ];
}


$modNick = $moderator;

$modNick =~ s/@.*//;
$modNick =~ s/-.*//;

$date = `date`; chop $date;

print STDERR "Activity: $date Forwarding $Message_ID, $Subject from $From ".
             "to $moderator for approval\n";

$MessageNumber = time . $$;

print STDERR "Opening $MNG_ROOT/tmp/messages/$MessageNumber\n";

open( MESSAGE, "> $MNG_ROOT/tmp/messages/$MessageNumber" );
print MESSAGE $Body;
close( MESSAGE );

$Subject = "Subject: try again" if( !$Subject );

open( COMMAND, "| sendmail $moderator > /dev/null"  );

print COMMAND "From: $ENV{'DECISION_ADDRESS'}
$Subject ::$Prefix/$MessageNumber
To: $moderator
X-Moderate-For: $ENV{'NEWSGROUP'}
Organization: Robots Are Us

$message

This is an automated message sent to you as the moderator of
$ENV{'NEWSGROUP'}. Simply reply to this message,
DO NOT quote the message body in your reply, and state your decision ON
THE FIRST LINE, choosing LITERALLY from ONE of the following options
(you can even cut and paste):

approve
preapprove
";

open( REASONS, "$MNG_ROOT/etc/rejection-reasons.lst" );
while( <REASONS> ) {
  ($reason, $explanation) = split( /::/, $_ );
  print COMMAND "reject $reason\n";
}
close( REASONS );

print COMMAND "

You can also specify a comment, by typing word comment at the
beginning of a line _after_ approve, preapprove, or reject, and
then your comment on one or several lines. Do NOT put your comment
before approve, preapprove, or reject.

Message follows:
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
";

print COMMAND $Body;
close( COMMAND );

if( $needAck eq "yes" ) {
  open( ACK, "| modack.received" );
  print ACK $Body;
  close( ACK );
}

1;
