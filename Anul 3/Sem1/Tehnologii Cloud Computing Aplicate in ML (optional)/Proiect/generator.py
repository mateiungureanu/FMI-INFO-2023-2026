import os
import time
import shutil
import random

# Simulam un sistem extern care produce loguri
def genereaza_log():
    # 1. Cream fisierul TEMPORAR (in afara folderului monitorizat)
    nume_fisier = f"log_simulat_{int(time.time())}.txt"
    continut = [
        "INFO: Sistemul functioneaza normal.",
        "WARN: Utilizare CPU 80%.",
        "CRITICAL: Eroare conexiune Baza de Date!", # Asta cautam noi
        "INFO: Proces finalizat."
    ]
    
    print(f"--> [GENERATOR] Creez fisierul {nume_fisier}...")
    
    with open(nume_fisier, "w") as f:
        f.write("\n".join(continut))
    
    # Pauza mica sa fim siguri ca s-a scris pe disk
    time.sleep(1)
    
    # 2. MUTAREA ATOMICA (Asta declanseaza sigur on_moved in Ingestor)
    destinatie = os.path.join("incoming_logs", nume_fisier)
    print(f"--> [GENERATOR] Mut fisierul in {destinatie}...")
    
    # Asigura-te ca folderul exista (just in case)
    os.makedirs("incoming_logs", exist_ok=True)
    
    shutil.move(nume_fisier, destinatie)
    print("--> [GENERATOR] Gata! Log trimis.\n")

if __name__ == "__main__":
    while True:
        input("Apasă ENTER pentru a genera un log critic (sau Ctrl+C pentru stop): ")
        genereaza_log()