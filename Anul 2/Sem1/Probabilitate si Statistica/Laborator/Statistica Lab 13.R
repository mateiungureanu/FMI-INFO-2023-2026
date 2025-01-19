#Statistica Lab 13 

#Metoda verosimilitatii maxime
#Daca o functie cu valori pozitive are punct de maxim sau minim local,
#acesta se pastreaza si daca se logaritmeaza functia initiala
f1 <- function(x)
{
  sin(x)
}

t <- seq(0.001,pi-0.001,0.001)
#Q: De ce nu am luat intervalul (0,pi)?



#gasirea punctelor de extrem cu functia optimize
require(graphics)
#in mod implicit cauta punctul de minim
optimize(f1,c(0.001,pi-0.001))

#vreau punctul de maxim

optimize(f1,c(0.001,pi-0.001),maximum=T)



#Problema cu f(x)=x^2/(54*teta^3)*exp(-x/(3*teta)), x>0

#const=ln(produs(xi^2))
#x este vectorul ce reprezinta esantionul dat
x <- rgamma(1000,3,90)
n_calc <- 1000
xbar_calc <- sum(x)/n_calc #mean(x)
const_calc <- sum(2*log(x))

logVerosim <- function(teta,xbar,n,const)
{
  -n*log(54)-3*n*log(teta)+const-1/(3*teta)*n*xbar 
}
t <- seq(0.001,0.5,0.0001)
plot(t,logVerosim(t,xbar_calc,n_calc,const_calc),type="l")

#Q: Ce reprezinta 100 mai jos?
#"A wild guess" legat de intervalul pe care sa cautam punctul de maxim
#Daca facem plot inainte vedem mai bine care e intervalul mai bun

o <- optimize(logVerosim,c(0.001,100),maximum=T,xbar=xbar_calc,n=n_calc,const=const_calc)
teta_maxim <- o$maximum
#ce obtin daca iau intervalul de cautare mai fin
o <- optimize(logVerosim,c(0.001,0.1),maximum=T,xbar=xbar_calc,n=n_calc,const=const_calc)
teta_maxim <-o$maximum



teta_estimat <- xbar_calc/9

#Observam ca teta_estimat si teta_maxim(calculat prin metode numerice) sunt foarte apropiate

t <- seq(0.001,0.5,0.0001)
plot(t,logVerosim(t,xbar_calc,n_calc,const_calc),type="l")
abline(v=teta_maxim,col="red")

#Metoda momentelor
#De ce metoda momentelor uneori nu e buna

#Folositi metoda momentelor pentru a estima teta pentru X~Unif(0,teta) in baza unui 
#esantion de volum 100

#Estimatorul dat de metoda momentelor este teta=2*xbar

teta <- 18
sample_size <- 30
nr_simulari <- 1000
teta_estimat <- numeric(nr_simulari)

for( i in 1:nr_simulari)
{
  u <- runif(sample_size,0,teta)
  xbar <- mean(u)
  teta_estimat[i] <- 2*xbar
}
hist(teta_estimat)
plot(density(teta_estimat))
abline(v=18, col="green")

#y <- runif(1000,6,13)
#hist(y)

#MVM pentru aceeasi problema
#teta_MVM=max(valorile din esantion)
teta <- 18
x <- runif(1000,0,teta)
teta_MVM <- max(x)

for( i in 1:nr_simulari)
{
  u <- runif(sample_size,0,teta)
  xbar <- mean(u)
  teta_estimat[i] <- max(x)
}
hist(teta_estimat)
plot(desnity(teta_estimat))
abline(v=25, col='green')

#Tema: Optimizati codul de mai sus