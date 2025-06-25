n = int(input())
l = []
nr_viraje_stanga = 0
nr_viraje_dreapta = 0
nr_situatii_fara_viraj = 0
for i in range(n):
    coordinate = input()
    x, y = map(int, coordinate.split())
    l += [[x, y]]
l += [l[0]]
for i in range(1, n):
    determinant = l[i][0] * l[i+1][1] + l[i-1][0] * l[i][1] + l[i-1][1] * l[i+1][0] - l[i][0] * l[i-1][1] - l[i+1][0] * l[i][1] - l[i+1][1] * l[i-1][0]
    if determinant == 0:
        nr_situatii_fara_viraj += 1
    elif determinant > 0:
        nr_viraje_stanga += 1
    else:
        nr_viraje_dreapta += 1
print(nr_viraje_stanga, nr_viraje_dreapta, nr_situatii_fara_viraj)