#include <iostream>

using namespace std;
/********** polimorfism la executie prin functii virtuale - upcasting si downcasting *********/

/***** smart pointers *****/
/*
class Persoana
{
protected:
    string nume;
public:
    Persoana(string s = "") : nume(s){}
    virtual void citire();
    virtual void afisare();
    virtual ~Persoana(){}
};

class Elev : public Persoana
{
    int clasa;
public:
    Elev(string s="", int c=0):Persoana(s),clasa(c){}
    void citire();
    void afisare();
    ~Elev(){}
};

int main()
{
    /*
    Persoana* p = new Elev();
    p->citire();
    p->afisare();
    delete p;

    shared_ptr<Persoana> p2 = make_shared<Persoana>("AAA");
    p2->afisare();

    p2 = make_shared<Elev>("BBB",5); /// upcasting
    p2->afisare();
    */
/*
    vector<Persoana*> v;
    v.push_back(new Persoana());
    v.back()->citire();
    v.push_back(new Elev());
    v.back()->citire();

    for(auto p = v.begin(); p != v.end(); p++)
        (*p)->afisare();
*/
/*    vector<shared_ptr<Persoana>> v2;
    v2.push_back(make_shared<Persoana>());
    v2.back()->citire();
    v2.push_back(make_shared<Elev>());
    v2.back()->citire();

    for(auto p = v2.begin(); p != v2.end(); p++)
        (*p)->afisare();
    return 0;
}

void Persoana::citire(){cout<<"Nume "; cin>>nume;}
void Persoana::afisare(){cout<<nume<<" ";}
void Elev::citire(){Persoana::citire(); cout<<"Clasa "; cin>>clasa;}
void Elev::afisare(){Persoana::afisare(); cout<<clasa<<"\n";}
*/


/***** destructori virtuali *****/
/*
class Persoana
{
protected:
    string nume;
public:
    Persoana(string s = "") : nume(s){cout<<"constr Persoana ";}
    virtual void citire();
    virtual void afisare();
    virtual ~Persoana(){cout<<"destr Persoana";}
};

class Elev : public Persoana
{
    int clasa;
public:
    Elev(string s="", int c=0):Persoana(s),clasa(c){cout<<" constr Elev";}
    void citire();
    void afisare();
    ~Elev(){cout<<" destr Elev";}
};

int main()
{
    Persoana* p = new Elev(); /// upcast
    delete p;
    return 0;
}

void Persoana::citire(){cout<<"Nume "; cin>>nume;}
void Persoana::afisare(){cout<<nume<<" ";}
void Elev::citire(){Persoana::citire(); cout<<"Clasa "; cin>>clasa;}
void Elev::afisare(){Persoana::afisare(); cout<<clasa<<"\n";}
*/

/***** covariance exemplu *****/
/*
class Persoana
{
protected:
    string nume;
public:
    Persoana(string s = "") : nume(s){}
    virtual void citire();
    virtual void afisare();
    virtual Persoana* concatenare(){ return new Persoana(nume+="Popescu");}
};

class Elev : public Persoana
{
    int clasa;
public:
    Elev(string s="", int c=0):Persoana(s),clasa(c){}
    void citire();
    void afisare();
///    Persoana* concatenare(){ return new Elev(nume+="Popescu", clasa+=1);}
    Elev* concatenare(){ return new Elev(nume+="Popescu", clasa+=1);}   /// covarianta tipurilor
};

int main()
{
    Persoana *p = new Persoana("Ana");
    p->afisare();
    p = p->concatenare();
    p->afisare();
    cout<<"\n";
    p = new Elev("Ion",11);
    p->afisare();
    p = p->concatenare();
    p->afisare();

    Elev A("anonim",0);
    Elev *B = A.concatenare();
    B->afisare();
    return 0;
}

void Persoana::citire(){cout<<"Nume "; cin>>nume;}
void Persoana::afisare(){cout<<nume<<" ";}
void Elev::citire(){Persoana::citire(); cout<<"Clasa "; cin>>clasa;}
void Elev::afisare(){Persoana::afisare(); cout<<clasa<<"\n";}
*/

/**** clase abstracte ****/
/*
class Persoana /// clasa abstracta (are cel putin o functie virtuala pura) / interfata
{
protected:
    string nume;
public:
    virtual void citire() = 0; /// functie virtuala pura
    virtual void afisare();
};

class Elev : public Persoana
{
    int clasa;
public:
    void citire();
    void afisare();
};

class Pensionar : public Persoana
{
public:
    void citire(){}
};

int main()
{
///    Persoana ob;
    Elev ob1;
    Pensionar ob2;
///    cout << sizeof(Persoana) << endl; /// aparitia vptr daca virtual
    Persoana *p = new Elev();
    p->citire();
    p->afisare();
    return 0;
}

void Persoana::citire(){cout<<"Nume "; cin>>nume;}
void Persoana::afisare(){cout<<nume<<" ";}
void Elev::citire(){Persoana::citire(); cout<<"Clasa "; cin>>clasa;}
void Elev::afisare(){Persoana::afisare(); cout<<clasa<<"\n";}
*/


/// ... si cu ce ne ajuta??? ---> vector<Baza*> retine tipuri diferite de adrese de obiecte

