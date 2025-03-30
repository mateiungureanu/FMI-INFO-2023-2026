# Curs: Nisioi Sergiu
# Laborator: Dragan Mihaita

## Table of contents
1. [Switch](#1-switch)
   + [Setup](#setup)
   + [Terminal](#terminal)
   + [Testarea echipamentului](#testarea-echipamentului)
2. [Router](#2-router)
   + [Setup](#setup-1)
   + [Terminal](#terminal-1)
   + [Testarea echipamentului](#testarea-echipamentului-1)
3. [Server](#3-server)
4. [Calcularea IP-urilor](#4-calcularea-ip-urilor)
5. [???](#???)

## 1. Switch

### Setup

+ Click pe \[End Devices\], click pe PC, click **in coltul din stanga jos** al spatiului de lucru
+ Click pe numele lui \(PC0\), sterge numele, scrie "Grecia"
+ Click pe PC
+ **Power off**
+ Scroll in jos pana la placa de retea, drag & drop in sectiunea Modules, cauta in sectiunea Modules placa cu **CGE** \(PT-HOST-NM-1CGE\), drag & drop in locul placii de retea
+ **Power on**
+ Schimba pe tabul _Desktop_
+ Intra pe **IP Configuration**
  + IPv4 Address: `174.40.20.22`
  + Subnet Mask: `255.255.254.0`
  + Default Gateway: `174.40.20.1`
  + DNS Server: `209.165.200.254`
+ Inchide de la x-ul mic
+ Intra pe **Email**
  + Your Name: `Grecia`
  + Email Address: `Grecia@info.ro`
  + Incoming Mail Server: `209.165.200.254`
  + Outgoing Mail Server: `209.165.200.254`
  + User Name: `Grecia`
  + Password: `123456`
+ Click **Save**
+ \(optional\) Click **Configure Email**, verific daca am scris corect
+ Click pe \[Network Devices\], click pe \[Switches\], click pe **2960**, click **la cativa centimetri mai sus si mai la dreapta fata de PC**
+ Click pe numele lui \(Switch0\), sterge numele, scrie "Sw-Grecia"
+ Click pe \[End Devices\], click pe Laptop, click **la cativa centimetri mai sus si mai la stanga fata de Switch**
+ Click pe \[Connections\], click pe _Console_, click pe Switch, click pe **Console**, click pe Laptop, click pe **RS 232**  
![Rezultat](poze/switch.png)
+ Click pe Laptop
+ Schimba pe tabul _Desktop_
+ Intra pe **Terminal**
+ Click **OK**
+ Apasa **Enter**

### Terminal
Apasa **Enter** dupa fiecare comanda  

switch\#  
```
enable
configure terminal
```
switch\(config\)\#
```
no ip domain lookup
hostname Sw-Grecia
```
Sw-Grecia\(config\)\#
```
no cdp run
service password-encryption
enable secret ciscosecpa55
enable password ciscoenapa55
banner motd $Vineri 14.03.2025 la ora 9:00 va avea loc sedinta IT!$
line console 0
```
Sw-Grecia\(config-line\)\#
```
password ciscoconpa55
login
logging synchronous
exec-timeout 20 10
exit
```
Sw-Grecia\(config\)\#
```
line vty 0 15
```
Sw-Grecia\(config-line\)\#
```
password ciscovtypa55
login
logging synchronous
exec-timeout 5 5
end
```
Sw-Grecia\#
> **IMPORTANT**
> Comanda asta salveaza configuratia. O poti rula oricand vrei, cand esti in Sw-Grecia\#
```
copy running-config startup-config
```
+ **Enter** \(intrebare despre nume\)
```
clock set HH:MM:SS D Mon YYYY
configure terminal
```
Sw-Grecia\(config\)\#
```
ip domain name info.ro
username Admin01 privilege 15 secret Admin01pa55
line vty 0 15
```
Sw-Grecia\(config-line\)\# 
```
transport input ssh
login local
exit
```
Sw-Grecia\(config\)\#
```
crypto key generate rsa
```
+ `2048`, **Enter** \(intrebare despre biti\)
```
ip ssh version 2
logging host 209.165.200.254
service timestamps log datetime msec
service timestamps debug datetime msec
interface vlan 1
```
Sw-Grecia\(config-if\)\#
```
description legatura cu reteaua 174.40.20.0/23
ip address 174.40.20.2 255.255.254.0
no shutdown
exit
```
Sw-Grecia\(config\)\# 
```
ip default-gateway 174.40.20.1
exit
```

### Testarea echipamentului

+ Click pe \[Connections\], click pe _Copper Straight-Through_, click pe Switch, click pe **GigabitEthernet 0/2**, click pe PC, click pe **GigabitEthernet0**
+ Click pe PC, click pe **Command Prompt**

Sw-Grecia\#
```
ping 174.40.20.2
ssh -l Admin01 174.40.20.2
```
+ `Admin01pa55`

![Testare reusita](poze/switch_test.png)

## 2. Router

Schimbari in setul de date:  
| Anglia |     | Sw-Anglia |
| :----: | :-: | :-------: |
| 171.160.1.61 | IPv4 Address | 171.160.0.2  |
| 255.255.224.0 | Subnet Mask | 255.255.224.0 |
| 171.160.0.1 | Default Gateway | 171.160.0.1 |
| 171.160.47.254| DNS Server

### Setup

+ Click pe \[Network Devices\], click pe \[Routers\], click pe **2911** sau pe **2901**, click **la cativa centimetri mai la dreapta fata de PC**
+ Click pe numele lui \(Router0\), sterge numele, scrie "R-Anglia"
+ Click pe Router
+ **Power off**
+ Cauta in sectiunea Modules placa cu **HWIC-2T**, drag & drop **cat mai aproape de sursa**
+ **Power on**
+ Inchide fila
+ Click pe bulina dinspre Switch de pe cablul _Console_ Laptop-Switch, click pe Router, click pe **Console**
+ Click pe Laptop
+ Schimba pe tabul _Desktop_
+ Intra pe **Terminal**
+ Click **OK**
+ Interogare: `no`, **Enter**
+ Apasa **Enter**

### Terminal
Apasa **Enter** dupa fiecare comanda  

router\#  
```
enable
configure terminal
```
router\(config\)\#
```
no ip domain lookup
hostname R-Anglia
```
R-Anglia\(config\)\#
```
no cdp run
service password-encryption
security passwords min-length 10
login block-for 50 attempts 3 within 20
enable secret ciscosecpa55
enable password ciscoenapa55
banner login $Accesul persoanelor neautorizate este strict interzis!$
banner motd $Vineri 21.03.2025 la ora 14:00 serverul va fi oprit!$
line console 0
```
R-Anglia\(config-line\)\#
```
password ciscoconpa55
login
logging synchronous
exec-timeout 20 10
exit
```
R-Anglia\(config\)\#
```
line vty 0 15
```
R-Anglia\(config-line\)\#
```
password ciscovtypa55
login
logging synchronous
exec-timeout 5 5
end
```
R-Anglia\#
> **IMPORTANT**
> Comanda asta salveaza configuratia. O poti rula oricand vrei, cand esti in R-Anglia\#
```
copy running-config startup-config
```
+ **Enter** \(intrebare despre nume\)
```
clock set HH:MM:SS D Mon YYYY
configure terminal
```
R-Anglia\(config\)\#
```
ip domain name info.ro
username Admin01 privilege 15 secret Admin01pa55
line vty 0 15
```
R-Anglia\(config-line\)\# 
```
transport input ssh
login local
exit
```
R-Anglia\(config\)\#
```
crypto key generate rsa
```
+ `2048`, **Enter** \(intrebare despre biti\)
```
ip ssh version 2
logging host 171.160.47.254
service timestamps log datetime msec
service timestamps debug datetime msec
interface gigabitethernet 0/0
```
R-Anglia\(config-if\)\#
```
description legatura cu reteaua 171.160.0.0/19
ip address 171.160.0.1 255.255.224.0
no shutdown
exit
```
R-Anglia\(config\)\# 
```
interface serial 0/0/0
```
R-Anglia\(config-if\)\#
```
description legatura cu routerul R-server
ip address 171.160.56.5 255.255.255.252
no shutdown
```

### Testarea echipamentului

+ Click pe \[Connections\], click pe _Copper Straight-Through_, click pe Switch, click pe **GigabitEthernet 0/1**, click pe Router, click pe **GigabitEthernet 0/0**
+ Click pe PC, intra pe **Command Prompt**  
sau
+ Click pe altceva, intra pe CLI
  + Password: `ciscoconpa55`
```
ping [ip_de_la_unul_din_dispozitive]
ssh -l Admin01 [ip_de_la_unul_din_dispozitive]
```


## 3. Server

### Setup

+ Click pe \[End-Devices\], click pe \[Server\], click **undeva in spatiul de lucru \(?\)**
+ Click pe numele lui \(Server0\), sterge numele, scrie "Server1"
+ Click pe Server
+ **Power off**
+ Drag & drop la placa de retea in sectiunea Modules, cauta in sectiunea Modules placa cu **CGE** \(PT-HOST-NM-1CGE\), drag & drop in locul placii de retea
+ **Power on**
+ Schimba pe tabul _Desktop_
+ Intra pe **IP Configuration**
  + IPv4 Address: `171.160.47.254`
  + Subnet Mask: `255.255.240.0`
  + Default Gateway: `171.160.32.1`
  + DNS Server: `171.160.47.254`
+ Inchide de la x-ul mic
+ Intra pe **Email**
  + Your Name: `Server`
  + Email Address: `Server@info.ro`
  + Incoming Mail Server: `171.160.47.254`
  + Outgoing Mail Server: `171.160.47.254`
  + User Name: `Server`
  + Password: `123456`
+ Click **Save**
+ \(optional\) Click **Configure Email**, verific daca am scris corect
+ Click pe \[Connections\], click pe _Copper Straight-Through_, click pe Switch, click pe **FastEthernet**, click pe Server, click pe **FastEthernet**

### Verificare

+ Intra pe **Command Prompt**
```
ping 171.160.32.2
ssh -l Admin 171.160.32.2
ping 171.160.32.1
ping 171.160.56.6
```

### Continuare

+ Schimba pe tabul _Services_
+ Schimba **HTTP** pe _Off_
+ Click pe **DNS** in sectiunea Services, schimba **DNS Services** pe _On_
  + Name: `info.ro`
  + Address: `171.160.47.254`
+ Click **Add**
+ Click pe **Syslog** in sectiunea Services, schimba **Service** pe _On_
+ Click pe **Email** in sectiunea Services, schimba **SMTP** pe _On_, schimba **POP3 Services** pe _On_
  + Domain Name: `info.ro`
  + User: `PC-Anglia`, `PC-Albania`, `service`, `Server1` si toti ceilalti useri
  + Password: `123456` pentru toti userii   
  + Dupa fiecare user si parola, click **+**
+ Click pe **FTP** in sectiunea Services, schimba **Service** pe _On_
  + User: `PC-Anglia`, `PC-Albania`, `service`, `Server1` si toti ceilalti useri
  + Password: `123456` pentru toti userii
  + Bifeaza **Write**, **Read**, **List**  
  + Dupa fiecare user si parola, click **+**
+ Click pe PC
+ Schimba pe tabul _Desktop_
+ Intra pe **Web Hosts**
  + URL: `info.ro`
+ Click **Go**
+ Intra pe **Email**
+ Click pe **Compose**
  + To: `Server@info.ro`
  + Subject: `Test`
+ Verifica serviciu email -> send \(a trimis cu succes\) **??????**

### Verificare

+ Click pe destinatie
+ Schimba pe tabul _Desktop_
+ Intra pe **Email**
+ Verifica la Received
+ Click pe PC
+ Schimba pe tabul _Desktop_
+ Intra pe **Command Prompt**
```
dir
ftp 171.160.47.254
```
  + Username: `PC-Anglia`
  + Password: `123456`  

ftp>
```
dir
get [nume_fisier] (ex. primul)
quit 
```
```
dir
```
+ Daca apare si fisierul transferat e bine

## 4. Calcularea IP-urilor

IP oarecare: `172.168.244.156/13`  

| | | |
| :- | :- | :- |
| <ins>**pas 1**</ins> | `1010.1100/1010.1000/1111.0000/1001.1100` | convertire in binar |
| | `1111.1111/1111.1000/0000.0000/0000.0000` | n biti de 1 si restul de 0, unde n e masca |
| | `1010.1100/1010.1000/0000.0000/0000.0000` | operatie de si-logic intre primele 2 adrese |

| | | |
| :- | :- | :- |
| **NA** \(network address\) | `172.168.0.0/13` | a treia adresa |
| **BA** \(broadcast address\) | `172.175.255.255/13` | NA + a doua adresa negata \(operatie de sau-logic / negare\) |
| **RA** \(range address\) | `172.168.0.1 - 172.175.255.254 /13` | \(NA + 1\) - \(BA - 1\)|

+ **NA** e mereu numar par, **BA** e mereu numar impar  
+ **NA** si **BA** nu se asigneaza
+ **NA** nu se termina mereu cu 0, iar **BA** nu se termina mereu cu 255

| retele | |
| -: | :- |
| DIJON | = 1022 H |
| DEJA | = 126 H |
| DAMBOVITA | = 31 H |
| DUBLIN | = 2047 H |
| DOLJ | = 511 H |
| DAMASC | = 4095 H |
| **legaturi intre retele** | |
| DIJON - DEVA | = 2 H |
| DEVA - DAMBOVITA | = 2 H |
| DAMBOVITA - DUBLIN | = 2 H |
| DUBLIN - DOLJ | = 2 H |
| DOLJ - DAMASC | = 2 H |

| <ins>**pas 2**</ins> | sortare mare -> mic, si incadrare intre puteri ale lui 2 | 2<sup>n</sup>-2 valori asignabile |
| :- | :-: | - |
| | 2<sup>12</sup> &le; 4095 &le; 2<sup>13</sup> | 2<sup>12</sup>=4096 - 2 < 4095 => 2<sup>12</sup> 2<sup>13</sup>
| | 2<sup>11</sup> &le; 2047 &le; 2<sup>12</sup> |
| | 2<sup>9</sup> &le; 1022 &le; 2<sup>10</sup> |
| | 2<sup>9</sup> &le; 511 &le; 2<sup>10</sup> |
| | 2<sup>6</sup> &le; 126 &le; 2<sup>7</sup> |
| | 2<sup>5</sup> &le; 31 &le; 2<sup>6</sup> |
| | 2<sup>1</sup> &le; 2 &le; 2<sup>2</sup> |
| | 2<sup>1</sup> &le; 2 &le; 2<sup>2</sup> |
| | 2<sup>1</sup> &le; 2 &le; 2<sup>2</sup> |
| | 2<sup>1</sup> &le; 2 &le; 2<sup>2</sup> |
| | 2<sup>1</sup> &le; 2 &le; 2<sup>2</sup> |


| <ins>**pas 3**</ins> | |
| -: | :- |
| `4095` | 
| **NA** | `172.168.0.0/19` \[32 \(nr de biti\) - 13 \(puterea lui 2 din dreapta\)\] |
| **BA** | `172.168.31.255/19` \[31.255 de la pasul 1 \(19 de 1, apoi si-logic\)\] |
| **RA** | `172.168.0.1 - 172.168.31.254 /19` |
| `2047` | |
| **NA** | `172.168.32.0/20` \(BA anterior + 1\) |
| **BA** | `172.168.47.255/20` |
| **RA** | `172.168.32.1 - 172.168.47.254 /20` |
| `1022` | |
| **NA** | `172.168.48.0/22` |
| **BA** | `172.168.51.255/22` |
| **RA** | `172.168.48.1 - 172.168.51.254 /22` |
| `511` | |
| **NA** | `172.168.52.0/22` |
| **BA** | `172.168.55.255/22` |
| **RA** | `172.168.52.1 - 172.168.55.254 /22` |
| `126` | |
| **NA** | `172.168.56.0/25` |
| **BA** | `172.168.56.127/25` |
| **RA** | `172.168.56.1 - 172.168.56.126 /25` |
| `31` | |
| **NA** | `172.168.56.128/26` |
| **BA** | `172.168.56.191/26` |
| **RA** | `172.168.56.129 - 172.168.56.190 /26` |
| `2` DIJON - DEVA | |
| **NA** | `172.168.56.192/30` |
| **BA** | `172.168.56.195/30` |
| **RA** | `172.168.56.193 - 172.168.56.194 /30` |
| `2` DEVA - DAMBOVITA | |
| **NA** | `172.168.56.196/30` |
| **BA** | `172.168.56.199/30` |
| **RA** | `172.168.56.197 - 172.168.56.198 /30` |
| `2` DAMBOVITA - DUBLIN | |
| **NA** | `172.168.56.200/30` |
| **BA** | `172.168.56.203/30` |
| **RA** | `172.168.56.201 - 172.168.56.202 /30` |
| `2` DUBLIN - DOLJ | |
| **NA** | `172.168.56.204/30` |
| **BA** | `172.168.56.207/30` |
| **RA** | `172.168.56.205 - 172.168.56.206 /30` |
| `2` DOLJ - DAMASC | |
| **NA** | `172.168.56.208/30` |
| **BA** | `172.168.56.211/30` |
| **RA** | `172.168.56.209 - 172.168.56.210 /30` |

Primul IP asignabil din reteaua `4095`
+ 2<sup>12</sup> &le; 4095 &le; 2<sup>13</sup> deci sunt 8190 valori asignabile \(2<sup>13</sup>-2\)
+ 8190 / 26 = 315 IP-uri pentru switch-uri \(fiecare switch are 26 de porturi\)
+ Daca impartirea da cu rest, adaugi 1 la rezultat
+ Rezerva un IP pentru DG => mai adaugi 1 la rezultat
+ Daca e mai mare ca 255 \(iese de pe 8 biti\) imparti la 256: 316 / 256 = 1 rest 60
+ Adaugi catul pe al treilea octet si restul pe al patrulea octet la primul IP din retea
+ Mai adaugi 1 pentru a gasi primul IP de host asignabil: `172.168.1.61`

Primul IP asignabil din reteaua `2047`
+ 2<sup>11</sup> &le; 2047 &le; 2<sup>12</sup> deci sunt 4094 valori asignabile
+ 4094 / 26 = 157 rest 12
+ Rest &ne; 0 => 158
+ IP pentru DG => 159
+ `172.168.32.160`

Primul IP asignabil din reteaua `1022`
+ 2<sup>9</sup> &le; 1022 &le; 2<sup>10</sup> deci sunt 1022 valori asignabile
+ 1022 / 26 = 39 rest ...
+ Rest &ne; 0 => 40
+ IP pentru DG => 41
+ `172.168.48.42`

## 5. ???

+ Click pe PC, click pe **Command Prompt**
```
ping 172.168.96.2
ping 172.168.96.1
```
+ Click pe Laptop, click pe **Terminal**
+ Apasa **Enter**
+ Password: `ciscoconpa55`
+ `enable`
+ Password: `ciscosecpa55`
+ `configure terminal`  

config\)\#
```
interface giga 0/0
```
-if\)\#
```
description legatura cu ramura Eufrat
ip address 172.168.96.1 255.255.240.0
ip helper-address 10.10.10.6
no shutdown
exit
```
config\)\#
```
interface giga 0/1
```
-if\)\#
```
description ...
ip address 10.10.10.1 255.255.255.252
no shutdown
exit
```
config\)\#
```
interface serial 0/0/0
```
-if\)\#
```
description legatura cu routerul serverului
ip address 10.10.10.5 255.255.255.252
no shutdown
exit
```
config\)\#
```
ip route 192.168.100.96 255.255.255.240 serial 0/0/0
```

+ Muta firul de la router la R-Server
+ Click pe Server, click pe **Terminal**
+ + Apasa **Enter**
+ Password: `ciscoconpa55`
+ `enable`
+ Password: `ciscosecpa55`
+ `configure terminal`  

config\)\#
```
interface giga 0/0
```
-if\)\#
```
description ...
ip address 192.168.100.97 255.255.255.224 (sau 240?)
no shutdown
exit
```
config\)\#
```
interface serial 0/0/0
```
-if\)\#
```
description ...
ip address 10.10.10.6 255.255.255.252
no shutdown
exit
```
config\)\#
```
ip dhcp excluded-address 172.168.96.1 172.168.96.160
ip dhcp pool Eufrat
```
dhcp-config\)\#
```
network 172.168.96.0 255.255.240.0
default-router 172.168.96.1
dns-server 192.168.100.110
exit
```
config\)\#
```
ip route 172.168.96.0 255.255.240.0 serial 0/0/0
ip route 10.10.10.0 255.255.255.252 serial 0/0/0
```

