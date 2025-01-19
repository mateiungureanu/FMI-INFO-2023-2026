window.onload = function () {
    document.body.onclick = f;
    function f() {
        var request = fetch("/titlu");
        request.then(function (response) {
            return response.text();
        }).then(function (text) {
            document.querySelector("h2").innerHTML = text;
        });
    }
    var select = document.querySelector("#categorie")
    select.onchange = function () {
        fetch("/filtru?cat=" + select.value).then(function (response) {
            return response.text();
        }).then(function (text) {
            var sursa = JSON.parse(text);
            document.querySelector("#s").innerHTML = "";
            for (var s of sursa)
            {
                var img = document.createElement("img")
                img.src = s;
                document.querySelector("#s").appendChild(img);
            }
            
        });
    }
}