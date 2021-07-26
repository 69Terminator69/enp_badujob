ESX = nil

local PlayerData = {}
local playerInService = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end 

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(100)
    end

    PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
end)

RegisterNetEvent('enp_badujob:sociedad')
AddEventHandler('enp_badujob:sociedad', function()
    if PlayerData.job.grade_name == 'boss' then
        TriggerEvent('esx_society:openBossMenu', 'badu', function(data, menu)
            menu.close()
            align    = 'bottom-right'
        end, { wash = false })
    end
end)

Citizen.CreateThread(function()
    while true do
        local _msec = 250
        if PlayerData.job and PlayerData.job.name == 'badu' then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)


            local cloakroom = { x = -709.28, y = -907.19, z = 19.22}
            local dist_cloakroom = Vdist(playerCoords, cloakroom.x, cloakroom.y, cloakroom.z, true)
            
            if dist_cloakroom < 3 then
                _msec = 0
                Draw3DText( cloakroom.x, cloakroom.y, cloakroom.z, "Taquillas\n~c~Pulsa ~r~[E]~c~ para cambiarte")
                if dist_cloakroom <= 1.5 and IsControlJustPressed(0, 38) then
                    OpenTaquilla()
                end
            end

            --if playerInService then
                
                local shop = { x = -705.72, y = -915.43, z = 19.22}
                local dist_shop = Vdist(playerCoords, shop.x, shop.y, shop.z, true)

                if dist_shop < 3 then
                    _msec = 0
                    Draw3DText( shop.x, shop.y, shop.z, "Tienda\n~c~Pulsa ~r~[E]~c~ para abrir la nevera")
                    if dist_shop <= 1.5 and IsControlJustPressed(0, 38) then
                        ExecuteCommand('me Abre la nevera')
                        OpenShopMenu()
                    end
                end

                local garage = { x = -727.37, y = -909.94, z = 19.3}
                local dist_garage = Vdist(playerCoords, garage.x, garage.y, garage.z, true)

                if dist_garage < 3 then
                    _msec = 0
                    if not IsPedInAnyVehicle(playerPed, true) then
                        Draw3DText( garage.x, garage.y, garage.z, "Garage\n~c~Pulsa ~r~[E]~c~ para sacar un vehículo")
                        if dist_garage <= 1.5 and IsControlJustPressed(0, 38) then
                            OpenGarageMenu()
                        end
                    else
                        Draw3DText( garage.x, garage.y, garage.z, "Garage\n~c~Pulsa ~r~[E]~c~ para guardar un vehículo")
                        if dist_garage <= 1.5 and IsControlJustPressed(0, 38) then
                            local vehicle = GetVehiclePedIsIn(playerPed, false)
                            ESX.Game.DeleteVehicle(vehicle)
                        end
                    end
                end

                local armory = { x = -702.73, y = -916.82, z = 19.22}
                local dist_armory = Vdist(playerCoords, armory.x, armory.y, armory.z, true)

                if dist_armory < 3 then
                    _msec = 0
                    Draw3DText( armory.x, armory.y, armory.z, "Almacén\n~c~Pulsa ~r~[E]~c~ para abrir el almacén")
                    if dist_armory <= 1.5 and IsControlJustPressed(0, 38) then
                        ExecuteCommand('me Mete la llave y abre la puerta')
                        OpenArmoryMenu()
                    end
                end
                
                
                local boss = { x = -709.65, y = -905.26, z = 19.22}
                local dist_boss = Vdist(playerCoords, boss.x, boss.y, boss.z, true)
            
                if PlayerData.job and PlayerData.job.name == 'badu' and PlayerData.job.grade_name == 'boss' then
                    if dist_boss < 3 then
                        _msec = 0
                        Draw3DText( boss.x, boss.y, boss.z, "Despacho\n~c~Pulsa ~r~[E]~c~ para encender el ordenador")
                        if dist_boss <= 1.5 and IsControlJustPressed(0, 38) then
                            ExecuteCommand('me Enciende el ordenador y mira la lista de empleados')
                            TriggerEvent('enp_badujob)
                        end
                    end
                end

                
           -- end
        end 


        Citizen.Wait(_msec)
    end
end)

RegisterKeyMapping('MenuBadu', 'Menu Badulaque', 'keyboard', 'F6')
RegisterCommand('MenuBadu', function()
    if PlayerData.job and PlayerData.job.name == 'badu' then
        OpenMobileMenu()
    end
end)
function OpenMobileMenu()
	ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'facturas', {
        title = 'Facturas'
    }, function(data, menu)

        local amount = tonumber(data.value)
        if amount == nil then
            ESX.ShowNotification('Cantidad invalida')
        else
            menu.close()
            local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
            if closestPlayer == -1 or closestDistance > 3.0 then
                ESX.ShowNotification('No hay nadie cerca')
            else
                TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(closestPlayer), 'society_Badu', 'Badulaque', amount)
                ESX.ShowNotification('Factura emitada')
            end

        end

    end, function(data, menu)
        menu.close()
    end)
