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

puncte = []

for i in range(4):
    coordonate = input()
    x, y = map(int, coordonate.split())
    
    puncte.append([x, y])

dD = determinant(*puncte[0], *puncte[1], *puncte[2], *puncte[3])
if dD > 0:
    print("AC: ILLEGAL")
else:
    print("AC: LEGAL")

dA = determinant(*puncte[1], *puncte[2], *puncte[3], *puncte[0])
if dA > 0:
    print("BD: ILLEGAL")
else:
    print("BD: LEGAL")