+ Salveaza
+ Leaga echipamentul, fac teste, dau ping

+ Adu 2 Laptopuri in spatiul de lucru, leaga-le pe ambele cu FastEthernet 1 de Switch, cablu Straight-Through
+ Click pe Laptop, click pe **Terminal**
+ Apasa **Enter**
+ Password: `ciscoconpa55`
+ `enable`
+ Password: `ciscosecpa55`
+ `configure terminal`  

config\)\#
```
interface range fa 0/1-2
```
-if\)\#
```
no shutdown
exit
```

+ Click pe PC, click pe **IP Configuration**
+ Click pe **DHCP**
+ ???
+ Leaga R-Server de Sw-Server cu G0/1 - G0/0, apoi Sw-Server de Server cu G0/1 - 0/0
+ Leaga Eufrat de R-Server cu Serial 0/0/0 ambele, cu cablu rosu fara ceas
+ Click pe Network Devices, click pe Wireless, click pe WPT300N, click in spatiul de lucru
+ Click pe WPT300N, scrie Wi-FiEufrat
+ Leaga service si ISR \(WiFiEufrat\) cu, FastEthernet, Ethernet \(primul\), cu cablu Straight-Through
+ Click pe service, click pe **IP Configuration**, scrie la IPv4 `192.168.0.15`
+ Click pe x mic, click pe **Web Browser**, scrie `192.168.0.1`
+ Logheaza-te cu credentalele `admin` `admin`
+ Click pe DHCP, click pe static IP
  + `10.10.10.2`
  + `255.255.255.252`
  + `10.10.10.1`
  + `192.168.100.110`
