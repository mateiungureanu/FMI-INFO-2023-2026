# Laborator 3
# problema 1
# a)
# L = [chr(x) for x in range(ord('a'), ord('z'))]
# print(L)

# b)
# L = [x if x % 2 != 0 else -x for x in range(1, int(input("n="))+1)]
# print(L)
# L2 = [x * (-1) ** (x+1) for x in range(1, int(input("n="))+1)]
# print(L2)

# c)
# L = [1, 2, 3, 4, 5, 6, 7, 8, 9]
# L2 = [x for x in L if x % 2 != 0]
# print(L2)

# d)
# L = [1, 2, 9, 4, 5, 7, 1, 8, 9]
# L2 = [L[i] for i in range(len(L)) if i % 2 != 0]
# print(L2)
# L3 = [L[i] for i in range(1, len(L), 2)]
# print(L3)

# e)
# L = [2, 4, 1, 7, 5, 1, 8, 10]
# L2 = [L[i] for i in range(len(L)) if i % 2 == L[i] % 2]
# print(L2)
# L3 = [i[1] for i in enumerate(L) if i[0] % 2 == i[1] % 2]
# print(L3)
# L4 = [n for (m,n) in enumerate(L) if m % 2 == n % 2]
# print(L4)

# f)
# L = [1, 2, 3, 4]
# L2 = [(L[i], L[i+1]) for i in range(len(L)-1)]
# print(L2)

# g)
# matrice:
# M = [[(linie, coloana) for coloana in range(4)] for linie in range(3)]
# print(*M, sep='\n')

# n = int(input("n="))
# M = [[f"{x}*{y}={x*y}" for y in range(1, n+1)] for x in range(1, n+1)]
# for linie in M:
#     print(*linie, sep='\t')

# h)
# sir = "ABCDE"
# n = len(sir)
# l = ["".join([sir[(i+j)%n] for i in range(n)]) for j in range(n)]
# print(l)
# l1 = [sir[i:] + sir[:i] for i in range(n)]
# print(l1)

# i)
# n = int(input("n="))
# l = [[i]*i for i in range(n)]
# print(l)

# problema 2
# a)
# L = [46, 4, 6, 23, 10, 15, 53, 155]
# print(sorted(L, key=lambda x: str(x)))
# print(sorted(L, key=str))

# b)
# print(sorted(L, key=lambda x: str(x)[::-1]))

# c)
# L = [27, 533, 2422, 188888, 23211]
# print(sorted(L, key=lambda x: len(str(x)), reverse=True))

# d)
# print(sorted(L, key=lambda x: len(set(str(x)))))

# e)
# L = [1231, 11331, 1431, 12331, 11243]
# print(sorted(L, key=lambda x: (len(str(x)), x)))

# problema liste.1
# l1 = [int(x) for x in input("l1: ").split()]
# l2 = [int(x) for x in input("l2: ").split()]
# n = len(l1)
# for i in range(0, n, 2):
#     auxl1 = l1[i]
#     auxl2 = l2[i]
#     l1 = l1[:i] + [auxl2] + l1[i+1:]
#     l2 = l2[:i] + [auxl1] + l2[i+1:]
# print(l1, l2)

# problema liste.2
# lista = [int(x) for x in input("lista: ").split()]
# ok1 = None
# ok2 = None
# for i in range(len(lista)):
#     if lista[i] == 0:
#         if ok1 is None:
#             ok1 = i
#         elif ok2 is None:
#             ok2 = i
# lista = lista[:ok1] + lista[ok2 + 1:]
# print(lista)

# problema liste.3
# lista = [int(x) for x in input("lista: ").split()]
# print([x for x in lista if x != 0])

# problema liste.4
# lista = [int(x) for x in input("lista: ").split()]
# k = int(input("k="))
# s = 0
# ct = 0
# for i in range(len(lista)):
#     s += lista[i]
#     ct += 1
#     if ct == k:
#         ct = i
#         break
# smin = s
# smini = 0
# for i in range(ct, len(lista)):
#     s -= lista[i-k]
#     s += lista[i]
#     if s < smin:
#         smin = s
#         smini = i
# lista = lista[:smini - k + 1] + lista[smini + 1:]
# print(lista)

# problema liste.5
# lista = [int(x) for x in input("lista: ").split()]
# result = [lista[i] for i in range(len(lista)) if i == 0 or lista[i] != lista[i-1]]
# print(result)

# problema liste.6
# lista = [int(x) for x in input("lista: ").split()]
# result = []
# for i in range(len(lista)):
#     result.append(lista[i])
#     if lista[i] < 0:
#         result.append(0)
# print(result)

