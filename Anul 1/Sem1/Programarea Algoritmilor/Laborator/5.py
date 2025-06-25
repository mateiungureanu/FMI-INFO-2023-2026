# Laborator 5
# problema 3
# def citire():
#     f = open("cuburi.txt", "r")
#     L = []
#     n = int(f.readline())
#     for linie in f:
#         lat, cul = linie.split()
#         L.append((int(lat), cul))
#     f.close()
#     return n, L
#
#
# def greedy(Lcuburi):
#     Lcuburi.sort(key=lambda t: -t[0])
#     # Lcuburi.sort(reverse=True)
#     h = Lcuburi[0][0]
#     sol = [Lcuburi[0]]
#     for lat, cul in Lcuburi[1:]:
#         if cul != sol[-1][1]:
#             sol.append((lat, cul))
#             h += lat
#     return sol, h
#
#
# def afisare(sol, h):
#     g = open("turn.txt", "w")
#     Lafisare = []
#     for cub in sol:
#         Lafisare.append("{} {}\n".format(*cub))
#     Lafisare.append(f"\nInalime totala: {h}")
#     g.writelines(Lafisare)
#     g.close()
#
#
# n, Lcuburi = citire()
# print(Lcuburi)
# Lturn, hturn = greedy(Lcuburi)
# print(Lturn, hturn)
# afisare(Lturn, hturn)

# problema 5
# def citire():
#     f = open("activitati.txt")
#     n = int(f.readline())
#     Lactiv = []
#     for linie in f:
#         durata, termen = linie.split()
#         Lactiv.append((int(durata), int(termen)))
#     f.close()
#     return Lactiv
#
#
# def greedy(Lactivitati):
#     Lactivitati.sort(key=lambda t: t[1])
#     intarziere_max = 0
#     t_curent = 0
#     sol = []  # (start,durata,termen,intarziere)
#     for durata, termen in Lactivitati:
#         intarziere = max(0, (t_curent + durata) - termen)
#         if intarziere_max < intarziere:
#             intarziere_max = intarziere
#         sol.append((t_curent, durata, termen, intarziere))
#         t_curent += durata
#     return sol, intarziere_max
#
#
# def afisare(sol, intarziere_max):
#     g = open("intarzieri.txt", "w")
#     g.write("Interval\t Termen \tIntarziere\n")
#     for start, durata, termen, intarziere in sol:
#         g.write(f"({start} --> {start + durata})\t\t{termen}\t\t{intarziere}\n")
#     g.write(f"Intarzierea maxima: {intarziere_max}")
#     g.close()
#
#
# Lactivitati = citire()
# print(Lactivitati)
# sol, intarziere_max = greedy(Lactivitati)
# print(sol, intarziere_max)
# afisare(sol, intarziere_max)

# problema 1
# def citire():
#     f = open("tis.txt", "r")
#     L = [int(i) for i in f.readline().split()]
#     L.sort(key=lambda x: x)
#     s = 0
#     print(L)
#     lista = []
#     for i in range(0, len(L)):
#         s += L[i]
#         tuplu = (i, s)
#         lista.append(tuplu)
#     return lista
#
#
# lista = citire()
# print(lista)
# print("{0:.2f}".format(sum(t[1] for t in lista)/len(lista)))


# problema 2
# def citire():
#     f = open("spectacole.txt")
#     L = []
#     sir = f.readline()
#     while sir:
#         ora1 = sir.split("-")[0]
#         ora2 = sir.split("-")[1].split(maxsplit=1)[0]
#         nume = sir.split("-")[1].split(maxsplit=1)[1]
#         L += [(ora1, ora2, nume)]
#         sir = f.readline()
#     f.close()
#     return L
#
#
# lista = citire()
# lista.sort(key=lambda t: t[1])
# orasf = 0
# g = open("programari.txt", "a")
# for i in range(0, len(lista)):
#     if lista[i][0] > str(orasf):
#         g.write(f"{lista[i][0]}-{lista[i][1]} {lista[i][2]}")
#         orasf = lista[i][0]
# g.close()

