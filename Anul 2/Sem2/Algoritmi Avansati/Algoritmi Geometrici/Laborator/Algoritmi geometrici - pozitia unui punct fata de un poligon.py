n = int(input())
Poligon = []
for i in range(n):
    coordonate = input()
    xP, yP = map(int, coordonate.split())
    Poligon += [(xP, yP)]
m = int(input())
Points = []
for i in range(m):
    coordonate = input()
    xQ, yQ = map(int, coordonate.split())
    Points += [(xQ, yQ)]

def orientare(x1, y1, x2, y2, x3, y3):
    return (x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1)

xM = 1000000000
yM = 2000000000

for punct in Points:
    xQ, yQ = punct
    numar_intersectii = 0
    pe_margine = False
    
    for i in range(n):
        x1, y1 = Poligon[i]
        x2, y2 = Poligon[(i+1) % n]
        determinant = orientare(x1, y1, x2, y2, xQ, yQ)
        if determinant == 0:
            if min(x1, x2) <= xQ <= max(x1, x2) and min(y1, y2) <= yQ <= max(y1, y2):
                pe_margine = True
                break
    
    if pe_margine:
        print("BOUNDARY")
        continue
    
    for i in range(n):
        x1, y1 = Poligon[i]
        x2, y2 = Poligon[(i+1) % n]

        o1 = orientare(xQ, yQ, xM, yM, x1, y1)
        o2 = orientare(xQ, yQ, xM, yM, x2, y2)
        o3 = orientare(x1, y1, x2, y2, xQ, yQ)
        o4 = orientare(x1, y1, x2, y2, xM, yM)

        if o1 * o2 < 0 and o3 * o4 < 0:
            numar_intersectii += 1
    
    if numar_intersectii % 2 == 1:
        print("INSIDE")
    else:
        print("OUTSIDE")