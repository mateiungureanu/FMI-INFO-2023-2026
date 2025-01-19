#include <iostream>

using namespace std;

/****** curs 4 - static si local *********/

class Bilet
{
    int id;
    static const int an = 2024; /// nu trebuie alocat si initi in afara clasei pt ca static const
/// public:
    static int contor;
public:
    Bilet(){ id = contor; contor++;}
    void afis(){cout<<id<<" "<<contor<<'\n';}
    void f1(){cout<<id<<" "<<contor<<'\n';}
    ///static void f2(){cout<<id<<" "<<contor<<'\n';}
    static void f3(Bilet X){cout<<X.id<<" "<<contor<<'\n';}
    static void f4(){Bilet Y; cout<<Y.id<<" "<<contor<<'\n';}
    /// f2 diferit de f3 si f4, chiar daca statice
};
int Bilet::contor;
int main()
{
    Bilet A;
    A.afis();
    Bilet B;
    B.afis(); A.afis();
///    cout<<Bilet::contor;
}

/********* rest curs 3 ***************/
/*
class B {
public:
    B() {cout << "B";}
    B(int x) {
        cout << "B(" << x << ")";
    }
};

class C {
    B b; // apel constr
public:
    C(int x) { b = B(778); cout << "C";} /// atriburea elem unui ob temporar creat
};

int main() {
    C c(777);

    return 0;
}
*/

/*
class Test
{ int x;
public:
    Test(int x = 0){ this->x = x; cout<<"C "<<x<<"\n";}
    ~Test(){cout<<"D\n";}
}ob1(1);

Test ob2(2);

int main()
{
    Test ob3(3);
    for(int i = 4; i<=5; i++) /// atentie
    {
        Test ob(i);
    }
    return 0;
}
*/
