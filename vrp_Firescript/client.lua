local blips = {}

------------------------------          ------------------------------
------------------------------ Dispatch ------------------------------
------------------------------          ------------------------------
local fireStation = {
  { x = 216.85, y = -1648.05, z = 30.72, name = "Davis Station"},
  { x = 1194.27, y = -1464.01, z = 36.65, name = "El Burro Station"},
  { x = -634.79, y = -124.02, z = 39.01, name = "Rockford Hills Station"},
  { x = -379.34, y = 6118.42, z = 31.85, name = "Paleto Fire Station"},
  { x = 1691.79, y = 3584.92, z = 36.6, name = "Sandy Shores Fire Station"},
  { x = -1030.88, y = -2374.77, z = 20.61, name = "Los Santos Airport Fire Station"},
  { x = -1189.27, y = -1784.38, z = 15.62, name = "Vespucci Beach LifeGuard Station"},
}

RegisterNetEvent("triggerSound")
AddEventHandler("triggerSound", function()
  local plX, plY, plZ = table.unpack(GetEntityCoords(GetPlayerPed(-1), true)) --Gets player XYZ
  local nearestStation

  for i = 1, #fireStation, 1 do

    local distDiff = Vdist(plX, plY, plZ, fireStation[i].x, fireStation[i].y, fireStation[i].z) --Gets distance between player and firestation[i]
    local nearestStationDiff

    if nearestStation == nil then --if there is no nearest station yet (first run) then...
      nearestStation = i
      nearestStationDiff = Vdist(plX, plY, plZ, fireStation[i].x, fireStation[i].y, fireStation[i].z) --Gets distance between player and firestation[i]
    else -- if there already a value attached to "nearestStation"
      nearestStationDiff = Vdist(plX, plY, plZ, fireStation[nearestStation].x, fireStation[nearestStation].y, fireStation[nearestStation].z) --Gets distance between player and nearest station so far
    end

    if distDiff <= nearestStationDiff then -- if new station is the closest yet
      nearestStation = i -- assign new closest station
    end
  end


  ---- PLAYING THE SOUND IN A RIDDM
  for i = 1, 10, 1 do -- repeat to make it sound like an alarm
    for i = 1, 10, 1 do -- used to make it louder
      PlaySoundFromCoord(i, "scanner_alarm_os", fireStation[nearestStation].x, fireStation[nearestStation].y, fireStation[nearestStation].z, "dlc_xm_iaa_player_facility_sounds", 1, 500, 0) --Plays sound from nearest station
    end
    Wait(1000)
  end
  Wait(1000)
  for i = 1, 3, 1 do -- repeat to make it sound like an alarm
    for i = 1, 10, 1 do -- used to make it louder
      PlaySoundFromCoord(i, "scanner_alarm_os", fireStation[nearestStation].x, fireStation[nearestStation].y, fireStation[nearestStation].z, "dlc_xm_iaa_player_facility_sounds", 1, 500, 0) --Plays sound from nearest station
    end
    Wait(2000)
  end
end)
------------------------------------------------------------

function IconNotif(sprite, style, contact, title, text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    SetNotificationMessage(sprite, sprite, true, style, contact, title, text)
    DrawNotification(false, true)
end

function addBlip(name, id, color, text, x, y, z)
    name = AddBlipForCoord(x, y, z)
	local transM = 250
    SetBlipSprite(name, id)
    SetBlipColour(name, color)
	SetBlipAlpha(name,  transM)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(name)
	 while transM ~= 0 do
        Wait(3000) -- hers increases or decreases the time the blip appears
        transM = transM - 1
        SetBlipAlpha(name, transM)
    end
    return name
end

function blipName(name, id, color, text, x, y, z)
    blips.name = addBlip(name, id, color, text, x, y, z)
    return blips
end

function removeblip(name)
    if blips.name ~= nil then
        RemoveBlip(blips.name)
        blips.name = nil
    end
end

RegisterNetEvent('WK:CreateBlip')
AddEventHandler('WK:CreateBlip', function(x, y, z)
	TriggerServerEvent("WK:syncedAlarm") -- Starts fire alarm
	TriggerServerEvent("Fire-EMS-Pager:PageTones", {"fire"}, false) -- add PageTones {"medical", "rescue", "fire", "other"}
	IconNotif("CHAR_CALL911", 4, "Rapporter til stationen", "Vi har identificeret en brand!") -- Danish
	--IconNotif("CHAR_CALL911", 4, "Reports to the station", "We have identified a fire!") -- English
    addBlip(nil, 436, 1, "Fire!", x, y, z)
end)

RegisterNetEvent('WK:RemoveBlip')
AddEventHandler('WK:RemoveBlip', function(id, color, text, x, y, z)
    fire = blipName(nil, id, color, text, x, y, z)
    removeblip(fire)
end)
