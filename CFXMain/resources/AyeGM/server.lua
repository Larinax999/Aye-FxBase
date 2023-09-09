while not exports.mongodb:isReady() do Citizen.Wait(100) end -- wait for mongo connection
local players={}

-- source = playerid
RegisterNetEvent("AyeGM:INIT",function()
    local i=source
    local uid=exports.AyeSlot:Getuuid(i)
    if not players[i] then
        players[i] = exports.mongodb:findPlayer(uid)
    end
    TriggerClientEvent("AyeGM:LOGIN",i,players[i])
end)

AddEventHandler("playerDropped",function() -- Disconnected
    local i=source
    if players[i] then
        local pos = GetEntityCoords(GetPlayerPed(i))
        exports.mongodb:savePlayer(players[i].uuid,{["$set"]={["Pos"]={["x"]=pos.x+0.0,["y"]=pos.y+0.0,["z"]=pos.z+0.0}}})
        players[i] = nil
    end
end)