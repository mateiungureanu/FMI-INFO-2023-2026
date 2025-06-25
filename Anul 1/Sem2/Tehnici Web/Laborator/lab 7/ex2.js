window.addEventListener("load", f)

function f()
{
	window.addEventListener("click", creazaDiv) 
}

function creazaDiv(event)
{
	let d = document.createElement("div");
	d.classList.add("animat");
	document.body.appendChild(d);
	d.style.position = "absolute";
	let w = getComputedStyle(d).width;
	let h = getComputedStyle(d).height;
	d.style.left = event.clientX - parseInt(w)/2 + "px";
	d.style.top = event.clientY - parseInt(h)/2 + "px";
	let nume = "miscare" + (Math.floor(Math.random() * 2)+1);
	d.style.animationName = nume;

	d.onclick = function(event)
	{
		event.stopPropagation();
	}
}
