local isBusy = false
local truck, trailer
local pickupBlip, dropoffBlip
local PlayerData = {}

CreateThread(function()
    while ESX == nil do Wait(0) end
    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob', function(job)
    PlayerData.job = job
end)

-- Create the main job blip on the map
CreateThread(function()
    local blip = AddBlipForCoord(Config.JobStartPoint.Pos)
    SetBlipSprite(blip, Config.JobBlip.Sprite)
    SetBlipDisplay(blip, Config.JobBlip.Display)
    SetBlipScale(blip, Config.JobBlip.Scale)
    SetBlipColour(blip, Config.JobBlip.Colour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.JobBlip.Name)
    EndTextCommandSetBlipName(blip)
end)

-- OPTIMIZED: Combined thread for all job interactions
CreateThread(function()
    while true do
        local sleep = 1500 -- Start with a long sleep timer
        if PlayerData.job and PlayerData.job.name == Config.RequiredJob then
            local playerCoords = GetEntityCoords(PlayerPedId())
            local jobDist = #(playerCoords - Config.JobStartPoint.Pos)
            local cloakroomDist = #(playerCoords - Config.CloakroomPoint.Pos)

            -- If the player is near either point, shorten the sleep timer
            if jobDist < 10.0 or cloakroomDist < 10.0 then
                sleep = 5
            end

            -- Handle Job Start Point
            if jobDist < 10.0 then
                DrawMarker(1, Config.JobStartPoint.Pos.x, Config.JobStartPoint.Pos.y, Config.JobStartPoint.Pos.z - 1.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.5, 1.5, 1.5, 0, 255, 0, 100, false, true, 2, nil, nil, false)
                if jobDist < 2.0 and not isBusy then
                    ESX.ShowHelpNotification(Locale['press_to_start'])
                    if IsControlJustReleased(0, 38) then -- Key 'E'
                        OpenDeliveryMenu()
                    end
                end
            end

            -- Handle Cloakroom Point
            if cloakroomDist < 10.0 then
                DrawMarker(1, Config.CloakroomPoint.Pos.x, Config.CloakroomPoint.Pos.y, Config.CloakroomPoint.Pos.z - 1.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.5, 1.5, 1.5, 50, 150, 255, 100, false, true, 2, nil, nil, false)
                if cloakroomDist < 2.0 then
                    ESX.ShowHelpNotification(Locale['press_to_open_cloakroom'])
                    if IsControlJustReleased(0, 38) then -- Key 'E'
                        OpenCloakroomMenu()
                    end
                end
            end
        end
        Wait(sleep)
    end
end)

function OpenDeliveryMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'delivery_type', {
        title    = Locale['delivery_menu_title'],
        align    = 'top-left',
        elements = {
            {label = Locale['short_delivery'], value = 'short'},
            {label = Locale['long_delivery'],  value = 'long'}
        }
    }, function(data, menu)
        menu.close()
        TriggerServerEvent('dk_truckerjob:startJob', data.current.value)
    end, function(data, menu)
        menu.close()
    end)
end

function OpenCloakroomMenu()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom', {
        title    = Locale['cloakroom'],
        align    = 'top-left',
        elements = {
            {label = Locale['wear_work_clothes'],   value = 'work_clothes'},
            {label = Locale['wear_civilian_clothes'], value = 'civilian_clothes'}
        }
    }, function(data, menu)
        if data.current.value == 'work_clothes' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                local model = GetEntityModel(PlayerPedId())
                if model == `mp_m_freemode_01` then
                    TriggerEvent('skinchanger:loadClothes', skin, PlayerData.job.skin_male)
                else
                    TriggerEvent('skinchanger:loadClothes', skin, PlayerData.job.skin_female)
                end
            end)
        end

        if data.current.value == 'civilian_clothes' then
            ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin)
                TriggerEvent('skinchanger:loadSkin', skin)
            end)
        end
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end

