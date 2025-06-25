import math

# a = float(input())
# b = float(input())
ab = input()
# a, b = ab.split()
# a = int(a)
# b = int(b)
a, b = map(int, ab.split())
p = int(input())
m = int(input())
l = math.ceil(math.log((b-a)*pow(10,p), 2))
d = (b-a)/pow(2,l)
for i in range(m):
    sir = input()
    if sir == "TO":
        x = float(input())
        count = 0
        while a+count*d <= x:
            count += 1
        count-=1
        length = len(bin(count)[2:])
        while(length < l):
            length += 1
            print("0", end="")
        print(bin(count)[2:])
    if sir == "FROM":
        bit = input()
        print(f"{a+int(bit, 2)*d:0,.{l}f}")
