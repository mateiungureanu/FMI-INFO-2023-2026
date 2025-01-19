window.onload = function(){
	setTimeout(function(){document.querySelector("h1").innerHTML = "Jocul s-a terminat!";
				document.querySelector("#container").remove();}, 10000)
	for(let i = 0;i<20;i++){
		let imagine = document.createElement("img");
		// daca punem var in loc de let se modifica doar ultima imagine
		imagine.src = "sad.png";
		// sau:
		// imagine.setAttribute("src", "sad.png");
		imagine.alt = "text";
		document.querySelector("#container").appendChild(imagine);
		imagine.onclick = function(){
			imagine.src = "happy.png";
			document.querySelector("#scor").innerHTML = parseInt(document.querySelector("#scor").innerHTML) + 1;
			imagine.onclick = null;
		}
	document.querySelector("#game p").style.visibility = "visible";
	}	
}