local Me
local Handsup=false
local Pointing=false
local Crouched=false
local Weapons = { -- 0 default
    ---melee---
    ["WEAPON_SNOWBALL"] = 0,
    ["WEAPON_UNARMED"] = 0.15,
    -- ["WEAPON_BAT"] = 0.14,
    -- ["WEAPON_BOTTLE"] = 0.25,
    -- ["WEAPON_DAGGER"] = 0,
    -- ["WEAPON_CROWBAR"] = 0.20,
    -- ["WEAPON_FLASHLIGHT"] = 0.20,
    -- ["WEAPON_GOLFCLUB"] = 0.14,
    -- ["WEAPON_HAMMER"] = 0.20,
    -- ["WEAPON_HATCHET"] = 0.30,
    -- ["WEAPON_KNUCKLE"] = 0.3,
    -- ["WEAPON_KNIFE"] = 0.5,
    -- ["WEAPON_MACHETE"] = 0.3,
    -- ["WEAPON_SWITCHBLADE"] = 0.25,
    -- ["WEAPON_NIGHTSTICK"] = 0.30,
    -- ["WEAPON_WRENCH"] = 0.20,
    -- ["WEAPON_BATTLEAXE"] = 0,
    -- ["WEAPON_POOLCUE"] = 0.25,
    -- ["WEAPON_STONE_HATCHET"] = 0,
    ---Pistol---
    -- ["WEAPON_PISTOL"] = 0.35,
    -- ["WEAPON_PISTOL_MK2"] = 0,
    -- ["WEAPON_COMBATPISTOL"] = 0.35,
    -- ["WEAPON_APPISTOL"] = 0.1,
    -- ["WEAPON_STUNGUN"] = 0.01,
    -- ["WEAPON_PISTOL50"] = 0.5,
    -- ["WEAPON_SNSPISTOL"] = 0,
    -- ["WEAPON_SNSPISTOL_MK2"] = 0,
    -- ["WEAPON_HEAVYPISTOL"] = 0,
    -- ["WEAPON_VINTAGEPISTOL"] = 0,
    -- ["WEAPON_FLAREGUN"] = 0,
    -- ["WEAPON_MARKSMANPISTOL"] = 0,
    -- ["WEAPON_REVOLVER"] = 0.3,
    -- ["WEAPON_REVOLVER_MK2"] = 0,
    -- ["WEAPON_DOUBLEACTION"] = 0,
    ---Submachine Guns---
    -- ["WEAPON_MICROSMG"] = 0,
    -- ["WEAPON_SMG"] = 0,
    -- ["WEAPON_SMG_MK2"] = 0,
    -- ["WEAPON_ASSAULTSMG"] = 0,
    -- ["WEAPON_COMBATPDW"] = 0,
    -- ["WEAPON_MACHINEPISTOL"] = 0,
    -- ["WEAPON_MINISMG"] = 0,
    -- ["WEAPON_COMBATMG_MK2"] = 0,
    ---Shotguns---
    -- ["WEAPON_PUMPSHOTGUN"] = 0,
    -- ["WEAPON_PUMPSHOTGUN_MK2"] = 0,
    -- ["WEAPON_SAWNOFFSHOTGUN"] = 0,
    -- ["WEAPON_ASSAULTSHOTGUN"] = 0,
    -- ["WEAPON_BULLPUPSHOTGUN"] = 0,
    -- ["WEAPON_MUSKET"] = 0,
    -- ["WEAPON_HEAVYSHOTGUN"] = 0,
    -- ["WEAPON_DBSHOTGUN"] = 0,
    -- ["WEAPON_AUTOSHOTGUN"] = 0,
    ---Assault Rifles---
    -- ["WEAPON_ASSAULTRIFLE"] = 0,
    -- ["WEAPON_ASSAULTRIFLE_MK2"] = 0,
    -- ["WEAPON_CARBINERIFLE"] = 0,
    -- ["WEAPON_CARBINERIFLE_MK2"] = 0,
    -- ["WEAPON_ADVANCEDRIFLE"] = 0,
    -- ["WEAPON_SPECIALCARBINE"] = 0,
    -- ["WEAPON_BULLPUPRIFLE"] = 0,
    -- ["WEAPON_BULLPUPRIFLE_MK2"] = 0,
    -- ["WEAPON_COMPACTRIFLE"] = 0,
    ---Light Machine Guns---
    -- ["WEAPON_MG"] = 0,
    -- ["WEAPON_COMBATMG"] = 0,
    -- ["WEAPON_GUSENBERG"] = 0,
    ---Sniper Rifles---
    -- ["WEAPON_SNIPERRIFLE"] = 0,
    -- ["WEAPON_HEAVYSNIPER"] = 0,
    -- ["WEAPON_HEAVYSNIPER_MK2"] = 0,
    -- ["WEAPON_MARKSMANRIFLE_MK2"] = 0,
    ---Heavy Weapons---
    -- ["WEAPON_RPG"] = 0,
    -- ["WEAPON_GRENADELAUNCHER"] = 0,
    -- ["WEAPON_GRENADELAUNCHER_SMOKE"] = 0,
    -- ["WEAPON_MINIGUN"] = 0,
    -- ["WEAPON_FIREWORK"] = 0,
    -- ["WEAPON_RAILGUN"] = 0,
    -- ["WEAPON_COMPACTLAUNCHER"] = 0,
    -- ["WEAPON_RAYMINIGUN"] = 0,
    -- ["WEAPON_HOMINGLAUNCHER"] = 0
}

