#include <iostream>

using namespace std;

/****** date membre conts ----> obligatoriu rescrierea op= ********/
/*
class Profesor
{
    string denumire;
    const int an;
public:
    Profesor(string s = "") : an(2024){denumire = s;}
    void afis(){cout<<an<<" "<<denumire<<endl;}
    Profesor& operator= (const Profesor&);
};

Profesor& Profesor::operator=(const Profesor& ob)
{
    if (this != &ob)
    {
        denumire = ob.denumire;
    }
    return *this;
}
int main()
{
    Profesor A("Popescu");
    A.afis();
    Profesor B;
    B = A;
    B.afis();
    return 0;
}
*/

/****** datele membre referinta necesita obligatoriu rescrierea op=  *******/
/*
class Profesor
{
    string denumire;
public:
    Profesor(string s = ""){denumire = s;}
    void afis(){cout<<denumire<<endl;}
};

class Materie
{
    string nume;
    Profesor& p;
public:
    Materie(Profesor& pp) : p(pp){}
    void set_nume(string s){nume = s;}
    void afis(){cout<<nume<<" "; p.afis();}
    Materie& operator=(const Materie&);
};

Materie& Materie::operator=(const Materie& ob)
{
    if (this != & ob)
    {
        p = ob.p;
        nume = ob.nume;
    }
    return *this;
}

int main()
{
    Profesor A("Popescu");
    Materie B(A);
    B.set_nume("Algebra");
    B.afis();
    Materie C(B);
    C.set_nume("Geometrie");
    B = C;
    B.afis();
    return 0;
}
*/
