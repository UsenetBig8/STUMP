#!/bin/sh
#
# Copyright 1999-2000 Igor Chudov
# Copyright 2020 Tristan Miller
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
# posts a nice report
#

TODAY="$(date)"
DATE6="$(date +%y%m%d)"

LOGFILE="$HOME/Mail/from"
LOGFILE_ARCHIVED="$MNG_ROOT/archive/old/from.$DATE6"

Report() {
  echo Subject: "$NEWSGROUP" report for "$TODAY"
  echo Newsgroups: "$NEWSGROUP"
  echo To: "$SUBMIT"
  echo From: "$ADMIN"
  echo Reply-To: "$ADMIN"
  echo Organization: CrYpToRoBoMoDeRaToR CaBaL
  echo ""

(
  echo Subject: "$NEWSGROUP" report for "$TODAY"
  echo Newsgroups: "$NEWSGROUP"
  echo Date: "$TODAY"
  echo ""

cat << _EOB_
This is an automated report about activity of our newsgroup
$NEWSGROUP. It covers period between the 
previous report and the current one, ending 
on $TODAY.

Note that we do not report the number of articles cancelled
after they got approved, because the cancellations are done
manually. Typically messages get cancelled by requests of
posters themselves.

Lastly, the statistics below are skewed towards higher numbers because
there are always some test messages from moderators themselves who
approve and reject them to make sure that our robomoderator functions
properly.

_EOB_

  stump-report.pl "$LOGFILE"
) | stump-pgp -staf -u "$PMUSER_APPROVAL" -z "$PMPASSWORD" 2>/dev/null
}

Report | sendmail -t

mv "$LOGFILE" "$LOGFILE_ARCHIVED"
gzip -9 "$LOGFILE_ARCHIVED" &
