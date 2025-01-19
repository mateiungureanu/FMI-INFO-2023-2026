/// RTTI = Runtime Type Identification

#include <iostream>
#include <typeinfo>
#include <vector>

using namespace std;

class Produs{
public:
    virtual void afisare(){cout<<"produs\n";}
};
class Jucarie : public Produs{
    public:
    void afisare(){cout<<"jucarie\n";}
};

class Carte : public Produs{
    public:
    void afisare(){cout<<"carte\n";}
};

class Aliment : public Produs{
    public:
    void afisare(){cout<<"aliment\n";}
};

/*** sabloane - Template-uri ***/

template<class T>
void afis(T v[10], int n)
{
    for(int i = 0; i<n; i++)
        v[i].afisare();
}

template<>
void afis(Aliment v[10], int n)
{
    for(int i = 0; i<n; i++)
        {cout<<"specializare de functie template "; v[i].afisare();}
}

void afis(Carte v[10], int n)
{
    for(int i = 0; i<n; i++)
        {cout<<i<<" "; v[i].afisare();}
}

/*
void afis(Jucarie v[10], int n)
{
    for(int i = 0; i<n; i++)
        v[i].afisare();
}

void afis(Carte v[10], int n)
{
    for(int i = 0; i<n; i++)
        v[i].afisare();
}

void afis(Aliment v[10], int n)
{
    for(int i = 0; i<n; i++)
        v[i].afisare();
}
*/

int main()
{
    Jucarie j[10];
    Carte c[10];
    Aliment a[10];

    afis(j,2);
    afis<Jucarie>(j,2);
    afis(c,3);
    afis(a,4);

    Produs p[10];
    afis(p,5);
}

/**** RTTI - cu dynamic_cast ****/
/*

int main()
{
    Carte*w = dynamic_cast<Carte*>(p);   /// not ok;
    /// w = NULL (dupa incercare de conversie/cast); downcast imposibil in acest caz

    Jucarie* a = new Jucarie();
    /// incerc pointerul p poate contine aceeasi informatie ca si pointerul a?
    Jucarie* A = dynamic_cast<Jucarie*> (a);
    if (A) A->afisare();
    else cout<<"null";

    Produs* p = new Jucarie();

    Jucarie* B = dynamic_cast<Jucarie*> (p);
    if (B) B->afisare();
    else cout<<"null";

    Carte* C = dynamic_cast<Carte*> (p);
    if (C) C->afisare();
    else cout<<"null";

    if (dynamic_cast<Aliment*> (p)) (dynamic_cast<Aliment*>(p))->afisare();
    else cout<<"\nnull\n";

    vector<Produs*> v;
    v.push_back(new Jucarie());
    v.push_back(new Carte());
    v.push_back(new Jucarie());
    v.push_back(new Aliment());
    v.push_back(new Aliment());
    v.push_back(new Jucarie());

    for(int i = 0; i < v.size(); i++)
        if (dynamic_cast<Jucarie*>(v[i]))
    {
        cout<<i<<" "; (*v[i]).afisare();
    }
}
*/

/**** RTTI - cu typeid ****/
/*
int main()
{
    Jucarie* a = new Jucarie();
    cout<<typeid(a).name()<<" "<<typeid(*a).name() <<endl;

    Produs* p = new Jucarie(); /// upcast
    cout<<typeid(p).name()<<" "<<typeid(*p).name() <<endl;

    vector<Produs*> v;
    v.push_back(new Jucarie());
    v.push_back(new Carte());
    v.push_back(new Jucarie());
    v.push_back(new Aliment());
    v.push_back(new Aliment());
    v.push_back(new Jucarie());

    for(int i = 0; i < v.size(); i++)
        if (typeid(*v[i]) == typeid(Jucarie))
    {
        cout<<i<<" "; (*v[i]).afisare();
    }

        for(int i = 0; i < v.size(); i++)
        if (typeid(*v[i]) == typeid(Carte))
    {
        cout<<i<<" "; (*v[i]).afisare();
    }

        for(int i = 0; i < v.size(); i++)
        if (typeid(*v[i]) == typeid(Aliment))
    {
        cout<<i<<" "; (*v[i]).afisare();
    }
}
*/

/**** inutil pe nepolimorfic ****/
/*
class Produs
{

};

int main()
{
    int a;
    cout<<typeid(a).name()<<"\n";

    float b;
    cout<<typeid(b).name()<<"\n";

    char* s;
    cout<<typeid(s).name()<<"\n";

    Produs c;
    cout<<typeid(c).name()<<"\n";

   /**************************/
///   const int d = 1; /// typeid ====>da
/*    int d;

   if (typeid(a) == typeid(d)) cout<<"da";

   if (typeid(c) == typeid(Produs)) cout<<"\nda\n";


    return 0;
}
*/
