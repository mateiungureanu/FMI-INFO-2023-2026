# Laborator 4
# problema 1 a)
# def frecventa(*nume_fisiere):
#     D = {}
#     for nume in nume_fisiere:
#         f = open(nume)
#         L_cuv = f.read().split()
#         for cuv in L_cuv:
#             # if cuv not in D:
#             #     D[cuv] = 1
#             # else:
#             #     D[cuv] += 1
#             D[cuv]=D.get(cuv, 0) + 1
#         f.close()
#     return D

# peoblema 1 b)
# D12 = frecventa("cuvinte1.in", "cuvinte2.in")
# print(D12)
# print(D12.items())
# print(sorted(D12.keys()))

# problema 1 c)
# D1 = frecventa("cuvinte1.in")
# print(D1)
# print(sorted(D1.items(), key = lambda t : t[1], reverse = True))
# print(sorted(D1.items(), key = lambda t : -t[1]))

# problema 1) d)
# D2 = frecventa("cuvinte2.in")
# print(D2)
# print(sorted(D2.items(), key = lambda t : (-t[1], t[0])))
# print(min(D2.items(), key = lambda t : (-t[1], t[0]))[0])

# problema 1 e)
# S12 = sum([D1.get(cuv, 0) * D2.get(cuv, 0) for cuv in D12.keys()])
# S1 = sum([frecv ** 2 for frecv in D1.values()]) ** 0.5
# S2 = sum([frecv ** 2 for frecv in D2.values()]) ** 0.5
# rez = round(S12 / (S1 * S2), 2)
# print(rez)

# problema 3
# with (open("test.in", "r") as f):
#     lista = []
#     nota = 1
#     for line in f:
#         aux, rez = line.split("=")
#         x, y = aux.split("*")
#         if int(x) * int(y) == int(rez):
#             nota += 1
#             lista.append(f"{line.strip()} Corect")
#         else:
#             lista.append((f"{line.strip()} Gresit {int(x) * int(y)}"))
#     lista.append(f"Nota {nota}")
#
# with (open("test.out", "w")) as g:
#     g.write("\n".join(lista))

# problema 5
# def negative_pozitive(lista_numere):
#     lista_poz = [x for x in lista_numere if x > 0]
#     lista_neg = [x for x in lista_numere if x < 0]
#     return lista_neg, lista_poz
#
# nume = input("nume fisier: ") # numere.txt
# with open(nume, "r") as f:
#     lnr  = [int(x) for x in f.read().split()]
#     print(lnr)
# lneg, lpoz = negative_pozitive(lnr)
#
# with open(nume, "a") as g:
#     g.write("\n".join([str(x) for x in sorted(lneg)]))
#     g.write("\n".join([str(x) for x in sorted(lpoz)]))

# problema 8 b)
# def liste_x(x, *Liste):
#     global nr
#     for L in Liste:
#         if x in L:
#             nr += 1
#
# nr = 0
# liste_x(3, [1, 5, 7], [3], [1, 8, 3], [4, 3])
# print(nr)

# problema 9
# def alipire(*numere):
#     rez = int("".join([max(str(x)) for x in numere]))
#     return rez
#
# def binary(a, b, c):
#     aux = alipire(a, b, c)
#     return alipire(aux) == 1  # True daca e 1, False daca nu e 1

# problema 2
# p = int(input("p="))
# nume = input("nume fisier: ")
# g = open("rime.txt", "a")
# with open(nume, "r") as f:
#     D = {}
#     for cuv in f.read().split():
#         if cuv[-p:] in D.keys():
#             D[cuv[-p:]].append(cuv)
#         else:
#             D[cuv[-p:]] = [cuv]
#     for key in D.keys():
#         D[key].sort(reverse=True)
#     for key in sorted(D, key=lambda t: -len(D[t])):
#         print(*D[key], file=g, end='\n')
#     g.close()

