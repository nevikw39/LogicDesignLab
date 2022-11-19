#!/usr/bin/python3

import random
import sys

import regex


N = 1 << 16

str = ''.join(random.choice("01") for _ in range(N))

pattern = regex.compile("1110(01)+1")
s = set(i.end() - 1 for i in pattern.finditer(str, overlapped=True))

for i in range(N):
    print(str[i], '1' + ('1' if i + 1 < N and str[i + 1] == '1' else '0') if i in s else '00')

# for i in pattern.finditer(str, overlapped=True):
#     print(i.end(), file=sys.stderr)
print(len(s), file=sys.stderr)
