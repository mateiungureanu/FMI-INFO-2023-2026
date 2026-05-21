def bkt(dic, litere, stariFinale, stareCurenta, stariVizitate):
    if stareCurenta in stariFinale:
        global accepta
        accepta = True
    if stareCurenta not in stariVizitate:
        for i in litere:
            if (stareCurenta, i) in dic.keys():
                # print(f"{(stareCurenta, i)} -> {dic[(stareCurenta, i)]}")
                bkt(dic, litere, stariFinale, dic[(stareCurenta, i)], stariVizitate + [stareCurenta])


ok = 1
complet = 1
# A
f = open("input1.txt", 'r')
nrStariA = int(f.readline())
stariA = [int(i) for i in f.readline().split()]
nrLitereA = int(f.readline())
litereA = [i for i in f.readline().split()]
stareInitialaA = int(f.readline())
nrStariFinaleA = int(f.readline())
stariFinaleA = [int(i) for i in f.readline().split()]
nrTranzitiiA = int(f.readline())
tranzitiiAuxA = [f.readline() for _ in range(nrTranzitiiA)]
f.close()
tranzitiiA = []
for i in range(len(tranzitiiAuxA)):
    termeniA = tranzitiiAuxA[i].split();
    tranzitiiA += [(int(termeniA[0]), termeniA[1], int(termeniA[2]))]
dA = {}
for t in tranzitiiA:
    dA[(t[0], t[1])] = t[2]
for t in stariA:
    for i in litereA:
        if (t, i) not in dA.keys():
            complet = 0
            dA[(t, i)] = -1
if complet == 0:
    stariA += [-1]
    nrStariA += 1
    for i in litereA:
        dA[(-1, i)] = -1

# complementul lui A
nrStariFinaleComplementA = nrStariA - nrStariFinaleA
stariFinaleComplementA = [i for i in stariA if i not in stariFinaleA]

complet = 1
# B
g = open("input2.txt", 'r')
nrStariB = int(g.readline())
stariB = [int(i) for i in g.readline().split()]
nrLitereB = int(g.readline())
litereB = [i for i in g.readline().split()]
stareInitialaB = int(g.readline())
nrStariFinaleB = int(g.readline())
stariFinaleB = [int(i) for i in g.readline().split()]
nrTranzitiiB = int(g.readline())
tranzitiiAuxB = [g.readline() for _ in range(nrTranzitiiB)]
g.close()
tranzitiiB = []
for i in range(len(tranzitiiAuxB)):
    termeniB = tranzitiiAuxB[i].split();
    tranzitiiB += [(int(termeniB[0]), termeniB[1], int(termeniB[2]))]
dB = {}
for t in tranzitiiB:
    dB[(t[0], t[1])] = t[2]
for t in stariB:
    for i in litereB:
        if (t, i) not in dB.keys():
            complet = 0
            dB[(t, i)] = -1
if complet == 0:
    stariB += [-1]
    nrStariB += 1
    for i in litereB:
        dB[(-1, i)] = -1


# complementul lui B
nrStariFinaleComplementB = nrStariB - nrStariFinaleB
stariFinaleComplementB = [i for i in stariB if i not in stariFinaleB]

# intersectia lui A cu complementul lui B
nrstariC = nrStariA * nrStariB
stariC = [(i, j) for i in stariA for j in stariB]
stareInitialaC = (stareInitialaA, stareInitialaB)
stariFinaleC = [(i, j) for i in stariFinaleA for j in stariFinaleComplementB]
litereC = [i for i in litereA for j in litereB if i == j]
if litereC == []:
    print("nu recunosc acelasi limbaj")
    exit()
tranzitiiC = []
for t in stariC:
    for i in litereC:
        tranzitiiC += [(t, i, (dA[(t[0], i)], dB[(t[1], i)]))]
dC = {}
for t in tranzitiiC:
    dC[(t[0],t[1])] = t[2]

# intersectia lui B cu complementul lui A
nrstariD = nrStariA * nrStariB
stariD = [(i, j) for i in stariB for j in stariA]
stareInitialaD = (stareInitialaB, stareInitialaA)
stariFinaleD = [(i, j) for i in stariFinaleB for j in stariFinaleComplementA]
litereD = [i for i in litereB for j in litereA if i == j]
if litereD == []:
    print("nu recunosc acelasi limbaj")
    exit()
tranzitiiD = []
for t in stariD:
    for i in litereD:
        tranzitiiD += [(t, i, (dB[(t[0], i)], dA[(t[1], i)]))]
dD = {}
for t in tranzitiiD:
    dD[(t[0], t[1])] = t[2]

# print(stariFinaleC)

# print(dA)
# print(dB)
# print(dC)
# print(dD)
accepta = False
bkt(dC, litereC, stariFinaleC, stareInitialaC, [])
# print(accepta)
accepta1 = accepta
accepta = False
bkt(dD, litereD, stariFinaleD, stareInitialaD, [])
if accepta1 == False and accepta == False:
    print("recunosc acelasi limbaj")
else:
    print("nu recunosc acelasi limbaj")