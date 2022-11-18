from math import gcd
from random import randrange as rand


for _ in range(1 << 16):
    a = rand(1 << 16)
    b = rand(1 << 16)
    print(a, b, gcd(a, b))
