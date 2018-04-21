
# What

Simple tool to build B+ tree database file of known good software hashes
and to check your own hashes against that database.

The DB file is Kyoto Cabinet. Only hashes are stored (no file names, os, etc.)
to keep the database file as small as possible (< 1GB) when even the source file
for non-duplicate NIST hashes is >5GB.

# Requirements

pip install kyoto-cabinet

# Build the db

Go to https://www.nist.gov/itl/ssd/software-quality-group/nsrl-download/current-rds-hash-sets
and download "Modern RDS (minimal)". Unzip rds_modernm.zip.

Index the NSRLFile.txt. Mind that the target file *MUST* end in ".kct" to make B+ trees.
There are 42M lines.

./index.py NSRLFile.txt NSRLFile.kct

# Use the db

Feed the tool with list of lines with SHA-1 hashes. The tool will remove all lines that
have known good hashes. The remaining files are the ones that might be interesting.

cat testhashes.txt | ./check.py NSRLFile.kct
