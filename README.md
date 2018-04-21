
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
