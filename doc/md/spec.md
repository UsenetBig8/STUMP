Soc.Culture.Russian.Moderated Robomoderator Project ( 6-Mar-1996)

Soc.Culture.Russian.Moderated Robomoderator Project
===================================================

This document describes in details how the robomoderator for a new group
`soc.culture.russian.moderated` works.

Contents
========

1.  [Requirements to the Robomoderator](#requirements)
2.  [Processing of Incoming Messages](#incoming)
3.  [Signing Approved Messages](#signing)
4.  [Exchange with Human Moderators](#humans)
5.  [Detecting Forgeries](#monitoring)
6.  [To Do List](#todo)

![](scheme1.gif) []{#requirements}

1. Requirements to the Robomoderator
====================================

Requirements to the moderation process originate from two sources: the
proposed Charter, and from our past experiences with forgeries,
mailbombings, and other no less interesting things. We tried to take
into account habits and weaknesses of the future users and posters.

1.1. Requirements of the Charter
--------------------------------

### 1.1.1. Enforcement of Style

All articles longer than 25 lines should not contain more than 2/3 of
quoted text. All articles longer than 25 lines cannot have more than 75
characters per line on average.

### 1.1.2. Posting Policy

Robomoderator should be able to support so called \"white list\" and
\"black list\" of posters. All messages submitted by members of the
white list get approved and posted immediately (see [Signing Approved
Messages).](#signing) However, presense of certain text patterns in the
body of messages from posters from \"white list\" may trigger sending
the article to human moderators for approval.

All messages submitted by members of the \"black list\" are rejected.
However, no person shall be in the black list for period exceeding one
month.

Messages from all oter persons get forwarded to human moderators for
approval.

### 1.1.3. Authentification and Protection from Forgeries

Robomoderator must be able to decide whether a certain poster is
required to submit PGP signed articles, and if the answer is yes, reject
all messages that are not signed properly. Robomoderator should be able
to work in \"protected\" mode, when all posters from the white list are
required to sign their submissions with PGP, and provide robomoderator
with their public PGP keys.

### 1.1.4. Openness of the Moderation Process

All users whose messages have been rejected must receive a clear
explanation of reasons for rejection. Moderators must establish an
address for appeals that will reach all moderators. All rejected
submissions must be placed on a designated WWW page for public scrutiny.

1.1.5. Nature of Users
----------------------

A big part of our users has little experience with computers and have
not been exposed to the issues of computer security. They may have
little experience in using encryption products such as PGP. At the same
time, they may be valuable contributors to the newsgroup and should not
be discouraged from posting by excessive requirements to their methods
of posting.

Many of the users (frequently users of freenets) simply have no way of
installing and using PGP. Many companies discourage their employees from
using PGP at work.

1.2. Security
-------------

At the same time, many other posters and participants find pleasure in
hooliganism, forging other people\'s posts, mailbombing, attempts to
hack computers of their flamewar enemies and so on. We shall, therefore,
reasonably expect such attempts to continue. We shall take adequate
steps in protecting posters and robomoderation process from malicious
attempts to disrupt process of moderation and forge messages under other
people\'s names.

We shall make an attempt to prevent as many attacks on the moderation
protocol as possible.

### 1.2.1. Anonymous and Pseudonymous Posting

Unfortunately, there have been cases when some mentally unstable users
harassed other users, for example by faxing silly complaints to human
resources departments of their employers, posting phone number of their
bosses and by other equally creative methods.

This alone justifies a need for allowing users to post pseudonymously.
These users may use anonymous remailers to deliver their messages to the
submission address. At the same time, they may want to have a permanent
identity, that is, correct belief of others that a series of posts has
been written by one person or a group of persons. As well, we may
request these users to PGP-sign their submissions.

### 1.2.2. Protection from Forgeries

We shall protect out moderated newsgroup against forgeries, that is,
unapproved postings with fake \"Approved: \" field. For this task,
robomoderator shall sign all approved messages with its private key, and
all other users must be able to verify these signatures using the public
key of the robomoderator.

All articles not bearing a valid signature by robomoderator must be
destroyed.

[]{#incoming}

2. Processing of Incoming Messages
==================================

2.1. Mail Processing
--------------------

Note that the robomoderator communicates with the outside world through
email. Submissions, approval/rejection messages and complaints arrive by
mail.

All incoming mail, including submissions, appeals, messages approved and
rejected by human moderators, requests for public key for approving
articles, and so on, are redirected to **procmail** utility. Procmail
script filters out all mail bombs. After that, messages get processed
according to their destination address.

Types of incoming messages include:

1.  Submissions intended for posting
2.  Approval messages by human moderators
3.  Rejection messages by human moderators
4.  Appeals to the moderator board
5.  Requests for public key used for approvals

Each of the types has its own mail alias.

2.2. Processing of Incoming Submissions.
----------------------------------------

Incoming submissions may be encrypted with robomod\'s public key. We
urge our users to use this encryption.

### 2.2.1. Checking PGP Signatures

If an incoming message has a PGP signature, it is verified against
database of known PGP Public keys. If the verification fails by any
reason, the message is rejected and a rejection note is sent to the
sender.

Note that users\' message may contain so called header block inside the
signed portion of their submissions. This may protect users from replay
attacks when their messages are intercepted and then crossposted to
zillions of newsgroup with some offensive subject. The following header
fields in the header block will override header fields supplied in the
envelope of incoming emails:

-   **`Reply-To:`**
-   **`Subject:`**
-   **`Newsgroups:`**

If the signature matches, the address header fields are rewritten in the
following way:

-   Address set in the **`From:`** field is stored in **`X-Origin`**
    field.
-   **`From:`** field is set to the main user id in the PGP key
-   **`Reply-To:`** field is set to \[possibly overriden in the header
    block\] **`Reply-To:`**. If it is not present, it is set to the
    address in the **`From:`** field.

### 2.2.2. Rules Requiring Presence of PGP signatures

The following conditions cause rejection of unsigned messages:

1.  The poster is in the database of people required to sign their
    submissions;
2.  The poster is in the \"white list\" (that normally causes automatic
    approval) and a flag requiring all posters from white list to sign
    their messages is set to YES.

### 2.2.3. Removal of PGP Signatures

If user\'s submission is signed (and signature is valid), but contains
no header block, PGP signature is removed. A standard header field
X-Auth-Info: valid PGP signature from \<username\> was detected and
removed If header block is present, PGP signature is not removed. We do
it for the purpose of protecting our users from replay attacks outlined
above.

2.3. Approval messages by human moderators
------------------------------------------

For details on exchange between robomod and human moderators, see
separate chapter [Exchange with Human Moderators](#humans).

Messages coming to approved address are decrypted with a special traffic
key. Their integrity is verified, in particular robomod checks the
following:

1.  That moderator attached word **`APPROVE` to the bottom of the
    approval message.**

2.  That moderator\'s address attached to the article matches
    moderator\'s address specified in the article sent for moderation.
    It helps us prevent attacks when someone wanting to get his/her
    message approved intercepts it on the way to human moderators and
    sends it to every human moderator, in the hope that it will boost
    the chances of message to be posted.

    As per our scheme, only the original human moderator addressee can
    produce a valid approval.

3.  That the article bears a valid signature from our Traffic key. This
    key is different from the key used for approvals. Private part of
    the traffic key is known only to the robomoderator, and public part
    is known to human moderators only.

    This ensures that moderators cannot approve articles that did not
    come through the initial submission address.

After that, the approved message gets signed with our approval key and
gets posted. See [Signing Approved Messages](#signing).

2.4. Rejection Messages by Human Moderators
-------------------------------------------

Rejection messages by human moderators are verified in the same fashion
as approvals, with the only exception that it required word **`REJECT`
instead of **`APPROVE`. Rejection messages also carry a code of the
reason of rejection.****

Based on this code, a rejection message and a full copy of the original
article is sent to the author of the submission.

2.5. Appeals to the Moderator Board
-----------------------------------

These appeals are simply distributed to all moderators.

2.6. Requests for public key used for approvals
-----------------------------------------------

A text copy of the approval key is sent back as a reply. []{##signing}

Signing Approved Messages
=========================

All approved messages are signed using PMApp by Greg Rose from Sterling
Software, with the approval\'s private PGP key. Other users will have
the public key and will be able to verify approvals using Greg Rose\'s
**pmcheck** script. []{##humans}

3. Exchange with Human Moderators
=================================

3.1. Internal Traffic Key
-------------------------

Human moderators will exercise their best judgment in deciding whether
to approve or reject submissions. Since, at least theoretically, daily
number of articles received by human moderators may be high, it is very
desirable to avoid having human moderators sign each of their decisions.
If we required human moderators to sign every decision, they would
likely store their passphrases in an insecure way.

Still, in our system there must be some secret that should be known in
order to be able successfully approve a message. Without this secret,
anyone could send fake \"approved\" messages to the robomoderator.

To solve this problem, we introduce another PGP key, **Robomod\'s
Internal Traffic Key**. Its private component will be known only to the
robomoderator. Its public component will be known only to human
moderators. To ensure security, human moderators encrypt all approval
and rejection messages sent to robomoderator with that key.

Note that our system uses another PGP key, which is called **Approval
Key** and is used for exchange with the outside world, in particular
for:

-   Signing approved articles before posting;
-   Signing rejection messages;
-   Verification of approval by PGP Moose.

4.2. Protocol of Exchange between Robomod and Human Moderators
--------------------------------------------------------------

### 4.2.1. Sending Submissions to Human Moderators

Before sending out a message to a human moderator, robomod takes the
following steps:

-   It adds a line

             SENT_TO: <moderator_address>

    to the bottom of the article.

-   It signs the article (including headers) using the Internal Traffic
    Key. Note that this signature is not valid for final approval of
    postings, because it uses a different PGP key.

-   It prepends each line of the whole signed article by string
    **`"X_"`**.

-   It creates headers for email delivery to human moderators and adds a
    special header

             X-Moderate-For: <newsgroup name>

    so that human moderators can filter the messages for moderation into
    a special mailbox.

### 4.2.2. Processing by Human Moderators

Human moderators receive submissions by email. They review them and
decide whether to approve or reject them. If they approve a message,
they pipe it through a shell script called \"approve\". This script
simply adds a line

          APPROVE <moderator>

to the pre-signed article, encrypts it as a whole with robomod\'s
Internal Traffic Key, and sends to the special email address for
approved postings.

Similar thing happens when moderators reject postings. They pipe the
article to a special script called \'reject\'. It asks for a reson for
rejection, and then appends a line

           REJECT <moderator> <reason>

and then encrypts the whole message with robomod\'s Internal Traffic
Key. The encrypted message is sent to a special address for rejections.
[]{#monitoring}

5. Detecting Forgeries
======================

PGP Moose scripts will run on one or several machines to monitor the
newsgroup. They will be reporting all unauthorized articles, and
possibly canceling them. All messages coming into the robomoderator and
failing verification will be reported to the maintainer of the
robomoderator.

At least in the beginning, automatic cancelling will be turned off.
Instead, all articles failing verification will be reported to the
robomod support person.

[]{#todo}

6. To Do List
=============

-   Implement dup checking with Vulis\'s message digest prog. Maybe
    I\'ll do it after getting 32 meg of memory and installing Postgres.
    Maybe postgres is not such a good idea if i want robomod to be
    portable. need 2 think more.
-   Proofread PMApp for security problems.
-   Implement checks for excessive quoting and too long lines (PMApp
    also wraps lines! That\'s silly).

------------------------------------------------------------------------

[![Creative Commons
License](https://i.creativecommons.org/l/by/4.0/88x31.png)](http://creativecommons.org/licenses/by/4.0/)\
Copyright © 1996 Igor Chudov. This work is licensed under a [Creative
Commons Attribution 4.0 International
License](http://creativecommons.org/licenses/by/4.0/).
