math.randomseed(GetInstanceId())
local MaxCount=GetConvarInt("sv_maxclients",0)
local Count=0 -- Players Count // #GetPlayers() for restart script when server is up
local Lock=true
local players={}
local queue={}
local QGo=0

function Getuuid(i)
    return string.sub(GetPlayerIdentifierByType(i,"steam")or"",7,99) -- remove 'steam:'
end

RegisterNetEvent("AyeSlot:",function() -- playerActivated / player in server
    local id=source
    if not players[id] then -- source = playerid
        Count = Count+1
        players[id] = true
    end
end)

AddEventHandler("playerConnecting",function(name, _, deferrals) -- Connecting / _ = setReason
    local id  = source
    local sid = GetPlayerIdentifierByType(id,"steam")
    deferrals.defer()
    Citizen.Wait(1)
    print(string.format("[Connecting] Name : %s ID : %s ^7",name,id))
    if Count >= MaxCount then
        deferrals.done("\n\n\nServer Full.")
    elseif Lock == true then
        deferrals.done("\n\n\nServer Unavailable.")
    elseif sid == nil then
        deferrals.done("\n\n\nCan't find Steam ID (Restart Steam/Fivem and try again)\n\n")
    elseif exports.mongodb:checkPlayer(Getuuid(id)) == 0 then
        exports.mongodb:RegisterPlayer({uuid=Getuuid(id),UName=name})
        deferrals.update("\n\n\nFirst Time?")
        Citizen.Wait(2000) -- make sure data in db (but you can remove this if you want)
        deferrals.update("\n\n\nWelcome...")
        Citizen.Wait(500)
    end
    -- queue syetem (UNTEST USE WITH CAUTION)
    table.insert(queue,id)
    while true do
        if GetPlayerPing(id)==0 then return end -- if player in queue ping will be -1 but if disconnect/cancel will be 0
        if QGo==id then
            QGo=0
            break
        end
        deferrals.update(string.format("Queue Size is %d [Lucky Number is %d]\n",#queue,math.random(1,100)))
        Citizen.Wait(500)
    end
    deferrals.done()
end)

AddEventHandler("playerDropped",function() -- Disconnected
    local id=source
    print(string.format("[Disconnected] ID : %s ^7",id))
    if players[id] then
        Count = Count-1
        players[id] = nil
    end
end)

Citizen.CreateThread(function()
    while not exports.mongodb:isReady() do Citizen.Wait(100) end -- wait for mongo connection
    Citizen.Wait(2000) -- make sure everthing ready.
    Lock=false
    while true do
        if #queue > 0 then
            QGo=queue[1]
            table.remove(queue,1)
            Citizen.Wait(650) -- delay per user
            if QGo~=0 then
                Citizen.Wait(850)
                QGo=0
            end
        else
            Citizen.Wait(2000)
        end
    end
end)