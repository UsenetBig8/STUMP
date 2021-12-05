# Instructions on Setup and Use of the STUMP Robomoderator

Attention! Before reading instructions, please read the specification and description of how the robomoderator works.

## Contents

-   Where to get HELP
-   Understanding Moderation
    -   What does 'moderated' mean?
    -   Why do Usenet moderated newsgroups exist ?
    -   Role of a moderator
-   Initial Setup
    -   Setting up a separate Linux account. [SYSADMIN]
    -   Setting up sendmail aliases. [SYSADMIN]
    -   Setting up procmail
    -   Setting up GnuPG
    -   Setting up Perl
-   Starting With Robomoderator
    -   Unpacking Source
    -   Creating **../etc** directory
    -   Setting .profile for robomod support
    -   Editing Data Files in **../data**
    -   Creating List for reasons of Rejection and Rejection Messages
    -   Creating GnuPG keys.
    -   Compiling C programs in **../c** directory
-   Testing Your Setup
    -   Choosing a victim group
    -   Things to Test
    -   Testing individual moderators
-   Maintenance of the Robomod
    -   Maintaining a preapproved list
    -   Maintaining a blacklist
    -   Maintaining list of people not needing acknowledgment
    -   "Vacationing" of moderators, maintenance of private
        mailing list for moderators.
-   Upgrading the Robomoderator

## Where to get Help

First of all, please take your time and be prepared to be patient. Since configurations of local systems and newsgroups are different, setting them up takes some time. There are two ways you can get help. The first one is free, the second is not. If you know something about Linux, you probably can try to go the first route. If you are not a Linux person, second route may be the way to go.

-   STUMP-users mailing list.

    There is a mailing list for STUMP users. You can subscribe and ask your questions there. They will likely be answered within a day or two. The mailing list information can be found at:
    https://savannah.gnu.org/mail/?group=stump

-   The news.admin.moderation newsgroup is a forum for asking questions and getting help with moderation related issues.

## Understanding Moderation

### What does 'moderated' mean ?

'Moderated' means that all postings to the newsgroup go to a mail address (e.g., news.group@example.com) instead of appearing in the newsgroup directly. The postings are then forwarded via email to a moderator, or group of moderators, or even an automated program, who decides whether to actually inject the article into the newsgroup or to reject it as not meeting guidelines spelled out in the group's charter.

The main purpose of newsgroup moderation is to prevent inappropriate posts to the newsgroup. For example, moderation can prevent discussion or requests for software from appearing in groups dedicated to posting
source code. It can also be used to facilitate discussions, to create a forum for announcements, to prevent repeated posts of the same information, or to cut off endless uninformative arguments. Some groups, e.g., rec.humor.funny and some source groups, also use it to control the traffic volume.

Moderation should not be used to censor unpopular viewpoints, or those that the moderator simply disagrees with. It is best to have a very clear charter and moderation policy for the newsgroup, so that newsgroup readers and posters can tell which topics are, or are not, appropriate for discussion on the newsgroup.

### Why do Usenet moderated newsgroups exist ?

Groups on the net are moderated for a variety of reasons. All moderation serves the same basic purpose, to filter out inappropriate postings and to deliver timely, on-topic articles. Most moderated groups fall into one of five general categories:

1. Groups with postings of an informative nature not suited to discussion and always originating from the same (very small) group of posters. Groups within this category include news.lists, news.announce.newusers and comp.mail.maps.

2. Groups derived from regular groups with such a high volume that it is hard for the average reader to keep up. The moderated versions of these groups are an attempt to provide a lower volume and higher quality version of the same forum. An example of this category is news.announce.newgroups (a reduced form of news.groups).

3. Groups derived from regular groups that have often been abused. That is, the regular groups often received postings of items that were not germane to the stated topic of the group (or sometimes even within the realm of politeness for the net). This also includes groups suffering from an annoying number of duplicate postings and inappropriate followups. Moderated groups in this category include comp.sources.misc.

4. Groups designed to serve as direct feedback to an off-the-net group. The discussion in comp.std.mumps is an example of this.

