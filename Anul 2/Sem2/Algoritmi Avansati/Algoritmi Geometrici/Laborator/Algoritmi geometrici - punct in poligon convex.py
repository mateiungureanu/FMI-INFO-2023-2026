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

def pe_segment(x1, y1, x2, y2, xq, yq):
    return min(x1, x2) <= xq <= max(x1, x2) and min(y1, y2) <= yq <= max(y1, y2)

def in_triunghi(p1, p2, p3, q):
    x1, y1 = p1
    x2, y2 = p2
    x3, y3 = p3
    xq, yq = q

    o1 = orientare(x1, y1, x2, y2, xq, yq)
    o2 = orientare(x2, y2, x3, y3, xq, yq)
    o3 = orientare(x3, y3, x1, y1, xq, yq)

    if o1 == 0 and pe_segment(x1, y1, x2, y2, xq, yq):
        return "BOUNDARY"
    if o2 == 0 and pe_segment(x2, y2, x3, y3, xq, yq):
        return "BOUNDARY"
    if o3 == 0 and pe_segment(x3, y3, x1, y1, xq, yq):
        return "BOUNDARY"

    if (o1 > 0 and o2 > 0 and o3 > 0) or (o1 < 0 and o2 < 0 and o3 < 0):
        return "INSIDE"
    return "OUTSIDE"


P0 = Poligon[0]

for punct in Points:
    xq, yq = punct

    if orientare(*P0, *Poligon[1], xq, yq) < 0 or orientare(*P0, *Poligon[-1], xq, yq) > 0:
        print("OUTSIDE")
        continue

    st = 1
    dr = n - 1
    while dr - st > 1:
        mid = (st + dr) // 2
        if orientare(*P0, *Poligon[mid], xq, yq) > 0:
            st = mid
        else:
            dr = mid

    rezultat = in_triunghi(P0, Poligon[st], Poligon[dr % n], punct)
    print(rezultat)
