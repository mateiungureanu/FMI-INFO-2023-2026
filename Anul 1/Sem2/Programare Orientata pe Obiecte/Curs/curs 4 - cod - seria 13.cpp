#include <iostream>

using namespace std;

/*********** recap curs 3 - clase si functii prieten *************/
/*
class Test2;

class Test1
{
    int x;
public:
    Test1(int a = 0){x = a;}
    friend void prieten_cu_Test1(Test1);
    friend void prieten_cu_ambele_clase(Test1,Test2);
    void membra_Test1_prietena_cu_Test2(Test2);
    friend class Test3;
};

class Test2
{
    int y;
public:
    Test2(int a = 0){y = a;}
    friend void prieten_cu_ambele_clase(Test1 ,Test2);
    friend void Test1::membra_Test1_prietena_cu_Test2(Test2);
    friend class Test3;
};

class Test3
{
public:
    void membra_Test3(Test1, Test2);
};

void prieten_cu_Test1(Test1 A){Test1 B(2); cout<<A.x<<" "<<B.x<<endl;}
void prieten_cu_ambele_clase(Test1 A,Test2 B) {cout<<A.x<<" "<<B.y<<endl;}
void Test1::membra_Test1_prietena_cu_Test2(Test2 ob){cout<<ob.y<<endl;}
void Test3::membra_Test3(Test1 A, Test2 B){cout<<A.x<<" "<<B.y<<endl;}

int main()
{
    Test1 ob1(1);
    prieten_cu_Test1(ob1);

    Test2 ob2(5);
    prieten_cu_ambele_clase(ob1, ob2);

    ob1.membra_Test1_prietena_cu_Test2(ob2);

    Test3 ob3;
    ob3.membra_Test3(ob1,ob2);
}
*/

/*********** recap curs 3 - inline ********************/
/*
class Test
{
    int x;
public:
    void functie_implicit_inline(){ cout<<x<<endl; } /// declarare + definire in clasa
    void functie_explicit_inline();
    void functie_not_inline();
};

inline void Test::functie_explicit_inline(){ cout<<x<<endl;}

void Test::functie_not_inline(){ cout<<x<<endl;}

int main()
{
    Test ob;
    ob.functie_implicit_inline();
    ob.functie_explicit_inline();
    ob.functie_not_inline();
}
*/
/********** recap curs 3 - ordine apel constr si destructori **********/

class Test1
{ int x;
public:
    Test1(int a = 0){x = a; cout<<"Test1 - C init - "<<x<<endl;}
    Test1(const Test1& ob){x = ob.x; cout<<"Test1 - C copy - "<<x<<endl;}
    ~Test1(){cout<<"Test1 - dest - "<<x<<endl;}
}A(1);

class Test2
{ int x;
public:
    Test2(int a = 0){x = a; cout<<"Test2 - C init - "<<x<<endl;}
    Test2(const Test2& ob){x = ob.x; cout<<"Test2 - C copy - "<<x<<endl;}
    ~Test2(){cout<<"Test2 - dest - "<<x<<endl;}
}B(2);

class Test3
{
    Test2 obA;
    Test1 obB;
    int x;
public:
    Test3(int a = 0){x = a; cout<<"Test3 - C init - "<<x<<endl;}
    Test3(const Test3& ob){x = ob.x; cout<<"Test3 - C copy - "<<x<<endl;}
    ~Test3(){cout<<"Test3 - dest - "<<x<<endl;}
}C(3);

Test1 D(4);

void f(Test1 E){Test2 F(5);}

int main()
{
    Test3 G(6);
    for(int i = 0; i<2; i++) { Test2 ob(i);}
    Test1 H(7);
    f(H);
}

/********** curs4 - const si neconst *************************/
/*
int main()
{
    /// caz 1
    int a1 = 1;
    int b1 = a1;
    a1++;
    b1++;
    cout<<a1<<" "<<b1<<endl;

    /// caz 2
/// const protejeaza zona de memorie asignata
    const int a2 = 2;
    int b2 = a2;
///    a2++;
    b2++;
    cout<<a2<<" "<<b2<<endl;

        /// caz 3
/// const protejeaza zona de memorie asignata
    int a3 = 1;
    const int b3 = a3;
    a3++;
///    b3++;
    cout<<a3<<" "<<b3<<endl;

            /// caz 4
/// const protejeaza zona de memorie asignata; eroare atat la a4++ cat si la b4++;
    const int a4 = 1;
    const int b4 = a4;
///    a4++;
///    b4++;
    cout<<a4<<" "<<b4<<endl;
}
*/

/********** referinte const *****************/
/*
int main()
{
    /// caz 1
    int a1 = 1;
    int& b1 = a1;
    a1++;
    b1++;
    cout<<a1<<" "<<b1<<endl;

    /// caz 2
/// eroare; nici macar nu se permite ca o referinta neconst sa arate catre o zona care a fost declarata anterior const
//    const int a2 = 2;
//    int& b2 = a2;
//    a2++;
//    b2++;
//    cout<<a2<<" "<<b2<<endl;

        /// caz 3
/// eroare la b3++; referinta const nu poate modifica valoarea zonei de memorie referite, dar se poate modifica direct
    int a3 = 1;
    const int& b3 = a3;
    a3++;
///    b3++;
    cout<<a3<<" "<<b3<<endl;

            /// caz 4
/// eroare atat la a4++ cat si la b4++;
    const int a4 = 1;
    const int& b4 = a4;
///    a4++;
///    b4++;
    cout<<a4<<" "<<b4<<endl;
}
*/

/*************** posibile probleme - cand este nevoie se supraincarcam CC si =  ************/
/*
class Test
{ int x;
public:
    Test(int x = 0){this->x = x;}
    void afis(){cout<<x<<endl;}
    const Test operator+(Test&);
    Test(const Test&);
    Test& operator=(const Test&);
};
/// 1) adaugarea CC - ok
Test::Test(const Test& ob){ this->x = ob.x;}

/// 2) adaugarea op=  va cere rescrierea op+, pentru instr D = B + C; tip returnat de op+ acelasi cu arg op=
Test& Test::operator=(const Test& ob)
{
    if (this != &ob)
    {
        this->x = ob.x;
    }
    return *this;
}
/// nu este suficient doar referinta, ci referinta const
const Test Test::operator+(Test& ob)
{

    Test local;
    local.x = this->x + ob.x; /// cout<<"local "<<local.x<<endl;
    return local;

///    return Test(this->x + ob.x); /// obiectele temporare sunt const
}

int main()
{
    Test A(1), B, C;
    C = B = A;
    C.afis();

    Test D;
    D = B + C;
    D.afis();
    return 0;
}
*/

/*************** cand nu e nevoie se supraincarcam CC si =  ************/
/*
class Test
{ int x;
public:
    Test(int x = 0){this->x = x;}
    void afis(){cout<<x<<endl;}
    Test operator+(Test);
};

Test Test::operator+(Test ob)
{
    Test local;
    local.x = this->x + ob.x;
    return local;
}

int main()
{
    Test A(1), B, C;
    C = B = A;
    C.afis();

    Test D;
    D = B + C;
    D.afis();
    return 0;
}
*/