# problema 4
# def citire():
#     f = open("bani.txt")
#     L = [int(x) for x in f.readline().split()]
#     s = int(f.read())
#     f.close()
#     return L, s
#
#
# lista, suma = citire()
# lista.sort(key=lambda x: -x)
# i = 0
# g = open("plata.txt", "a")
# g.write(f"{suma} = ")
# while suma > 0:
#     if lista[i] > suma:
#         i += 1
#     else:
#         imp = suma // lista[i]
#         suma -= imp*lista[i]
#         if lista[i] != 1:
#             g.write(f"{lista[i]}*{imp} + ")
#         else:
#             g.write(f"{lista[i]}*{imp}")
#         i += 1
# g.close()

# problema 6
# def citire():
#     f = open("evenimente.txt")
#     L = []
#     sir = f.readline()
#     while sir:
#         ora1 = sir.split("-")[0]
#         ora2 = sir.split("-")[1].split()[0]
#         nume = sir.split("-")[1].split()[1]
#         L += [(ora1, ora2, nume)]
#         sir = f.readline()
#     f.close()
#     return L
#
#
# lista = citire()
# lista.sort(key=lambda t: t[0])
# sali = [[] for i in range(len(lista))]
# sali[0] += [lista[0]]
# for i in range(1, len(lista)):
#     for j in range(len(lista)):
#         if not sali[j]:
#             sali[j] += [lista[i]]
#             break
#         if lista[i][0] >= sali[j][-1][1]:
#             sali[j] += [lista[i]]
#             break
# while [] in sali:
#     sali.remove([])
# g = open("sali.txt", "a")
# g.write(f"Numar minim de sali: {len(sali)}")
# print(sali)
# for i in range(len(sali)):
#     g.write(f"\n\nSala {i+1}:\n")
#     for t in sali[i]:
#         if sali[i][0] == t:
#             g.write(f"({t[0]}-{t[1]} {t[2]})")
#         else:
#             g.write(f", ({t[0]}-{t[1]} {t[2]})")
# g.close()

# problema 7
# def citire():
#     f = open("obiecte.txt")
#     L = []
#     g = int(f.readline())
#     sir = f.readline()
#     while sir:
#         L += [tuple(int(x) for x in sir.split())]
#         sir = f.readline()
#     f.close()
#     return g, L
#
#
# masa, listaN = citire()
# lista = sorted(listaN, key=lambda t: -t[1]/t[0])
# i = 0
# procent = 0
# castig = 0
# l = []
# g = open("rucsac.txt", "a")
# while masa:
#     if lista[i][0] < masa:
#         masa -= lista[i][0]
#         castig += lista[i][1]
#         l += [listaN.index(lista[i])+1]
#     else:
#         procent = masa/lista[i][0]
#         castig += lista[i][0]*procent
#         masa = 0
#         l += [listaN.index(lista[i])+1]
#     i += 1
# g.write(f"Castig maxim: {castig}\n\nObiecte incarcate:\n")
# for i in l[:-1]:
#     g.write(f"Obiect {i}: 100.00%\n")
# g.write(f"Obiect {l[-1]}: {procent*100:.2f}%\n")
# g.close()

