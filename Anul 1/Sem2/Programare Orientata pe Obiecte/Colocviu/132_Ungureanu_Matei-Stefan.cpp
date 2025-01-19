// Ungureanu Matei-Stefan 132
// CLion
// Dragos Bahrim


#include <iostream>
#include <vector>

class Inventar {
protected:
    static int id_counter;
    int id;
    float cost;
public:
    Inventar(int Id, float Cost) : id(++id_counter), cost(Cost) {}
    explicit Inventar(float Cost) : id(++id_counter), cost(Cost) {}
    virtual ~Inventar() = default;
    std::istream& operator>>(std::istream& cin)
    {
        std::cout<<"\nid:"<<(*this).id<<"\ncost:";
        cin>>(*this).cost;
        return cin;
    }
    virtual void afis()
    {
        std::cout<<"\nid:"<<id<<"\ncost:"<<cost;
    }
    int
    getCost() const
    {
        return cost;
    }
    void
    setCost(float Cost)
    {
        cost = Cost;
    }
};

class Zid : public Inventar {
private:
    float inaltime;
    float lungime;
    float grosime;
public:
    Zid(float Cost, float Inaltime, float Lungime, float Grosime) : Inventar(Cost), inaltime(Inaltime), lungime(Lungime), grosime(Grosime) {}
//    Zid() : Inventar(int Cost), inaltime(0), lungime(0), grosime(0) {}
    ~Zid() override = default;
    friend std::istream& operator>>(std::istream& cin, Zid z)
    {
        z.Inventar::operator>>(cin);
        std::cout<<"\ninaltime:";
        cin>>z.inaltime;
        std::cout<<"\nlungime:";
        cin>>z.lungime;
        std::cout<<"\ngrosime:";
        cin>>z.grosime;
        return cin;
    }
    void afis() override
    {
        Inventar::afis();
        std::cout<<"\ninaltime:"<<inaltime<<"\nlungime:"<<lungime<<"\ngrosime:"<<grosime;
    }
    float
    getInaltime() const
    {
        return inaltime;
    }
    void
    setInaltime(float Inaltime)
    {
        inaltime = Inaltime;
    }
    float
    getLungime() const
    {
        return lungime;
    }
    void
    setLungime(float Lungime)
    {
        lungime = Lungime;
    }
    float
    getGrosime() const
    {
        return grosime;
    }
    void
    setGrosime(float Grosime)
    {
        grosime = Grosime;
    }
};

class Turn : public Inventar {
private:
    int putere;
public:
    Turn(float Cost, int Putere) : Inventar(Cost), putere(Putere) {}
//    Turn() : Inventar(), putere(0) {}
    ~Turn() override = default;
    void afis() override
    {
        Inventar::afis();
        std::cout<<"\nputere:"<<putere;
    }
    int
    getPutere() const
    {
        return putere;
    }
    void
    setPutere(int Putere)
    {
        putere = Putere;
    }
};

class Robot : public Inventar {
protected:
    int damage;
    int nivel;
    int viata;
public:
    Robot(float Cost, int Damage, int Nivel, int Viata) : Inventar(Cost), damage(Damage), nivel(Nivel), viata(Viata) {}
//    Robot() : Inventar(), damage(0), nivel(0), viata(0) {}
    ~Robot() override = default;
    void afis() override
    {
        Inventar::afis();
        std::cout<<"\ndamage:"<<damage<<"\nnivel:"<<nivel<<"\nviata:"<<viata;
    }
    int
    getDamage() const
    {
        return damage;
    }
    void
    setDamage(int Damage)
    {
        damage = Damage;
    }
    int
    getNivel() const
    {
        return nivel;
    }
    void
    setNivel(int Nivel)
    {
        nivel = Nivel;
    }
    int
    getViata() const
    {
        return viata;
    }
    void
    setViata(int Viata)
    {
        viata = Viata;
    }
};

class Robot_Aerian : public Robot {
private:
    int autonomie;
public:
    Robot_Aerian(float Cost, int Damage, int Nivel, int Viata, int Autonomie) : Robot(Cost, Damage, Nivel, Viata), autonomie(Autonomie) {}
//    Robot_Aerian() : Robot(), autonomie(0) {}
    ~Robot_Aerian() override = default;
    void afis() override
    {
        Robot::afis();
        std::cout << "\nautonomie:" << autonomie;
    }
    int
    getAutonomie() const
    {
        return autonomie;
    }
    void
    setAutonomie(int Autonomie)
    {
        autonomie = Autonomie;
    }
};

class Robot_Terestru : public Robot {
private:
    int nr_gloante;
    bool are_scut;
public:
    Robot_Terestru(float Cost, int Damage, int Nivel, int Viata, int Nr_gloante, bool Are_scut) : Robot(Cost, Damage, Nivel, Viata), nr_gloante(Nr_gloante), are_scut(Are_scut) {}
//    Robot_Terestru() : Robot(), nr_gloante(0), are_scut(true) {}
    ~Robot_Terestru() override = default;
    void afis() override
    {
        Robot::afis();
        std::cout<<"\nnr gloante:"<<nr_gloante<<"\nscut:"<<are_scut;
    }
    int
    getNrGloante() const
    {
        return nr_gloante;
    }
    void
    setNrGloante(int NrGloante)
    {
        nr_gloante = NrGloante;
    }
    bool
    getAreScut() const
    {
        return are_scut;
    }
    void
    setAreScut(bool AreScut)
    {
        are_scut = AreScut;
    }
};