+ Router IP: `192.160.50.65`
+ Mask: `255.255.255.224`
+ Start: `192.260.50.66`
+ Max: 13
+ Click exit, scroll in afara ferestrei, save
+ Click pe Laptop, click pe **IP Configuration**
+ Pune noua adresa
+ Click pe x mic, click pe **Web Browser**, scrie IP-ul \(??\)
+ Logheaza-te cu credentalele `admin` `admin`
+ Click pe Wireless
+ SSID: Wi-FIEufrat
+ Click pe AUTO, AUTO
+ Channel 6 sau 11
+ Click Save
+ Click pe Security
+ Selecteaza WPA2Personal
+ Password: `RadiusPa55`
+ Click Save
+ Adauga un nou Laptop, redenumeste-l Lap1
+ Power off
+ Schimba placa de retea in WPC300N
+ Power on
+ Nu mai asignezi IP
+ Intra pe PC, **Web Browser**, click pe Wireless
+ Click pe Profiles \(NU TE APROPIA DE DEFAULT\)
+ New Wi-FiEufrat -> OK
+ Click Advanced
+ Nume: Wi-FiEthernet, next, yes
+ Click WPA2Personal, next
+ Password: `RadiusPa55`
+ Click next, save, connect profiles
+ Intra pe **Email**
  + Your Name: `Lap1`
  + Email Address: `Lap1@info.ro`
  + Incoming Mail Server: `192.168.100.110`
  + Outgoing Mail Server: `192.168.100.110`
  + User Name: `Lap1`
  + Password: `123456`
