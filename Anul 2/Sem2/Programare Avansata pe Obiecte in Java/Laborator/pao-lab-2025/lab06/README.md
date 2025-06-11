# PAO Lab 6

## Exercitiul 1 - Interfete marker

Modelati o clasa Vessel (vapor) care contine un camp de tip String numit name.
Suprascrieti in aceasta clasa metoda clone() din Object cu si fara a implementa Clonable.

## Exercitiul 2 - Clase adaptor

Interfata java.awt.event.WindowListener si clasa adaptor java.awt.event.WindowAdapter din Java Swing.
Creati un nou WindowListener care sa implementeze doar metoda WindowListener#windowOpened().

## Exercitiul 3 - Extinderea interfetelor 

Creati o interfata Bird care contine o metoda default fly().
Creati o interfata Plane care contine o metoda default fly().
Creati clasa Superman care implementeaza interfata Bird si Plane.

## Exercitiul 4 - Sealed classes

Modelati clasa abstracta MedicalStaff care poate avea ca subclase doar clasele Doctor si Nurse.
La randul ei clasa Doctor poate avea ca subclase doar clasele Surgeon si GeneralPractitioner, in timp ce clasa Nurse nu
poate fi extinsa.

## Exercitiul 5 - Enums

Creati un enum numit Day care contine zilele saptamanii. 
Verificati output-ul metodelor values(), name() si ordinal().