5. Groups that are gatewayed into Usenet from an Internet mailing list. These groups are moderated by someone on the Internet side but are shared with the Usenet population. Submissions mailed to the proper addresses, given below, will appear in both the group on Usenet, and the Internet list. This includes some groups in the "inet" distribution such as comp.ai.vision.

### Role of a moderator

Moderating a newsgroup is a volunteer effort but it carries certain responsibilities. The role of a moderator is to review, approve and post articles relevant to a newsgroup according to the group's charter or guidelines.

If an article does not qualify for posting, it is to be sent back to the author with an explanation of why it is not suitable for posting.

Depending on the nature of the group, acceptable turnaround time can range from a few days to a few weeks. If posts accepted for the group have a long delay before being actually posted, as happens with moderated net magazines, it is a good idea to let the submitter know that the post was accepted, and what the approximate posting date will be.

## Initial Setup

The steps outlined in this chapter should be done only once at the beginning, when setting up the robomoderator. Suppose that you, are the moderator of the newly created group, and your users like to refer to your group as Comp.Sys.FooBars.Moderated or **csfm**.

### Server Prerequisites

It is recommended to run STUMP on a dedicated server or virtual server like a VPS or a public cloud instance that also a Usenet server. It is possible to run these servers on a home PC if a dynamic DNS service is available but a dedicated server is always best.

A best practice would be to create a dedicated user or alias per newsgroup so mail filtering is easy to work with. Mail filtering applications like procmail best with clear differences like different email addresses.

### Security

The Perl scrips that are used in STUMP and WebSTUMP have been proofread and verified for security in the past and built extensive protection against malicious attacks aiming to hack robomoderation account. However, the original code is over 20 years old and may not be completely reliable. Of course, being that this is an open-source application, feel free to contribute to the project or write your own moderation software!

### Setting up sendmail aliases

Remember that robomoderator performs several functions:

- Accepts and checks incoming submissions
- Accepts approvals and rejections by human moderators
- Maintains moderators' private mailing list
- Forwards complaints of posters to all human moderators

For each such purpose, a separate email address must be established. Note the distinction between an email address and a user id: several email addresses may correspond to one user ID. These addresses should normally be *sendmail aliases*. These aliases are normally defined in file `/etc/aliases`.

Example aliases file for Comp.Sys.FooBars.Moderated:

```
# submissions
csfm-submit:                csfm                         
# To me, technical problems
csfm-admin:                 johndoe                       
# Moderators' list
csfm-mods:                  csfm                           
# Non-technical complaints, same as "board" above
csfm-board:                 csfm-mods                     
# Mail errors, go to hell
csfm-errors:                /dev/null                    
# Approved and rejected messages
csfm-approved:              csfm                       
# Approval key autoreply Bot
csfm-approval-key:          csfm                   
# for posters who do not want autoacknowledgments:
csfm-noack:                 csfm                          
# alternative names, for absent-minded posters
comp-sys-foobars-moderated: csfm-submit
comp.sys.foobars.moderated: csfm-submit
```

As you can easily see, messages to all of these addresses go to the robomoderator's address.

Note also, that if you have only one address and a sendmail-based system, and a non-cooperative sysadmin, you can try to get around the requirement to have several sendmail aliases. If addresses like yourname+comment@yoursite.com work, then you can use addresses like "csfm+approved@yoursite.com" instead. Make sure that they do in fact work (it is not guaranteed) and then edit your stump/etc/procmailrc accordingly.


### Setting up procmail

