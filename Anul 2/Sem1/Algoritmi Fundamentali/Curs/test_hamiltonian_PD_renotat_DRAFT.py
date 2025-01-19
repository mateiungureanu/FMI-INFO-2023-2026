n=4
#l_muchii=[[1,2],[1,4],[2,3],[3,4],[5,4],[1,5]]
l_muchii=[[1,3],[2,3],[2,4],[1,4]]


adj=[[] for i in range(n)]
for x,y in l_muchii:
    adj[y-1].append(x-1)
    adj[x-1].append(y-1)
#noduri 0,...n-1
#multimi- reprezentate ca siruri binare,memorate in baza 10 (x)
# un nod apartine unei multimi - pozitia in bit
nr_submult= 1 << n
dp=[[False for i in range(nr_submult)] for j in range(n)]
#dp[nod][x]=True <=> exista lant elementar de la 0 (nu 1 - noduri numerotate de la 0) la nod cu multimea nodurilor data de mask
#initial stim ca exista lant doar de la 0 la 0 cu multimea de noduri {0} - codificata 0..01, deci 1
dp[0][1]=True #de la 0 la 0 !!!nu 1
for x in range(1, nr_submult): #toate sumbultimile nevide
    for i in range(n):
        if x & (1<<i): # i este in submultime
            #dp[j][x] este True daca
            #exista un vecin u al lui j astfel incat
            #avem drum de la 0 la u prim multimea corespunzatoare
            # lui x fara elementul j
            for j in adj[i]: #vecinii  lui i
                if (x & (1<<j)!=0)  and dp[j][x^(1<<i)]:  #(j este in S)
                    dp[i][x]=True #dp[j][S-{i}]

#exista circuit hamiltonian daca si numai daca
#exista un vecin i al lui 0 astfel incat
#avem lant hamiltonian de la 0 la i, deci care trece prin
#toate nodurile, adica prin multimea codificata 11...1 = nr_submult - 1
for i in range(n):
    if dp[i][nr_submult - 1] and (i in adj[0]):
        print("da")
        break
else:
    print("nu")
print(*[bin(x) for x in range(1, nr_submult) if x & 1 ])
for i in range(n):
    print(*[dp[i][x] for x in range(1, nr_submult) if x & 1])