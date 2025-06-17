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
            x_le.append(val)
        else:
            x_ge.append(val)
    else:
        val = -c / b
        if b > 0:
            y_le.append(val)
        else:
            y_ge.append(val)

x_min = min(x_le) if x_le else None
x_max = max(x_ge) if x_ge else None
y_min = min(y_le) if y_le else None
y_max = max(y_ge) if y_ge else None

if (x_min is not None and x_max is not None and x_min < x_max) or \
   (y_min is not None and y_max is not None and y_min < y_max):
    print("VOID")
else:
    if x_min is not None and x_max is not None and y_min is not None and y_max is not None:
        print("BOUNDED")
    else:
        print("UNBOUNDED")