#!/usr/bin/python3

from random import randrange as rand


N = 1 << 16
M = 1 << 4

for _ in range(N):
    a = rand(M) - (M >> 1)
    b = rand(M) - (M >> 1)
    print(a, b, a * b)
