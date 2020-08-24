/* cuthead.c

   Copyright 1999-2000 Igor Chudov

   This file is part of STUMP.

   STUMP is free software: you can redistribute it and/or modify it
   under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   STUMP is distributed in the hope that it will be useful, but
   WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
   General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with STUMP.  If not, see <https://www.gnu.org/licenses/>.

   This program simply ignires first line, or if argc == 2, first
   lines specified by argv[1].
*/

#include <stdio.h>

#define MAX_BUF 4096

const char * Usage = "Usage: %s [number-of-lines]\n";

char buf[MAX_BUF];

int main( int argc, char **argv )
{
  int first;

  if( argc == 1 ) first = 1;
  else if( argc == 2 ) {
    if( (first = atoi( argv[1] ) ) <= 0 ) {
      fprintf( stderr, Usage, argv[0] );
      exit( 1 );
    }
  } else {
    fprintf( stderr, Usage, argv[0] );
    exit( 1 );
  }

  while( fgets( buf, sizeof( buf ), stdin ) ) {
    if( first )
      first--;
    else
      fputs( buf, stdout );
  }
}
