import random
import math
import tkinter as tk
from tkinter import ttk
import matplotlib.pyplot as plt
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

nr_cromozomi = 20
domeniu = "-5 8"
left, right = map(int, domeniu.split())
coeficienti = "-4 3 2"
a, b, c = map(int, coeficienti.split())
precizie = 6
p_incrucisare = 0.25
p_mutatie = 0.01
nr_etape = 50

# nr_cromozomi = int(input())
# domeniu = input()
# left, right = map(int, domeniu.split())
# coeficienti = input()
# a, b, c = map(int, coeficienti.split())
# precizie = int(input())
# p_incrucisare = float(input())
# p_mutatie = float(input())
# nr_etape = int(input())

l = math.ceil(math.log((right - left) * pow(10, precizie), 2))
d = (right - left) / pow(2, l)

def functie(x):
    return a * x * x + b * x + c

def find_interval(intervale, x):
    left_interval, right_interval = 0, len(intervale) - 1
    while left_interval <= right_interval:
        mid = (left_interval + right_interval) // 2
        if intervale[mid] <= x < intervale[mid + 1]:
            return mid + 1
        elif x < intervale[mid]:
            right_interval = mid - 1
        else:
            left_interval = mid + 1

cromozomi = []
val_maxime = []
val_medii = []

f = open("output.txt", "w")

print("Populatia initiala", file=f)
for i in range(nr_cromozomi):
    x = random.uniform(left, right)
    binar = bin(int((x - left) / d))[2:].zfill(l)
    cromozomi.append([binar, x, functie(x)])
    print(f"{i+1}: {cromozomi[i][0]} x= {cromozomi[i][1]:.6f} f= {cromozomi[i][2]:.6f}", file=f)

