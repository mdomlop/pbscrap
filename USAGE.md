USAGE
=====

Execute `pbscrap -h` for inline help.

## Required arguments

`pbscrap` will require at least one of these two arguments:

* `-q` or `--query`
    To indicate a list of queries. If a query consists of two words, you must
    enter quotation marks. In this way:

    pbscrap -q aquery 'second multiword query'

* `-i` or `--infile`
    To indicate a file containing a list of queries. Each line in the file
    represents a query.

        $ cat /home/user/myqueries
        aquery
        second multiword query

        $ pbscrap -i /home/user/myqueries

The -q and -i options can be used simultaneously without problems.

## Optional arguments

* `-f` or `--frequence`
    To indicate a frequency in seconds, minutes, hours or days.

    Without this option the program will run only once. Otherwise it will
    remain in execution until you finish it manually.

    To ndicate the frequency in seconds indicates an integer greater than 0.
    To do so in minutes add m to that number, h for hours and d to do it in days

    The program will print a warning if the frequency is very low, since in
    this circumstance it is possible to be banned by the server pastebin.com.
    However, at least for now, it is possible to continue to obtain results
    despite this ban. Please do not use low frequencies if it is not necessary.

* `-o` or `--outdir`
    To indicate the directory where the results of the program execution will
    be stored.

    The program will try to create such a directory if it does not exist.

* `-v` or `--verbose`
    To print text by standard output.
