window.addEventListener("load", creazaButon)

function creazaButon()
{
	for (let i = 0; i<10; i++)
	{
		let b = document.createElement("button");
		b.innerHTML = i;
		b.classList.add("copil", "cifra" + i);
		document.body.appendChild(b);
	}

	window.onkeydown = coloreaza;
	function coloreaza(event)
	{
		if(event.key >= '0' && event.key <= '9')
		{
			document.querySelector(".cifra" + event.key).style.backgroundColor = "black";
		}
	}
	window.onkeyup = decoloreaza;
	function decoloreaza(event)
	{
		if(event.key >= '0' && event.key <= '9')
		{
			document.querySelector(".cifra" + event.key).style.backgroundColor = "";
		}
	}
}