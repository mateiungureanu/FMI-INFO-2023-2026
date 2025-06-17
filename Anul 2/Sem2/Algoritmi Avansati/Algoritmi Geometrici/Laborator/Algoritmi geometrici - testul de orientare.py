t = int(input()) # nr teste
for i in range(t):
    coordinate = input()
    xP, yP, xQ, yQ, xR, yR = map(int, coordinate.split())
    determinant = xQ * yR + xP * yQ + yP * xR - xQ * yP - xR * yQ - yR * xP
    if determinant == 0:
        print("TOUCH")
    elif determinant > 0:
        print("LEFT")
    else:
        print("RIGHT")
