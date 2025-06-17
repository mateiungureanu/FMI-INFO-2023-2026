
import copy

class NodArbore:
    def __init__(self, _informatie, _parinte=None, _g=0, _h=0):
        self.informatie = _informatie
        self.parinte = _parinte
        self.g=_g
        self.h=_h
        self.f=_g+_h
        
    def __lt__(self,elem):
        return self.f<elem.f or (self.f==elem.f and self.h<elem.h) 

    def drumRadacina(self):
        # Return the path from the root to the current node
        nod = self
        l = []
        while nod:
            l.append(nod.informatie)
            nod = nod.parinte
        return l[::-1]

    def inDrum(self, infoNod):
        # Check if a node is in the path from the root to the current node
        nod = self
        while nod:
            if nod.informatie == infoNod:
                return True
            nod = nod.parinte
        return False

    def __str__(self):
        return str(self.informatie)

    def __repr__(self):
        # Return a string representation of the node and its path
        sirDrum = "->".join(map(str, self.drumRadacina()))
        return f"{self.informatie}, cost:{self.g}, ({sirDrum})"

class Graf:
    def __init__(self,  _start, _scopuri):
        self.start = _start
        self.scopuri = _scopuri


    def valideaza(self):
        matrDesfasurata = self.start[0] + self.start[1] + self.start[2]
        nrInvers = 0
        matrDesfasurata.remove(0)
        for i, elem_i in enumerate(matrDesfasurata[:-1]):
            for j, elem_j in enumerate(matrDesfasurata[i+1:]):
                if elem_i > elem_j:
                    nrInvers += 1
        return nrInvers % 2 == 0\


    def estimeaza_h(self,infoNod):
        def distMH(l1, c1, l2, c2):
            return abs(l1 - l2) + abs(c1 - c2)

        h = 0
        for i, linie in enumerate(infoNod):
            for j, elem in enumerate(linie):
                if elem == 0:
                    continue
                iScop = (elem-1) // 3
                jScop = (elem-1) % 3
                h += distMH(i, j, iScop, jScop)
        return h
            
        
    def scop(self, informatieNod):
        return informatieNod in self.scopuri

    def succesori(self, nod):
        
        def gasesteGol (matr):
            for i, linie in enumerate(matr):
                for j, elem in enumerate(linie):
                    if elem == 0:
                        return i, j
        lSuccesori = []
        lGOl, cGol = gasesteGol(nod.informatie)
        directii = [-1, 0], [1, 0], [0, -1], [0, 1] # sus, jos, stanga, dreapta
        for d in directii:
            lPlacute = lGOl + d[0]
            cPlacuta = cGol + d[1]
            if 0 <= lPlacute < 2 and 0 <= cPlacuta < 2:
                infoSuccesor = copy.deepcopy(nod.informatie)
                infoSuccesor[lGOl][cGol], infoSuccesor[lPlacute][cPlacuta] = infoSuccesor[lPlacute][cPlacuta], infoSuccesor[lGOl][cGol]
                if not nod.inDrum(infoSuccesor):
                    nodNou = NodArbore(infoSuccesor, nod, nod.g + 1, self.estimeaza_h(infoSuccesor))
                    lSuccesori.append(nodNou)
        return lSuccesori


def aStar(gr):
    OPEN = [NodArbore(gr.start)]
    CLOSED=[]
    while OPEN:
        nodCurent = OPEN.pop(0)
        CLOSED.append(nodCurent)
        if gr.scop(nodCurent.informatie):
            print("Solutie: ", end="")
            print(repr(nodCurent))
            return
        lSuccesori=gr.succesori(nodCurent)
        gasitOPEN=False
        for s in lSuccesori:
            for nod in OPEN:
                if s.informatie==nod.informatie:
                    gasitOPEN=True
                    if s<nod:
                        OPEN.remove(nod)
                    else:
                        lSuccesori.remove(s)
                    break
            if not gasitOPEN:
                for nod in CLOSED:
                    if s.informatie==nod.informatie:
                        if s<nod:
                            CLOSED.remove(nod)
                        else:
                            lSuccesori.remove(s)
                        break
        OPEN+=lSuccesori
        OPEN.sort()  
    print("Nu avem solutii")      

f=open("input2.txt","r")
start = [list(map(int, linie.strip().split())) for linie in f.read().strip().split("\n")]
scopuri = [    [[1, 2, 3], [4, 5, 6], [7, 8, 0]]    ]
f.close()
print(start)
print(scopuri)
gr = Graf(start, scopuri)
if not gr.valideaza():
    print("Nu avem solutii")
else:
    aStar(gr)