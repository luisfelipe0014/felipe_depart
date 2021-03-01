-----------------------------------------------------------------------------------------------------------------------------------------
-- VRP
-----------------------------------------------------------------------------------------------------------------------------------------
local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CONEXÃO
-----------------------------------------------------------------------------------------------------------------------------------------
src = {}
Tunnel.bindInterface("felipe_depart",src)
vSERVER = Tunnel.getInterface("felipe_depart")
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCALIDADES
-----------------------------------------------------------------------------------------------------------------------------------------
local lojas = {992069095, -654402915}

local localidades = {
	{ 25.65,-1346.58,29.49 },
	{ 2556.75,382.01,108.62 },
	{ 1163.54,-323.04,69.20 },
	{ -707.37,-913.68,19.21 },
	{ -47.73,-1757.25,29.42 },
	{ 373.90,326.91,103.56 },
	{ -3243.10,1001.23,12.83 },
	{ 1729.38,6415.54,35.03 },
	{ 547.90,2670.36,42.15 },
	{ 1960.75,3741.33,32.34 },
	{ 2677.90,3280.88,55.24 },
	{ 1698.45,4924.15,42.06 },
	{ -1820.93,793.18,138.11 },
	{ 1392.46,3604.95,34.98 },
	{ -2967.82,390.93,15.04 },
	{ -3040.10,585.44,7.90 },
	{ 1135.56,-982.20,46.41 },
	{ 1165.91,2709.41,38.15 },
	{ -1487.18,-379.02,40.16 },
	{ -1222.78,-907.22,12.32 },
	{ 123.49,-1035.3,29.28 },
	{ 130.68,-1052.86,22.97 },
	{ 344.63,-598.33,43.31 },
	{ 161.95,6641.24,31.72 },
	{ -160.07,6322.36,31.6 },
	{ -2540.54,2313.18,33.42 },
	{ 5.36,-1605.2,29.4 },
	{ 798.54,-735.48,28.0 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- OPENSHOP
-----------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	SetNuiFocus(false,false)
    while true do
        sleep = 1500
        local pos = GetEntityCoords(GetPlayerPed(-1), false)
        for i = 1, #lojas do
            local loja = GetClosestObjectOfType(pos.x, pos.y, pos.z, 1.0, lojas[i], false, false, false)
			local lojaPos = GetEntityCoords(loja)
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
            if loja ~= 0 then
				sleep = 0
				DrawText3D(lojaPos.x, lojaPos.y, lojaPos.z+0.9, "Pressione [~p~E~w~] para acessar a ~p~LOJA~w~.", 255, 255, 255)
				if IsControlJustPressed(0,38) then
					SetNuiFocus(true,true)
					SendNUIMessage({ action = "showMenu" })
				end
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
	SetNuiFocus(false,false)
	while true do
		sleep = 1500
		local ped = PlayerPedId()
		if not IsPedInAnyVehicle(ped) then
			local x,y,z = table.unpack(GetEntityCoords(ped))
			for k,v in pairs(localidades) do
				local distance = Vdist(x,y,z,v[1],v[2],v[3])
				sleep = 0
				if distance <= 1.2 and IsControlJustPressed(1,38) and vSERVER.checkSearch() then
					SetNuiFocus(true,true)
					SendNUIMessage({ action = "showMenu" })
				end
			end
		end
		Citizen.Wait(sleep)
	end
end)


function DrawText3D(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.28, 0.28)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 25, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPCLOSE
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("shopClose",function(data)
	SetNuiFocus(false,false)
	SendNUIMessage({ action = "hideMenu" })
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- UTILIDADESLIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("utilidadesList",function(data,cb)
	local shopitens = vSERVER.utilidadesList()
	if shopitens then
		cb({ shopitens = shopitens })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- VESTUARIOLIST
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("vestuarioList",function(data,cb)
	local shopitens = vSERVER.vestuarioList()
	if shopitens then
		cb({ shopitens = shopitens })
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- SHOPBUY
-----------------------------------------------------------------------------------------------------------------------------------------
RegisterNUICallback("shopBuy",function(data)
	if data.index ~= nil then
		vSERVER.shopBuy(data.index,data.price,data.amount)
	end
end)