# problema 4
# import random
# f = open("date.in", "r")
# g = open("date.out", "a")
# for linie in f.readlines():
#     email = linie.split()[1].lower() + "." + linie.split()[0].lower() + "@s.unibuc.ro"
#     parola = chr(random.randrange(ord('A'), ord('Z')+1))
#     for i in range(3):
#         parola += chr(random.randrange(ord('a'), ord('z')+1))
#     for i in range(4):
#         parola += str(random.randrange(0, 10))
#     print(email, parola, file=g, end='\n')
# f.close()
# g.close()

# problema 6 a)
# f = open("elevi.in", "r")
# d = {}
# for i in f.readlines():
#     d[int(i.split()[0])] = [i.split()[1], i.split()[2], [int(x) for x in i.split(maxsplit=3)[3].split()]]
# print(d)
# f.close()

# problema 6 b)
# def marire_note(cnp, dictionar):
#     if cnp in dictionar.keys():
#         dictionar[cnp][2][0] += 1
#     else:
#         return None
#     return dictionar[cnp][2][0]
#
#
# x = int(input())
# print(marire_note(x, d))


# problema 6 c)
# def adauga_note(cnp, lista, dictionar):
#     if cnp in dictionar.keys():
#         dictionar[cnp][2] += lista
#     else:
#         return None
#     return dictionar[cnp][2]
#
#
# x = int(input())
# l_note = [10, 8]
# print(adauga_note(x, l_note, d))

# problema 6 d)
# def delete(cnp, dictionar):
#     dictionar.pop(cnp, None)
#
#
# x = int(input())
# delete(x, d)
# print(d)

# problema 6 e)
# L = [[d[i][0], d[i][1], d[i][2]] for i in d]
# L = sorted(L, key=lambda x: (-sum(int(j) for j in x[2])/len(x[2]), x[0], x[1]))
# print(L)
# with open("elevi.out", "a") as g:
#     g.write("\n".join(" ".join(str(x) for x in i) for i in L))

# problema 6 f)
# import random
# import string
#
# def parola(dictionar):
#     for cnp in dictionar:
#         dictionar[cnp].append("")
#         for j in range(3):
#             dictionar[cnp][3] += random.choice(string.ascii_letters)
#         for j in range(3):
#             dictionar[cnp][3] += str(random.randrange(0, 10))
#
#
# parola(d)
# print(d)

# problema 7
# rezolvarea mea
# def citire(lista):
#     l = [int(x) for x in input("lista:").split()]
#     for i in range(len(l)):
#         lista.append(l[i])
#
#
# def f(s, x, i=0, j=-1):
#     if j == -1:
#         j = len(s)
#     for k in range(i, j):
#         if x <= s[k]:
#             return k
#     return -1
#
#
# L = []
# citire(L)
# n = len(L)
# ok = 1
# for i in range(n-1):
#     if f(L, L[i], i+1) != -1:
#         ok = 0
# if ok == 0:
#     print("Nu")
# else:
#     print("Da")

# rezolvara la laborator
# def citire():
#     n = int(input("n="))
#     L = []
#     for i in range(n):
#         L.append(int(input(f"elementul{i+1}: ")))
#     return L
#
#
# def functie(s, x, i=0, j=None):
#     if j is None:
#         j = len(s)
#     for poz in range(i, j):
#         if s[poz] > x:
#             return poz
#     return -1
#
#
# L = citire()
# print(L)
# print(functie([1, 4, 5, 5, 3], 2))


# problema 8 a)
# def f(k, *functii):
#     nr = 0
#     for i in functii:
#         if k in i:
#             nr += 1
#     return nr
#
#
# x = int(input())
# print(f(3, [1, 5, 7], [3], [1, 8, 3], [4, 3]))

# problema 10
# def cautare_cuvant(cuv, nume_fis_out, *nume_fis_in):
#     g = open(nume_fis_out, "a")
#     for fisier in nume_fis_in:
#         g.write(fisier)
#         g.write(' ')
#         f = open(fisier, "r")
#         s = f.readlines()
#         for linie in s:
#             if cuv in linie or cuv.capitalize() in linie:
#                 g.write(str(s.index(linie)+1))
#                 g.write(' ')
#         g.write("\n")
#         f.close()
#     g.close()
#
#
# cautare_cuvant("floare", "rez.txt", "eminescu.txt", "paunescu.txt")