int Inventar::id_counter = 0;



int
main()
{
    float puncte = 50000;
    int ok = 1, k, id;
    std::vector<Inventar*>inv;
    while(ok == 1)
    {
        std::cout << "\n0.Iesi\n1.Adauga zid\n2.Adauga turn\n3.Adauga robot aerian\n4.Adauga robot terestru\n5.Upgradeaza un zid\n6.Upgradeaza turn\n7.Upgradeaza robot aerian\n8.Upgradeaza robot terestru\n9.Afiseaza\n";
        std::cin >> k;
        switch(k)
        {
            case(0):
            {
                ok = 0;
                break;
            }
            case(1):
            {
                Zid z(300, 2, 1, 0.5);
                if(puncte - z.getCost() < 0)
                {
                    std::cout<<"prea putine puncte disponibile";
                    break;
                }
                inv.emplace_back(&z);
                puncte -= z.getCost();
                break;
            }
            case(2):
            {
                Turn t(500, 1000);
                if(puncte - t.getCost() < 0)
                {
                    std::cout<<"prea putine puncte disponibile";
                    break;
                }
                inv.emplace_back(&t);
                puncte -= t.getCost();
                break;
            }
            case(3):
            {
                Robot_Aerian ra(100, 100, 1, 100, 10);
                if(puncte - ra.getCost() < 0)
                {
                    std::cout<<"prea putine puncte disponibile";
                    break;
                }
                inv.emplace_back(&ra);
                puncte -= ra.getCost();
                break;
            }
            case(4):
            {
                Robot_Terestru rt(50, 100, 1, 100, 50, false);
                if(puncte - rt.getCost() < 0)
                {
                    std::cout<<"prea putine puncte disponibile";
                    break;
                }
                inv.emplace_back(&rt);
                puncte -= rt.getCost();
                break;
            }
            case(5):
            {
                std::cout<<"id:";
                std::cin>>id;
                Zid *pzid = dynamic_cast<Zid*>(inv[id]);
                if(puncte - 100 * (pzid->getLungime()+1) * (pzid->getInaltime()+1) * (pzid->getGrosime()+1) < 0)
                {
                    std::cout<<"prea putine puncte disponibile";
                    break;
                }
                puncte -= 100 * (pzid->getLungime()+1) * (pzid->getInaltime()+1) * (pzid->getGrosime()+1);
                pzid->setCost(100 * (pzid->getLungime()+1) * (pzid->getInaltime()+1) * (pzid->getGrosime()+1));
                pzid->setInaltime(pzid->getInaltime()+1);
                pzid->setLungime(pzid->getLungime()+1);
                pzid->setGrosime(pzid->getGrosime()+1);
                break;
            }
            case(6):
            {
                std::cout<<"id:";
                std::cin>>id;
                Turn *pturn = dynamic_cast<Turn*>(inv[id]);
                if(puncte - 500 * (pturn->getPutere()+500) < 0)
                {
                    std::cout<<"prea putine puncte disponibile";
                    break;
                }
                puncte -= 500 * (pturn->getPutere()+500);
                pturn->setCost(500 * (pturn->getPutere()+500));
                pturn->setPutere(pturn->getPutere()+500);
                break;
            }
            case(7):
            {
                std::cout<<"id:";
                std::cin>>id;
                auto *pra = dynamic_cast<Robot_Aerian*>(inv[id]);
                if(puncte - 50 * (pra->getAutonomie()+1) * (pra->getNivel()+1) * (pra->getDamage()+25) < 0)
                {
                    std::cout<<"prea putine puncte disponibile";
                    break;
                }
                puncte -= 50 * (pra->getAutonomie()+1) * (pra->getNivel()+1) * (pra->getDamage()+25);
                pra->setCost(50 * (pra->getAutonomie()+1) * (pra->getNivel()+1) * (pra->getDamage()+25));
                pra->setAutonomie(pra->getAutonomie()+1);
                pra->setNivel(pra->getNivel()+1);
                pra->setDamage(pra->getDamage()+25);
                break;
            }
            case(8):
            {
                std::cout<<"id:";
                std::cin>>id;
                auto *prt = dynamic_cast<Robot_Terestru*>(inv[id]);
                if(puncte - 10 * (prt->getNrGloante()+100) * (prt->getNivel()+1) * (prt->getDamage()+50) < 0)
                {
                    std::cout<<"prea putine puncte disponibile";
                    break;
                }
                puncte -= 10 * (prt->getNrGloante()+100) * (prt->getNivel()+1) * (prt->getDamage()+50);
                prt->setCost(10 * (prt->getNrGloante()+100) * (prt->getNivel()+1) * (prt->getDamage()+50));
                prt->setNrGloante(prt->getNrGloante()+100);
                prt->setNivel(prt->getNivel()+1);
                prt->setDamage(prt->getDamage()+50);
                if(prt->getNivel() == 5)
                {
                    prt->setAreScut(true);
                    prt->setViata(prt->getViata()+50);
                }
                break;
            }
            case(9):
            {
                for(auto i : inv)
                {
                    i->afis();
                }
                break;
            }
        }
    }
    return 0;
}
