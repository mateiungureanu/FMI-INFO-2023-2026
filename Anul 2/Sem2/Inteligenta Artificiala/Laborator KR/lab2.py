#inlocuiti fiecare comentariu TODO 
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
        
    def estimeaza_h(self,infoNod):
        if self.scop(infoNod):
            return 0
        minH = float("inf")
        for scop in self.scopuri:
            h = 0
            for iScop, stivaScop in enumerate(scop):
                for iBloc, bloc in enumerate(stivaScop):
                    try:
                        if bloc != infoNod[iScop][iBloc]:
                            h += 1
                    except:
                        h += 1
            if minH > h:
                minH = h
        return minH

    def scop(self, informatieNod):
        # Check if a node is a goal node
        return informatieNod in self.scopuri

    def succesori(self, nod):
        lSuccesori = []
        for i, istiva in enumerate(nod.informatie):
            if not istiva:
                continue
            copieStive = copy.deepcopy(nod.informatie)
            bloc = copieStive[i].pop()
            for j, jstiva in enumerate(copieStive):
                if i==j:
                    continue
                infoSuccesor = copy.deepcopy(copieStive)
                infoSuccesor[j].append(bloc)
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

def obtineStive(sirStive):
    return [sir.strip().split() if sir != "#" else [] for sir in sirStive.strip().split("\n")]
    

f=open("input1.txt","r")
sirStart, sirScopuri = f.read().split("=========")
start = obtineStive(sirStart)
scopuri = [obtineStive(sir) for sir in sirScopuri.split("---")]
f.close()
gr = Graf(start, scopuri)
aStar(gr)
