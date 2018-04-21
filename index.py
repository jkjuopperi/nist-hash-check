#!/usr/bin/env python

import sys
import re
import codecs
import kyotocabinet as kc

unhex = codecs.getdecoder('hex')

db = kc.DB()
db.open(sys.argv[2], kc.DB.OWRITER | kc.DB.OCREATE)

linenumber = 0
with codecs.open(sys.argv[1], 'r', 'ascii', 'ignore') as f:
  for line in f:
    try:
      #m = re.search(r'^"([^"]*)","([^"]*)","([^"]*)","([^"]*)",(\d*),(\d*),"([^"]*)","([^"]*)"\r', line)
      m = re.search(r'^"([^"]*)"', line)
      if linenumber > 0 and m:
        sha1 = unhex(m.group(1))[0]
        #md5 = unhex(m.group(2))[0]
        #crc32 = unhex(m.group(3))[0]
        #filename = m.group(4)
        if len(sha1) == 20:
          db.set(sha1, b'\xff') # Just put a dummy byte

    except Exception:
      print("Error at line", linenumber)

    if linenumber % 100000 == 0:
      print(linenumber)

    linenumber += 1

db.close()