You should set up **procmail** - an excellent, free third-party tool for flexible processing of incoming email messages. It works on any Linux. This is a standard package in most Linux distributions. Also, you can follow [this link](http://www.ii.com/internet/robots/) for an excellent introduction (and more!) to procmail.

Look at the [sample .procmailrc file](procmailrc.txt) that is used by soc.culture.russian.moderated.

### Setting up GnuPG

**NOTE:** Not all moderators need to set up GnuPG. You only need GnuPG if you plan to use PGP Moose for authentication of approvals. Skip the rest of this section if you are not interested. You can always return to it later. Make sure that the settings in the [stump/etc/modenv](modenv.txt) file are correct. If you plan to NOT use GnuPG, keep GnuPG set to "none" in the "stump/etc/modenv" file.

Set up and familiarize yourself with GnuPG (or GNU Privacy Guard), an excellent third-party encryption and authentication program. GnuPG is a GNU free software version of the PGP application. This is another application that should be with most Linux and Unix distributions and can be installed with your distribution's package manager. The [GnuPG manual](https://gnupg.org/gph/en/manual.html) is available for newbies.

### Setting up Perl

Most likely you already have a perl interpreter. Simply type at your Linux command prompt:

$ perl -v If you see some meaningful output, you are fine and you have perl. Otherwise you need to install it. You can install perl and it's libraries using your distribution's package manager.

## Starting with Robomoderator

### Downloading STUMP

Currently the best way to download Robomoderator is by cloning the source code from the GNU Savannah git repository:

```
$  git clone https://git.savannah.gnu.org/git/stump.git
``

### Unpacking Source

Creating **..../etc** directory
--------------------------------

In the distribution that you receive, under ` $HOME/stump`, there is
directory `$HOME/stump/etc.dist`. It should be **renamed** to
` $HOME/stump/etc`, and you should do the same with bin.dist, tmp.dist
and data.dist directories. etc contains files that you need to
customize. The reason for such renaming is that when you receive
upgrades of the robomod, the upgrade does not override the files that
you customized.

Go through files in etc directory, and edit them carefully.

Most of them are self explanatory. I put lots of comments in them. You
should begin with editing the [stump/etc/modenv](modenv.txt) file.

Create a symbolic links for procmail:

$ /bin/ln -s $HOME/stump/etc/procmailrc $HOME/.procmailrc mkdir
$HOME/Mail # Creates directory for mail chmod 700 $HOME.Mail # Make
it safe Edit your [$HOME/stump/procmailrc](procmailrc.txt) to tailor it
to the needs of your newsgroup. Do it carefully.

**IMPORTANT:** Later you MUST make sure that procmail processes all your
incoming mail correctly and that all rules are written right. For logs
of all procmail activity you may look into $HOME/Mail/from logfile. You
can set `VERBOSE=ON` in the `procmailrc` file if you want to see
detailed output.

NOTE: file Mail/from is an excellent source of debugging information.

Editing Data Files in **..../data**
------------------------------------

Rename `data.dist` to `data`.

You can (and should) edit some of the files in the data directory. These
files are good.guys.list, bad.guys.list, bad.words.list. They contain
Perl's regular expressions for detecting messages from preapproved and
blacklisted posters, and suspicious words, respectively.

Edit them and leave them blank (no spaces).

Setting .profile for robomod support
------------------------------------

It is **very important** that you source `modenv` file from the etc
directory in your .profile (or .login) file. You need to have several
environment variables, including PATH, to be set correctly in order to
support robomod properly.

Put this in your .profile or .login file: source $HOME/stump/etc/modenv

Creating ONE PAIR of GnuPG keys.
------------------------------

[Skip this part if you do not plan on using PGP Moose].

According to [the specification](spec.html) of the robomod, you have to
have one GnuPG key - for signing approved articles with PGP Moose
application.

Pick a passphrase that is not too hard to type and remember. Usage of
these GnuPG keys is not a very high-security application, so you can
select 512-bit key sizes. Save this passphrase in file
`$HOME/.GnuPG-passphrase`

. Make sure that this passphrase is not readable by anyone except the
robomod user.

Name the key by analogy with the key used for SCRM (see modenv file and
user names there). Your GnuPG Key must be named like this:

    pub   512/ABB554F5 1996/02/26 CSFM Approval Key <csfm-approval-key@yoursite.com>

GnuPG Keys are generated using command GnuPG -kg -u "CSFM Approval Key
<csfm-approval-key@yoursite.com>"

Copy your keyring to a specially designated place for STUMP: cp
$HOME/.GnuPG/pubring.GnuPG $HOME/stump/data/pubring.GnuPG

Compiling C programs in **stump/c** directory
---------------------------------------------

Go to the c directory and type ./compile. That should do it. If it does
not, figure out on your own. The programs are extremely simple. Perhaps
you can change the setting of CC to gcc, especially if you use Sun
computers.

Creating List for reasons of Rejection and Rejection Messages
-------------------------------------------------------------

You should think what broad categories for reasons of rejection you will
have in your group. Give them simple names. Edit file `etc/reject` and
edit part that consists of calls to subroutine `addReason`. Customize it
to your taste. After that, go to directory `etc/messages` and make sure
that files there have exactly the names that you listed as first
parameters in calls to `addReason`. Make sure they have comprehensive
and polite messages corresponding to the broad reasons for rejection
that you made up.

These messages will be sent to users when their articles are rejected
for specified reasons. The messages that I supplied are not bad.

Make sure that you keep the following files:

-   abuse -- to send back when rejecting banned users
-   crosspost -- to send back when rejecting for megacrossposting
-   charter -- to send back when rejecting for violating requirements
    of the charter that are checked automatically
-   signature -- to send back when rejecting for bogus GnuPG signature.

Edit file `rejection-reasons.lst` and put there the reasons that your
moderators are allowed to choose for rejections. They should have names
corresponding to the filenames in etc/messages, separated from comments
by double colon ::.

Example:

    offtopic::Message is grossly off topic (spam, turks, etc)
    charter::Technical violation of charter (binary, exc. quoting)
    harassing::Message of harassing/insulting/hatemongering content

------------------------------------------------------------------------

[Testing Your Setup]{#test}
===========================

First of all, your default setup uses my free WebSTUMP service, so that
you have a Web based interface for moderation. This means that you
install and host STUMP, and you use my installation of WebSTUMP to
moderate articles. WebSTUMP is a web based moderation tool, which is
nice but a pain to set up. (it requires running setuid code and cgi-bin
capability).

To test your newsgroup, first write to `ichudov @ algebra . com`, and
ask me to create a newsgroup account for you in webstump. Please tell me
your newsgroup name and the approved address (such as
csfm-approved@your.site.com). Free WebSTUMP is located at

<http://freewebstump.algebra.com/stump-cgi/webstump.cgi>

You should test your setup of the robomoderator very extensively. If the
robomod fails when your group goes to production, you will be ashamed.
When you are testing, look at file $HOME/Mail/from, which contains all
standard error output of your programs. Try to send submissions by email
to your moderation address. Do

tail -f $HOME/Mail/from to see what's going on.

Choosing a "victim" group
---------------------------

I suggest that you use `misc.jobs.misc` for your testing. It is a dead
newsgroup infested by spamsters. Nobody will bother and complain about
your postings.

Edit file `etc/modenv` and put `misc.jobs.misc` in the assignment to
NEWSGROUP, for testing purposes.

Things to Test
--------------

Test at least these conditions:

Testing Schedule

Test Case

Test Goal

Moderators' list

Moderators receive all message submitted to the address for thir private
list.

Ackonwledgments of Receipt

Submitters receive polite and informative messages for every message
that they submit (you can turn ack mode off for individuals or even
altogether)

Distribution of Submissions

Each message submitted to the robomoderator gets sent to a randomly
selected human moderator in an appropriate format.

Approvals work

Messages approved by human moderators actually get posted.

Rejections Work

Messages rejected by human moderators do not get posted; submitters
receive polite and informative explanations of the reasons of rejection,
and pointers to FAQ and Charter of your newsgroup.

White List Works

Messages sent by users whose "From: " addresses match regular
expressions in the good.guys.list file.

------------------------------------------------------------------------

****The End****

------------------------------------------------------------------------

[![Creative Commons
License](https://i.creativecommons.org/l/by/4.0/88x31.png)](http://creativecommons.org/licenses/by/4.0/)
Copyright © 1996 Igor Chudov. This work is licensed under a [Creative
Commons Attribution 4.0 International
License](http://creativecommons.org/licenses/by/4.0/).