# problema 8
# def clear_file(filename):
#     with open(filename, "w") as f:
#         f.write('')
#
#
# def citire():
#     f = open("proiecte.txt")
#     L = []
#     sir = f.readline()
#     while sir:
#         L += [[x for x in sir.split()]]
#         sir = f.readline()
#     L.sort(key=lambda t: -int(t[2]))
#     f.close()
#     return L
#
#
# clear_file("profit.txt")
# g = open("profit.txt", "a")
# lista = citire()
# profit = 0
# m = int(max(t[1] for t in lista))
# print(m, lista)
# dic = {}
# i = 0
# while i < m + 1:
#     if lista[i][1] not in dic:
#         dic[lista[i][1]] = lista[i]
#         profit += int(lista[i][2])
#         i += 1
#     elif lista[i][1] != "1":
#         lista[i][1] = str(int(lista[i][1]) - 1)
#     else:
#         i += 1
# for i in sorted(dic.keys()):
#     g.write(f"Ziua {int(i)}: {dic[i][0]}\n")
# g.write("Profit maxim: ")
# ok = 0
# print(dic)
# for i in dic:
#     if ok == 0:
#         g.write(f"{dic[i][2]}")
#         ok = 1
#     else:
#         g.write(f"+{dic[i][2]}")
# g.write(f"={profit}")
# g.close()

# problema 9
# def citire():
#     f = open("intervale.txt")
#     L = []
#     sir = f.readline()
#     while sir:
#         L += [[int(x) for x in sir.split()]]
#         sir = f.readline()
#     L.sort(key=lambda t: t[1])
#     f.close()
#     return L
#
#
# lista = citire()
# print(lista)
# g = open("acoperire.txt", "a")
# cui = lista[0][1]
# g.write(f"{cui}\n")
# for i in range(1, len(lista)):
#     if not (lista[i][0] <= cui <= lista[i][1]):
#         cui = lista[i][1]
#         g.write(f"{cui}\n")

# problema 10
# def citire():
#     f = open("intervale1.txt")
#     L = []
#     sir = f.readline()
#     while sir:
#         L += [[int(x) for x in sir.split()]]
#         sir = f.readline()
#     L.sort(key=lambda t: (t[0], -t[1]))
#     f.close()
#     return L
#
#
# lista = citire()
# print(lista)
# g = open("reuniune.txt", "a")
# g.write("Reuniunea intervalelor:\n")
# si = lista[0][0]
# fi = 0
# l = 0
# for i in range(len(lista)):
#     if lista[i][0] < lista[i-1][1]:
#         if fi < lista[i][1]:
#             fi = lista[i][1]
#     else:
#         g.write(f"[{si}, {fi}]\n")
#         l += (fi-si)
#         si = lista[i][0]
#         fi = lista[i][1]
# g.write(f"[{si}, {fi}]\n")
# l += (fi-si)
# g.write(f"\nLungimea reuniunii: {l}")
# g.close()

# problema 11
# def citire():
#     f = open("lungimi2.txt")
#     L = []
#     sir = f.readline()
#     while sir:
#         nume, lungime = sir.split()
#         lungime = int(lungime)
#         L += [(lungime, nume)]
#         sir = f.readline()
#     L.sort(key=lambda t: t[0])
#     f.close()
#     return L
#
#
# lista = citire()
# g = open("interclasari.txt", "a")
# k = 0
# aux = []
# while len(lista) > 1:
#     k += 1
#     g.write(f"Pas {k}:\nStructura contine: ")
#     for t in lista:
#         if t == lista[0]:
#             g.write(f"({t[0]}, {t[1]})")
#         else:
#             g.write(f", ({t[0]}, {t[1]})")
#     lista += [(lista[0][0]+lista[1][0], 'L'+str(int(lista[-1][1][1])+1))]
#     aux += [lista[-1][0]]
#     g.write(f".\nDin vectorii ({lista[0][0]}, {lista[0][1]}) si ({lista[1][0]}, {lista[1][1]}) rezulta ({lista[-1][0]}, {lista[-1][1]}).\n\n")
#     lista.remove(lista[0])
#     lista.remove(lista[0])
# g.write(f"Pas {k+1}:\nStructura contine: ({lista[0][0]}, {lista[0][1]}).\n\n")
# g.write("Numar total deplasari: ")
# for i in aux:
#     if i == aux[0]:
#         g.write(str(i))
#     else:
#         g.write(f" + {i}")
# g.write(f" = {sum(x for x in aux)}.")
# g.close()
