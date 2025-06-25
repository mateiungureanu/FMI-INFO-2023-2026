lk = input()
l, k = map(int, lk.split())
c = input()
iuri = input().split()
for i in iuri:
    c = c[:int(i)] + str(1 - int(c[int(i)])) + c[int(i)+1:]
print(c)