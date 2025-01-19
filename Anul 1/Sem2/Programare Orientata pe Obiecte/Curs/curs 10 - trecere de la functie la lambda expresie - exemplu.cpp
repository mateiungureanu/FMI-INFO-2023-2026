#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

class Produs
{
    string denumire;
    int pret;
public:
    Produs(string d = "", int p = 0):denumire(d),pret(p){}
    void afisare(){cout<<denumire<<" "<<pret<<endl;}
    friend bool cmp_denumire(Produs&, Produs&);
    friend bool cmp_pret(Produs&, Produs&);
    string get_denumire(){return denumire;}
    int get_pret(){return pret;}
};

bool cmp_denumire(Produs& a, Produs& b){return a.denumire < b.denumire;}
bool cmp_pret(Produs&a, Produs& b)
{
    if (a.pret > b.pret) return 1;
    if (a.pret == b.pret) return a.denumire > b.denumire;
    return 0;
}

int main()
{
    vector<Produs> v;
    v.push_back(Produs("paine",2));
    v.push_back(Produs("jucarie",10));
    v.push_back(Produs("carte",5));
    v.push_back(Produs("apa",10));

    for(auto &p : v)
        p.afisare();

///    sort(v.begin(),v.end(),cmp_denumire);
    sort(v.begin(),v.end(),[](Produs& a, Produs& b){return a.get_denumire() < b.get_denumire();});
    for(auto &p : v)
        p.afisare();

///    sort(v.begin(),v.end(),cmp_pret);
    sort(v.begin(),v.end(),
         [](Produs&a, Produs& b){
    if (a.get_pret() > b.get_pret()) return true;
    if (a.get_pret() == b.get_pret()) return a.get_denumire() > b.get_denumire();
    return false;
});
    for(auto &p : v)
        p.afisare();

    return 0;
}
