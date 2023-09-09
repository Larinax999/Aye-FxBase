const mongoose = require("mongoose");
const Fusers = require("./Schema/users");

mongoose.set("debug", true);
mongoose.pluralize(null);

main().catch(err=>console.error(err));

async function main() {
    await mongoose.connect(GetConvar("mongodb_url","mongodb://127.0.0.1:27017/FiveM"));
    console.log("[OK] Connected to DataBase");
}

function hasKeys(n,f) { // n = need (array), f = find (object)
    return Object.keys(f).forEach(k=>n.includes(k)) // case sensitive
}

function toJSON(d) { // sucks save only _id / use JSON.stringify better
    if (null==d) return null;
    d=d.toObject({getters:true});
    delete d["_id"]; // because toObject will change _id to id
    return d;
}

exports("isReady",function() {
    return mongoose.connection.readyState==1;
});

exports("RegisterPlayer",async function(a) { // create player data
    if (hasKeys(["uuid","UName"],a)) return; // check keys
    await Fusers.create({uuid:a.uuid,UName:a.UName});
});

exports("checkPlayer",async function(u) { // get count player data
    return await Fusers.countDocuments({uuid:String(u)});
});

exports("findPlayer",async function(u) { // get player data
    return toJSON(await Fusers.findOne({uuid:String(u)}));
});

exports("savePlayer",async function(u,d) { // save player data / update
    return await Fusers.updateOne({uuid:String(u)},d);
});