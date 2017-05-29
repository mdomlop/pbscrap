pbscrap
=======

A simple scraper for <https://pastebin.com>.

`pbscrap` is a utility that reads `pastebin.com` looking for posts that contain
the required words or phrases.

If a query is successful, the post is stored under a directory with the name of
the query.

A log file is generated. And also creates an html file with links to the posts.

The queries to be made can be indicated by the command line, as well as through
a text file, where each line of the same represents a query.

You can specify the execution frequency in whole (integer) units of seconds,
minutes, hours or days.

If no output directory is specified, all these files will be written to the
working directory from where the program was called.

For more information read the [USAGE.md](https://github.com/mdomlop/pbscrap/blob/master/USAGE.md) file.
