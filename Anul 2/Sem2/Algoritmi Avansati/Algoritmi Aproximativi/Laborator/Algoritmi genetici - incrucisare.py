l = int(input())
x = input()
y = input()
i = int(input())

rezultat1 = x[:i] + y[i:]
rezultat2 = y[:i] + x[i:]
print(rezultat1)
print(rezultat2)