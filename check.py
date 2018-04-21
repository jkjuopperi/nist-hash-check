#!/usr/bin/env python

import sys
import re
import codecs
import kyotocabinet as kc

unhex = codecs.getdecoder('hex')

db = kc.DB()
db.open(sys.argv[1], kc.DB.OREADER)

for line in sys.stdin:
  m = re.search(r'([0-9a-fA-F]{40})', line)
  if m:
    hash = unhex(m.group(1))[0]
    if db.check(hash) == -1:
      sys.stdout.write(line)

sys.stdout.flush()
db.close()
