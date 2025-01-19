#include <iostream>

using namespace std;

/// Exercitii
/*
int main()
{
    int i = 8;
    auto f = [i]() mutable
    {
        int j = 2;
        auto m = [&i,j]() mutable {i /= j;};
        m();
        cout<<"inner "<<i<<endl;
    };
    f();
    cout<<"outer "<<i<<endl;
}
*/
/*
int main()
{
    int i=1, j=2, k=3;
    auto f =  [i,&j,&k]() mutable    {
        auto m =  [&i,j,&k]() mutable
        {
            i=4;
            j=5;
            k=6;
        };
        m();
        cout << i << j << k;
    };
    f();
    cout << " : " << i << j << k;
}
*/

/// varianta 4 cu lambda
/*
int main()
{
    int a = 1, n = 3;
    [&a,n]()
    {
        for(int i = 0; i<n; i++)
            a = a * 10;
    }();
    cout<<a<<"  "<<n<<endl;

}
*/
/// varianta 4 cu functie
/*
void f5(int &x, int n)
{
    int a = 1;
    for(int i = 0; i<n; i++)
        a = a * x;
    x = a;
}

int main()
{
    int a = 10, n = 3;
    f5(a,n);
    cout<<a<<"  "<<n<<endl;
}
*/

/// varianta 3 cu lambda
/*
int main()
{
    auto y = [](int x, int n)->int
    {
        int a = 1;
        for(int i = 0; i<n; i++)
            a = a * x;
        return a;
    };
    int z = y(10, 3);
    cout<<z<<endl;
}
*/

/// varianta 3 fara lambda  x^n + y^n
/*
int f4 (int x, int n){
    int a = 1;
    for(int i = 0; i<n; i++)
        a = a * x;
    return a;
}

int main()
{
    int a = f4(10,3);
    cout<<a<<endl;
}
*/

/// varianta 2 cu lambda
/*
int main()
{
    int a = 10;
    int b = [&a]()->int{return a*2; a++;}(); /// apelul expresiei lambda ()
  cout<<b<<"  "<<a<<endl;
  int c = [&a]()->int{return a*2;}();
  cout<<c<<"  "<<a<<endl;
  auto d = [&a]()->int{return a*2; a++;};
  int e = d();
  cout<<e<<"  "<<a<<endl;
}
*/

/// varianta 2 fara lamda
/*int f3(int x){return x*2;}

int main()
{
  int a = 10;
  int b = f3(a);
  cout<<b<<endl;
}
*/

/// varianta 1 cu lamda
/*
int main()
{
    int a = 10;
    [&a](){a = a*3;};
    cout<<a<<endl;
    [a]()mutable->void{a = a*2;};
    cout<<a<<endl;
    return 0;
}
*/
/// varianta 1 fara lambda
/*void f1(int& x){x = x*2;}

void f2(int x){x = x*3;}

int main()
{
    int a = 10;
    f1(a);
    cout<<a<<endl;
    f2(a);
    cout<<a<<endl;
    return 0;
}
*/
