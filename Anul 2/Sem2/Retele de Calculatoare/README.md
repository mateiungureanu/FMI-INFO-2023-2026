# Laborator: Dragan Mihaita

## Table of contents
1. [Switch](#1-switch)
2. [Router](#2-router)

## 1. Switch

### Setup

+ Click pe \[End Devices\], click pe PC, click **in coltul din stanga jos** al spatiului de lucru
+ Click pe numele lui \(PC0\), sterge numele, scrie "GRECIA"
+ Click pe monitorul calculatorului
+ **Power off**
+ Scroll in jos pana la placa de retea, drag & drop in sectiunea Modules, cauta in sectiunea Modules placa cu **CGE** \(PT-HOST-NM-1CGE\), drag & drop in locul placii de retea
+ **Power on**
+ Schimba de pe tabul _physical_ pe tabul _desktop_
+ Intra pe **IP Configuration**
  + IPv4 Address: `174.40.20.22`
  + Subnet Mask: `255.255.254.0`
  + Default Gateway: `174.40.20.1` \(cel mai mic IP posibil asignabil\)
  + DNS Server: `209.165.200.254`
+ Inchide de la x-ul mic
+ Intra pe **Email**
  + Your Name: `GRECIA` \(numele PC-ului\)
  + Email Address: `GRECIA@info.ro`
  + Incoming Mail Server: `209.165.200.254`
  + Outgoing Mail Server: `209.165.200.254`
  + User Name: `GRECIA`
  + Password: `123456`
+ Click **Save**
+ \(optional\) Click **Configure Email**, verific daca am scris corect
+ Click pe \[Network Devices\], click pe \[Switches\], click pe **2960**, click **la cativa centimetri mai sus si mai la dreapta fata de PC**
+ Click pe numele lui \(Switch0\), sterge numele, scrie "Sw-GRECIA"
+ Click pe \[End Devices\], click pe Laptop, click **la cativa centimetri mai sus si mai la stanga fata de Switch**
+ Click pe \[Connections\], click pe \[Console\], click pe Switch, click pe **Console**, click pe Laptop, click pe **RS 232**
![Rezultat](poze/switch.png)
+ Click pe Laptop
+ Schimba de pe tabul _physical_ pe tabul _desktop_
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
hostname Sw-GRECIA
```
Sw-GRECIA\(config\)\#
```
no cdp run
SERVICE password-encryption
enable secret ciscosecpa55
enable password ciscoenapa55
banner motd $Vineri 14.03.2025 la ora 9:00 va avea loc sedinta IT!$
line console 0
```
Sw-GRECIA\(config-line\)\#
```
password ciscoconpa55
login
logging synchronous
exec-timeout 20 10
exit
```
Sw-GRECIA\(config\)\#
```
line vty 0 15
```
Sw-GRECIA\(config-line\)\#
```
password ciscovtypa55
login
logging synchronous
exec-timeout 5 5
exit
```
Sw-GRECIA\(config\)\#
```
end
```
Sw-GRECIA\#
> **IMPORTANT**
> Comanda asta salveaza configuratia. O poti rula oricand vrei, cand esti in Sw-GRECIA\#
```
copy running-file startup-config
```
+ Apasa **Enter** \(intrebarea despre nume\)
```
clock set HH:MM:SS D Mon YYYY
```
+ Exemplu: `clock set 16:58:15 6 Mar 2025`
```
configure terminal
```
Sw-GRECIA\(config\)\#
```
ip domain name info.ro
username Admin01 privilege 15 secret Admin01pa55
line vty 0 15
```
Sw-GRECIA\(config-line\)\# 
```
transport input ssh
login local
exit
```
Sw-GRECIA\(config\)\#
```
crypto key generate rsa
```
+ Scrie `2048`, apoi apasa **Enter** \(intrebare despre biti\)
```
ip ssh version 2
logging host 209.165.200.254
SERVICE timestamps log datetime msec
SERVICE timestamps debug datetime msec
interface vlan 1
```
Sw-GRECIA\(config-if\)\#
```
description legatura cu reteaua 174.40.20.2/23
ip address 174.40.20.2 255.255.254.0
no shutdown
```
+ \*Mar 6, 17:24:32.033: %LINK-5-CHANGED: Interface Vlan1, changed state to up
```
exit
```
Sw-GRECIA\(config\)\# 
```
ip default-gateway 174.40.20.1
```


## 2. Router