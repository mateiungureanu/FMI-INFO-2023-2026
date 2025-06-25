# Laborator 2
# problema 1
# sir = input("sir=")
# rez = sir.replace(sir[0], "")
# print(f"Dupa stergerea literei \'{sir[0]}\', sirul obtinut este \"{rez}\" de lungime {len(sir)}")
# print(sir.split(sir[0]))
# rez2 = "".join(sir.split(sir[0]))
# print("Dupa stergerea literei \'{}\', sirul obtinut este \"{}\" de lungime {}".format(sir[0], rez2, len(rez2)))

# problema 3
# s = input("s=")
# for i in range(len(s)//2 + len(s)%2):
#     print(s[i:len(s)-i].center(len(s), " "))

# problema 4
# x = input("x=")
# sg = input("sg=")
# sc = input("sc=")
# s = x.replace(sg,sc)
# print(s)
# r = x.replace(sg,sc,2)
# if "ger" in r:
#     print("textul contine prea multe greseli, doar 2 au fost corectate")
# else:
#     print(r)

# problema 5
# prop = input("prop=")
# s = input("s=")
# t = input("t=")
# l = prop.split(" ")
# # gresit
# # for x in l:
# #     if x == s:
# #         x = t
# # corect
# for i in range(len(l)):
#     if l[i] == s:
#         l[i] = t
# print(l)
# rez = " ".join(l)
# print(rez)

# problema 6 a)
# s = input("s=")
# output = ""
# nr = 0
# for c in s:
#     if c.isdigit():
#         nr = nr * 10 + int(c)
#     else:
#         output += c * nr
#         nr = 0
# print(output)

# problema 6 b)
# s = input("s=")
# nr = 1
# rez = ""
# for i in range(1,len(s)):
#     if s[i] == s[i-1]:
#         nr += 1
#     else:
#         rez += str(nr)
#         rez += s[i-1]
#         nr = 1
# rez += str(nr)
# rez += s[-1]
# print(rez)

# problema 7
# s = input("s=")
# rez = s.split(" ")
# suma = 0
# for i in range(len(rez)):
#     if rez[i].isdigit() == 1:
#         suma += int(rez[i])
# print(suma)

# problema 8
# s = input("s=")
# x = s.split(" ")
# ok = True
# if len(x) > 2:
#     ok = False
# ctliteramare = 0
# ctcratima = 0
# for i in x:
#     for j in i:
#         if 'A' <= j <= 'Z':
#             ctliteramare += 1
#         elif j == '-':
#             ctcratima += 1
#         elif not ('a' <= j <= 'z'):
#             ok = False
# if ctliteramare < 2 or (ctliteramare == 2 and ctcratima != 0) or (ctliteramare == 3 and ctcratima != 1) or (ctliteramare == 4 and ctcratima != 2):
#     ok = False
# if ok is True:
#     print("nume valid")
# else:
#     print("nume invalid")

# problema 9 a)
# s = input("s=")
# k = int(input("k="))
# rez = ""
# for i in s:
#     if 'a' <= i <= 'z':
#         if chr(ord(i) + k) <= 'z':
#             i = chr(ord(i) + k)
#         else:
#             i = chr(ord('a') + (k - (ord('z') - ord(i)) - 1))
#     if 'A' <= i <= 'Z':
#         if chr(ord(i) + k) <= 'Z':
#             i = chr(ord(i) + k)
#         else:
#             i = chr(ord('A') + (k - (ord('Z') - ord(i)) - 1))
#     rez += i
# print(rez)

# problema 9 b)
# s = input("s=")
# k = int(input("k="))
# rez = ""
# for i in s:
#     if 'a' <= i <= 'z':
#         if chr(ord(i) - k) >= 'a':
#             i = chr(ord(i) - k)
#         else:
#             i = chr(ord('z') - (k - (ord(i) - ord('a')) - 1))
#     if 'A' <= i <= 'Z':
#         if chr(ord(i) - k) >= 'A':
#             i = chr(ord(i) - k)
#         else:
#             i = chr(ord('Z') - (k - (ord(i) - ord('A')) - 1))
#     rez += i
# print(rez)

# problema 10
# s = input("s=")
# c = input("c=")
# ok = True
# for i in s:
#     p = c.find(i)
#     if p == -1:
#         ok = False
#         break;
#     else:
#         c = c[:p] + c[p+1:]
# if ok == False:
#     print("nu sunt anagrame")
# else:
#     print("sunt anagrame")

# problema 11 a) 1
# s = input("s=")
# i = 0
# while i < len(s):
#     if s[i] in "aeiouAEIOU":
#         s = s[:i+1] + 'p' + s[i] + s[i+1:]
#         i += 2
#     i += 1
# print(s)

# problema 11 a) 2
# s = input(("s="))
# i = 0
# while i < len(s):
#     if s[i] in "aeiouAEIOU":
#         s = s[:i+1] + s[i+3:]
#     i += 1
# print(s)

# problema 11 b) 1
# s = input("s=")
# i = 0
# while i < len(s)-1:
#     if s[i+1] == '-' or s[i+1] == ' ':
#         s = s[:i+1] + 'p' + s[i] + s[i+1:]
#         i += 3
#     i += 1
# s += 'p'
# s += s[len(s)-2]
# print(s)
# i = 0
# while i < len(s):
#     if s[i] == '-':
#         s = s[:i] + s[i+1:]
#     i += 1
# print(s)

# problema 11 b) 2
# s = input("s=")
# i = 0
# while i < len(s):
#     if s[i+1] == 'p' and s[i] == s[i+2]:
#         s = s[:i+1] + s[i+3:]
#     i += 1
# print(s)

# problema 2
# t = input("t: ")
# s = input("s: ")
# i = 0
# k = 0
# if s.find(t) != -1:
#     while k < len(s):
#         i = s.find(t, k)
#         k = i + len(t)
#         print(i, end=" ")
#
# if s.index(t) != ValueError:
#     while k < len(s):
#         i = s.find(t, k)
#         k = i + len(t)
#         print(i, end=" ")
