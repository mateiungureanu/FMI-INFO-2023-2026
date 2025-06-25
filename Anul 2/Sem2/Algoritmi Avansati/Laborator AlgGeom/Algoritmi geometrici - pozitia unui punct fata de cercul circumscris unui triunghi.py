def determinant(xA, yA, xB, yB, xC, yC, xD, yD):
    matrix = [
        [xA, yA, xA**2 + yA**2, 1],
        [xB, yB, xB**2 + yB**2, 1],
        [xC, yC, xC**2 + yC**2, 1],
        [xD, yD, xD**2 + yD**2, 1]
    ]
    
    def det4(m):
        a, b, c, d = m[0]
        minor0 = [
            [m[1][1], m[1][2], m[1][3]],
            [m[2][1], m[2][2], m[2][3]],
            [m[3][1], m[3][2], m[3][3]]
        ]
        minor1 = [
            [m[1][0], m[1][2], m[1][3]],
            [m[2][0], m[2][2], m[2][3]],
            [m[3][0], m[3][2], m[3][3]]
        ]
        minor2 = [
            [m[1][0], m[1][1], m[1][3]],
            [m[2][0], m[2][1], m[2][3]],
            [m[3][0], m[3][1], m[3][3]]
        ]
        minor3 = [
            [m[1][0], m[1][1], m[1][2]],
            [m[2][0], m[2][1], m[2][2]],
            [m[3][0], m[3][1], m[3][2]]
        ]
        
        def det3(m):
            return (m[0][0]*(m[1][1]*m[2][2] - m[1][2]*m[2][1])
                   - m[0][1]*(m[1][0]*m[2][2] - m[1][2]*m[2][0])
                   + m[0][2]*(m[1][0]*m[2][1] - m[1][1]*m[2][0]))
        
        return (a * det3(minor0) - b * det3(minor1) 
                + c * det3(minor2) - d * det3(minor3))
    
    return det4(matrix)

triunghi = []
for _ in range(3):
    x, y = map(int, input().split())
    triunghi.append((x, y))

m = int(input())

for _ in range(m):
    x, y = map(int, input().split())
    d = determinant(*triunghi[0], *triunghi[1], *triunghi[2], x, y)
    
    if d > 0:
        print("INSIDE")
    elif d < 0:
        print("OUTSIDE")
    else:
        print("BOUNDARY")