var express = require("express");
var fs = require("fs");

var app = express();

app.set("view engine", "ejs");

app.use(express.static("html"));

app.use(express.static("poze"));

app.get("/abc", function (req, res) {
    v = ["hello", "bye", "good night", "good morning", "good afternoon"];
    mesaj = v[Math.floor(Math.random() * 5)];
    res.send(mesaj);
});

app.get("/p1", function (req, res) {
    var nume = req.query.nume;
    var n1 = req.query.nota1;
    var n2 = req.query.nota2;
    var media = (parseInt(n1) + parseInt(n2)) / 2;
    res.send("Studentul " + nume + " are media " + media);
});

app.get("/p2", function (req, res) {
    dictionar = [{ cuvant: "carte", engleza: "book", franceza: "livre" }, { cuvant: "floare", engleza: "flower", franceza: "fleur" }, { cuvant: "tablou", engleza: "picture", franceza: "photo" }, { cuvant: "film", engleza: "movie", franceza: "film" }]
    var cuv = req.query.cuvant;
    var limba = req.query.limba;
    for (var c of dictionar)
    {
        if (cuv == c.cuvant)
            traducere = c[limba];
    }    
    res.send(traducere);
});

app.get("/carti", function(req, res) {
    const carti = [ { titlu: 'Crimă și pedeapsă', autor: 'Fiodor Dostoievski', an: 1866 }, { titlu: 'Mandrie și prejudecata', autor: 'Jane Austen', an: 1813 }, { titlu: 'Harry Potter și piatra filozofală', autor: 'J.K. Rowling', an: 1997 }, { titlu: 'Marele Urias Prietenos', autor: 'Roald Dahl', an: 1982 }, { titlu: 'Micul Print', autor: 'Antoine de Saint Exupery', an: 1943 } ];
    const titlu = "Bine ati venit!";
    res.render("carti", {vector_carti: carti, test_titlu: titlu});

})

app.get("/titlu", function(req, res) {
    res.send("salut!");
})

app.get("/filtru", function(req, res) {
    var categorie = req.query.cat;
    var date = fs.readFileSync("carti.json");
    var carti = JSON.parse(date);
    for (var c of carti)
    {
        if(categorie == c.categorie)
        {
            res.send(JSON.stringify(c.carti));
        }
    }
})

// citire din fisier
// var date = fs.readFileSync("fisier.json", "ctf8");
// var ob = JSON.parse(date);

// pentru post in loc de get:
// - pe unde apare get se pune post
// - req.query devine req.body
// - in html: METHODS = "post"
// - inainte de functia app.post punem functia asta:
// app.use(express.urlencoded({extended: true}));

app.listen(5000, function () {
    console.log("A pornit serverul");
});