-- function GetMe() -- you will need this later. 
--     return Me
-- end

RegisterCommand("crouched",function()
    DisableControlAction(1,36,true)
    DisableControlAction(2,36,true)
    local ped = PlayerPedId()
    if IsEntityDead(ped) then return end

    while not HasAnimSetLoaded("move_ped_crouched") do 
        RequestAnimSet("move_ped_crouched")
        Citizen.Wait(50)
    end 

    Crouched = not Crouched
    if Crouched then 
        ResetPedMovementClipset(ped,0)
    else
        SetPedMovementClipset(ped,"move_ped_crouched",0.25)
    end
end,false)
RegisterKeyMapping("crouched", "Crouched", "keyboard", "LCONTROL")

function HandUp()
    local ped=PlayerPedId()
    if Handsup or IsEntityDead(ped) then
        Handsup=false
        ClearPedSecondaryTask(ped)
        return
    end
    Handsup=true
    while not HasAnimDictLoaded("random@mugging3") do 
        RequestAnimDict("random@mugging3")
        Citizen.Wait(50)
    end
    TaskPlayAnim(ped,"random@mugging3","handsup_standing_base",8.0,-8,-1,49,0,false,false,false)
end
RegisterCommand("handup",HandUp,false)
RegisterKeyMapping("handup", "Hands Up", "keyboard", "X")

-- [GM]
RegisterNetEvent("AyeGM:LOGIN", function(data)
    Me=data
    local plr=PlayerId()
    -- data.NowID=GetPlayerServerId(plr)
    spawnPlayer({x=Me.Pos.x,y=Me.Pos.y,z=Me.Pos.z,model=GetHashKey("mp_m_freemode_01")})

    -- load map/place
    RequestIpl("shr_int") -- vehicle shop
    EnableInteriorProp(7170,"csr_beforeMission")
    EnableInteriorProp(7170,"shutter_open")

    -- disable wanted level
    SetPlayerWantedLevel(plr,0,false)
    SetPlayerWantedLevelNow(plr,false)
    SetPlayerHealthRechargeMultiplier(plr, 0.0)

    -- remove npc v2
    CancelCurrentPoliceReport()
    SetAudioFlag("PoliceScannerDisabled",true)
    SetCreateRandomCops(false)
    SetCreateRandomCopsNotOnScenarios(false)
    SetCreateRandomCopsOnScenarios(false)
    SetGarbageTrucks(false)
    SetRandomBoats(false)
    SetRandomBoatsInMp(false)

    -- remove ambient sounds
    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
    SetAudioFlag("DisableFlightMusic",true)
    DistantCopCarSirens(false)

    -- disable radio
    SetUserRadioControlEnabled(false)
    SetTextChatEnabled(false)

    -- set up weapons
    SetWeaponsNoAutoswap(true)
    for i, v in pairs(Weapons) do SetWeaponDamageModifier(i,v) end

    -- Can Attack everyone
    SetRelationshipBetweenGroups(5,GetHashKey("PLAYER"),GetHashKey("PLAYER"))
    SetCanAttackFriendly(PlayerPedId(),true,false)
    NetworkSetFriendlyFireOption(true)

    Citizen.CreateThread(function()
        DisplayCash(false)
        DisplayAreaName(false)
        RemoveMultiplayerBankCash()
        RemoveMultiplayerWalletCash()
        while true do
            Citizen.Wait(1000)
            RestorePlayerStamina(PlayerId(), 1.0)
            local plr = PlayerPedId()
            if not IsEntityDead(plr) and IsPedInAnyVehicle(plr,false) then -- if in car (Vehicle)
                DisplayRadar(true)
                SetVehicleRadioEnabled(GetVehiclePedIsIn(plr),false)
            else -- if not in car / disable mini map
                DisplayRadar(false)
            end
        end
    end)
end)
-- [GM]
TriggerServerEvent("AyeGM:INIT")