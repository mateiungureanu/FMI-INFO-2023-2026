class NodArbore:
    def __init__(self, _informatie, _parinte=None):
        self.informatie = _informatie
        self.parinte = _parinte

    def drumRadacina(self):
        nod=self
        l=[]
        while nod:
            l.append(nod)
            nod = nod.parinte
        return l[::-1]

    def inDrum(self,infoNod):
        nod=self
        while nod:
            if nod.informatie == infoNod:
                return True
            nod = nod.parinte
        return False

    def __str__(self):
        return f"{self.informatie}"

    def __repr__(self):
        sirDrum = "->".join([str(nod) for nod in self.drumRadacina()])
        return f"{self.informatie}, ({sirDrum})"

class Graf:
    def __init__(self, _matr, _start, _scopuri):
        self.matr=_matr
        self.start=_start
        self.scopuri=_scopuri

    def scop(self, informatieNod):
        return informatieNod in self.scopuri

    def succesori(self, nod):
        lSuccesori=[]
        for infoSuccesor in range(len(self.matr)):
            conditieMuchie = self.matr[nod.informatie][infoSuccesor] == 1
            conditieNotInDrum = not nod.inDrum(infoSuccesor)
            if conditieMuchie and conditieNotInDrum:
                nodNou = NodArbore(infoSuccesor, nod)
                lSuccesori.append(nodNou)
        return lSuccesori

m = [
    [0, 1, 0, 1, 1, 0, 0, 0, 0, 0],
    [1, 0, 1, 0, 0, 1, 0, 0, 0, 0],
    [0, 1, 0, 0, 0, 1, 0, 1, 0, 0],
    [1, 0, 0, 0, 0, 0, 1, 0, 0, 0],
    [1, 0, 0, 0, 0, 0, 0, 1, 0, 0],
    [0, 1, 1, 0, 0, 0, 0, 0, 0, 0],
    [0, 0, 0, 1, 0, 0, 0, 0, 0, 0],
    [0, 0, 1, 0, 1, 0, 0, 0, 1, 1],
    [0, 0, 0, 0, 0, 0, 0, 1, 0, 0],
    [0, 0, 0, 0, 0, 0, 0, 1, 0, 0]
]

def BF(gr, nsol):
    coada = [NodArbore(gr.start)]
    while coada:
        nodCurent = coada.pop(0)
        if gr.scop(nodCurent.informatie):
            print("Solutie: ", end="")
            print(repr(nodCurent))
            nsol-=1
            if nsol == 0:
                return
        coada+=gr.succesori(nodCurent)

def depth_first(gr, nsol=1):
    DF(NodArbore(gr.start), nsol)

def DF(nodCurent, nsol):
    if nsol <= 0:  
        return nsol
    #print("Stiva actuala: " + repr(nodCurent.drumRadacina()))

    if gr.scop(nodCurent.informatie):
        print("Solutie: ", end="")
        print(repr(nodCurent))
        
        nsol -= 1
        if nsol == 0:
            return nsol
    lSuccesori = gr.succesori(nodCurent)
    for sc in lSuccesori:
        if nsol != 0:
            nsol = DF(sc, nsol)

    return nsol

def DF_nerecursiv(gr, nsol):
    stiva = [NodArbore(gr.start)]
    while stiva:
        nodCurent = stiva.pop()
        if gr.scop(nodCurent.informatie):
            print("Solutie: ", end="")
            print(repr(nodCurent))
            nsol-=1
            if nsol == 0:
                return
        stiva+=gr.succesori(nodCurent)

start = 0
scopuri = [5, 9]
gr=Graf(m,start,scopuri)
# BF(gr, 4)
# depth_first(gr, 4)
DF_nerecursiv(gr,4)  