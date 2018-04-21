
# What

Simple tool to build B+ tree database file of known good software hashes
and to check your own hashes against that database.

The DB file is Kyoto Cabinet. Only hashes are stored (no file names, os, etc.)
to keep the database file as small as possible (< 1GB) when even the source file
for non-duplicate NIST hashes is >5GB.

# Requirements

pip install kyoto-cabinet

# Build the db

Either run `./download.sh` or go to https://www.nist.gov/itl/ssd/software-quality-group/nsrl-download/current-rds-hash-sets,
download "Modern RDS (minimal)" and unzip it (rds_modernm.zip).

Index the NSRLFile.txt. Mind that the target file *MUST* end in ".kct" to make B+ trees.
There are 42M lines.

`./index.py NSRLFile.txt NSRLFile.kct`

# Use the db

Feed the tool with list of lines with SHA-1 hashes. The tool will remove all lines that
have known good hashes. The remaining files are the ones that might be interesting.

`cat testhashes.txt | ./check.py NSRLFile.kct`

# But I like SQL!

If you want to put the whole data in PostgreSQL, there is also a script for that.
You need to download the whole "Modern RDS (microcomputer applications from 2000 to present)"
set, extract the files from the downloaded ISO image, unzip NSRLFile.txt.zip,
create a PostgreSQL database and run the script to populate the database.

`createdb hashes`
`./make-psql-db.sh hashes`

The script assumes there are files named nsrlmfg.txt, nsrlos.txt, nsrlprod.txt and nsrlfile.txt.

From PostgreSQL, you can query things like:
`SELECT * FROM file WHERE "SHA-1" = UPPER('0000002D9D62AEBE1E0E9DB6C4C4C7C16A163D2C');`
