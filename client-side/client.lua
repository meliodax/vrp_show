-----------------------------------------------------------------------------------------------------------------------------------------
-- PROXY
-----------------------------------------------------------------------------------------------------------------------------------------	
local Tunnel = module("vrp", "lib/Tunnel")
local Proxy = module("vrp", "lib/Proxy")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
sRP = {}
Tunnel.bindInterface("mlx-showid",sRP)
vSERVER = Tunnel.getInterface("mlx-showid")
-----------------------------------------------------------------------------------------------------------------------------------------
-- TABLES
-----------------------------------------------------------------------------------------------------------------------------------------
local table = {}
local cPlayer = nil
-----------------------------------------------------------------------------------------------------------------------------------------
-- FUNCTION
-----------------------------------------------------------------------------------------------------------------------------------------
function sRP.getPermission(status)
    cPlayer = status
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREAD
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
    while true do
        local timeDistance = 3000
        if cPlayer then
            timeDistance = 1000
            for id = 0, 256 do 
                if NetworkIsPlayerActive(id) then
                    if GetPlayerPed(id) ~= PlayerId() then         
                        local players = vSERVER.returnPlayers(GetPlayerServerId(id))
                        table[id] = players 
                    end
                end
            end
        end
        Citizen.Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOW ID
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread( function()
    while true do
        local timeDistance = 1000
        if cPlayer then 
            local ped = PlayerPedId()
            timeDistance = 4 
            if IsControlPressed(1,288) then 
                for k, v in pairs(GetActivePlayers()) do 
                    local coords = GetEntityCoords(ped) 
                    local coords2 = GetEntityCoords(GetPlayerPed(v))
                    local distance = #(coords - vector3(coords2["x"],coords2["y"],coords2["z"]))
			    	if PlayerPedId() ~= GetPlayerPed(v) then
                        if distance <= 400 then 
				    		DrawText3D(coords2, table[v], 255, 255, 255)
                        end
                    end
                end
            end
        end
        Citizen.Wait(timeDistance)
    end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- DRAWTEXT3D
-----------------------------------------------------------------------------------------------------------------------------------------
function DrawText3D(coords, text, r,g,b)
    local onScreen,_x,_y = World3dToScreen2d(coords["x"],coords["y"],coords["z"]+1)
    local cam = GetFinalRenderedCamCoord()
    local dist = #(coords - vector3(cam["x"],cam["y"],cam["z"]))
 
    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
   
    if onScreen then
        SetTextFont(0)
        SetTextProportional(1)
        SetTextScale(0.0, 0.55)
        SetTextColour(r, g, b, 255)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end
