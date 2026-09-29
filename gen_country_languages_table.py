#!/usr/bin/env python3

# generate SQL Table from http://wiki.openstreetmap.org/wiki/Nominatim/Country_Codes

import sys
import urllib.request
import re

url = "http://wiki.openstreetmap.org/wiki/Nominatim/Country_Codes"
with urllib.request.urlopen(url) as response:
    content = response.read().decode("utf-8")

inside_table = False
col = 0
countries = []
country = {}
regex = re.compile("<.+?>", re.IGNORECASE)

oldline = ""
for line in content.splitlines():
    if '</table>' in line:
        inside_table = False
    if inside_table:
        if '<td' in line:
            line = regex.sub('', line).strip()
            if col == 0:
                country['iso'] = line.lower()
            if col == 1:
                country['name'] = line
            if col == 3:
                country['langs'] = line.replace(", ", ",")
            # check for proper table alignment (<tr><td>)
            if col == 0:
                if '<tr>' not in oldline:
                    sys.stderr.write("invalid <tr><td> alignment\n")
                    sys.exit(1)
            if col < 3:
                col += 1
            else:
                countries.append(dict(country))
                col = 0
    if line == '<table class="wikitable sortable">':
        inside_table = True
    oldline = line

for c in countries:
    print("%s\t{%s}" % (c['iso'], c['langs']))
