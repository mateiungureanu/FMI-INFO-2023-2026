import bisect

n = int(input())
x_ge = []
x_le = []
y_ge = []
y_le = []

for _ in range(n):
    a, b, c = map(int, input().split())
    
    if a != 0:
        val = -c / a
        if a > 0:
            bisect.insort(x_le, val)
        else:
            bisect.insort(x_ge, val)
    else:
        val = -c / b
        if b > 0:
            bisect.insort(y_le, val)
        else:
            bisect.insort(y_ge, val)

exista_dreptunghi = x_ge and x_le and y_ge and y_le

m = int(input())
for _ in range(m):
    x, y = map(float, input().split())
    
    if not exista_dreptunghi:
        print("NO")
        continue

    idx_x_sup = bisect.bisect_right(x_le, x)
    if idx_x_sup == len(x_le):
        print("NO")
        continue

    idx_x_inf = bisect.bisect_left(x_ge, x)
    if idx_x_inf == 0:
        print("NO")
        continue

    idx_y_sup = bisect.bisect_right(y_le, y)
    if idx_y_sup == len(y_le):
        print("NO")
        continue

    idx_y_inf = bisect.bisect_left(y_ge, y)
    if idx_y_inf == 0:
        print("NO")
        continue

    R = x_le[idx_x_sup]
    L = x_ge[idx_x_inf - 1]
    T = y_le[idx_y_sup]
    B = y_ge[idx_y_inf - 1]

    if L < x < R and B < y < T:
        print("YES")
        print("{0:.6f}".format((R - L) * (T - B)))
    else:
        print("NO")
