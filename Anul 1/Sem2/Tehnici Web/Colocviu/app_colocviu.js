const express = require('express');
const app = express();

app.use(express.static("html_colocviu"));

app.get("/p4", function (req, res) {
    let cuvinteRegex = /^[a-z\s]+$/;
    let cuv = req.query.cuv;
    let selectie = req.query.tip;
    if (!cuvinteRegex.test(cuv)) {
        res.send("Date invalide.");
    }
    else {
        let cuvinte = cuv.split(" ");
        if (selectie == "alfabetic") {
            cuvinte.sort();
            if (selectie == "lungime") {
                cuvinte.sort(function (a, b) {
                    if (a.length > b.length)
                        return a;
                    else return b;
                });
            }
        }
        res.send(cuvinte);
    }
});

app.listen(7000, function () {
    console.log("Serverul a pornit");
});
