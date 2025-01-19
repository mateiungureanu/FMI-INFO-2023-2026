#include <iostream>

using namespace std;

class Baza{
public:
    virtual void f1(){cout<<"B\n";}
};

class Derivata: public Baza
{
public:
    void f1(){cout<<"D\n";}
    void f2(){cout<<"alta\n";}
};

int main()
{
    Baza*p = new Derivata(); /// upcast
    p->f1();
///    p->f2();
    ((Derivata*)(p))->f2();
    (dynamic_cast<Derivata*>(p))->f2(); /// downcast merge daca si numai daca sursa polimorfica aka fct virtuala in baza
}

/******** functii virtuale ***********/
/*
class Interfata
{
public:
    virtual void f2(){}
};

class Baza1 : virtual public Interfata
{
public:
    virtual void f1(){cout<<"Baza1_f1\n";}
    virtual void f2(){cout<<"Baza1_f2\n";}
    virtual void f3(){cout<<"Baza1_f3\n";}
};

class Baza2: virtual public Interfata
{
public:
    void f1(){cout<<"Baza2_f1\n";}
    virtual void f2(){cout<<"Baza2_f2\n";}
};

class Derivata: public Baza1, public Baza2
{
public:
    void f1(){cout<<"Derivata_f1\n";}
    void f2(){cout<<"Derivata_f2\n";}
};

int main()
{
    cout<<sizeof(Baza1)<<" "<<sizeof(Baza2)<<" "<<sizeof(Derivata)<<endl;
    Interfata* p = new Derivata(); /// upcast
    p->f1();
    p->f2();
}
*/

/*
class Baza1
{
public:
    virtual void f1(){cout<<"Baza1_f1\n";}
    virtual void f2(){cout<<"Baza1_f2\n";}
    virtual void f3(){cout<<"Baza1_f3\n";}
};

class Baza2
{
public:
    void f1(){cout<<"Baza2_f1\n";}
    virtual void f2(){cout<<"Baza2_f2\n";}
};

class Derivata: public Baza1, public Baza2
{
public:
    void f1(){cout<<"Derivata_f1\n";}
    void f2(){cout<<"Derivata_f2\n";}
};

int main()
{
    cout<<sizeof(Baza1)<<" "<<sizeof(Baza2)<<" "<<sizeof(Derivata)<<endl;
    Baza2* p = new Derivata();
    p->f1();
    p->f2();
}
*/
/*
class Baza{
 //   int a;
 //   char b,c,d,e,h;
 //   long long i;
 // string z;
public:
    virtual void f(){}
    virtual int g(){return 1;}
};

int main()
{
    cout<<sizeof(Baza);
}
*/
/********* mostenire virtuala *************/
/*
class Baza
{
public:
    Baza(){cout<<"Baza\n";}
};

class Baza2
{
public:
    Baza2(){cout<<"Baza2\n";}
};

class Derivata1 : public Baza2
{
public:
    Derivata1(){cout<<"Derivata1\n";}
};

class Derivata2 : public Baza
{
public:
    Derivata2(){cout<<"Derivata2\n";}
};

class Derivata3 : virtual public Baza
{
public:
    Derivata3(){cout<<"Derivata3\n";}
};

class Derivata4 : public Baza
{
public:
    Derivata4(){cout<<"Derivata4\n";}
};

///class Derivata5 : public Derivata1, Derivata2, protected Derivata3, public Derivata4
class Derivata5 : public Derivata1, protected Derivata3
{
public:
    Derivata5(){cout<<"Derivata5\n";}
};

int main()
{
    Derivata5 ob;  /// virtual prioritizeaza baza
}*/

