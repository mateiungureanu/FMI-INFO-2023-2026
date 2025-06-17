#laborator 1

# problema rucsacului - v fractionara
def rucsac_fractionar(n, C):
    valoare_totala = 0
    l.sort(key=lambda x: x[0]/x[1], reverse=True)
    for i in l:
        if C - i[1] >= 0:
            C -= i[1]
            valoare_totala += i[0]
        else:
            valoare_totala += i[0] * C / i[1]
            C = 0
    if int(valoare_totala) == valoare_totala:
        return int(valoare_totala)
    else:
        return "%.4f" % valoare_totala

# n = int(input())
# C = int(input())
# l = []
# for i in range(n):
#     v = int(input())
#     l += [[v, 0]]
# for i in l:
#     g = int(input())
#     i[1] = g
# print(f"{rucsac_fractionar(n, C)}")

# problema rucsacului - v discreta (1/0)

def rucsac_discret(i, C, memo):
    valoare_totala = 0
    
    if C == 0:
        return 0
    
    if memo[i - 1] != -1:
        return memo[i - 1]
    
    for j in range(1, i+1):
        if C - l[j-1][1] >= 0:
            valoare_totala = max(valoare_totala, l[j-1][0] + rucsac_discret(j - 1, C-l[j-1][1], memo))
            #                                     valoare                             greutate
    
    memo[i-1] = valoare_totala
    
    if int(valoare_totala) == valoare_totala:
        return int(valoare_totala)
    else:
        return "%.4f" % valoare_totala

n = int(input())
C = int(input())
l = []
for i in range(n):
    v = int(input())
    l += [[v, 0]]
for i in l:
    g = int(input())
    i[1] = g
memo = [-1] * (C+1)
print(rucsac_discret(n, C, memo))