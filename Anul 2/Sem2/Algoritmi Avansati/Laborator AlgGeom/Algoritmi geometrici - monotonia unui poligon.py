n = int(input())
Poligon = []
for i in range(n):
    coordonate = input()
    xP, yP = map(int, coordonate.split())
    Poligon += [(xP, yP)]

def este_monoton(axa):
    minim = 0
    maxim = 0

    for i in range(1, n):
        if Poligon[i][axa] < Poligon[minim][axa]:
            minim = i
        if Poligon[i][axa] > Poligon[maxim][axa]:
            maxim = i

    i = minim
    while i != maxim:
        urm = (i + 1) % n
        if Poligon[i][axa] > Poligon[urm][axa]:
            return False
        i = urm

    i = minim
    while i != maxim:
        urm = (i - 1 + n) % n
        if Poligon[i][axa] > Poligon[urm][axa]:
            return False
        i = urm

    return True

if este_monoton(0):
    print("YES")
else:
    print("NO")

if este_monoton(1):
    print("YES")
else:
    print("NO")
