local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")

vRPl = {}
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP","WK_fire")
Lclient = Tunnel.getInterface("WK_fire","WK_fire")
Tunnel.bindInterface("WK_fire",vRPl)
-------------------------------------------------------------------------------------------------
print("Fire Script has loaded! Coded by Wick")

RegisterServerEvent("WK:firePos")
AddEventHandler("WK:firePos", function(gx, gy, gz)
	local user_id = vRP.getUserId({source}, function(user_id) return user_id end)
	local Firefighter = fire()	
	
	if user_id == Firefighter then
			print(string.format("Brand rapporteret %.2f, %.2f, %.2f.",gx,gy,gz))
			TriggerClientEvent("WK:FirePlacing", -1, gx, gy, gz)
	end		
end)
 RegisterServerEvent("WK:firesyncs")
 AddEventHandler("WK:firesyncs", function( firec, lastamnt, deletedfires, original )
	--local test = ping
	TriggerClientEvent("WK:firesyncs2", -1, firec, lastamnt, deletedfires, original)
	--TriggerClientEvent("WK:firesync3", -1)
 end)
  RegisterServerEvent("WK:fireremovesyncs2")
 AddEventHandler("WK:fireremovesyncs2", function( firec, lastamnt, deletedfires, original )
	--local test = ping
	TriggerClientEvent("WK:fireremovesync", -1, firec, lastamnt, deletedfires, original)
 end)
 RegisterServerEvent("WK:firesyncs60")
 AddEventHandler("WK:firesyncs60", function()
	--local test = ping
	--TriggerClientEvent("WK:firesyncs2", -1, firec, lastamnt, deletedfires, original)
	TriggerClientEvent("WK:firesync3", -1)
 end)
  RegisterServerEvent("WK:removefires")
 AddEventHandler("WK:removefires", function( x, y, z, i )
	local test = i
	--local test = ping
	TriggerClientEvent("WK:fireremovess", -1, x, y, z, test)
	--TriggerClientEvent("WK:firesync3", -1)
 end)
 RegisterServerEvent("fire:syncedAlarm")
AddEventHandler("fire:syncedAlarm", function()
  TriggerClientEvent("triggerSound", source)
end)
 
AddEventHandler("chatMessage", function(p, color, msg)
    if msg:sub(1, 1) == "/" then
        fullcmd = stringSplit(msg, " ")
        cmd = fullcmd[1]
		
		

       --[[ if cmd == "/gofire" then
			TriggerClientEvent("chatMessage", p, "FIRE ", {255, 0, 0}, "Du startede en brand! ")
                local fireamnt = cmd[2]
        	TriggerClientEvent("WK:firethings", p)
        	CancelEvent()
        end]]
        if cmd == "/firestop" then
			TriggerClientEvent("chatMessage", p, "FIRE ", {255, 0, 0}, "Du stoppede alle brande!")
        	TriggerClientEvent("WK:firestop", p)
			TriggerClientEvent("WK:firesync", -1)
        	CancelEvent()
        end
       --[[ if cmd == "/coor098ds" then
        	TriggerClientEvent("WK:coords", p)
        	CancelEvent()
        end]]
		if cmd == "/firecount" then
        	TriggerClientEvent("WK:firecounter", p)
        	CancelEvent()
        end
        if cmd == "/cbomb" then
        	TriggerClientEvent("WK:carbomb", p)
        	CancelEvent()
        end
		if cmd == "/sync" then
        	TriggerClientEvent("WK:firesync3", p)
			CancelEvent()
        end
    end
end)
function stringSplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end
------------------------------------------------------
function fire() -- function used to return the user id of the police group in a table
	local users = vRP.getUsersByPermission({"wk.fire"})

	 for k, v in pairs(users) do
		local user_id = v
		local player = vRP.getUserSource({user_id})
		local Firefighter = user_id
		if player ~= nil then
			return user_id
		end
	 end
end

local Firefighter = {}
------------------------------------------------------------
----------------------- RANDOM FIRES -----------------------
------------------------------------------------------------
RegisterServerEvent("WK:amfireman")

local spawnRandomFires = true -- set to true and put x,y,z locations and amount of time before their is a chance of a fire spawning
local spawnRandomFireChance = 750 -- basically a thousand sided dice is rolled and if it gets above this number then a fire spawns at one of the locations specified
local spawnRandomFireAlways = true -- for debugging, overrides the chance.
local randomSpawnTime = 900000 -- time to wait before trying ot spawn another random fire in milliseconds 1,200,000 is 20 minutes.
local randomResponseTime = 1000 -- time to wait for response from clients if they're a fireman.
local function randomFireAttempt()
	if not spawnRandomFires then
		SetTimeout(randomSpawnTime,randomFireAttempt)
		print("Tilfældige brande er slukket.")
	elseif not spawnRandomFireAlways and not (math.random(1,1000) <= spawnRandomFireChance) then
		SetTimeout(randomSpawnTime,randomFireAttempt)
		print("Tilfældig brand fik et dårligt kast.")
	else
		print("Tilfældig brand starter...")
		local event
		event = AddEventHandler("WK:amfireman",function()
			local user_id = vRP.getUserId({source}, function(user_id) return user_id end)
			local Firefighter = fire()
			if user_id == Firefighter then
				RemoveEventHandler(event)
				event = nil
				TriggerClientEvent("WK:random",user_id)
				SetTimeout(randomSpawnTime,randomFireAttempt)
				--print("[FIRE] "..(GetPlayerName(source) or "???").." vil klar det.")
			end
		end)
		SetTimeout(randomResponseTime,function()
			if event then
				RemoveEventHandler(event)
				event = nil
				SetTimeout(randomSpawnTime,randomFireAttempt)
				print("[FIRE] Nevermind, ingen brandmænd!")
			end
		end)
		TriggerClientEvent("WK:askfireman",-1)
	end
end
math.randomseed(os.time())
SetTimeout(randomSpawnTime,randomFireAttempt)