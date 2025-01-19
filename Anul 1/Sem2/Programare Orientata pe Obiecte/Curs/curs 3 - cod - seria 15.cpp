#include <iostream>

using namespace std;

class Materie
{
    int an;
public:
    Materie(int a = 10) : an(a){}
    void afis(){cout<<an<<endl;}
    operator int(){return an;} /// operator de cast catre int
};

int main()
{
    Materie A(2024);
    Materie B(A);
    B.afis();
    Materie C;
    C = A;
    C.afis();

    Materie D = 2025; /// constr cu 1 param
    D.afis();

    int x = D; /// cast
    cout<<x;
}

/*********** functii prieten **********/

/*
class Materie
{
protected:
    int an;
public:
friend void afis(Materie);
friend ostream& operator<<(ostream&, Materie&);
};

void afis(Materie A){ cout<<A.an;}
ostream& operator<<(ostream& out, Materie& ob)
{
    out<<ob.an<<endl;
    return out;
}

int main()
{
    Materie X;
    afis(X);
    cout<<X; /// operator<<(cout,X);
    X = X + 10; /// X.operator=(X.operator+(10));
    X = 10 + X; /// operator+(10,X) ---> friend
    return 0;
}
*/

/*
class Materie
{
protected:
    int an;
public:
    void f(){ an = 1;}
private:
    void g(){ an = 2;}
protected:
    void h(){ an = 3;}
};

class Materie_Grea : protected Materie
{
    int nr_restantieri;
public:
    void fd(){ an = 4;}
};

class MaterieFgrea : public Materie_Grea
{
public:
    void fffd(){ an = 5;}
};

int main()
{
    Materie A;
    A.f();
///    A.g();
///    A.h();
    Materie_Grea B;
    B.fd();
    B.f();
    MaterieFgrea C;
    C.fffd();

    return 0;
}
*/
