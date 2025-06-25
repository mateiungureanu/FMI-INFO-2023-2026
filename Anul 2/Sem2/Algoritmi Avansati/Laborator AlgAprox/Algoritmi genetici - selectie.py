def functie(x):
    return a*x*x + b*x + c

abc = input()
a, b, c = map(int, abc.split())
n = int(input())
F = 0
T = 0
f = []
numere = input().split()
for i in range(n):
    x = float(numere[i])
    f += [functie(x)]
    F += f[i]
for i in range(n):
    print(f"{T/F:0,.6f}")
    T += f[i]
print(f"{1:0,.6f}")