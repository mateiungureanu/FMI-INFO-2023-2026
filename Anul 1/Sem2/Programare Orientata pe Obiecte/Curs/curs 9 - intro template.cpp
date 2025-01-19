#include <iostream>

using namespace std;

template<class T>
class Vec;

///template<class T>
///istream& operator>>(istream&, Vec<T>&);

template<class T>
istream& operator>>(istream& in, Vec<T>& ob){in>>ob.n; for(int i = 0; i<ob.n; i++) in>>ob.v[i]; return in;}

template<class T>
class Vec
{
    T v[10];
    int n;
public:
    friend istream& operator>> <>(istream&, Vec<T>& );
    void afisare(); ///declarare
};

template<class T>
void Vec<T>::afisare(){for(int i = 0; i<n; i++)cout<<v[i]<<" ";} ///definire

///template<class T>
///istream& operator>>(istream& in, Vec<T>& ob){in>>ob.n; for(int i = 0; i<ob.n; i++) in>>ob.v[i]; return in;}

int main()
{
    Vec<int> ob;
    cin>>ob;
    ob.afisare();
}

/**************/
/*
template<class T>
class Vec
{
    T v[10];
    int n;
public:
    template<class T1> friend istream& operator>>(istream&, Vec<T1>& );
    void afisare(); ///declarare
};

template<class T>
void Vec<T>::afisare(){for(int i = 0; i<n; i++)cout<<v[i]<<" ";} ///definire

template<class T1>
istream& operator>>(istream& in, Vec<T1>& ob){in>>ob.n; for(int i = 0; i<ob.n; i++) in>>ob.v[i]; return in;}

int main()
{
    Vec<int> ob;
    cin>>ob;
    ob.afisare();
}
*/

/***   decl + def fct prieten in clasa = OK ***/
/*
template<class T>
class Vec
{
    T v[10];
    int n;
public:
    friend istream& operator>>(istream& in, Vec<T>& ob){in>>ob.n; for(int i = 0; i<ob.n; i++) in>>ob.v[i]; return in;}
    void afisare(); ///declarare
};

template<class T>
void Vec<T>::afisare(){for(int i = 0; i<n; i++)cout<<v[i]<<" ";} ///definire

int main()
{
    Vec<int> ob;
    cin>>ob;
    ob.afisare();
}
*/

/***   template<class T> obligatoriu la definire in afara clasei ***/
/*
template<class T>
class Vec
{
    T v[10];
    int n;
public:
    void citire(){cin>>n; for(int i = 0; i<n; i++) cin>>v[i];}
    void afisare(); ///declarare
};

template<class T>
void Vec<T>::afisare(){for(int i = 0; i<n; i++)cout<<v[i]<<" ";} ///definire

int main()
{
    Vec<int> ob;
    ob.citire();
    ob.afisare();
}
*/

/**** nu e necesar definire cu template daca decl+def in clasa pt fct membre ***/
/*
template<class T>
class Vec
{
    T v[10];
    int n;
public:
    void citire(){cin>>n; for(int i = 0; i<n; i++) cin>>v[i];}
    void afisare(){for(int i = 0; i<n; i++)cout<<v[i]<<" ";} /// declarare + definire
};

int main()
{
    Vec<int> ob;
    ob.citire();
    ob.afisare();
}
*/
/*******/
/*
///template<class T>
///void f(T i){cout<<"template\n";}

template<>
void f(int i){cout<<"specializare pe int\n";}

void f(int i){cout<<"netemplate\n";}

int main()
{
    f(10);   /// 10 - const de tip int
    char * s = "abc";
///    f(s);
    f(1.2); /// 1.2 - const de tip double
    return 0;
}
*/
