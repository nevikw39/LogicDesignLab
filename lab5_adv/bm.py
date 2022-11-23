#!/usr/bin/python3

N = 4
M = 1 << N

for i in range(M):
    for j in range(M):
        a = i - (M >> 1)
        b = j - (M >> 1)
        print(a, b, a * b)
