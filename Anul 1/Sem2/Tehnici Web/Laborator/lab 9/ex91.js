window.onload = f;

function f() {
	let b = document.querySelector("#submit");
	b.onclick = function(event){
		event.preventDefault();
		let n1 = parseInt(document.querySelector("#n1").value);
		let n2 = parseInt(document.querySelector("#n2").value);
		let op = document.querySelector("#op").value;
		let rez;
		if(op == "+") rez = n1 + n2;
		if(op == "-") rez = n1 - n2;
		if(op == "*") rez = n1 * n2;
		if(op == "/") rez = n1 / n2;
		let p = document.createElement("p");
		p.innerHTML = n1 + " " + op + " " + n2 + " = " + rez;
		document.body.appendChild(p);
// 9.4
		localStorage.clear();
		location.reload(); //ca sa mearga ex 1, dau delete la linia asta
	}
// 9.2
	let p = document.querySelector("#salut");
	if(!localStorage.getItem("mesaj")) localStorage.setItem("mesaj", "Hello");
	else {
		localStorage.setItem("mesaj", localStorage.getItem("mesaj") + "o");
		p.innerHTML = localStorage.getItem("mesaj") + "!";
	}
	p.onclick = function(){
		localStorage.clear();
		location.reload();
	}
// 9.4
	
	let pc = document.querySelectorAll("p");
	for (let i = 0; i<pc.length; i++)
		pc[i].onclick = function(){
			pc[i].style.color = "red";
			localStorage.setItem("indice", i);
	}
	if(localStorage.getItem("indice")) pc[localStorage.getItem("indice")].style.color = "red";


// 9.5 schita

let input = document.createElement("input");
input.type="range";
input.min = "2";
input.max = "8";
input.value = "2";
document.body.appendChild(input);

input.onchange = function() {
	for(let i=0;i<input.value;i++){
		let buton[i] = document.createElement("button");
		buton[i].class = "buton";
	}
}
let culoare = "red";
window.onkeydown = function(event){
	let v = 0;
	if(event.key=='a' && n==0){
		n=1;
		setInterval = (function() {buton[v].style.color = culoare; v++;}, 3000s);
	}
	if(event.key=='s') clearInterval(setInterval);
}
}