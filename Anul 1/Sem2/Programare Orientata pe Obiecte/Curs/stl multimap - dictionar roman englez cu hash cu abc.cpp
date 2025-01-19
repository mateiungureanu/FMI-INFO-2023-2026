/*
Construiti un dictionar roman-englez retinand datele intr-o tabela de dispersie. Listele de coliziuni vor fi implementate sub forma
unor arbori binari de cautare. Pentru o dimensiune N a tabelei de hash, functia de hash care va fi folosita este:
hash(cuvant_in_romana) = (suma codurilor ASCII ale caracterelor cuvantului) % N.
Exemplu: hash("casa")=(99+97+115+97) % 11 = 1
a)	Construi?i tabela de dispersie.
b)	Afisati toate informatiile din tabela.
c)	Traduceti o propozitie in limba engleza.
*/

#include<iostream>
#include<string.h>
#include<map>

using namespace std;
struct pereche
{
    char value[100], value_engleza[100];
    friend ostream& operator<< (ostream& out, pereche& p)
    {
        out<<p.value<< " --> "<<p.value_engleza<<endl;
        return out;
    }
};

int n, nrcuv;
char s[100],se[100];

void afisare(multimap<int,pereche> m)
{
    for (multimap<int,pereche>::iterator itr = m.begin(); itr != m.end(); ++itr) {
        cout << itr->first << '\t' << itr->second << endl;
    }
}

int hash(char s[100])
{
    int sum = 0, i;
    if (s=="") return -1;
    for(i=0 ; i<strlen(s); i++) sum = sum + s[i];
    return sum % n;
}

char* cauta_cuvant(multimap<int,pereche> m, char s[100])
{
    pair<multimap<int,pereche>::iterator , multimap<int,pereche>::iterator> gasit = m.equal_range(hash(s));
    multimap<int,pereche>::iterator it;
    for(it = gasit.first; it!= gasit.second; it++)
        if (strcmp(s,(it->second).value)==0) return (it->second).value_engleza;
        return "netradus (%s)   ";
}

int main()
{

    multimap<int,pereche> m;
    cout<< "Dimensiunea tabelei de dispersie(hash):";
    cin>>n;
    cout<< "Nr de cuvinte de inserat in hash:";
    cin>>nrcuv;
    for (int i = 0; i < nrcuv; i++)
    {
        pereche p;
        cout<<"Cuvant de inserat in romana: ";
        cin>>p.value;
        cout<<"Traducerea lui in engleza: ";
        cin>>p.value_engleza;
        m.insert (pair<int,pereche>(hash(p.value),p));
    }
    cout<<"Afisarea intregului dictionar:\n";
    afisare(m);

    char prop[100], *p, *cuveng;

    cout<<"Propozitia in limba romana:  ";
    cin.get();
    cin.get(prop,100);

    p= strtok(prop," ");
    while(p)
    {
        // daca p exista, se afla in arborele corespunzator functiei de hash
        cuveng = cauta_cuvant(m,p);
        cout<<cuveng<<" ";
        p = strtok(NULL," ");
    }

    return 0;
}
