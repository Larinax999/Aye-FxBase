-- to prevent trying to spawn multiple times
local spawnLock = false

-- function as existing in original R* scripts
function freezePlayer(freeze)
    local id=PlayerId()
    local ped=PlayerPedId()
    SetPlayerControl(id,not freeze, false)
    -- SetEntityVisible(ped, true)
    SetPlayerInvincible(id, freeze)
    FreezeEntityPosition(ped, freeze)
    SetEntityCollision(ped, not freeze)
    -- SetCharNeverTargetted(ped, true)
    -- RemovePtfxFromPed(ped)
    if not IsPedFatallyInjured(ped) then
        ClearPedTasksImmediately(ped)
    end
end

function teleport(spawn)
    local ped = PlayerPedId()
    -- preload collisions for the spawnpoint
    RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)
    SetEntityCoords(ped, spawn.x, spawn.y, spawn.z, false, false, false, true)
    NetworkResurrectLocalPlayer(spawn.x, spawn.y, spawn.z, 0.0, true, true, false)
    Citizen.Wait(500)
    -- while not HasCollisionLoadedAroundEntity(ped) do
    --     Citizen.Wait(1000)
    -- end
end

function spawnPlayer(spawn)
    if spawnLock then return end
    spawnLock = true
    -- DoScreenFadeOut(500)

    -- freeze the local player
    freezePlayer(true)

    -- model set
    RequestModel(spawn.model)

    -- load the model for this spawn
    while not HasModelLoaded(spawn.model) do
        -- RequestModel(spawn.model)
        Citizen.Wait(5)
    end

    -- change the player model
    SetPlayerModel(PlayerId(), spawn.model)
    SetPedDefaultComponentVariation(PlayerPedId()) -- prevent invisible for mp char

    -- release the player model
    SetModelAsNoLongerNeeded(spawn.model)

    -- preload collisions for the spawnpoint
    -- RequestCollisionAtCoord(spawn.x, spawn.y, spawn.z)

    -- spawn the player
    local ped = PlayerPedId()
    -- V requires setting coords as well
    teleport(spawn)
    -- gamelogic-style cleanup stuff
    ClearPedTasksImmediately(ped)
    --SetEntityHealth(ped, 300) -- TODO: allow configuration of this?
    RemoveAllPedWeapons(ped) -- TODO: make configurable (V behavior?)
    ClearPlayerWantedLevel(PlayerId())

    -- why is this even a flag?
    --SetCharWillFlyThroughWindscreen(ped, false)

    -- set primary camera heading
    --SetGameCamHeading(spawn.heading)
    --CamRestoreJumpcut(GetGameCam())

    freezePlayer(false)
    ShutdownLoadingScreen()
    -- DoScreenFadeIn(500)
    -- TriggerEvent("playerSpawned", spawn)
    spawnLock = false
end
