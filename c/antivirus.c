/* antivirus.c - 

   Copyright 1996 Igor Chudov

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

   This program replaces all "dangerous" characters in the incoming file
   to '_' character. Dangerous characters are all characters less than 32 
   (space) and not equal to \n, \r, \t, \f and ^H.

   It also notices lines > 1024 characters and splits them, adding space
   character in front of the split line.

   In ``fascist'' mode (when called with argument -fascist), it is much
   more restrictive: it permits only newlines, space, TAB, lowercase and
   uppercase letters, and digits. Everything else is replaced by '_'
   character.  Fascist mode should be used to filter user input that is
   to be used in shell scripts. It may prevent users from being able to
   fool poorly written shell scripts that accept user commands into
   executing arbitrary programs. Since, unfortunately, it is likely that
   some of the scripts would be prone to such attacks, using this
   program is highly recommended BEFORE doing anything with user input.

   This program should be used to preprocess all incoming mail before 
   feeding to mail processing scripts. It in fact may prove useful 
   against viruses exploiting weaknesses of C programs that overflow
   buffers, etc.
*/

#include <stdio.h>

#define MAX_CHAR 256 /* max unsigned char */
#define MAX_LEN 1024 /* max allowed line size */
#define NEWLINE "\n" /* newline for Unix, for DOS I think "\r\n" */

unsigned char charTable[ MAX_CHAR ];

#define SET_GOOD_INTERVAL( l, u ) \
  for( i = l; i <= u; ) charTable[i++] = 1;

void initCharTable( int fascist )
{
  int i;

  /* bad characters can only be used for viruses */
  for( i=0; i < MAX_CHAR; i++ ) charTable[i] = 0;

  charTable['\n'] = 1;
  charTable[' ']  = 1;
  charTable['\r'] = 1;
  charTable['\t'] = 1;
  charTable['\f'] = 1;

  if( fascist ) { /* fascist mode - used for shells */
    SET_GOOD_INTERVAL( 'a', 'z' );
    SET_GOOD_INTERVAL( 'A', 'Z' );
    SET_GOOD_INTERVAL( '0', '9' );
    charTable['-'] = 1;
    charTable['+'] = 1;
    charTable['.'] = 1;
    charTable[','] = 1;
  } else { /* normal mode - used to filter users' mail. */

    /* Good characters, incl Cyrillic */
    SET_GOOD_INTERVAL( ' ', MAX_CHAR );
  
    charTable[8] = 1;        /* 8 is Ctrl-H, BackSpace */
  }
}

int main( int argc, char **argv )
{
  int ch, len = 0;
  int fascist = 0;

  if( argc == 2 ) {
    if( strcmp( argv[1], "-fascist" ) ) {
      fprintf( stderr, "Usage: %s [-fascist]\n", argv[0] );
      return( 1 );
    }
    fascist = 1;
  } else if( argc != 1 ) {
    fprintf( stderr, "Usage: %s [-fascist]\n", argv[0] );
    return( 1 );
  }

  initCharTable( fascist );

  while( (ch = getchar()) != EOF )
    {
      if( !charTable[ch] ) ch = '_';
      if( ch == '\n' ) len = 0; else len++;
      if( len > MAX_LEN ) {
        printf( NEWLINE " " );
        len = 1;                 /* because I put " " */
      }
      putchar( ch );
    }

  return 0;
}
