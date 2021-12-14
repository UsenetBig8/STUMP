# STUMP Robomoderator Program

**Making Moderation Easy**

<!---
JE - This is the latest update
**Moderation of newsgroups:**
Users of ReadySTUMP can now moderate newsgroups with pictures. Articles with embedded pictures (uuencoded or MIME) will be displayed properly (as graphical
images) to the moderators. That makes it possible to create moderated newsgroups with pictures and moderate them easily. At the moment, I limited this service to users of ReadySTUMP, for technical reasons. If you are interested in creating a moderated picture newsgroup.
-->

<!---
JE - Insert Statement About B8MB and STUMP/WebSTUMP
STUMP is more than just a program. It is also **my commitment** to
support and maintain it and its users in the best way possible. It is
also a community of existing users who can help you with their advice.
My goal is to keep STUMP the most flexible, easiest to use for human
moderators, and most full featured package available. I actively solicit
you to make your suggestions to improve STUMP, and welcome any and all
criticism.
-->

## Basic features of the Robomoderator

STUMP Can run on any Unix. Moderators can use any OS, and generally can do their job as long as they are able to read email.

Web-based moderation with WebSTUMP is also possible. It can be done by moderators
even without knowledge of CGI or access to a CGI-enabled Web server is available
as well as the ability to set up your own webservers if you want to.

Documentation is available in multiple formats.

* User support available through stump-users mailing list: https://savannah.gnu.org/mail/?group=stump
* Extremely versatile but easy configuration management.
* Support for **group moderation** -- multiple human moderators, which are randomly chosen for every incoming message that needs to be reviewed.
* Automatic rejection of nonconforming messages, for example megacrossposts and encoded binaries are rejected automatically without human intervention.
* Support of a preapproved list of posters whose posts are presumed to be good and do not need human review. It can help the moderator team to save their time and speed up posts by frequent posters. In practice, **about 80% of moderators' time can be saved with this feature.**
* Everything is archived. Achives may be presented as WWW Pages [like
this](http://stump.algebra.com/~asar/approved/maillist.html).
* Exchange between human moderators and robomod program is secured by PGP encryption and signatures. It prevents any "spoofing" of the robomoderator, when malicious users try to simulate fake moderators' approvals. This security is provided internally by perl scripts, and human moderators need not bother - everything is done for them.
* Acknowledgments of receipt, rejection messages with explanations (standardized or supplied by human moderators) are sent back to posters.
* All approved articles are digitally signed by PMApp program by Greg Rose. It provides positive and reliable identification of forgeries and unapproved posts. A daemon program is provided that looks for all unauthorized posts and deletes
them automatically. Note that these signatures are placed in the header of the post and they do not clutter the actual text of the messages. These scripts also
provide protectin from subtle impersonation attacks described by Dr. Vulis.
* Some posters may request additional protection from forgeries.
* Support for a moderators'-only mailing list. This is nice for newsgroups that have more than one moderator.

## Typical Setups Supported


STUMP supports the following typical configurations of robomoderator
programs:

* **"Technical":** Posts from all posters are approved automatically by default, but posts from a selected group of people are forwarded to human moderators for review. There are several "suspicious" words which also trigger forwarding an article to a human moderator for review.

This configuration is good for a technical newsgroup suffering from a small number of net abusers. For example, it could be useful for sci.physics or comp.lang.ada.

-   **"Announce" or "Culture":** Each submission triggers a reply with a FAQ (or any other text). All submissions are forwarded to a human moderator for review, but some posters are preapproved. Some posters may voluntarily request the robomoderator to accept only PGP signed articles. This configuration is good for an *.announce newsgroup where integrity and authentication are very important or a soc.culture.* newsgroup severely invaded by flamers, trollers, and
forgers.

-   **"Religious":** Everything goes as long as it is not crossposted to any other group. This configuration is good for a small cultural or religious newsgroup that offers freedom of speech but does not want any crossposted flames.

We shall note that the configurations above can be easily changed by changing contents of certain data files, and elements of these configurations can be intermixed (i.e., any newsgroup may restrict the number of crossposts or choose to send FAQ to posters).

## FAQ

There is a [List of Frequently Asked Questions (FAQ)](faq.txt). This is NOT a FAQ about installation, but rather a list of more general questions.

## Creating a New Newsgroups

If you want to propose a newsgroup, [click here](proponents.html).

## Downloading

You can download sources of STUMP from the project pages at savannah.gnu.org.

* https://savannah.gnu.org/projects/stump
* https://savannah.gnu.org/projects/webstump/

## Acknowledgments

The former maintainer, Igor Chudov would like to thank:

-   Stephen R. van den Berg at RWTH-Aachen, Germany, for his **procmail** utility.
-   Greg Rose, author of **PMApp**, a program for signing News articles with their headers.
-   soc.culture.russian readers for their criticism, suggestions and support.
-   Leonid Umantsev, for his **checkquote** program that verifies excessive quoting not allowed by SCRM's charter.

<!---
JE - Decide on how to display copyright notice
-->
