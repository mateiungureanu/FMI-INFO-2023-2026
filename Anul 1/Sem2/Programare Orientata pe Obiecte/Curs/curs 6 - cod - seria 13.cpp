#include <iostream>

using namespace std;


/// virtual adauga un pointer "vptr" in clasa---> creste dimensiunea; late binding - > polimorfism la executie

class Serie
{
    char y;
    int x;
    char z1, z2, z3, z4;
    short int b1,b2;
public:
    virtual void f1(){}
    void f2(){}
    void f3(){}
    int f4(){return 1;}
};

int main()
{
    Serie A;
    cout<<sizeof(A)<<endl;
}


/**** alt exemplu de object slicing ****/
/*
class Serie
{
protected:
    string denumire;
public:
    Serie(string s = "") : denumire(s){}
    virtual void afis(){cout<<denumire<<endl;}
};

class Serie13 : public Serie{
    int nota;
public:
    Serie13(int a = 0, string d = ""):Serie(d),nota(a){}
    void afis(){cout<<nota<<" "<<denumire;}
};

void f(Serie& C){ C.afis(); }

int main()
{
    Serie A("info");
    Serie13 B(10,"mate");
    f(A);
    f(B);
    cout<<endl<<sizeof(A)<<" "<<sizeof(B);
}
*/

/*
class Baza
{
protected:
    int x;
public:
    Baza(){ x = 0;}
    Baza(int x) { this->x = x;}
    Baza(const Baza& ob){ x = ob.x;}
    void afis(){cout<<x<<'\n';}
};

class Derivata : public Baza{
int y;
    public:
    Derivata(){ y = 0;} /// Derivata() : Baza(){ y = 0;}
    Derivata(int x, int y) : Baza(x) {this->y = y;}
///    Derivata(const Derivata& ob) : Baza(ob) {y = ob.y;} /// atentie object slicing pt CC din Baza
    Derivata(const Derivata& ob) {x = ob.x; y = ob.y;} /// ok si asa
    void afis(){cout<<this->x<<' '<<y<<'\n';}
};


int main()
{
    Derivata ob1; ob1.afis();
    Derivata ob2(1,2); ob2.afis();
    Derivata ob3(ob2); ob3.afis();
    Derivata ob4;
    ob4 = ob3;
    ob4.afis();
}
*/

/* constructorii pentru mostenire */
/*
class Baza
{
protected:
    int x;
public:
    Baza(){ x = 0; cout<<x<<'\n';}
    Baza(int x) { this->x = x; cout<<this->x<<'\n';}
    Baza(const Baza& ob){ x = ob.x; cout<<this->x<<'\n';}
};

class Derivata : public Baza{
int y;
    public:
    Derivata(){ y = 0; cout<<this->x<<' '<<y<<'\n';}
    Derivata(int x, int y) : Baza(x) { this->y = y; cout<<this->x<<' '<<y<<'\n';}
    Derivata(const Derivata& ob) : Baza(ob){ y = ob.y; cout<<this->x<<' '<<y<<'\n';}
};

int main()
{
    Derivata ob1;
    Derivata ob2(1,2);
    Derivata ob3(ob2);
}
*/

/// varianta using sau varianta functie noua publica care
/// acceseaza functia devenita privata
/*
class Baza
{
protected:
    int x;
public:
    void f(){ x = 1; cout<<x<<' ';}
};

class Derivata : Baza{
public:
    using Baza::f;
///    void f(){ x = 2; cout<<x<<' ';}
};

class Derivata2 : public Derivata{
public:
///    void f(){ x = 3; cout<<x<<' ';}
};

int main()
{
    Derivata ob1;
    ob1.f();
    Derivata2 ob2;
    ob2.f();

    return 0;
}
*/

/*
class Baza
{
protected:
    int x;
public:
    void f(){ x = 1; cout<<x<<' ';}
};

class Derivata : Baza{
public:
    void f(){ x = 2; cout<<x<<' ';}
};

class Derivata2 : public Derivata{
public:
    void f(){ x = 3; cout<<x<<' ';}  //// atentie la definirea clasei fara a o utiliza
};

int main()
{
    Derivata ob1;
    ob1.f();
///    Derivata2 ob2;
///    ob2.f();
    return 0;
}
*/

/*
class Baza
{
public:
    void f(){ cout<<"baza\n";}
};

class Derivata : Baza{
public:
    using Baza::f;
};

class Derivata2 : public Derivata{
public:
};

int main()
{
    Derivata ob1;
    ob1.f();
    Derivata2 ob2;
    ob2.f();

    return 0;
}
*/
