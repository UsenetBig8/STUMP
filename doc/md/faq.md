# Frequently Asked Questions

## I approved an article but my news server rejected it. What can I do?

If an article is rejected by the news server when STUMP attempts to post it, the failed article will be saved in the `tmp/` directory with a filename that begins "failed".

You can resubmit failed articles using the script `bin/submitFailed`. If the rejection was due to some temporary error, this may be all that is required.

However, the article may also have been rejected for a good reason. For example, many news servers will reject an article with a Date header that is more than couple of days in the past (this is another good reason to make sure that you are checking the article queue regularly). In this case, you can either contact the original poster and ask them to repost their article, or you can edit the date header in the "failed" article to the current date and run the `submitFailed` script. Editing the Date header is not good practice, but you may consider it better than losing the article altogether, particularly as some posters will not bother to resubmit an article that didn't show up.
