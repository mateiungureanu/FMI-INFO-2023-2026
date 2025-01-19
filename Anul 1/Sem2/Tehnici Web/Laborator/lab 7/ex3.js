window.onload = f

function f()
{
	let intrebare = document.querySelector("#intrebare");
	let buton = document.querySelector("#start");
	let raspuns = document.querySelector("#raspuns");
	let formular = document.querySelector("#form");
	intrebare.style.display = "none";
	formular.style.display = "none";
	buton.onclick = f2
	function f2()
	{
		formular.style.display = "block";
		intrebare.style.display = "block";
		buton.style.display = "none";
		let k = setTimeout(function(){alert("A expirat timpul!"); for(let b of form.children) {b.disabled = true;}},5000);
		form.onclick = f3
		function f3()
		{
			clearTimeout(k)
			for (let b of form.children)
			{
				b.disabled = true;
				if(b.checked == true)
					raspuns.innerHTML = "Raspuns " + b.value; 
			}
		}
	}
}
