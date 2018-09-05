PBScrap
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


USAGE
=====

Execute `pbscrap -h` for inline help.

## Required arguments

`pbscrap` will require at least one of these two arguments:

* `-q` or `--query`
    To indicate a list of queries. If a query consists of two words, you must
    enter quotation marks. In this way:

        $ pbscrap -q aquery 'second multiword query'

* `-i` or `--infile`
    To indicate a file containing a list of queries. Each line in the file
    represents a query.

        $ cat /home/user/myqueries
        aquery
        second multiword query

        $ pbscrap -i /home/user/myqueries

The -q and -i options can be used simultaneously without problems. All queries
are case insensitive.

## Optional arguments

* `-f` or `--frequence`
    To set a execution frequency in seconds, minutes, hours or days.

    Without this option the program will run only once. Otherwise it will
    remain in execution until you finish it manually.

    To set the frequency in seconds, indicate an integer greater than 0.  To
    do so in minutes, add `m` to that number, `h` for hours, and `d` to do it
    in days.

    The program will print a warning if the frequency is very low, since in
    this circumstance it is possible to be banned by the server pastebin.com.
    However, at least for now, it is possible to continue to obtain results
    despite this ban. Please do not use low frequencies if it is not necessary.

* `-o` or `--outdir`
    To indicate the directory where the results of the program execution will
    be stored.

    The program will try to create such a directory if it does not exist.

    Without this option storing will be done in current directory.

* `-v` or `--verbose`
    To print log text to standard output.

## Examples

To search por `perl` content every 2 minutes (results will be stored in
 current directory):

    $ pbscrap -q perl -f 2m

Same but storing in `/tmp/OUT`. Directory will be created if not exists.

    $ pbscrap -q perl -f 2m -o /tmp/OUT

For search `perl`, `honey bunny`, and the contents of `/home/user/things`,
outputting files to `/tmp/OUTDIR`, every 1 hour, with verbose messages to
terminal.

    $ pbscrap -q perl 'honey bunny' -f 1h -o /tmp/OUT -v -i /home/user/things

Installation
------------

You can choose between different installation methods.

### Classic method ###

- Build and install:

        $ make
        # make install

- Uninstall:

        # make uninstall

### Arch Linux package

- Build and install:

        $ make arch_pkg
        # pacman -U pbscrap-1.0b-1--any.pkg.tar.xz

- Uninstall:

        # pacman -Rsc snapman