/********** cand downcast-ul / dynamic_cast reuseste? *******************/
/// ATENTIE la stilul acesta de diamant si cate mosteniri virtuale e nevoie
/*
class Baza{
public:
    virtual ~Baza(){}
};

class D1 : virtual public Baza{};
class D2 : virtual public D1{};
class D3 : virtual public D2{};

class D4 : virtual public Baza{};
class D5 : public D4, public D3{};

int main()
{
    Baza* a = new D5();
    D1* b = dynamic_cast<D1*>(a); if (!b) cout<<"nu se poate face cast catre D1\n";
    D2* c = dynamic_cast<D2*>(a); if (c == NULL) cout<<"nu se poate face cast catre D2\n";
    D3* d = dynamic_cast<D3*>(a); if (!d) cout<<"nu se poate face cast catre D3\n";
    D4* e = dynamic_cast<D4*>(a); if (!e) cout<<"nu se poate face cast catre D4\n";
return 0;
}
*/

/*
class Baza{
public:
    virtual ~Baza(){}
};

class D1 : public Baza{};
class D2 : public D1{};
class D3 : public D2{};

class D4 : public Baza{};

int main()
{
    Baza* a = new D2();
    D1* b = dynamic_cast<D1*>(a); if (!b) cout<<"nu se poate face cast catre D1\n";
    D2* c = dynamic_cast<D2*>(a); if (c == NULL) cout<<"nu se poate face cast catre D2\n";
    D3* d = dynamic_cast<D3*>(a); if (!d) cout<<"nu se poate face cast catre D3\n";
    D4* e = dynamic_cast<D4*>(a); if (!e) cout<<"nu se poate face cast catre D4\n";
return 0;
}

/*
class Baza
{
public:
    virtual void f(){cout<<"Baza\n";}
};

class Derivata : public Baza
{
public:
    virtual void f(){cout<<"f rescris in Derivata\n";}
    virtual void g(){cout<<"g virtual in Derivata\n";}
    void h(){cout<<"h nevirtual in Derivata\n";}
};

int main()
{
    /// apel functii din Derivata prin obiect - ok
    Derivata ob;
///    ob.f(); /// f rescris in derivata
///    ob.g();
///    ob.h();

    /// upcast prin referinta
    Baza& a = ob;
    a.f(); /// f rescris in derivata
    /// a.g(); a.h(); /// nu pot fi apelate prin referinta catre baza
    ((Derivata&)a).g();
    ((Derivata&)a).h();
/// sau, pentru ierarhii polimorfice
    (dynamic_cast<Derivata&>(a)).g();
    (dynamic_cast<Derivata&>(a)).h();

    /// idem upcast prin pointer
    Baza*p = &ob;
    p->f(); /// f rescris in derivata
    /// p->g(); p->h(); /// nu pot fi apelate prin pointer catre baza
    ((Derivata*)p)->g();
    ((Derivata*)p)->h();
/// sau, pentru ierarhii polimorfice
    (dynamic_cast<Derivata*>(p))->g();
    (dynamic_cast<Derivata*>(p))->h();

    return 0;
}
*/
/******** upcast si ierarhii nepolimorfice ***********/
/*
class Baza
{
public:
    void f(){cout<<"Baza\n";}
};

class Derivata : public Baza
{
public:
    virtual void f(){cout<<"f rescris in Derivata\n";}
    virtual void g(){cout<<"g virtual in Derivata\n";}
    void h(){cout<<"h nevirtual in Derivata\n";}
};

int main()
{
    /// apel functii din Derivata prin obiect - ok
    Derivata ob;
///    ob.f(); /// f rescris in derivata
///    ob.g();
///    ob.h();

    /// upcast prin referinta
    Baza& a = ob;
    a.f(); /// f rescris in derivata
    /// a.g(); a.h(); /// nu pot fi apelate prin referinta catre baza, DECI TREBUIE DOWNCAST
    ((Derivata&)a).g();
    ((Derivata&)a).h();
/// nu merge pentru ierarhii nepolimorfice
///    (dynamic_cast<Derivata&>(a)).g();
///    (dynamic_cast<Derivata&>(a)).h();

    /// idem upcast prin pointer
    Baza*p = &ob;
    p->f(); /// f rescris in derivata
    /// p->g(); p->h(); /// nu pot fi apelate prin pointer catre baza
    ((Derivata*)p)->g();
    ((Derivata*)p)->h();
/// nu merge pentru ierarhii nepolimorfice
///    (dynamic_cast<Derivata*>(p))->g();
///    (dynamic_cast<Derivata*>(p))->h();

/// idem pentru upcast care sa retina adresa unui ob derivat alocat dinamic Baza*b = new Derivata();

/// Ar fi mers prin atribuire directa? NU.
    Derivata* q;
///    q = p;
///    q->f();

    Baza *r;
    r = q;
    return 0;
}
*/
/****** atribuire directa de pointeri pentru upcast/downcast ? *******/
/*
class Baza
{
public:
    void f(){cout<<"Baza\n";}
};

class Derivata : public Baza
{
public:
    virtual void f(){cout<<"f rescris in Derivata\n";}
    virtual void g(){cout<<"g virtual in Derivata\n";}
    void h(){cout<<"h nevirtual in Derivata\n";}
};

int main()
{
    Derivata ob;
///    ob.f(); /// f rescris in derivata
///    ob.g();
///    ob.h();

    /// upcast prin referinta ok
    Baza& a = ob;
    a.f(); /// f rescris in derivata

    /// downcast - tentativa directa - nu merge. De ce? nu se stie exact catre ce face referire a
///    Derivata& b = a;

    /// idem upcast prin pointer ok
    Baza*p = &ob;

    Derivata* q;
///    q = p;  /// nu merge downcast direct nici pe pointeri

    Baza *r;
    r = q; /// upcast ok
    return 0;
}
*/
