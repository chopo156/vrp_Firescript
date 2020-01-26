local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","vRP_fire")

-- x, y, z, maxFlames, maxRange

local randomFireLocations = {
    [1] = {['x'] = 43.75216293335, ['y'] = -1868.8829345703, ['z'] = 22.906671524048, ['maxFlames'] = 25, ['maxRange'] = 5},
    [2] = {['x'] = 540.18634033203, ['y'] = -179.38772583008, ['z'] = 54.481338500977, ['maxFlames'] = 15, ['maxRange'] = 5},
    [3] = {['x'] = 313.78930664063, ['y'] = -205.43640136719, ['z'] = 54.086311340332, ['maxFlames'] = 15, ['maxRange'] = 5},
    [4] = {['x'] = 136.43348693848, ['y'] = 758.21600341797, ['z'] = 209.43995666504, ['maxFlames'] = 30, ['maxRange'] = 10},
    [5] = {['x'] = -602.11218261719, ['y'] = -1199.1341552734, ['z'] = 16.550569534302, ['maxFlames'] = 30, ['maxRange'] = 5}
}

local timerSpawn = math.random(1800000, 2400000) -- every 30 minutes (1800000, 2400000)
local timerDespawn = math.random(2000000, 2500000) -- every 35 minutes (or so)

Citizen.CreateThread(function()
	local user_id = vRP.getUserId({source})
	local Firefighter = vRP.getUsersByPermission({"wk.fire"})
	local pompieri = {}

    while true do
        Wait(0)
        if #Firefighter > 0 then
            Citizen.Wait(timerSpawn)
			local index = math.random(1, 5) -- Remember to add it too
            TriggerClientEvent('FireScript:StartFireAtPosition', -1, randomFireLocations[index].x, randomFireLocations[index].y, randomFireLocations[index].z, randomFireLocations[index].maxFlames, randomFireLocations[index].maxRange)
            for fired, v in pairs(Firefighter) do
                local u_source = vRP.getUserSource({fired})
                TriggerClientEvent('WK:CreateBlip', u_source, randomFireLocations[index].x, randomFireLocations[index].y, randomFireLocations[index].z)
            end

			-- debug

			--print(randomFireLocations[index].x)
			--print(randomFireLocations[index].y)
			--print(randomFireLocations[index].z)
			--print(randomFireLocations[index].maxFlames)
			--print(randomFireLocations[index].maxRange)

            Citizen.Wait(timerDespawn)
			TriggerClientEvent('FireScript:RemoveFireAtPosition', -1, randomFireLocations[index].x, randomFireLocations[index].y, randomFireLocations[index].z)
			TriggerClientEvent('WK:RemoveBlip', 436, 1, "Fire1", randomFireLocations[index].x, randomFireLocations[index].y, randomFireLocations[index].z)
        end
    end
end)

RegisterServerEvent("WK:syncedAlarm")
AddEventHandler("WK:syncedAlarm", function()
  TriggerClientEvent("triggerSound", source)
end)