-- Event to start the delivery on the client side
RegisterNetEvent('dk_truckerjob:startDelivery', function(pickupPoint, dropoffPoint, deliveryType)
    isBusy = true
    ESX.ShowNotification(Locale['delivery_started'])

    -- Spawn the truck and trailer
    ESX.Game.SpawnVehicle(Config.TruckModel, Config.VehicleSpawnPoint.Pos, Config.VehicleSpawnPoint.w, function(spawnedTruck)
        truck = spawnedTruck
        ESX.Game.SpawnVehicle(Config.TrailerModel, Config.VehicleSpawnPoint.Pos, Config.VehicleSpawnPoint.w, function(spawnedTrailer)
            trailer = spawnedTrailer
            AttachVehicleToTrailer(truck, trailer, 1.1)
            TaskWarpPedIntoVehicle(PlayerPedId(), truck, -1)
        end)
    end)

    -- Create blip for the pickup location
    pickupBlip = AddBlipForCoord(pickupPoint.Pos)
    SetBlipRoute(pickupBlip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Locale['pickup_location'])
    EndTextCommandSetBlipName(pickupBlip)

    -- Start a new thread to monitor the delivery progress
    CreateThread(function()
        local atPickup = false
        while isBusy do
            local currentSleep = 1000
            local ped = PlayerPedId()
            
            -- Check if the truck exists and is driveable
            if DoesEntityExist(truck) and (not IsVehicleDriveable(truck, false) or GetVehicleEngineHealth(truck) <= 100.0) then
                ESX.ShowNotification(Locale['delivery_failed'])
                TriggerServerEvent('dk_truckerjob:jobFailed')
                cleanup()
                break -- Exit the loop immediately
            end

            -- NEW: Check if the player has died
            if IsPedDeadOrDying(ped, 1) then
                ESX.ShowNotification(Locale['delivery_failed_death'])
                TriggerServerEvent('dk_truckerjob:jobFailed')
                cleanup()
                break
            end

            local playerCoords = GetEntityCoords(ped)

            if not atPickup then
                local pickupDist = #(playerCoords - pickupPoint.Pos)
                if pickupDist < 15.0 then
                    currentSleep = 5
                    DrawMarker(1, pickupPoint.Pos.x, pickupPoint.Pos.y, pickupPoint.Pos.z - 1.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 5.0, 5.0, 5.0, 255, 255, 0, 100, false, true, 2, nil, nil, false)
                    if pickupDist < 5.0 then
                        ESX.ShowNotification(Locale['picked_up'])
                        atPickup = true
                        
                        RemoveBlip(pickupBlip)
                        dropoffBlip = AddBlipForCoord(dropoffPoint.Pos)
                        SetBlipRoute(dropoffBlip, true)
                        BeginTextCommandSetBlipName("STRING")
                        AddTextComponentString(Locale['dropoff_location'])
                        EndTextCommandSetBlipName(dropoffBlip)
                    end
                end
            else
                local dropoffDist = #(playerCoords - dropoffPoint.Pos)
                if dropoffDist < 15.0 then
                    currentSleep = 5
                    DrawMarker(1, dropoffPoint.Pos.x, dropoffPoint.Pos.y, dropoffPoint.Pos.z - 1.0, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 5.0, 5.0, 5.0, 0, 255, 0, 100, false, true, 2, nil, nil, false)
                    if dropoffDist < 5.0 then
                        ESX.ShowNotification(Locale['delivery_complete'])
                        TriggerServerEvent('dk_truckerjob:completeDelivery', deliveryType)
                        cleanup()
                    end
                end
            end
            Wait(currentSleep)
        end
    end)
end)

-- Function to clean up after a delivery
function cleanup()
    isBusy = false
    if DoesEntityExist(truck) then
        ESX.Game.DeleteVehicle(truck)
    end
    if DoesEntityExist(trailer) then
        ESX.Game.DeleteVehicle(trailer)
    end
    if DoesBlipExist(pickupBlip) then
        RemoveBlip(pickupBlip)
    end
    if DoesBlipExist(dropoffBlip) then
        RemoveBlip(dropoffBlip)
    end
    truck, trailer, pickupBlip, dropoffBlip = nil, nil, nil, nil
end
