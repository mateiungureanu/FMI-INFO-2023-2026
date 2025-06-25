window.onload = function(){
	let nume = prompt("Introduceti un nume");
	let mesaj = document.querySelector(".message");
	mesaj.innerHTML += " " + nume;
	let nrsecret = Math.floor(Math.random() * 20) + 1;
	console.log(nrsecret);
	let input = document.getElementById("guess");
	let verifica = document.getElementById("check");
	let scor = document.querySelector(".score");
	let incercari = document.querySelector(".hightscore");
	let s = 20;
	let i = 0;

	verifica.onclick = function(){
		i++;
		incercari.innerHTML = i;
		if(parseInt(input.value) == nrsecret){
			document.body.style.backgroundColor = "red";
			mesaj.innerHTML = "Ati ghicit numarul!";
			document.querySelector(".number").innerHTML = nrsecret;
			scor.innerHTML = s;
			document.querySelector("#jucatori").innerHTML = nume + " a castigat!";
			verifica.innerHTML = "Joaca din nou";
			verifica.onclick = function(){
				window.location.reload();
			}
		}
		else{
			mesaj.innerHTML = "Numarul nu e corect";
			s--;
			scor.innerHTML = s;	
		}
		if(s==0){
			verifica.disabled = true;
		}
	}
}