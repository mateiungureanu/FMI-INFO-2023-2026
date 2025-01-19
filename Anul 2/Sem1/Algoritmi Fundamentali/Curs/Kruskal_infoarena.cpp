#include <fstream>
#include <algorithm>
#include <vector>
using namespace std;

struct muchie{
    int vi,vf;
    int cost;
    
};

int tata[200001], h[200001],cost,n,m;
vector< pair<int,int> >  muchii_apcm;
muchie muchii[400001];

void Initial(int u)
{
        tata[u]=h[u]=0;
}


/*fara compresie de cale
int Reprez(int u)
{
    while(tata[u]!=0)
       u=tata[u];
    return u;  
}*/

int Reprez(int u){
  if (tata[u]==0) 
	return u;
  tata[u]=Reprez(tata[u]);   
  return tata[u];
}

 
void Reuneste(int u,int v)
{
    int ru,rv;
	ru=Reprez(u);
	rv=Reprez(v);
	if (h[ru]>h[rv])
		tata[rv]=ru;
	else{
		tata[ru]=rv;
		if(h[ru]==h[rv])
			h[rv]=h[rv]+1;

	}
	
}



int comp(muchie x, muchie y){
	if(x.cost<y.cost)
		return 1;
	return 0;	
}

void kruskal(){ 

    int nrmsel, mc,u,v,i;
    
    for(v=1;v<=n;v++) 
		Initial(v);
  
    nrmsel=0; 
    mc=0; 

     
    sort(muchii,muchii+m, comp);
   
        
	for(mc=0;mc<m;mc++)
	{
		
		u=muchii[mc].vi;
		v=muchii[mc].vf;
 
		if (Reprez(u)!=Reprez(v)){   
	    	nrmsel++;
	    	
	    	muchii_apcm.push_back({muchii[mc].vi,muchii[mc].vf});
	     	cost+=muchii[mc].cost;
	        Reuneste(u,v);
	        if(nrmsel==n-1)
	            break;
		}
		
    }
   
}

int main(){
	ifstream f("apm.in");
	
	int mc,i;

	
	f>>n;
	f>>m;
 
	for(i=0;i<m;i++)
		f>>muchii[i].vi>>muchii[i].vf>>muchii[i].cost;
	f.close();
   
     
    kruskal();
   
    ofstream g("apm.out"); 
    g<<cost<<endl;
    
    g<<n-1<<endl;
    
	for(auto x:muchii_apcm)
    	g<<x.first<<" "<<x.second<<endl;
    g.close();
 
	return 0;

}

