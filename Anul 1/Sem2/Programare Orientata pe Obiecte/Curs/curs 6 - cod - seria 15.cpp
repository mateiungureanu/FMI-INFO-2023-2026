#include <iostream>

using namespace std;

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
    Derivata(){ y = 0;}
    Derivata(int x, int y) : Baza(x) {this->y = y;}
    Derivata(const Derivata& ob) : Baza(ob) {y = ob.y;}
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

class Derivata : protected Baza{
public:
    void f(){ x = 2; cout<<x<<' ';}
};

class Derivata2 : public Derivata{
public:
    void f(){ x = 3; cout<<x<<' ';}
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
public:
    int x;
public:
    void f(){ x = 1; cout<<x<<' ';}
};

class Derivata : Baza{
public:
    void f(){ x = 2; cout<<x<<' ';}
};

class Derivata2 : public Derivata{
    using Baza::x; /// atentie; Baza ramane privata
public:
    void f(){ x = 3; cout<<x<<' ';}
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
