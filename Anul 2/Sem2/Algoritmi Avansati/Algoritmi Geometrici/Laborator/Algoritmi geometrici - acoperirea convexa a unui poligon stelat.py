n = int(input())
l = []
for i in range(n):
    x, y = map(int, input().split())
    l+= [[x, y]]
l += [l[0]]
acoperire = l[:2]
for i in range(1, n):
    while len(acoperire) >= 2:
        ultimul = acoperire[-1]
        penultimul = acoperire[-2]
        urmatorul = l[i+1]
        determinant = ultimul[0] * urmatorul[1] + penultimul[0] * ultimul[1] + penultimul[1] * urmatorul[0] - ultimul[0] * penultimul[1] - urmatorul[0] * ultimul[1] - urmatorul[1] * penultimul[0]
        if determinant > 0:
            break
        acoperire.pop()
    acoperire.append(l[i+1])
acoperire.pop()
print(len(acoperire))
for p in acoperire:
    print(p[0], p[1])
