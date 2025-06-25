# Laborator 1
# problema 1
# n = int(input("n = "))
# invN = 0
# copieN = n
# while copieN:
#     invN = invN * 10 + copieN % 10
#     copieN = copieN // 10
# if n == invN:
#     print(n, "da")
# else:
#     print(n, "nu")

# problema 2
# n = int(input("n = "))
# difmax = 0
# ieri = float(input("nr = "))
# k = 1
# while k < n:
#     azi = float(input("nr = "))
#     dif = azi - ieri
#     if dif > difmax:
#         difmax = dif
#         ziua = k
#     ieri = azi
#     k += 1
# if difmax == 0:
#     print("nu a existat nicio crestere")
# else:
#     print(f"cea mai mare crestere este de {round(difmax,2)} intre zilele {ziua} si {ziua+1}")

# problema 3
# def cmmdc(a, b):
#     if a > b:
#         return cmmdc(a-b, b)
#     elif a < b:
#         return cmmdc(a, b-a)
#     else:
#         return a
#
# L1 = int(input("L1 = "))
# L2 = int(input("L2 = "))
# k = cmmdc(L1, L2)
# n = L1 // k * (L2 // k)
# print(n, k)

# problema 4
# n = int(input("n = "))
# max1 = max2 = None
# while n:
#     n -= 1
#     x = int(input("x = "))
#     if max1 is None or x > max1:
#         max2 = max1
#         max1 = x
# if max1 is not None:
#     print(max1, max2)
# else:
#     print("imposibil")

# problema 5
# a = int(input("a = "))
# b = int(input("b = "))
# c = int(input("c = "))
# d = b**2 - 4*a*c
# if d < 0:
#     print("nu are nicio radacina")
# elif d > 0:
#     print(f"are radacinile distincte x1={(-b+d**0.5)/(2*a)} si x2={(-b-d**0.5)/(2*a)}")
# else:
#     print(f"are radacina dubla x={(-b+d**0.5)/(2*a)}")

# problema 6 a)
# n = int(input("n = "))
# cn = n
# k = 9
# ctk = 0
# nr = 0
# while k:
#     while cn:
#         a = cn % 10
#         if a == k:
#             ctk += 1
#         cn //= 10
#     while ctk:
#         nr = nr * 10 + k
#         ctk -= 1
#     k -= 1
#     ctk = 0
#     cn = n
# print(nr)

# problema 6 b)
# n = int(input("n = "))
# cn = n
# k = 0
# ctk = 0
# nr = 0
# ct0 = 0
# while k < 10:
#     ctk = 0
#     cn = n
#     while cn:
#         if k == cn % 10:
#             ctk += 1
#         cn //= 10
#     if k == 0 and ctk > 0:
#         ct0 = ctk
#     if k != 0 and ctk > 0:
#         if nr == 0 and ct0 > 0:
#             nr = k
#             ctk -= 1
#             while ct0:
#                 nr = nr * 10
#                 ct0 -= 1
#         while ctk:
#             nr = nr * 10 + k
#             ctk -= 1
#     k += 1
# print(nr)

# problema 7
# x = int(input("x = "))
# n = int(input("n = "))
# p = int(input("p = "))
# m = int(input("m = "))
# d = 0
# while m:
#     cn = n
#     while cn:
#         cn -= 1
#         m -= 1
#         d += x
#     x = x - x * p / 100
# print(d)
