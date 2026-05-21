def lambda_tranzitie(stare, dic):
    tranzitie = {stare}
    if (stare, '') in dic:
        for stareaUrm in dic[(stare, '')]:
            tranzitie |= lambda_tranzitie(stareaUrm, dic)
    return tranzitie


def bkt(vector, dic, finale, words, indexCuvant, indexLitera, stare):
    tranzitie = lambda_tranzitie(stare, dic)
    if indexLitera == len(words[indexCuvant]):
        if any(s in finale for s in closure):
            vector[indexCuvant] = 1
    else:
        for s in closure:
            if (s, words[indexCuvant][indexLitera]) in dic:
                for next_state in dic[(s, words[indexCuvant][indexLitera])]:
                    bkt(vector, dic, finale, words, indexCuvant, indexLitera + 1, next_state)
            if (s, '') in dic:
                for next_state in dic[(s, '')]:
                    bkt(vector, dic, finale, words, indexCuvant, indexLitera, next_state)


f = open("gpt.txt", 'r')
nrStari = int(f.readline())
stari = [int(i) for i in f.readline().split()]
nrLitere = int(f.readline())
litere = [i for i in f.readline().split()]
stareInitiala = stari.index(int(f.readline()))
nrStariFinale = int(f.readline())
stariFinale = [stari.index(int(i)) for i in f.readline().split()]
nrTranzitii = int(f.readline())
tranzitiiAux = [f.readline() for _ in range(nrTranzitii)]
nrCuvinte = int(f.readline())
cuvinte = []
for _ in range(nrCuvinte):
    cuvinte += f.readline().split()
f.close()
tranzitii = []
for i in tranzitiiAux:
    termen1 = None
    termen2 = None
    termen3 = None
    j = 0
    while i[j] != ' ':
        if termen1 is None:
            termen1 = i[j]
        else:
            termen1 += i[j]
        j += 1
    j += 1
    while i[j] != ' ':
        if termen2 is None:
            termen2 = i[j]
        else:
            termen2 += i[j]
        j += 1
    j += 1
    termen3 = i[j:]
    tranzitii += [(int(stari.index(int(termen1))), termen2, int(stari.index(int(termen3))))]
d = {}
for t in tranzitii:
    if t[1] == '.':
        tranzitie = ''
    else:
        tranzitie = t[1];
    if (t[0], tranzitie) not in d.keys():
        d[(t[0], tranzitie)] = [t[2]]
    else:
        d[(t[0], tranzitie)] += [t[2]]
stareCurenta = stareInitiala
print(stari)
print(tranzitii)
print(stareCurenta)
print(stariFinale)
print(d)
v = [0 for _ in range(nrCuvinte)]
for i in range(nrCuvinte):
    bkt(v, d, stariFinale, cuvinte, i, 0, stareCurenta)
for i in v:
    if i == 1:
        print("DA")
    else:
        print("NU")
