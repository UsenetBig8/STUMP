#
# Processes the "No Ack" request
#

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

$From =~ s/^From: //;
if( $From =~ m/([\w-\.]*)\@([\w-\.]+)/ ) {
  $From = "$1\@$2";
} else {
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