+ Click **Save**
+ Adauga un nou Laptop, redenumeste-l Lap2
+ Power off
+ Schimba placa de retea in WPC300N
+ Power on
+ Nu mai asignezi IP
+ Intra pe PC, **Web Browser**, click pe Wireless
+ Click pe Profiles \(NU TE APROPIA DE DEFAULT\)
+ Apasa rapid pe Wi-FiEufrat, nu lasa sa gaseasca reteaua singur
+ Click Advanced
+ Nume: Wi-FiEthernet, next, yes
+ Click WPA2Personal, next
+ Password: `RadiusPa55`
+ Click next, save, connect profiles
+ Intra pe **Email**
  + Your Name: `Lap2`
  + Email Address: `Lap2@info.ro`
  + Incoming Mail Server: `192.168.100.110`
  + Outgoing Mail Server: `192.168.100.110`
  + User Name: `Lap2`
  + Password: `123456`
+ Click **Save**
+ Leaga ISR de R-Eufrat G0/0 si G0/1, cu cablu Crossover
+ Intra pe ???
+ `ping 10.10.10.1`
+ `ping 10.10.10.5`
+ `ping 10.10.10.6`
+ `ping 192.168.100.97`
+ `ping 192.168.100.98`
+ Intra pe **Email**
+ Trimite mail catre Server
+ Mergi la Server si apasa Receive
+ Trimite mail catre Eufrat
+ Mergi la Eufrat si apasa Receive
+ Pentru orice echipament:
  + `ftp \[ip_server\]`
  + `dir`
  + `get \[unul-din-fisiere\]`
  + `quit`
  + `dir` <- verifica daca s-a transferat
+ Click pe Router
+ Intra pe **Command Prompt**
+ `ipconfig/all`
+ Cauta MAC/BIA
+ Click pe Laptop, **Web Browser**, router address
+ Click pe Wireless: prevent or permit
+ `00 04 9a 9b 0d 78`
+ Click **Save**

| | |
| -: | :- |
| !!! | package recieved |
| ... | request timeout |
| UUU | problems |

+ Schimba route catre Server