for iteratie in range(nr_etape):
    cromozom_maxim = max(cromozomi, key=lambda x: x[2])
    
    F = sum(crom[2] for crom in cromozomi)
    prob_selectie = [crom[2] / F for crom in cromozomi]
    
    if iteratie == 0:
        print("\nProbabilitati selectie", file=f)
        for i in range(nr_cromozomi):
            print(f"cromozom {i+1} probabilitate {prob_selectie[i]:.6f}", file=f)
    
    intervale = [0]
    for prob in prob_selectie:
        intervale.append(intervale[-1] + prob)
    
    if iteratie == 0:
        print("\nIntervale probabilitati selectie:", file=f)
        print(" ".join([f"{val:.6f}" for val in intervale]), file=f)
    
    selected = []
    for _ in range(nr_cromozomi - 1):
        u = random.uniform(0, 1)
        idx = find_interval(intervale, u) - 1
        selected.append(cromozomi[idx])
    
    if iteratie == 0:
        print("\n\nDupa selectie:", file=f)
        for i in range(nr_cromozomi - 1):
            print(f"{i+1}: {selected[i][0]} x= {selected[i][1]:.6f} f= {selected[i][2]:.6f}", file=f)
    
    to_be_crossed = []
    if iteratie == 0:
        print(f"\nProbabilitate de incrucisare {p_incrucisare}", file=f)
    
    for i, crom in enumerate(selected):
        u = random.uniform(0, 1)
        if u < p_incrucisare:
            to_be_crossed.append((i, crom))
            if iteratie == 0:
                print(f"{i+1}: {crom[0]} u= {u:.6f} < {p_incrucisare} participa", file=f)
        elif iteratie == 0:
            print(f"{i+1}: {crom[0]} u= {u:.6f}", file=f)
    
    while len(to_be_crossed) >= 2:
        if len(to_be_crossed) == 3:
            idx1, crom1 = to_be_crossed.pop()
            idx2, crom2 = to_be_crossed.pop()
            idx3, crom3 = to_be_crossed.pop()
            punct = random.randint(1, l - 1)
            
            if iteratie == 0:
                print(f"\nRecombinare dintre cromozomul {idx1+1} cu cromozomul {idx2+1} si cromozomul {idx3+1}:", file=f)
                print(f"{crom1[0]} {crom2[0]} {crom3[0]} punct {punct}", file=f)
            
            nou1 = crom1[0][:punct] + crom3[0][punct:]
            nou2 = crom2[0][:punct] + crom1[0][punct:]
            nou3 = crom3[0][:punct] + crom2[0][punct:]
            
            if iteratie == 0:
                print(f"Rezultat {nou1} {nou2} {nou3}", file=f)
            
            selected[idx1] = [nou1, left + int(nou1, 2) * d, functie(left + int(nou1, 2) * d)]
            selected[idx2] = [nou2, left + int(nou2, 2) * d, functie(left + int(nou2, 2) * d)]
            selected[idx3] = [nou3, left + int(nou3, 2) * d, functie(left + int(nou3, 2) * d)]
        else:
            idx1, crom1 = to_be_crossed.pop()
            idx2, crom2 = to_be_crossed.pop()
            punct = random.randint(1, l - 1)
            
            if iteratie == 0:
                print(f"\nRecombinare dintre cromozomul {idx1+1} cu cromozomul {idx2+1}:", file=f)
                print(f"{crom1[0]} {crom2[0]} punct {punct}", file=f)
            
            nou1 = crom1[0][:punct] + crom2[0][punct:]
            nou2 = crom2[0][:punct] + crom1[0][punct:]
            
            if iteratie == 0:
                print(f"Rezultat {nou1} {nou2}", file=f)
            
            selected[idx1] = [nou1, left + int(nou1, 2) * d, functie(left + int(nou1, 2) * d)]
            selected[idx2] = [nou2, left + int(nou2, 2) * d, functie(left + int(nou2, 2) * d)]
    
    if iteratie == 0:
        print("\nDupa recombinare:", file=f)
        for i in range(nr_cromozomi - 1):
            print(f"{i+1}: {selected[i][0]} x= {selected[i][1]:.6f} f= {selected[i][2]:.6f}", file=f)
    
    mutatii = []
    if iteratie == 0:
        print(f"\nProbabilitate de mutatie pentru fiecare gena {p_mutatie}", file=f)
        print("Au fost modificati cromozomii:", file=f)
    
    for i in range(len(selected)):
        lista_bits = list(selected[i][0])
        for j in range(len(lista_bits)):
            if random.uniform(0, 1) < p_mutatie:
                lista_bits[j] = '1' if lista_bits[j] == '0' else '0'
                if i not in mutatii:
                    mutatii.append(i)
        nou_binar = ''.join(lista_bits)
        selected[i][0] = nou_binar
        selected[i][1] = left + int(nou_binar, 2) * d
        selected[i][2] = functie(selected[i][1])
    
    if iteratie == 0 and mutatii:
        print(" ".join([str(m+1) for m in sorted(mutatii)]), file=f)
        print("\nDupa mutatie:", file=f)
        for i in range(nr_cromozomi - 1):
            print(f"{i+1}: {selected[i][0]} x= {selected[i][1]:.6f} f= {selected[i][2]:.6f}", file=f)
    
    selected.append(cromozom_maxim)
    cromozomi = selected
    
    val_max = max(crom[2] for crom in cromozomi)
    val_med = sum(crom[2] for crom in cromozomi) / nr_cromozomi
    val_maxime.append(val_max)
    val_medii.append(val_med)
    
    print(f"\nIteratia {iteratie+1}:", file=f)
    print(f">>>Valoare maxima {val_max:.6f}", file=f)
    print(f">>>Valoare medie {val_med:.6f}", file=f)

f.close()

def update_plot():
    ax.clear()
    ax.plot(range(1, len(val_maxime) + 1), val_maxime, 'r-', label="Maxim")
    ax.plot(range(1, len(val_medii) + 1), val_medii, 'b-', label="Medie")
    ax.legend()
    ax.set_title("Evoluția maximului și mediei")
    ax.set_xlabel("Iterație")
    ax.set_ylabel("Valoare")
    canvas.draw()

root = tk.Tk()
root.title("Evoluția Algoritmului Genetic")

frame_controls = tk.Frame(root)
frame_controls.pack(side=tk.TOP, fill=tk.X, padx=10, pady=5)

update_button = ttk.Button(frame_controls, text="Actualizează Graficul", command=update_plot)
update_button.pack(side=tk.LEFT, padx=5)

fig, ax = plt.subplots(figsize=(5, 4))
canvas = FigureCanvasTkAgg(fig, master=root)
canvas.get_tk_widget().pack()

update_plot()
root.mainloop()