#include <iostream>

using namespace std;

int main()
{
///    int d = 1;
///    const int* p = &d;
///    *p = 2;

///    const int A = 10;
///    int* q = &A;
    //int* q = (int*)&A;
    //*q = 20;

///    int* const r = &A; /// vezi cazul int*q = &A;
}

/************ obiecte statice **********************/
/*
class Carte
{ int a;
public:
    Carte(int x):a(x){cout<<"constr "<<a<<"\n";}
    void afis(){cout<<"carte\n";}
    ~Carte(){cout<<"destructor "<<a<<"\n";}
} A(10);

void adauga() { static Carte B(20);}

static Carte F(70);
Carte C(30);

int main(){
    Carte D(40);
    adauga();
    Carte E(50);
    static Carte G(80);
    return 0;
}
*/

/************ mutable ******************************/
/*
int main()
{
    int i = 10;
    auto A = [i]()mutable{i = i * 2; cout<<"local "<<i<<endl;};
    A();
    cout<<i<<endl;
    i = 25; A(); cout<<i<<endl;
    i = 30; A(); cout<<i<<endl;
    return 0;
}
*/
/*
int main()
{
    int i = 10;
    auto A = [&i](){i = i * 2; cout<<"local "<<i<<endl;};
    A();
    cout<<i<<endl;
    i = 25; A(); cout<<i<<endl;
    i = 30; A(); cout<<i<<endl;
    return 0;
}
*/
/*
int main()
{
    int i = 10;
    auto A = [i]()mutable{i = i * 2; cout<<"local "<<i<<endl; return i;};
    int j = A();
    cout<<i<<endl;
    i = 25; j = A(); cout<<i<<endl;
    i = 30; j = A(); cout<<i<<endl;
    return 0;
}
*/
/*
int main()
{
    int i = 10;
    auto A = [&i](){i = i * 2; cout<<"local "<<i<<endl; return i;};
    int j = A();
    cout<<i<<endl;
    i = 25; j = A(); cout<<i<<endl;
    i = 30; j = A(); cout<<i<<endl;
    return 0;
}
*/
/************ referinte ****************************/
/*
class Carte{
public:
    void afis(){cout<<"\ncarte\n";}
    Carte operator+(Carte ob){cout<<"\n + in baza"; return Carte();}
    Carte operator-(Carte ob){cout<<"\n - in baza"; return Carte();}
    Carte operator*(Carte& ob){cout<<"\n * in baza"; return Carte();}
};
class Articol : public Carte{
public:
    void afis(){cout<<"articol\n";}
    Articol operator+(Articol ob){cout<<"\n + in derivata"; return Articol();}
    Articol operator*(Articol& ob){cout<<"\n * in derivata"; return Articol();}
};

int main()
{
    Carte a,b,c;
///    c = a + b;
///    c = a - b;

    Articol d,e,f;
///    f = d + e;
///    (d - e).afis();  /// ok, pt ca rezultat Carte
///    f = d - e; /// d - e returneaza carte; articol = carte eroare; definire op=
///    f = d * e; /// pentru ca redefinit in clasa derivata

///    (a + d).afis(); /// a.operator+(d) ----> object slicing
        d + a; /// d.operator+(a);    operator+(Articol);; Articol = carte Nu;
///        ((Carte)d) + a; ok, pt ca (Carte) + Carte;
}
*/

/******** pointeri catre clase derivate ************/
/*
class Carte{public: virtual void afis(){cout<<"carte\n";}};
class Articol : public Carte{
public:
    void afis(){cout<<"articol\n";}
    void specific_derivata(){cout<<"specific\n";}
};

int main()
{
    Carte x;
    Articol y;
    x = y; /// obiect baza = obiect derivat direct; afiseaza "carte" / object slicing
    x.afis();
///    y = x; /// invers nu

    Carte* p = &y;
    y.afis(); /// afiseaza "articol"
    p->afis(); /// afiseaza "carte" / stabilit la compile time
///    p->specific_derivata(); /// pentru ca p stabilit ca pointer catre clasa de baza
///    ((Articol*)p)->specific_derivata();
    Articol * r = dynamic_cast<Articol*>(p);
    cout<<r<<endl;
///    (dynamic_cast<Articol*>(p))->specific_derivata();
    return 0;
}
*/

/***************************************************/
/*
class Carte{public: void afis(){cout<<"carte\n";}};
class Articol{public: void afis(){cout<<"articol\n";}};

int main()
{
    Carte x,y;
///    Articol* p = &x;
    Articol* p = (Articol*) &x;
    p->afis(); /// afiseaza "articol"
///    y = *p;
///    y = (Carte)(*p); /// atentie la tip de eroare "no matching function contr param (articol&)
    y = *(Carte*)(p);
    y.afis();
    return 0;
}
*/
