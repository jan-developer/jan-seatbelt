local seatbeltOn = false
local harnessOn = false
local harnessHp = 20
local harnessData = {}
local SpeedBuffer = {}
local vehVelocity = {x = 0.0, y = 0.0, z = 0.0}


local function UpdateSeatbeltState(isOn)
    seatbeltOn = isOn
    if seatbeltOn then
        exports.ox_lib:notify({title = 'Seatbelt', description = 'Seatbelt On', type = 'success'})
    else
        exports.ox_lib:notify({title = 'Seatbelt', description = 'Seatbelt Off', type = 'error'})
    end
    TriggerEvent('hud:client:ToggleSeatbelt', seatbeltOn)
end


RegisterNetEvent("seatbelt:client:ToggleSeatbelt", function(toggle)
    if toggle == nil then
        UpdateSeatbeltState(not seatbeltOn) 
    else
        UpdateSeatbeltState(toggle) 
    end
end)


function ToggleHarness(toggle)
    harnessOn = toggle
    if toggle then
        seatbeltOn = false
        exports.ox_lib:notify({title = 'Racing Belt', description = 'Racing belt connected', type = 'success'})
    else
        harnessHp = 10
        exports.ox_lib:notify({title = 'Racing Belt', description = 'Racing belt removed', type = 'error'})
        TriggerEvent("seatbelt:client:ToggleSeatbelt", false) 
    end
    TriggerEvent('hud:client:ToggleHarness', toggle)
end


RegisterNetEvent('seatbelt:client:UseHarness', function(ItemData)
    local ped = PlayerPedId()
    local inveh = IsPedInAnyVehicle(ped)
    local veh = GetVehiclePedIsIn(ped)
    if inveh and not IsThisModelABike(GetEntityModel(veh)) then
        if not harnessOn then
            QBCore.Functions.Progressbar("harness_equip", "Putting on race harness...", 5000, false, true, {
                disableMovement = false,
                disableCarMovement = false,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
                ToggleHarness(true)
                harnessHp = ItemData.info.uses
                harnessData = ItemData
                TriggerServerEvent('equip:harness', ItemData)
                TriggerEvent('hud:client:UpdateHarness', harnessHp)
            end)
        end
    else
        QBCore.Functions.Notify("You're not in a car.", 'error', 3500)
    end
end)


function HasHarness()
    return harnessOn
end