end


Draw3DText = function( x, y, z, text )
    local onScreen, _x, _y = World3dToScreen2d( x, y, z )

    if onScreen then
        SetTextScale( 0.4, 0.4)
        SetTextFont( 4 )
        SetTextColour( 255, 255, 255, 255)
        SetTextOutline()
        SetTextEntry( "STRING" )
        SetTextCentre( 1 )
        AddTextComponentString( text )
        DrawText( _x, _y)
    end
end


OpenTaquilla = function()
    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'cloakroom',{
        title = 'Taquilla',
        align = 'bottom-right',
        elements = {
            { label = 'Ropa de civil', value = 'citizen_wear'},
            { label = 'Uniforme', value = 'uniform'}
        }
    }, function( data, menu)
        local value = data.current.value

        local playerPed = PlayerPedId()

        if value == 'citizen_wear' then 
           -- if playerInService then 
              --  playerInService = false
                ExecuteCommand('me Abre la taquilla y se pone su ropa')
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)
                    local model = nil
          
                    if skin.sex == 0 then
                      model = GetHashKey("mp_m_freemode_01")
                    else
                      model = GetHashKey("mp_f_freemode_01")
                    end
          
                    RequestModel(model)
                    while not HasModelLoaded(model) do
                      RequestModel(model)
                      Citizen.Wait(1)
                    end
          
                    SetPlayerModel(PlayerId(), model)
                    SetModelAsNoLongerNeeded(model)
          
                    TriggerEvent('skinchanger:loadSkin', skin)
                    TriggerEvent('esx:restoreLoadout')
                end)
                menu.close()
           -- end
        elseif value == 'uniform' then 
           -- if not playerInService then
                ExecuteCommand('me Abre la taquilla y se pone la ropa de trabajo')
            --    playerInService = true
                ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

                    if skin.sex == 0 then
                        TriggerEvent('skinchanger:change', 'torso_1', 8)
                        TriggerEvent('skinchanger:change', 'torso_2', 0)
                        TriggerEvent('skinchanger:change', 'tshirt_1', 15)
                        TriggerEvent('skinchanger:change', 'arms', 8)
                        TriggerEvent('skinchanger:change', 'pants_1', 82)
                        TriggerEvent('skinchanger:change', 'pants_2', 2)
                        TriggerEvent('skinchanger:change', 'shoes_1', 31)
                        TriggerEvent('skinchanger:change', 'shoes_2', 0)
                        TriggerEvent('skinchanger:change', 'chain_1', 0)
                        TriggerEvent('skinchanger:change', 'chain_2', 0)
                        TriggerEvent('skinchanger:change', 'helmet_1', 5)
                        TriggerEvent('skinchanger:change', 'helmet_2', 0)
                    else
                        TriggerEvent('skinchanger:change', 'torso_1', 89)
                        TriggerEvent('skinchanger:change', 'torso_2', 0)
                        TriggerEvent('skinchanger:change', 'tshirt_1', 152)
                        TriggerEvent('skinchanger:change', 'tshirt_2', 0)
                        TriggerEvent('skinchanger:change', 'arms', 14)
                        TriggerEvent('skinchanger:change', 'pants_1', 51)
                        TriggerEvent('skinchanger:change', 'pants_2', 0)
                        TriggerEvent('skinchanger:change', 'shoes_1', 74)
                        TriggerEvent('skinchanger:change', 'shoes_2', 24)
                        TriggerEvent('skinchanger:change', 'chain_1', 0)
                        TriggerEvent('skinchanger:change', 'chain_2', 0)
                        TriggerEvent('skinchanger:change', 'helmet_1', -1)
                        TriggerEvent('skinchanger:change', 'helmet_2', 0)
                        TriggerEvent('skinchanger:change', 'mask_1', -1)
                        TriggerEvent('skinchanger:change', 'mask_2', 0)
                        TriggerEvent('skinchanger:change', 'bags_1', 0)
                        TriggerEvent('skinchanger:change', 'bags_2', 0)
                        TriggerEvent('skinchanger:change', 'glasses_1', 5)
                        TriggerEvent('skinchanger:change', 'glasses_2', 0)
                        TriggerEvent('skinchanger:change', 'bproof_1', 0)
                        TriggerEvent('skinchanger:change', 'bproof_2', 0)
                    end
                end)
                menu.close()
           -- end
        end
    end, function(data, menu)
        menu.close()
    end)
end

