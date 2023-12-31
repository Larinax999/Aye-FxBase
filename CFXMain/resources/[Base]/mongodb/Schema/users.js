const mongoose = require("mongoose");
module.exports=mongoose.model("users",mongoose.Schema({
    uuid: { // Steam ID or something
        type: String,
        required: true
    },
    UName: { // Username
        type: String,
        required: true
    },
    Pos: {
        type: Object,
        default: {x:-312.1,y:-915.1,z:31.1}
    }
    // Skin:{ // make it with yourself ;)
    //     type: Object,
    //     default: {"sex":0,"face":0,"skin":0,"age_1":0,"age_2":0,"beard_1":0,"beard_2":0,"beard_3":0,"beard_4":0,"eyebrows_1":0,"eyebrows_2":0,"eyebrows_3":0,"eyebrows_4":0,"hair_1":0,"hair_2":0,"hair_color_1":0,"hair_color_2":0,"makeup_1":0,"makeup_2":0,"makeup_3":0,"makeup_4":0,"lipstick_1":0,"lipstick_2":0,"lipstick_3":0,"lipstick_4":0,"ears_1":-1,"ears_2":0,"arms":0,"tshirt_1":0,"tshirt_2":0,"torso_1":0,"torso_2":0,"decals_1":0,"decals_2":0,"pants_1":0,"pants_2":0,"shoes_1":0,"shoes_2":0,"mask_1":0,"mask_2":0,"bproof_1":0,"bproof_2":0,"chain_1":0,"chain_2":0,"helmet_1":-1,"helmet_2":0,"glasses_1":-1,"glasses_2":0,"bags_1":0,"bags_2":0}
    // }
},{versionKey: false}),"users");