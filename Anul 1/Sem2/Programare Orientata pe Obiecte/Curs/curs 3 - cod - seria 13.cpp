#include <iostream>

using namespace std;

class Test
{ int x;
public:
///    void operator=(Test); /// nu asa
    Test& operator=(const Test&);
    Test& operator+(int){}
    friend Test& operator+(int, Test&);
    void set_x(int a){x = a;}
    void afis(){cout<<x;}
    const Test operator+(Test&);
    Test(const Test&); /// constr de copiere
    Test(int a = 0):x(a){}
};

    Test::Test(const Test& ob)
    {
        x = ob.x;
    }

///    void Test::operator=(Test Ob){}
Test& Test::operator=(const Test& Ob){
    if (this != &Ob)
    {
       /// this->x = Ob.x;
       x = Ob.x;
    }
    return *this;
}

Test& operator+(int a, Test& b)
{
    Test local;
    /// obiectul local se modifica
    return local;
}

const Test Test::operator+(Test& ob)
{
/*    Test local;
    local.x = this->x + ob.x;
    return local;
*/
    return Test(this->x + ob.x);
}
int main()
{
    Test A;
    Test B;
/*    B = A; /// B.operator=(A) /// operatorul = se supraincarca EXCLUSIV ca functie membra
    Test C;
    C = B = A; /// C.operator=(B.operator=(A))
    C+10; /// C.operator+(10)
    B = C + 10; /// B.operator=(C.operator+(10))
    Test D;
    D = 45 + C;   /// 45.operator+(C) ?????;  operator+(45,C)
*/
    Test D;
    A.set_x(10); A.afis();
    B.set_x(20);
    ///D = A;
    D = A + B; /// D.operator=(A.operator+(B))
 ///(A+B).afis();
    D.afis();

    return 0;
}