/*
class Baza
{
public:
    Baza(){cout<<"Baza\n";}
};

class Baza2
{
public:
    Baza2(){cout<<"Baza2\n";}
};

class Derivata1 : virtual public Baza
{
public:
    Derivata1(){cout<<"Derivata1\n";}
};

class Derivata2 : public Baza2
{
public:
    Derivata2(){cout<<"Derivata2\n";}
};

///class Derivata5 : public Derivata1, Derivata2, protected Derivata3, public Derivata4
class Derivata5 : public Derivata2, public Derivata1
{
public:
    Derivata5(){cout<<"Derivata5\n";}  /// afis B1, B2, D2, D1, D5 pt ca mostenirea D1 este virtual
};

int main()
{
    Derivata5 ob;  /// virtual (oriunde in ierarhie) => prioritate la construire
 }

*/

/**** problema diamantului ****/
/*
class interfata
{
public:
    interfata(){cout<<"constructor interfata\n";}
    interfata(int x){cout<<x<<" constructor interfata\n";}
    void afis(){cout<<"interfata\n";}
};

class universitate : virtual public interfata{
public:
    universitate(){cout<<"constructor universitate\n";}
    universitate(int x):interfata(x){cout<<x<<" constructor universitate\n";}
    void afis(){cout<<"universitatea ";}
};

class oras : virtual public interfata{
public:
    oras(){cout<<"constructor oras\n";}
    oras(int x):interfata(x){cout<<x<<" constructor oras\n";}
    void afis(){cout<<"din Bucuresti";}
};

class unibuc : public universitate,public oras
{
public:
    unibuc(){cout<<"constructor unibuc\n";}
///    unibuc(int x):universitate(x),oras(x){cout<<x<<" constructor unibuc\n";} ///atentie, nu se trimite corect catre baza
///    unibuc(int x):interfata(x){}
    };

int main()
{
    unibuc ob;
    ob.afis(); /// ambiguitate - necesita rescrierea functiei, sau apel explicit ob.universitate::afis();
    cout<<"*****\n";
///    unibuc ob2(10); /// nu e suficienta lista de init constr doar la parinti
}
*/

/**** mostenire din baza multipla ****/
/*
class universitate
{
public:
    void afis(){cout<<"universitatea ";}
};

class oras
{
public:
    void afis(){cout<<"din Bucuresti";}
};

class unibuc : public universitate, public oras
{

};

int main()
{
    unibuc ob;
    ob.afis(); /// ambiguitate - necesita rescrierea functiei, sau apel explicit ob.universitate::afis();
}
*/
/**** redefinirea functiilor membre statice - mica obs ****/
/*
class Baza
{
public:
    void afis(){cout<<"nestatic in baza\n";}
    /// static void afis(){cout<<"static in baza";} /// nu pot avea nestatic supraincarcat cu static si viceversa
};

class Derivata : public Baza{
public:
    static void afis(){cout<<"static in derivata\n";}
};

class Derivata2 : public Derivata{
public:
    static void afis(int x){cout<<"static in derivata 2\n";}
};

int main()
{
    Baza A;
    A.afis();

    Derivata B;
    B.afis();
    Derivata::afis();
    B.Baza::afis();

    Derivata2 C;
///    C.afis();/// nu exista in derivata 2 si cea din derivata e ascunsa
    Derivata2::afis(10);
}
*/
/**** redefinirea functiilor membre nestatice ************/
/*
class Baza {
public:
  int f() const { cout << "Base::f()\n";  return 1;  }
  int f(string) const { return 1; }
  void g() { }
};

class Derivata1 : public Baza {
public:    void g() const {}
};

class Derivata2 : public Baza {
public:
  // Redefinition:
  int f() const { cout << "Derived2::f()\n"; return 2;  }
};

class Derivata3 : public Baza {
public:
  // Change return type:
  void f() const { cout << "Derived3::f()\n"; }
};
class Derivata4 : public Baza {
public:
  // Change argument list:
  int f(int) const {
    cout << "Derived4::f()\n";
    return 4;
  }
};

int main() {
  string s("hello");

  Derivata1 d1;
  int x = d1.f();
  cout<<d1.f(s);

  Derivata2 d2;
  x = d2.f();
//!  d2.f(s); // string version hidden

  Derivata3 d3;
//!  x = d3.f(); // return int version hidden

  Derivata4 d4;
//!  x = d4.f(); // f() version hidden
  x = d4.f(1);
}
*/
