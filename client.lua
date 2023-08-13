        Locations = {
    { coords = vector3(-1516.48, -952.35, 7.3), heading = 323.66 },
    { coords = vector3(-1249.57, -1474.49, 3.29), heading = 305.6 },
    { coords = vector3(-1219.87, -1504.23, 3.36), heading = 104.66 },
    { coords = vector3(-1771.78, -1160.47, 12.02), heading = 43.54 },
    { coords = vector3(-1834.8, -1233.81, 12.02), heading = 34.05 },
    { coords = vector3(-1719.69, -1103.79, 12.02), heading = 36.33 },
    { coords = vector3(-1630.57, -1075.99, 12.07), heading = 175.02 },
    { coords = vector3(-1638.37, -1083.68, 12.08), heading = 235.22 },
    { coords = vector3(-1683.24, -1123.99, 12.15), heading = 108.16 },
    { coords = vector3(240.29, 166.84, 104.07), heading = 162.45 },
}

local function GetClosestPedByModel(model)
    local closestPed = nil
    local closestDistance = 99999

    local playerPed = GetPlayerPed(-1)
    local playerCoords = GetEntityCoords(playerPed)

    allPeds = GetGamePool('CPed')
    for _, ped in ipairs(allPeds) do
        if ped ~= playerPed and GetEntityModel(ped) == GetHashKey(model) then
            local pedCoords = GetEntityCoords(ped)
            local distance = #(pedCoords - playerCoords)
            if distance < closestDistance then
                closestPed = ped
                closestDistance = distance
            end
        end
    end

    return closestPed, closestDistance
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        local playerPed =   PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)

        local stand = GetClosestObjectOfType(playerCoords.x, playerCoords.y, playerCoords.z, 5.0, `prop_hotdogstand_01`, false, false, false)
        local standcoord = GetEntityCoords(stand)
        local standist = #(playerCoords - standcoord)

        AddTextEntry("buydog", "Buy hotdog for 5$ : ~INPUT_PICKUP~")

        if standist <= 2.0 then
        DisplayHelpTextThisFrame("buydog", false)
    end

        RequestModel("s_m_m_linecook")
        RequestAnimDict("missheist_agency2aig_13")
        RequestAnimDict("amb@prop_human_bbq@male@idle_a")
        RequestAnimDict("gestures@f@standing@casual")
        RequestAnimDict("mp_common")
        RequestAnimDict("mp_player_inteat@burger")


        if not DoesEntityExist(npcshop) then
        for i, item in ipairs(Locations) do
        npcshop = CreatePed(4, `s_m_m_linecook`, item.coords, item.heading, false, false)
    end
end
        
        local closestPed, closestDistance = GetClosestPedByModel("s_m_m_linecook") -- Replace with the desired ped model
        if closestPed and closestDistance <= 3.5 then
            if IsControlJustReleased(1, 51) and standist <= 2.0 then


        PlayAmbientSpeech1(closestPed, 'GENERIC_HI', 'SPEECH_PARAMS_FORCE_NORMAL')
        Wait(2000)
        TaskPlayAnim(playerPed, "gestures@f@standing@casual", "gesture_point", 8.0, 1.0, 3000, 48, 0, 0, 0, 0)
        Wait(2000)
        hotdog = CreateObject('prop_cs_hotdog_02', standcoord.x, standcoord.y, standcoord.z + 0.2, true, true, true)
        TaskPlayAnim(closestPed, "missheist_agency2aig_13", "pickup_briefcase_upperbody", 8.0, 1.0, 3000, 48, 0, 0, 0, 0)
        Wait(1500)
        AttachEntityToEntity(hotdog, closestPed, GetPedBoneIndex(closestPed, 28422), 0, 0, 0, 0, 0, 0, true, true,false, true, 1, true)
        Wait(2000)
        TaskPlayAnim(closestPed, "mp_common", "givetake2_a", 8.0, 1.0, 3000, 48, 0, 0, 0, 0)
        Wait(500)
        TaskPlayAnim(playerPed, "mp_common", "givetake2_a", 8.0, 1.0, 3000, 48, 0, 0, 0, 0)
        Wait(1000)
        DeleteObject(hotdog)
        hotdogped = CreateObject('prop_cs_hotdog_02', standcoord.x, standcoord.y, standcoord.z + 0.2, true, true, true)
        AttachEntityToEntity(hotdogped, playerPed, GetPedBoneIndex(playerPed, 60309), -0.0300, 0.0100, -0.0100, 95.1071, 94.7001, -66.9179, true, true,false, true, 1, true)
        TaskPlayAnim(playerPed, "mp_player_inteat@burger", "mp_player_int_eat_burger", 8.0, 1.0, -1, 49, 0, 0, 0, 0)


            end
        end
        local havedog = DoesEntityExist(hotdogped)
        if IsControlJustReleased(1, 73) and havedog then
            DeleteObject(hotdogped)
            ClearPedTasksImmediately(playerPed)
        end
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    DeleteEntity(allPeds)
    DeleteObject(hotdog)
    DeleteObject(hotdogped)
end)