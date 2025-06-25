# Laborator 7
# problema 1
# n = int(input("n="))
# v = [0] * (n+1)
# lungimi = [1, 2, 3]
# for i in lungimi:
#     v[i] = 1  # salt direct
# for i in lungimi:
#     for j in range(i+1, n+1):
#         v[j] += v[j-i]
# print(v)


# problema 2
# def f(n):
#     if n == 1:
#         return 0
#     if n % 2 == 0:
#         return 1 + f(n // 2)
#     else:
#         return 1 + f(3 * n + 1)
#
#
# n = int(input("n="))
# print(f(n))


# def f2(d, n):
#     if n == 1:
#         d[1] = 0
#         return d[n]
#     if n%2 == 0:
#         if n//2 not in d:
#             f2(d, n//2)
#         d[n] = 1+d[n//2]
#         return d[n]
#     else:
#         if 3*n+1 not in d:
#             f2(d, 3*n+1)
#         d[n] = 1+d[3*n+1]
#         return d[n]
#
#
# n = int(input("n="))
# d = {}
# f2(d, n)
# print(d)
# print(d[n])


# problema 5
# s = input("s:")  # subisr
# t = input("t:")  # rustice
# M = [[0] * (len(t) + 1) for i in range(len(s) + 1)]
# for i in range(1, len(s) + 1):
#     for j in range(1, len(t) + 1):
#         if s[i - 1] == t[j - 1]:
#             M[i][j] = 1 + M[i - 1][j - 1]
#         else:
#             M[i][j] = max(M[i][j - 1], M[i - 1][j])
#
# for linie in M:
#     print(*linie, sep=" ")
#
# rez = ""
# i = len(s)
# j = len(t)
# while i != 0 and j != 0:
#     if s[i - 1] == t[j - 1]:
#         rez = s[i - 1] + rez
#         i -= 1
#         j -= 1
#     elif M[i-1][j] >= M[i][j-1]:
#         i -= 1
#     else:
#         j -= 1
# print(rez)

# ce face codu de mai sus?????????????????????????????????????????????????????????????????????
