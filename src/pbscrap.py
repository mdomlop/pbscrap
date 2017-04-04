#!/usr/bin/env python3
# pbscrap.py: A simple pastebin.com scraper.

# Version: 20170329

import urllib3
import re
import datetime
import sys
import os
import hashlib
import argparse
import time

# The correct functioning of the program is highly dependent on this line:
regex = re.compile('^href="/(\w{8})">(.*)</a>')

urllib3.disable_warnings()  # No annoying output

url = 'http://pastebin.com'
news = url + '/archive'
raw = url + '/raw'

http = urllib3.PoolManager()

# Default options:
frequence = '-1'  # Frequecies as 10, 5m, 2h or 1d. Negatives means single shot
outdir = ''
infile = None
verbose = False
query = None

parser = argparse.ArgumentParser(
        prog='pbscrap',
        description='A simple pastebin.com scraper'
        )

# FIXME: Fails with -12m args as frequence
parser.add_argument('-f', '--frequence', default=frequence,
                    help='Frequece in secs, mins, hours or days')
parser.add_argument('-o', '--outdir', default=outdir,
                    help='Directory for outputting files')
parser.add_argument('-q', '--query', default=query, nargs='+',
                    help='A sequence of words to query')
parser.add_argument('-i', '--infile', default=infile,
                    help='A file from wich loading queries')
parser.add_argument(
            '-v', '--verbose', default=verbose, action='store_true',
            help='Verbose output')
args = parser.parse_args()


def scrap(outdir, queries):
    response = http.request('GET', news)
    rawnews = response.data.decode('utf-8')

    db = {}  # db = { idcode: title, idcode2: title2, ...}

    for line in rawnews.split():
        if line.startswith('href="/scraping">'):
            continue
        match = re.match(regex, line)
        if match:
            idcode = match.group(1)
            title = match.group(2)
            db[idcode] = title

    for idcode in db:
        link = url + '/' + idcode
        rawlink = raw + '/' + idcode
        title = db[idcode]

        response = http.request('GET', rawlink)
        try:
            content = response.data.decode('utf-8')
        except UnicodeDecodeError:
            print('Failed to decoding url:', rawlink, file=sys.stderr)
            print('Maybe it is not a utf-8 file?')
            print('DEBUG ME!')
            with open('error.log', 'a') as e:
                e.write('Error decoding:', rawlink)
            continue

        # Lowercase versions for case insensitive search
        _content = content.lower()
        _title = title.lower()

        findings = ''  # A string for storing founded queries

        for query in queries:
            _query = query.lower()

            if _query in _content or _query in _title:
                findings += ' ' + _query
        if findings:
            # To avoid conficts with OS directory separators
            findings_ = findings.replace(os.sep, '-')
            findings_ = findings.strip()
            # Uncomment this to allow copying files between the most common OS:
            # findings_ = findings_.replace('/', '-')
            # findings_ = findings_.replace('\\', '-')

            hsum = hashlib.md5(content.encode('utf-8')).hexdigest()

            fname = hsum
            storedir = os.path.join(outdir, findings_)

            # Downloading raw post to disk:
            try:
                os.makedirs(storedir, exist_ok=True)
            except PermissionError:
                print(
                        'Sorry, I can not make dir', storedir,
                        'Permission denied.\nExiting...\n'
                        )
                sys.exit(1)
            except:
                print('Unexpected error:', sys.exc_info()[0])
                raise

            outfile = os.path.join(storedir, fname)
            if not os.path.isfile(outfile):
                with open(outfile, 'w') as f:
                    f.write(content)

                # Logging results as plain text:
                logfile = os.path.join(args.outdir, 'pcscrap.log')
                ts = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                logline = ts + ' ' + link + ' ' + hsum + ' '
                logline += findings + ' ' + title
                logline += '\n'
                if args.verbose:
                    print(logline.rstrip())
                with open(logfile, 'a') as l:
                    l.write(logline)

                # Logging results as html:
                htmlfile = os.path.join(args.outdir, 'pcscrap.html')
                htmlline = '<h3>' + title + '</h3>\n'
                htmlline += '<ul>\n<li><a href="' + link
                htmlline += '" title="' + link
                htmlline += '">' + findings + '</a></li>\n</ul>\n\n'
                htmlline += '<p>' + ts + '</p>\n'
                htmlline += '<hr />'
                with open(htmlfile, 'a') as h:
                    h.write(htmlline)


def toseconds(period):
    '''Read minutes, hours or days and converts it to seconds.'''
    err = 'I do not know how to convert ' + period + ' to seconds'
    if period.endswith('m'):
        fperiod = period.replace('m', '')
    elif period.endswith('h'):
        fperiod = period.replace('h', '')
    elif period.endswith('d'):
        fperiod = period.replace('d', '')
    else:
        fperiod = period
    try:
        int(fperiod)
    except:
        print(err, file=sys.stderr)
        exit(3)
    fperiod = int(fperiod)
    if period.endswith('m'):
        fperiod = fperiod * 60
    elif period.endswith('h'):
        fperiod = fperiod * 60 * 60
    elif period.endswith('d'):
        fperiod = fperiod * 60 * 60 * 24
    return(fperiod)


def merge_queries():
    ''' Merges queries from infile and from --query args.
    Removing duplicates. '''

    query = []
    if args.query:
        for i in args.query:
            query.append(i)

    if args.infile:
        if not os.path.isfile(args.infile):
            parser.print_help()
            print(
                    '\nThe argument', args.infile,
                    'is not a file.\nExiting...\n',
                    file=sys.stderr
                    )
            sys.exit(1)

        with open(args.infile, 'r') as i:
            for line in i.readlines():
                # Skips blank lines but without removing trailing spaces:
                if line and line.strip():
                    query.append(line.rstrip('\n'))
    if query:
        query = set(query)  # Removing duplicates
        return(query)
    else:
        parser.print_help()
        print(
                '\nI need at least one argument to query.\nExiting...\n',
                file=sys.stderr
                )
        sys.exit(1)


# Executing at desired frequence:
freq = toseconds(args.frequence)
if freq < 0:
    q = merge_queries()
    scrap(args.outdir, q)
else:
    if freq < 10:
        print('''Warning: Low frecuencies may cause that you will be
blocked in pastebin.com server.''', file=sys.stderr)
        answer = input('Are you sure to want to continue? y/N ')
        if answer.lower() != 'y':
            sys.exit(2)
    # Action!
    while True:
        # The merging of infile and query in each instance of the loop allows
        # to edit infile during the execution and thus change the queries
        # dynamically without stopping the process.
        q = merge_queries()
        scrap(args.outdir, q)
        time.sleep(freq)
