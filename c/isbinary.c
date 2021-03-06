/*
  isbinary.c

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

  This program reads an article from standard input and checks if it 
  is a uuencoded binary. If it is, exits with exit code 0, otherwise 
  retcode = 1.
*/

#include <stdio.h>

#define MAX_BUF 16384
#define MAX_BINARY_LINES 10

char buf[MAX_BUF];

int main( int argc, char *argv[] )
{
  int nBinLines = 0, maxNBinLines = 0;

  /* skip header */
  while( fgets( buf, MAX_BUF, stdin ) ) 
    if( strlen( buf ) <= 1 ) break;

  while( fgets( buf, MAX_BUF, stdin ) ) {
    if( strlen( buf ) > 45 /* buf long enough */
        && (!(strchr( buf, ' ' ) || strchr( buf, '\t' )) /* no spaces */
           || (buf[0] == 'M') )  /* some uuencoded stuff begins with 'M' */
      ) { /* likely a uuencoded line */
      nBinLines++;
      maxNBinLines = (nBinLines > maxNBinLines) ? nBinLines : maxNBinLines;
    } else nBinLines = 0;
  }

  /* more than 10 consecutive 45 char lines with no blank - likely binary */
  return( maxNBinLines < MAX_BINARY_LINES );
}
