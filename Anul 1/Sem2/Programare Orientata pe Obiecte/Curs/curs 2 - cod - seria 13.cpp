#include <iostream>

using namespace std;

/**** "tipul" referinta ****/
class Materie
{
    int& nota;   /// mai tarziu
};

int main()
{
    int a(100); /// echivalent cu int a = 100;
    int& b = a; /// alias pentru a; arata catre aceeasi zona de memorie
    cout<<a<<" "<<b<<endl;
    a = a +10;
    cout<<a<<" "<<b<<endl;
    b = b + 30;
    cout<<a<<" "<<b<<endl;

    int c = 200;
    b = c;
    cout<<a<<" "<<b<<endl;

///    int &d;   /// eroare ; neinitializata
///    d = c;
}

/*
class Materie
{ private:
    string denumire;
    int an;
  public:
    void afisare();
    Materie(string s = "anonim", int a = 2024);
    ~Materie();
    void set_an(int); /// setter
    string get_denumire();
    int get_an(){return an;}
};

Materie::Materie(string s, int a) : denumire(s), an(a){}
void Materie::afisare(){cout<<"denumire ="<< denumire<<" an = "<<an<<endl;}
Materie::~Materie(){cout<<"destructor pentru "<<denumire<<endl;}
void Materie::set_an(int a){an = a;} /// setter
string Materie::get_denumire(){ return denumire;}

int main()
{
    Materie A, B("SDA"), C("LFA",9);

    A.afisare();
    B.afisare();
    C.afisare();
///    C.an = 10;
    C.set_an(10);
    C.afisare();
    cout<<C.get_denumire();
}
*/
/******** exemplu rezolutie de scop fara clase **********/

/*
int x = 10;

void f(int x)
{
///    x = 30;
    cout<<::x;
}

int main()
{
    int x = 20;
    f(x);
}
*/
/******* destructor, set, get, separarea declararii de definire; operatorul de rezolutie de scop *********/
/*
class Materie
{ private:
///    const int nota;  /// mai tarziu, const si lista de init constructori
    string denumire;
    int an;
  public:
    void afisare();
///    Materie(string s = "anonim", int a = 2024) : denumire(s), an(a), nota(10){} /// lista de initializare a constructorilor
    Materie(string s = "anonim", int a = 2024);
    ~Materie();
};

Materie::Materie(string s, int a) : denumire(s), an(a){}
void Materie::afisare(){cout<<"denumire ="<< denumire<<" an = "<<an<<endl;}
Materie::~Materie(){cout<<"destructor pentru "<<denumire<<endl;}

int main()
{
    Materie A, B("SDA"), C("LFA",9);

    A.afisare();
    B.afisare();
    C.afisare();
}
*/

/*******   supraincarcarea functiilor - exemplificare constructor *********/
/*
class Materie
{ private:
    string denumire;
    int an;
  public:
    void afisare(){cout<<"denumire ="<< denumire<<" an = "<<an<<endl;}
/*    Materie(){denumire = "anonim"; an = 2024;}  /// constructor de initializare explicit
    Materie(string s){denumire = s; an = 1000;}
    Materie(string s, int a){denumire = s; an = a;} */
///    Materie(string s = "anonim", int a = 2024){denumire = s; an = a;} /// valori implicite
/*    Materie(string s = "anonim", int a = 2024) : denumire(s), an(a){} /// lista de initializare a constructorilor
};

int main()
{
///    Materie A;  /// constructor de initializare; implicit
    Materie B("SDA"); /// constructor - parametrizat; trebuie explicit
    Materie C("LFA",9);/// constructor - parametrizat; trebuie explicit

///    A.afisare(); /// functie membra afisare();
    B.afisare();
    C.afisare();
}
*/
/******** TO DO **********************/
/*
class Materie
{
    string denumire;
    int an;
};

int main()
{
    Materie A;  /// constructor de initializare; implicit
    A.citire(); /// functie membra citire();
    cout<<A; /// supraincarcare operator<<
    A = A + 10; /// supraincarcare operator+

    Materie B("SDA"); /// constructor - parametrizat; trebuie explicit
    Materie C("LFA",9);/// constructor - parametrizat; trebuie explicit

    if (B == C) cout<<"aceleasi"; /// supraincarcare operator==

    return 0;
}
*/