OpenShopMenu = function()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'GiGi_Shops',
		{
			title    = 'Bienvenido/a al Supermercado',
			align    = 'bottom-right',
			elements = {
				{label = 'Pan (5$)', value = 'water_1', item = 'bread', price = 10, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Agua (10$)', value = 'water_1', item = 'water', price = 10, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Vino (10$)', value = 'water_1', item = 'vino', price = 10, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Café (5$)', value = 'water_1', item = 'cafe', price = 5, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Cerveza (8$)', value = 'water_1', item = 'beer', price = 8, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Vodka (12$)', value = 'water_1', item = 'vodka', price = 12, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Whiskey (15$)', value = 'water_1', item = 'whiskey', price = 15, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Leche (6$)', value = 'water_1', item = 'milk', price = 6, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Patatas Chips (12$)', value = 'water_1', item = 'patatas_chips', price = 12, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Magdalena (15$)', value = 'water_1', item = 'magdalena', price = 15, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Sandwich (10$)', value = 'water_1', item = 'sandwich', price = 10, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Chocolate (10$)', value = 'water_1', item = 'chocolate', price = 10, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Paquete Tabaco (5$)', value = 'water_1', item = 'paquete_tabaco', price = 5, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Mechero (15$)', value = 'water_1', item = 'mechero', price = 15, value = 1, type = 'slider', min = 1, max = 100},
				{label = 'Cargador Universal (500$)', value = 'water_1', item = 'cargador', price = 500, value = 1, type = 'slider', min = 1, max = 100},
			}
		},
		function(data, menu)
            local item = data.current.item
            local price = data.current.price
            local cantidad = data.current.value
            TriggerServerEvent('enp_badujob:shop:buy', item, cantidad, price)
		end,
	function(data, menu)
		menu.close()
	end)
end

OpenGarageMenu = function()
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
		'default', GetCurrentResourceName(), 'GiGi_Shops',
		{
			title    = 'Bienvenido/a al Supermercado',
			align    = 'bottom-right',
			elements = {
				{label = 'Furgoneta', model = 'youga2'},
			}
		},
		function(data, menu)
            if ESX.Game.IsSpawnPointClear(vector3(-727.37, -909.94, 18.3), 5) then
                ESX.Game.SpawnVehicle(data.current.model, vector3(-727.37, -909.94, 18.3), 179.24, function(vehicle)
                    TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
                    SetVehicleNumberPlateText(vehicle, 'TERMIDEV')
                end)
            else
                ESX.ShowNotification('Aparcarmiento obtruido')
            end
            menu.close()
		end,
	function(data, menu)
		menu.close()
	end)
end


OpenArmoryMenu = function()
	local elements = {
		{label = 'Guardar objetos', value = 'put_stock'},
		{label = 'Coger objetos', value = 'get_stock'}
	}


	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'armory', {
		title    = 'Almacén',
		align    = 'bottom-right',
		elements = elements
	}, function(data, menu)

	    if data.current.value == 'put_stock' then
			OpenPutStocksMenu()
		elseif data.current.value == 'get_stock' then
			OpenGetStocksMenu()
		end

	end, function(data, menu)
		menu.close()
	end)
end

OpenPutStocksMenu = function()
	ESX.TriggerServerCallback('enp_badujob:getPlayerInventory', function(inventory)
		local elements = {}

		for i=1, #inventory.items, 1 do
			local item = inventory.items[i]

			if item.count > 0 then
				table.insert(elements, {
					label = item.label .. ' x' .. item.count,
					type = 'item_standard',
					value = item.name
				})
			end
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Inventario',
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_put_item_count', {
				title = 'Cantidad'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Cantidad invalida')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('enp_badujob:putStockItems', itemName, count)

					Citizen.Wait(300)
					OpenPutStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end


OpenGetStocksMenu = function()
	ESX.TriggerServerCallback('enp_badujob:getStockItems', function(items)
		local elements = {}

		for i=1, #items, 1 do
			table.insert(elements, {
				label = 'x' .. items[i].count .. ' ' .. items[i].label,
				value = items[i].name
			})
		end

		ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'stocks_menu', {
			title    = 'Almacén',
			align    = 'bottom-right',
			elements = elements
		}, function(data, menu)
			local itemName = data.current.value

			ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'stocks_menu_get_item_count', {
				title = 'Cantidad'
			}, function(data2, menu2)
				local count = tonumber(data2.value)

				if count == nil then
					ESX.ShowNotification('Cantidad invalida')
				else
					menu2.close()
					menu.close()
					TriggerServerEvent('enp_badujob:getStockItem', itemName, count)

					Citizen.Wait(1000)
					OpenGetStocksMenu()
				end
			end, function(data2, menu2)
				menu2.close()
			end)
		end, function(data, menu)
			menu.close()
		end)
	end)
end