# problema sortari.1
# lista = [x for x in input("lista: ").split() if len(x) >= 2]
# print(" ".join(sorted(lista, key=lambda x: len(x), reverse=True)))

# problema sortari.2
# lista = [int(x) for x in input("lista: ").split()]
# print(sorted(lista, key=lambda x: (sum([int(i) for i in str(x)]), -x)))

# problema sortari.3 a)
# n = int(input('n='))
# lista = []
# for i in range(n):
#     lista += [[cuv for cuv in input().split(maxsplit=3)]]
#     lista[i][2] = int(lista[i][2])
#     lista[i][3] = [int(x) for x in lista[i][3].split()]
# print(lista)

# problema sortari.3 b)
# for i in range(n):
#     if min(lista[i][3]) < 5:
#         lista[i].append(False)
#     else:
#         lista[i].append(True)
# print(lista)

# problema sortari.3 c)
# lista = sorted(lista, key=lambda x: (x[2], x[0], x[1]))
# print(lista)

# problema sortari.3 d)
# lista = sorted(lista, key=lambda x: (x[2], -x[4], sum(int(i) for i in x[3] if i < 5), -sum(int(i) for i in x[3])/len(x[3]), x[0], x[1]))
# print(lista)

# problema sortari.3 e)
# print(max(lista, key=lambda x: sum(int(i) for i in x[3])/len(x[3]))[0], max(lista, key=lambda x: sum(int(i) for i in x[3])/len(x[3]))[1])

# problema sortari.4
# lista = [int(x) for x in input("lista: ").split()]
# lista = sorted(lista, key=lambda x: (-(x % 2), x * (-1) ** (x + 1)))
# print(lista)

# problema matrice.1
# metoda 1 citesc linie cu linie
# m = int(input("m="))
# n = int(input("n="))
# M = [[int(x) for x in input().split()] for i in range(m)]
# T = [[0 for x in range(m)] for j in range(n)]
# for i in range(n):
#     for j in range(m):
#         T[i][j] = M[j][i]
# for i in range(n):
#     print(*T[i])

# metoda 2 (ChatGPT) citesc toata matricea cu ctrl v
# matrice = [input() for i in range(m)]
# for i in range(m):
#     linie = [int(x) for x in matrice[i].split()]
#     M.append(linie)
# for i in range(m):
#     print(*M[i])

# problema matrice.2
# metoda 1
# m = int(input("m="))
# n = int(input("n="))
# M =[[int(input()) for j in range(n)] for i in range(m)]
# M = sorted(M, key=lambda x: x[0])
# for i in range(m):
#     for j in range(n):
#         x = str(M[i][j])
#         while len(x) < 5:
#             x += ' '
#         print(x, end=' ')
#     print()

# metoda 2
# m = int(input("m="))
# n = int(input("n="))
# M = [[int(input()) for j in range(n)] for i in range(m)]
# M = sorted(M, key=lambda x: x[0])
# M = [[str(x) + (5-len(str(x)))*" " for x in line] for line in M]
# print(M)

# problema matrice.3
# n = int(input("n="))
# M = [[0 for i in range(k)] for k in range(1, n+1)]
# for i in range(n):
#     M[i][0] = 1
#     M[i][i] = 1
# for i in range(2, n):
#     for j in range(1, i):
#         M[i][j] = M[i-1][j] + M[i-1][j-1]
# c = len(str(max(M[n-1])))
# M = [[str(x) + (c+1-len(str(x)))*" " for x in line] for line in M]
# for i in range(n):
#     print(*M[i])

# problema matrice.4
# n = int(input("n="))
# L = [i for i in range(2, n+1)]
# lista = []
# frecv = [0 for i in range(n+1)]
# for i in L:
#     ok = 1
#     for j in range(2, i):
#         if i % j == 0:
#             frecv[i] = 1
# for i in range(2, n+1):
#     if frecv[i] == 0:
#         print(i, end=' ')

# problema matrice.5
# m1 = input("m1: ").split()
# m2 = input("m2: ").split()
# reuniune = []
# intersectie = []
# i = 0
# j = 0
# while i < len(m1) and j < len(m2):
#     if m1[i] == m2[j]:
#         intersectie += m1[i]
#         reuniune += m1[i]
#         i += 1
#         j += 1
#     elif m1[i] < m2[j]:
#         reuniune += m1[i]
#         i += 1
#     elif m1[i] > m2[j]:
#         reuniune += m2[j]
#         j += 1
# if i == len(m1):
#     reuniune += m2[j:]
# elif j == len(m2):
#     reuniune += m1[i:]
# print(reuniune)
# print(intersectie)
