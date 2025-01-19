const express=require('express');
const app=express();

app.use(express.static("html1"));

const orase=[ { nume:"Aa", populatie:14000, capitala:true }, { nume:"Bb", populatie:7000, capitala:false }, { nume:"Cc", populatie:19000, capitala:false }, { nume:"Dd", populatie:5000, capitala:false }, { nume:"Ee", populatie:8000, capitala:true }, { nume:"Ff", populatie:12000, capitala:false }, { nume:"Gg", populatie:20000, capitala:true } ]

app.get("/p4", function(req,res) {
    let v = [];
    let dimensiune = req.query.tip;
    let capitala = req.query.capitala;
    for (let o of orase)
    {
        if (dimensiune == "mare" && o.populatie > 10000)
            if (capitala == "da" && o.capitala)
                v.push(o.nume);
        if (dimensiune == "mare" && o.populatie > 10000)
            if (capitala == "nu" && !o.capitala)
                v.push(o.nume);
        if (dimensiune == "mic" && o.populatie < 10000)
            if (capitala == "da" && o.capitala)
                v.push(o.nume);
        if (dimensiune == "mic" && o.populatie < 10000)
            if (capitala == "nu" && !o.capitala)
                v.push(o.nume);
    }
    res.send(v);
});

app.listen(7000, function(){
    console.log("Serverul a pornit");
});
