# Laborator 6
# problema V1
# def munte(L, st, dr):
#     jum = (st + dr) // 2
#     if len(L) < 3:
#         return None
#     if L[jum-1] < L[jum] > L[jum+1]:
#         return L[jum], jum
#     if L[jum-1] < L[jum]:
#         return munte(L, jum, dr)
#     if L[jum] > L[jum+1]:
#         return munte(L, st, jum)
#
#
# f = open("text.in")
# n = int(f.readline())
# numere = [int(i) for i in f.readline().split()]
#
# print(numere)
# print(munte(numere, 0, len(numere)-1))

# problema V2
# def mediana(L1, L2, st1, dr1, st2, dr2):
#     if dr1 == st1 + 1:
#         aux = sorted(L1[st1:dr1+1]+L2[st2:dr2+1])
#         return (aux[1] + aux[2]) / 2
#     pozmij1 = (st1 + dr1) // 2
#     pozmij2 = (st2 + dr2) // 2
#     if L1[pozmij1] == L2[pozmij2]:
#         return L1[pozmij1]
#     if L1[pozmij1] < L2[pozmij2]:
#         return mediana(L1, L2, pozmij1, dr1, st2, pozmij2)
#     if L1[pozmij1] > L2[pozmij2]:
#         return mediana(L1, L2, st1, pozmij1, pozmij2, dr2)
#
#
# l1 = [1, 12, 15, 16, 38]
# l2 = [2, 13, 17, 30, 45]
# print(mediana(l1, l2, 0, len(l1)-1, 0, len(l2)-1))

# problema M1 a)
# def completare(m, i, j, d):
#     global k
#     if d == 1:
#         m[i][j] = k
#         k += 1
#         return
#     else:
#         completare(m, i, j + d // 2, d // 2)
#         completare(m, i + d // 2, j, d // 2)
#         completare(m, i, j, d // 2)
#         completare(m, i + d // 2, j + d // 2, d // 2)
#
#
# n = int(input("n="))
# M = [[0]*2**n for _ in range(2**n)]
# k = 1
# completare(M, 0, 0, 2**n)
# for linie in M:
#     print(*linie)

# problema M1 b)
# ????????????????????????????????????????????????????????????????????????????????????????????????
def completare(M, i, j, d):
    global k
    if d == 1:
        M[i][j] = k
        k += 1
        return
    else:
        completare(M, i, j, d // 2)
        completare(M, i, j + d // 2, d // 2)
        completare(M, i + d // 2, j, d // 2)
        completare(M, i + d // 2, j + d // 2, d // 2)


n = int(input("n="))
m = int(input("m="))
M = [[0]*2**n for _ in range(2**m)]
k = 1
completare(M, 0, 0, 2**n)
for linie in M:
    print(*linie)

# problema M2
# la fel ca asta de dinainte,
#   _
# 0 |

# problema PD
