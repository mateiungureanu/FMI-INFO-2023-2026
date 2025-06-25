/*
document.getElementById('nume_id')
document.querySelector('selector_css')
document.querySelectorAll('selector_css')

ob.innerHTML (ia tot continutul, cu tot cu taguri)
ob.textContent (ia tot fara taguri)

pt concatenare: +=
Math.random() -> [0,1)
Math.floor(Math.random() * n) -> 0, 1, 2, ... n-1
*/


function f1(){
var nume = prompt("Cum te numesti?");
// document.querySelector("title").innerHTML = "Salut, " + nume + "!";
document.querySelector("title").innerHTML =  `Salut, ${nume}!`;
}


f1();

function f2(){
let v = ["citat1", "citat2", "citat3"];
var ob = document.querySelector("h1>span");
ob.innerHTML = v[Math.floor(Math.random() * v.length)];
var r = Math.floor(Math.random() * 256);
var g = Math.floor(Math.random() * 256);
var b = Math.floor(Math.random() * 256);
ob.style.color = `rgb(${r} ${g} ${b})`;
var r1 = Math.floor(Math.random() * 256);
var g1 = Math.floor(Math.random() * 256);
var b1 = Math.floor(Math.random() * 256);
document.body.style.backgroundColor = `rgb(${r1} ${g1} ${b1})`;
}

f2();

function f3(){
var imagine = document.querySelectorAll("img");

for (var i=0;i<imagine.length;i++){
	imagine[i].src = "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExbW1hcm5naHlua2UybGU5Y3UwbmIyZmlmMnY3M2N2MDJqbmg4OW8yeCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/VbnUQpnihPSIgIXuZv/giphy.gif";
	imagine[i].alt = "pisica invata JS";
}

/*
for(var i of imagine){
i.src = "https://media2.giphy.com/media/v1.Y2lkPTc5MGI3NjExbW1hcm5naHlua2UybGU5Y3UwbmIyZmlmMnY3M2N2MDJqbmg4OW8yeCZlcD12MV9pbnRlcm5hbF9naWZfYnlfaWQmY3Q9Zw/VbnUQpnihPSIgIXuZv/giphy.gif";
i.alt = "pisica invata JS";
}
*/

}


// f3();

function f4(){
var figura = document.querySelectorAll("figcaption");
for(var i=0;i<figura.length;i++){
	figura[i].innerHTML = "Figura " + (i+1);
}
}

// f4();

function f5(){
var paragrafe = document.querySelectorAll("p");
for(var i=0;i<paragrafe.length;i++){
	paragrafe[i].innerHTML = paragrafe[i].innerHTML.toUpperCase();
}
}

f5();

function f6(){
var a=[];
var figura = document.querySelectorAll("figure");
for(var f of figura){
	val1 = f.children[1].innerHTML;
	text = f.children[0].src;
	var index = text.lastIndexOf("/");
	val2 = text.slice(index+1);
	var ob = {"titlu":val1, "sursa":val2};
	console.log(ob);
	a.push(ob);
	alert(JSON.stringify(a));
}
}

f6();