# Curs: Nisioi Sergiu
# Laborator: Dragan Mihaita

## Table of contents
1. [Calcularea IP-urilor](#calcularea-ip-urilor)
   1. [Numar Switch-uri](#numar-switch-uri)
   2. [Subnet Mask](#subnet-mask)
   3. [Default Gateway](#default-gateway)
   4. [DNS Server](#dns-server)
   5. [IP Router](#ip-router)
   6. [IP Switch](#ip-switch)
   7. [IP Host](#ip-host)
2. [Setup](#setup)
   1. [Host si SERVICE](#host-si-service)
   2. [Switch](#switch)
   3. [Router](#router)
   4. [Server](#server)
   5. [Wi-FI](#wi-fi)
   6. [Laptop Wi-Fi](#laptop-wi-fi)
3. [Comenzi](#comenzi)
   1. [Comenzi Switch](#comenzi-switch)
   2. [Comenzi Router](#comenzi-router)
4. [Testare](#testare)
   1. [Ping si SSH](#ping-si-ssh)
   2. [HTTP si DNS](#http-si-dns)
   3. [Email](#email)
   4. [FTP](#ftp)
   5. [Syslog](#syslog)

## Calcularea IP-urilor

Se da un IP oarecare: `172.168.244.156/13`  

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
| | 2<sup>12</sup>-2 &le; 4095 &le; 2<sup>13</sup>-2 | 2<sup>12</sup>=4096 - 2 < 4095 => 2<sup>12</sup> 2<sup>13</sup>
| | 2<sup>11</sup>-2 &le; 2047 &le; 2<sup>12</sup>-2 |
| | 2<sup>9</sup>-2 &le; 1022 &le; 2<sup>10</sup>-2 |
| | 2<sup>9</sup>-2 &le; 511 &le; 2<sup>10</sup>-2 |
| | 2<sup>6</sup>-2 &le; 126 &le; 2<sup>7</sup>-2 |
| | 2<sup>5</sup>-2 &le; 31 &le; 2<sup>6</sup>-2 |
| | 2<sup>1</sup>-2 &le; 2 &le; 2<sup>2</sup>-2 |
| | 2<sup>1</sup>-2 &le; 2 &le; 2<sup>2</sup>-2 |
| | 2<sup>1</sup>-2 &le; 2 &le; 2<sup>2</sup>-2 |
| | 2<sup>1</sup>-2 &le; 2 &le; 2<sup>2</sup>-2 |
| | 2<sup>1</sup>-2 &le; 2 &le; 2<sup>2</sup>-2 |


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
+ 2<sup>12</sup>-2 &le; 4095 &le; 2<sup>13</sup>-2 deci sunt 8190 valori asignabile \(2<sup>13</sup>-2\)
+ 8190 / 26 = 315 IP-uri pentru switch-uri \(fiecare switch are 26 de porturi\)
+ Daca impartirea da cu rest, adaugi 1 la rezultat
+ Rezerva un IP pentru DG => mai adaugi 1 la rezultat
+ Daca e mai mare ca 255 \(iese de pe 8 biti\) imparti la 256: 316 / 256 = 1 rest 60
+ Adaugi catul pe al treilea octet si restul pe al patrulea octet la primul IP din retea
+ Mai adaugi 1 pentru a gasi primul IP de host asignabil: `172.168.0.0` + 317 = `172.168.1.61`

Primul IP asignabil din reteaua `2047`
+ 2<sup>11</sup>-2 &le; 2047 &le; 2<sup>12</sup>-2 deci sunt 4094 valori asignabile
+ 4094 / 26 = 157 rest 12
+ Rest &ne; 0 => 158
+ IP pentru DG => 159
+ `172.168.32.0` + 160 = `172.168.32.160`

Primul IP asignabil din reteaua `1022`
+ 2<sup>9</sup>-2 &le; 1022 &le; 2<sup>10</sup>-2 deci sunt 1022 valori asignabile
+ 1022 / 26 = 39 rest ...
+ Rest &ne; 0 => 40
+ IP pentru DG => 41
+ `172.168.48.0` + 42 = `172.168.48.42`

### Numar switch-uri
+ 2<sup>x</sup>-2 &le; n &le; 2<sup>y</sup>-2
+ 2<sup>y</sup>-2 / 26 = a rest b
+ Daca b == 0 -> numar switch-uri = a
+ Daca b &ne; 0 -> numar switch-uri = a + 1

### Subnet Mask
+ codat in README: SM.SM.SM.SM
+ 2<sup>x</sup>-2 &le; n &le; 2<sup>y</sup>-2
+ sm = 32 - y
+ Transformare in IP: sm / 8 = a rest b; SM = 255 de a ori, apoi b biti de 1 de la stanga la dreapta, tranformati in numar, apoi 0 daca mai sunt octeti liberi
+ Exemplu: sm = 18; 18 / 8 = 2 rest 2 -> 255 de 2 ori, apoi 11000000 in numar: 192, apoi un 0 -> 255.255.192.0

### Default Gateway
+ codat in README: DG.DG.DG.DG
+ NA al retelei respective + 1

### DNS Server
+ codat in README: DNS.DNS.DNS.DNS
+ BA al subretelei serverului – 1 \(este si IP-ul serverului respectiv\)

### IP Router
+ codat in README: IPR.IPR.IPR.IPR
+ Routerele au cate un IP pentru fiecare interfata folosita.
+ Pentru legatura cu o ramura cu host-uri: interfata Gigabit 0/0, IP: Default Gateway-ul subretelei respective
+ Pentru legatura cu alte routere: interfata Serial cea mai mica posibila, IP: cel mai mic posibil din subreteaua respectiva
+ Pentru legatura cu Wi-Fi: interfata Gigabit 0/1

### IP Switch
+ codat in README: IPS.IPS.IPS.IPS
+ range: Default Gateway + 1 <-> Default Gateway + numar switch-uri
+ Fiecare switch va primi cel mai mic IP disponibil -> primul switch are IP: DG + 1

### IP Host
+ codat in README: IPH.IPH.IPH.IPH
+ incep de la: Default Gateway + numar switch-uri + 1

## Setup

### Host si SERVICE

+ \[End Devices\] -> PC -> nume: "Nume"
+ PC -> Physical -> power off -> inlocuieste placa de retea cu PT-HOST-NM-1CGE \(drag & drop\) -> power on
+ PC -> Desktop -> IP Configuration
  + IPv4 Address: IPH.IPH.IPH.IPH
  + Subnet Mask: SM.SM.SM.SM
  + Default Gateway: DG.DG.DG.DG
  + DNS Server: DNS.DNS.DNS.DNS
+ PC -> Desktop -> Email
  + Your Name: Nume
  + Email Address: Nume@info.ro
  + Incoming Mail Server: DNS.DNS.DNS.DNS
  + Outgoing Mail Server: DNS.DNS.DNS.DNS
  + User Name: Nume
  + Password: 123456
+ Save
+ \(optional\) Configure Email -> verific daca am scris corect
+ \[End Devices\] -> Laptop -> nume: "SERVICE"

### Switch

+ \[Network Devices\] -> \[Switches\] -> 2960 -> nume: "SwNume"
+ Pentru primul Switch din schema: \[Connections\] -> Console -> SwNume \(Console\) --- SERVICE \(RS 232\)  
+ Altfel, muta cablul Console de la dispozitivul vechi la noul dispozitiv de configurat
+ SERVICE -> Desktop -> Terminal -> OK -> Enter
+ [Comenzi Switch](#comenzi-switch)
+ \[Connections\] -> Copper Straight-Through -> SwNume \(GigabitEthernet 0/2\) --- PC \(GigabitEthernet0\)

### Router

+ \[Network Devices\] -> \[Routers\] -> 2911 \(sau 2901 daca se cere\) -> nume: "RNume"
+ RNume -> Physical -> power off -> inlocuieste placa de retea cu HWIC-2T \(drag & drop\) -> power on
+ Muta cablul Console de la dispozitivul vechi la noul dispozitiv de configurat
+ SERVICE -> Desktop -> Terminal -> OK -> `no`, Enter -> Enter
+ [Comenzi Router](#comenzi-router)
+ \[Connections\] -> Copper Straight-Through -> SwNume \(GigabitEthernet 0/1\) --- RNume \(GigabitEthernet 0/0\)

### Server

+ \[End-Devices\] -> Server -> nume: ServerNume
+ ServerNume -> Physical -> power off -> inlocuieste placa de retea cu PT-HOST-NM-1CGE \(drag & drop\) -> power on
+ ServerNume -> Desktop -> IP Configuration
  + IPv4 Address: DNS.DNS.DNS.DNS
  + Subnet Mask: SM.SM.SM.SM
  + Default Gateway: DG.DG.DG.DG
  + DNS Server: DNS.DNS.DNS.DNS
+ ServerNume -> Desktop -> Email
  + Your Name: ServerNume
  + Email Address: ServerNume@info.ro
  + Incoming Mail Server: DNS.DNS.DNS.DNS
  + Outgoing Mail Server: DNS.DNS.DNS.DNS
  + User Name: ServerNume
  + Password: 123456
  + Save
+ \(optional\) Configure Email, verific daca am scris corect
+ ServerNume -> Services -> HTTP
  + HTTP: off
+ ServerNume -> Services -> DNS
  + DNS Services: on
  + Name: info.ro
  + Type: A Record
  + Address: DNS.DNS.DNS.DNS
  + Add
+ ServerNume -> Services -> Syslog
  + Service: on
+ ServerNume -> Services -> Email
  + SMTP: on
  + POP3 Services: on
  + Domain Name: info.ro
  + User: toti userii \(Nume, Lap1, Lap2, SERVICE, ServerNume etc.\)
  + Password: 123456 pentru toti userii
  + `+` dupa fiecare user si parola
+ ServerNume -> Services -> FTP
  + Service: on
  + User: toti userii \(Nume, Lap1, Lap2, SERVICE, ServerNume etc.\)
  + Password: 123456 pentru toti userii
  + Bifeaza Write, Read, List
  + Add dupa fiecare user si parola

### Wi-Fi

+ \[Network Devices\] -> \[Wireless Devices\] -> WRT300N -> nume: Wi-FiNume
+ \[Connections\] -> Copper Straight-Through -> SERVICE \(FastEthernet0\) --- Wi-Fi \(Ethernet1\)
+ SERVICE -> Desktop -> IP Configuration
  + IPv4: `192.168.0.R` \(R e numar random\)
+ SERVICE -> Desktop -> Web Browser -> `192.168.0.1` -> Go -> `admin`, `admin`
+ SERVICE -> Basic Setup
  + Internet Connection Type: Static IP
  + Internet IP Address: al doilea IP din RA-ul subretelei de 2 IP-uri a Wi-Fi-ului
  + Subnet Mask: 255.255.255.252
  + Default Gateway: primul IP din RA-ul subretelei de 2 IP-uri a Wi-Fi-ului
  + DNS1: DNS.DNS.DNS.DNS
  + Router IP
    + IP Address: `192.160.X.Y` \(X e numar random, Y se calculeaza incadrand numarul dorit de utilizatori ai WiFi-ului + IP-ul Wi-Fi-ului intre puteri ale lui 2, - 2; Y e multiplul valorii superioare, + 1\)
    + Subnet Mask: `255.255.255.224` \(32 - puterea aleasa mai sus, transformat in binar\)
  + Maximum number of Users: numarul dorit de useri de Wi-Fi, daca nu se specifica alege unul random (<= 253)
  + Scroll down -> Save Settings
  + Scroll up -> Start IP Address -> Y + 1
  + Scroll down -> Save Settings
+ SERVICE -> Desktop -> IP Configuration
  + IPv4: 192.168.X.Z \(Z e un IP valid din range: Start IP Address <-> Start IP Address + Maximum numbers of Users - 1\)
+ SERVICE -> Desktop -> Web Browser -> `192.168.X.Y` -> Go -> `admin`, `admin`
+ SERVICE -> Wireless
  + Basic Wireless Settings
    + Network Name (SSID): Wi-FiNume
    + Standard Channel: 6 sau 11
  + Wireless Security
    + Security Mode: WPA2 Personal
    + Passphrase: InfoTest
  + Wireless MAC Filter \(daca vrei sa faci whitelist/blacklist; doar dupa configurarea laptopurilor\)
    + Enabled
    + Prevent / Permit
    + Pentru a obtine adresa MAC: Command Prompt -> `ipconfig/all` -> Physical Address -> Wireless, nu Bluetooth. Aceasta adresa trebuie formatata punand ":" intre fiecare 2 cifre pentru a putea fi adaugata in filtru
+ Dupa ce adaugi cele 2 laptopuri si te asiguri ca merg, conecteaza Wi-Fi-ul la Router-ul apropiat: \[Connections\] -> Copper Cross-Over -> R-Server \(Gigabit 0/1\) --- Wi-FiNume \(Internet\)


### Laptop Wi-Fi

+ \[End-Devices\] -> Laptop -> nume: "Lap1" / "Lap2"
+ "Lap1" / "Lap2" -> Physical -> power off -> inlocuieste placa de retea cu WPC-300N \(drag & drop\) -> power on
+ "Lap1" / "Lap2" -> PC Wireless -> Profiles -> New -> Wi-FINume \(CAT MAI REPEDE, NU LASA SA DEA AUTOCOMPLETE\) -> Advanced Setup -> Next -> Next -> Security: WPA2-Personal -> Next -> Pre-shared Key: InfoTest -> Save -> Connect to Network

## Comenzi

### Comenzi Switch

Enter dupa fiecare comanda  

```
enable
configure terminal
no ip domain-lookup
hostname SwNume
no cdp run
service password-encryption
enable secret ciscosecpa55
enable password ciscoenapa55
banner motd $Vineri 14.03.2025 la ora 9:00 va avea loc sedinta IT!$
line console 0
password ciscoconpa55
login
logging synchronous
exec-timeout 20 10
exit
line vty 0 15
password ciscovtypa55
login
logging synchronous
exec-timeout 5 5
end
copy running-config startup-config (salveaza configuratia)
Enter (intrebare despre nume)
clock set HH:MM:SS D Mon YYYY (data si ora curenta)
configure terminal
ip domain name info.ro
username Admin01 privilege 15 secret Admin01pa55
line vty 0 15
transport input ssh
login local
exit
crypto key generate rsa
2048, Enter (intrebare despre biti)
ip ssh version 2
logging host DNS.DNS.DNS.DNS
service timestamps log datetime msec
service timestamps debug datetime msec
interface vlan 1
description ramura Nume
ip address IPS.IPS.IPS.IPS SM.SM.SM.SM
no shutdown
exit

interface range fa 0/1-2
no shutdown
exit

> necesita confirmare

interface range fa 0/1-24 (la primul switch, range-ul va fi 2-24, intrucat cu 0/1 vom uni TestDHCP)
shutdown
exit

> pana aici  

ip default-gateway DG.DG.DG.DG
exit
```

### Comenzi Router

Enter dupa fiecare comanda  

```
enable
configure terminal
no ip domain-lookup
hostname RNume
no cdp run
service password-encryption
security passwords min-length 10
login block-for 50 attempts 3 within 20
enable secret ciscosecpa55
enable password ciscoenapa55
banner login $Accesul persoanelor neautorizate este strict interzis!$
banner motd $Vineri 21.03.2025 la ora 14:00 serverul va fi oprit!$
line console 0
password ciscoconpa55
login
logging synchronous
exec-timeout 20 10
exit
line vty 0 15
password ciscovtypa55
login
logging synchronous
exec-timeout 5 5
end
copy running-config startup-config (salveaza configuratia)
Enter (intrebare despre nume)
clock set HH:MM:SS D Mon YYYY (data si ora curenta)
configure terminal
ip domain name info.ro
username Admin01 privilege 15 secret Admin01pa55
line vty 0 15
transport input ssh
login local
exit
crypto key generate rsa
2048, Enter (intrebare despre biti)
ip ssh version 2
logging host DNS.DNS.DNS.DNS
service timestamps log datetime msec
service timestamps debug datetime msec
interface gigabit 0/0
description legatura cu ramura Nume
ip address IPR.IPR.IPR.IPR SM.SM.SM.SM
ip helper-address IPRS.IPRS.IPRS.IPRS (seteaza dhcp: doar in giga 0/0, in toate routerele in afara de r-server) (ip r-server din legatura serial)
no shutdown
exit
interface giga 0/1 (doar la routerul care face legatura cu wifi)
description legatura cu wifi
ip address IPR.IPR.IPR.IPR 255.255.255.252
no shutdown
exit
interface serial 0/0/0
description legatura cu R-CelalaltNume
ip address IPR.IPR.IPR.IPR 255.255.255.252
no shutdown
interface giga 0/2 (shutdown la interfetele pe care nu le folosesti: giga 0/2 mereu, giga 0/1 daca nu ai wifi pe branch, si una dintre cele 2 serial la routerele din capete)
shutdown
exit
```

Doar in RServer, pentru fiecare retea mare:
```
ip dhcp excluded-address DG.DG.DG.DG IPU.IPU.IPU.IPU (DG pentru care configurezi dhcp acum) (IPU reprezinta IPH la retele in care primul host are ip static, in rest IPU este adresa ultimului switch)
ip dhcp pool Nume
network NA.NA.NA.NA SM.SM.SM.SM
default-router DG.DG.DG.DG
dns-server DNS.DNS.DNS.DNS
end
```

Pentru fiecare retea de care nu e legat direct routerul:
```
ip route NA.NA.NA.NA SM.SM.SM.SM serial 0/0/index (NA si SM de la subreteaua catre care faci rutarea acum) (index e indicele interfetei serial care porneste din router catre subreteaua catre care faci rutarea acum)
exit
```

## Testare

### Ping si SSH

+ PC -> Desktop -> Command Prompt

```
ping IP.IP.IP.IP
ssh -l Admin01 IP.IP.IP.IP
```
+ Password: `Admin01pa55`
+ In prima subretea, testeaza switch-ul si router-ul cu ping si ssh din host.
+ In celelalte subretele, testeaza toate IP-urile disponibile cu ping si ssh doar din command prompt-ul dispozitivului curent sau din terminalul SERVICE-ului, dupa caz.
+ Ping-ul si ssh-ul dispozitivului curent vor fi testate abia dupa configurarea urmatorului dispozitiv.

### HTTP si DNS

+ Dupa ce ai configurat serverul: Nume -> Physical -> Desktop -> Web Browser -> URL: info.ro
+ Adauga s la http
+ Site-ul Cisco Packet Tracer trebuie sa apara

### Email

+ Dupa ce ai configurat serverul: Nume -> Physical -> Desktop -> Email -> Compose
  + To: NUMESERVER@info.ro
  + Subject: Test
  + Mesaj: Testare serviciu email
+ Send
+ Server -> Physical -> Desktop -> Email -> Receive
+ Mail-ul de la primul host trebuie sa apara
+ Reply -> Mesaj: Confirmare primire email -> Send
+ Nume -> Physical -> Desktop -> Email -> Receive
+ Reply-ul de la server trebuie sa apara

### FTP

+ Dupa ce ai configurat serverul: Nume -> Physical -> Desktop -> Command Prompt
+ `dir`
+ `ftp DNS.DNS.DNS.DNS`
+ Username: Nume
+ Password: 123456
+ `dir`
+ `get [fisier_ales]` alege un fisier, cat mai mic
+ `quit`
+ `dir`
+ Fisierul trebuie sa apara printre fisierele enumerate, adica output-ul sa fie diferit de cel de la inceput.

### Syslog

+ Dupa ce ai configurat serverul: scoate un cablu de la locul lui lui si pune-l la loc.
+ In server, la serviciul Syslog, trebuie sa apara niste mesaje cu timestamps.
