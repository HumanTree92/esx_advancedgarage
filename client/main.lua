local CurrentActionData, userProperties, this_Garage, vehInstance, BlipList, PrivateBlips, JobBlips = {}, {}, {}, {}, {}, {}, {}
local HasAlreadyEnteredMarker = false
local LastZone, CurrentAction, CurrentActionMsg

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	if Config.Pvt.UseG then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedProperties', function(properties)
			userProperties = properties
			DeletePrivateBlips()
			RefreshPrivateBlips()
		end)
	end

	ESX.PlayerData = xPlayer

	CreateBlips()
	RefreshJobBlips()
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job

	DeleteJobBlips()
	RefreshJobBlips()
end)

RegisterNetEvent('esx_advancedgarage:getPropertiesC')
AddEventHandler('esx_advancedgarage:getPropertiesC', function(xPlayer)
	if Config.Pvt.UseG then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedProperties', function(properties)
			userProperties = properties
			DeletePrivateBlips()
			RefreshPrivateBlips()
		end)

		ESX.ShowNotification(_U('get_properties'))
		TriggerServerEvent('esx_advancedgarage:printGetProperties')
	end
end)

function has_value(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end
	return false
end

-- Start of Garage Menu
function OpenGarageMenu(_pJob, _vType)
	local elements = {}
	local pJob, vType = _pJob, _vType

	if pJob == 'ambulance' or pJob == 'police' then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('cars'), value = 'cars', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'cars')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('helis'), value = 'helis', spawnloc = this_Garage.Spawner2, spawnhead = this_Garage.Heading2})
			end
		end, pJob, 'helis')
	elseif pJob == 'mechanic' or pJob == 'taxi' then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('cars'), value = 'cars', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'cars')
	elseif pJob == 'civ' and vType == 'aircrafts' then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('helis'), value = 'helis', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'helis')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('planes'), value = 'planes', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'planes')
	elseif pJob == 'civ' and vType == 'boats' then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('boats'), value = 'boats', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'boats')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('subs'), value = 'subs', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'subs')
	elseif pJob == 'civ' and vType == 'cars' then
		if Config.Main.TruckShop then
			ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
				if #ownedVehicles > 0 then
					table.insert(elements, {label = _U('box'), value = 'box', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
				end
			end, pJob, 'box')

			ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
				if #ownedVehicles > 0 then
					table.insert(elements, {label = _U('haul'), value = 'haul', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
				end
			end, pJob, 'haul')

			ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
				if #ownedVehicles > 0 then
					table.insert(elements, {label = _U('other'), value = 'other', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
				end
			end, pJob, 'other')

			ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
				if #ownedVehicles > 0 then
					table.insert(elements, {label = _U('trans'), value = 'trans', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
				end
			end, pJob, 'trans')
		end

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('cycles'), value = 'cycles', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'cycles')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('compacts'), value = 'compacts', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'compacts')
		
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('coupes'), value = 'coupes', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'coupes')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('motorcycles'), value = 'motorcycles', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'motorcycles')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('muscles'), value = 'muscles', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'muscles')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('offroads'), value = 'offroads', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'offroads')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('sedans'), value = 'sedans', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'sedans')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('sports'), value = 'sports', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'sports')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('sportsclassics'), value = 'sportsclassics', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'sportsclassics')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('supers'), value = 'supers', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'supers')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('suvs'), value = 'suvs', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'suvs')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehicles)
			if #ownedVehicles > 0 then
				table.insert(elements, {label = _U('vans'), value = 'vans', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'vans')
	end
	Citizen.Wait(500)

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'garage_menu', {
		title = _U('garage_menu'),
		align = GetConvar('esx_MenuAlign', 'top-left'),
		elements = elements
	}, function(data, menu)
		local action, spawner, heading = data.current.value, data.current.spawnloc, data.current.spawnhead

		if action == 'spacer' then
		else
			local elements2 = {head = {_U('veh_plate'), _U('veh_name'), _U('veh_loc'), _U('actions')}, rows = {}}
			ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehicles', function(ownedVehs)
				for _,v in pairs(ownedVehs) do
					local vehStored = _U('veh_loc_unknown')
					if v.stored then
						vehStored = _U('veh_loc_garage')
					else
						vehStored = _U('veh_loc_impound')
					end

					table.insert(elements2.rows, {data = v, cols = {v.plate, v.vehName, vehStored, '{{' .. _U('spawn') .. '|spawn}} {{' .. _U('rename') .. '|rename}}'}})
				end

				ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'owned_vehicles_list', elements2, function(data2, menu2)
					local vehVehicle, vehPlate, vehStored, vehFuel = data2.data.vehicle, data2.data.plate, data2.data.stored, data2.data.fuel
					if data2.value == 'spawn' then
						if vehStored then
							if ESX.Game.IsSpawnPointClear(spawner, 5.0) then
								SpawnVehicle(spawner, heading, vehVehicle, vehPlate, vehFuel)
								ESX.UI.Menu.CloseAll()
							else
								ESX.ShowNotification(_U('spawnpoint_blocked'))
							end
						else
							ESX.ShowNotification(_U('veh_not_here'))
						end
					elseif data2.value == 'rename' then
						if Config.Main.RenameVehs then
							ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'renamevehicle', {
								title = _U('veh_rename', Config.Main.RenameMin, Config.Main.RenameMax - 1)
							}, function(data3, menu3)
								if string.len(data3.value) >= Config.Main.RenameMin and string.len(data3.value) < Config.Main.RenameMax then
									TriggerServerEvent('esx_advancedgarage:renameVehicle', vehPlate, data3.value)
									ESX.UI.Menu.CloseAll()
								else
									ESX.ShowNotification(_U('veh_rename_empty', Config.Main.RenameMin, Config.Main.RenameMax - 1))
								end
							end, function(data3, menu3)
								menu3.close()
							end)
						else
							ESX.ShowNotification(_U('veh_rename_no'))
						end
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end, pJob, action)
		end
	end, function(data, menu)
		menu.close()
	end)
end
-- End of Garage Menu

-- Start of Impound Menu
function OpenImpoundMenu(_pJob, _vType)
	local elements = {}
	local pJob, vType = _pJob, _vType

	if pJob == 'ambulance' and vType == 'none' or pJob == 'police' and vType == 'none' then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehiclesOut', function(ownedVehiclesOut)
			if #ownedVehiclesOut > 0 then
				table.insert(elements, {label = _U('cars'), value = 'cars', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'cars')

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehiclesOut', function(ownedVehiclesOut)
			if #ownedVehiclesOut > 0 then
				table.insert(elements, {label = _U('helis'), value = 'helis', spawnloc = this_Garage.Spawner2, spawnhead = this_Garage.Heading2})
			end
		end, pJob, 'helis')
	elseif pJob == 'mechanic' and vType == 'none' or pJob == 'taxi' and vType == 'none' then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehiclesOut', function(ownedVehiclesOut)
			if #ownedVehiclesOut > 0 then
				table.insert(elements, {label = _U('cars'), value = 'cars', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'cars')
	elseif pJob == 'civ' and vType == 'aircrafts' then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehiclesOut', function(ownedVehiclesOut)
			if #ownedVehiclesOut > 0 then
				table.insert(elements, {label = _U('aircrafts'), value = 'aircrafts', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'aircrafts')
	elseif pJob == 'civ' and vType == 'boats' then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehiclesOut', function(ownedVehiclesOut)
			if #ownedVehiclesOut > 0 then
				table.insert(elements, {label = _U('boats'), value = 'boats', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'boats')
	elseif pJob == 'civ' and vType == 'cars' then
		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehiclesOut', function(ownedVehiclesOut)
			if #ownedVehiclesOut > 0 then
				table.insert(elements, {label = _U('cars'), value = 'cars', spawnloc = this_Garage.Spawner, spawnhead = this_Garage.Heading})
			end
		end, pJob, 'cars')
	end
	Citizen.Wait(500)

	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'impound_menu', {
		title = _U('impound_menu'),
		align = GetConvar('esx_MenuAlign', 'top-left'),
		elements = elements
	}, function(data, menu)
		local action, spawner, heading = data.current.value, data.current.spawnloc, data.current.spawnhead
		local elements2 = {head = {_U('veh_plate'), _U('veh_name'), _U('impound_fee'), _U('actions')}, rows = {}}

		ESX.TriggerServerCallback('esx_advancedgarage:getOwnedVehiclesOut', function(outOwnedCars)
			if #outOwnedCars == 0 then
				ESX.ShowNotification(_U('impound_no_veh'))
			else
				for _,v in pairs(outOwnedCars) do
					if pJob == 'ambulance' and vType == 'none' then
						table.insert(elements2.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Ambulance.PoundP)), '{{' .. _U('return') .. '|return}}'}})
					elseif pJob == 'police' and vType == 'none' then
						table.insert(elements2.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Police.PoundP)), '{{' .. _U('return') .. '|return}}'}})
					elseif pJob == 'mechanic' and vType == 'none' then
						table.insert(elements2.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Mechanic.PoundP)), '{{' .. _U('return') .. '|return}}'}})
					elseif pJob == 'taxi' and vType == 'none' then
						table.insert(elements2.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Taxi.PoundP)), '{{' .. _U('return') .. '|return}}'}})
					elseif pJob == 'civ' and vType == 'aircrafts' then
						table.insert(elements2.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Aircrafts.PoundP)), '{{' .. _U('return') .. '|return}}'}})
					elseif pJob == 'civ' and vType == 'boats' then
						table.insert(elements2.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Boats.PoundP)), '{{' .. _U('return') .. '|return}}'}})
					elseif pJob == 'civ' and vType == 'cars' then
						table.insert(elements2.rows, {data = v, cols = {v.plate, v.vehName, _U('impound_fee_value', ESX.Math.GroupDigits(Config.Cars.PoundP)), '{{' .. _U('return') .. '|return}}'}})
					end
				end

				ESX.UI.Menu.Open('list', GetCurrentResourceName(), 'out_owned_vehicles_list', elements2, function(data2, menu2)
					local vehVehicle, vehPlate, vehFuel = data2.data.vehicle, data2.data.plate, data2.data.fuel
					local doesVehicleExist = false

					if data2.value == 'return' then
						for k,v in pairs (vehInstance) do
							if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehPlate) then
								if DoesEntityExist(v.vehicleentity) then
									doesVehicleExist = true
								else
									table.remove(vehInstance, k)
									doesVehicleExist = false
								end
							end
						end

						if not doesVehicleExist and not DoesAPlayerDrivesVehicle(vehPlate) then
							if ESX.Game.IsSpawnPointClear(spawner, 5.0) then
								ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function(hasEnoughMoney)
									if hasEnoughMoney then
										ESX.TriggerServerCallback('esx_advancedgarage:payImpound', function()
											SpawnVehicle(spawner, heading, vehVehicle, vehPlate, vehFuel)
											ESX.UI.Menu.CloseAll()
										end, pJob, vType, 'pay')
									else
										ESX.ShowNotification(_U('not_enough_money'))
									end
								end, pJob, vType, 'check')
							else
								ESX.ShowNotification(_U('spawnpoint_blocked'))
							end
						else
							ESX.ShowNotification(_U('veh_out_world'))
						end
					end
				end, function(data2, menu2)
					menu2.close()
				end)
			end
		end, pJob, action)
	end, function(data, menu)
		menu.close()
	end)
end
-- End of Impound Menu

-- Start of Store Menu
function OpenStoreMenu(_pJob, _vType)
	local pJob, vType = _pJob, _vType
	local playerPed  = GetPlayerPed(-1)

	if IsPedInAnyVehicle(playerPed,  false) then
		local playerPed = GetPlayerPed(-1)
		local coords = GetEntityCoords(playerPed)
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)
		local current = GetPlayersLastVehicle(GetPlayerPed(-1), true)
		local engineHealth = GetVehicleEngineHealth(current)
		local plate = vehicleProps.plate

		ESX.TriggerServerCallback('esx_advancedgarage:storeVehicle', function(valid)
			if valid then
				if engineHealth < 990 then
					if Config.Main.DamageMult then
						if pJob == 'ambulance' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Ambulance.PoundP*Config.Main.MultAmount)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						elseif pJob == 'police' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Police.PoundP*Config.Main.MultAmount)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						elseif pJob == 'mechanic' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Mechanic.PoundP*Config.Main.MultAmount)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						elseif pJob == 'taxi' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Taxi.PoundP*Config.Main.MultAmount)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						elseif pJob == 'civ' and vType == 'aircrafts' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Aircrafts.PoundP*Config.Main.MultAmount)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						elseif pJob == 'civ' and vType == 'boats' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Boats.PoundP*Config.Main.MultAmount)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						elseif pJob == 'civ' and vType == 'cars' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Cars.PoundP*Config.Main.MultAmount)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						end
					else
						if pJob == 'ambulance' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Ambulance.PoundP)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						elseif pJob == 'police' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Police.PoundP)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						elseif pJob == 'mechanic' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Mechanic.PoundP)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						elseif pJob == 'taxi' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Taxi.PoundP)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						elseif pJob == 'civ' and vType == 'aircrafts' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Aircrafts.PoundP)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						elseif pJob == 'civ' and vType == 'boats' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Boats.PoundP)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						elseif pJob == 'civ' and vType == 'cars' then
							local apprasial = math.floor((1000 - engineHealth)/1000*Config.Cars.PoundP)
							RepairVehicle(apprasial, vehicle, vehicleProps)
						end
					end
				else
					StoreVehicle(vehicle, vehicleProps)
				end	
			else
				ESX.ShowNotification(_U('cannot_store_vehicle'))
			end
		end, vehicleProps)
	else
		ESX.ShowNotification(_U('no_vehicle_to_enter'))
	end
end
-- End of Store Menu

-- Repair Vehicles
function RepairVehicle(apprasial, vehicle, vehicleProps)
	ESX.UI.Menu.CloseAll()
	ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'repair_vehicle_menu', {
		title = _U('damaged_vehicle'),
		align = GetConvar('esx_MenuAlign', 'top-left'),
		elements = {
			{label = _U('return_vehicle', apprasial), value = 'yes'},
			{label = _U('see_mechanic'), value = 'no'}
	}}, function(data, menu)
		menu.close()

		if data.current.value == 'yes' then
			TriggerServerEvent('esx_advancedgarage:payhealth', apprasial)
			vehicleProps.bodyHealth = 1000.0 -- must be a decimal value!!!
			vehicleProps.engineHealth = 1000
			StoreVehicle(vehicle, vehicleProps)
		elseif data.current.value == 'no' then
			ESX.ShowNotification(_U('visit_mechanic'))
		end
	end, function(data, menu)
		menu.close()
	end)
end

-- Store Vehicles
function StoreVehicle(vehicle, vehicleProps)
	for k,v in pairs (vehInstance) do
		if ESX.Math.Trim(v.plate) == ESX.Math.Trim(vehicleProps.plate) then
			table.remove(vehInstance, k)
		end
	end

	if Config.Main.LegacyFuel then
		currentFuel = exports['LegacyFuel']:GetFuel(vehicle)
		TriggerServerEvent('esx_advancedgarage:setVehicleFuel', vehicleProps.plate, currentFuel)
	end

	DeleteEntity(vehicle)
	TriggerServerEvent('esx_advancedgarage:setVehicleState', vehicleProps.plate, true)
	ESX.ShowNotification(_U('vehicle_in_garage'))
end

-- Spawn Vehicles
function SpawnVehicle(spawner, heading, vehicle, plate, fuel)
	ESX.Game.SpawnVehicle(vehicle.model, spawner, heading, function(callback_vehicle)
		ESX.Game.SetVehicleProperties(callback_vehicle, vehicle)
		SetVehRadioStation(callback_vehicle, 'OFF')
		SetVehicleFixed(callback_vehicle)
		SetVehicleDeformationFixed(callback_vehicle)
		SetVehicleUndriveable(callback_vehicle, false)
		SetVehicleEngineOn(callback_vehicle, true, true)
		SetEntityAsMissionEntity(callback_vehicle, true, false)
		local carplate = GetVehicleNumberPlateText(callback_vehicle)
		table.insert(vehInstance, {vehicleentity = callback_vehicle, plate = carplate})
		if Config.Main.LegacyFuel then
			exports['LegacyFuel']:SetFuel(callback_vehicle, fuel)
		end
		TaskWarpPedIntoVehicle(GetPlayerPed(-1), callback_vehicle, -1)
	end)

	TriggerServerEvent('esx_advancedgarage:setVehicleState', plate, false)
end

-- Check Vehicles
function DoesAPlayerDrivesVehicle(plate)
	local isVehicleTaken = false
	local players = ESX.Game.GetPlayers()
	for i=1, #players, 1 do
		local target = GetPlayerPed(players[i])
		if target ~= PlayerPedId() then
			local plate1 = GetVehicleNumberPlateText(GetVehiclePedIsIn(target, true))
			local plate2 = GetVehicleNumberPlateText(GetVehiclePedIsIn(target, false))
			if plate == plate1 or plate == plate2 then
				isVehicleTaken = true
				break
			end
		end
	end
	return isVehicleTaken
end

-- Entered Marker
AddEventHandler('esx_advancedgarage:hasEnteredMarker', function(zone)
	if zone == 'ambulance_garage_point' then
		CurrentAction = 'ambulance_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'ambulance_store_point' then
		CurrentAction = 'ambulance_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'ambulance_pound_point' then
		CurrentAction = 'ambulance_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'police_garage_point' then
		CurrentAction = 'police_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'police_store_point' then
		CurrentAction = 'police_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'police_pound_point' then
		CurrentAction = 'police_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'mechanic_garage_point' then
		CurrentAction = 'mechanic_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'mechanic_store_point' then
		CurrentAction = 'mechanic_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'mechanic_pound_point' then
		CurrentAction = 'mechanic_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'taxi_garage_point' then
		CurrentAction = 'taxi_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'taxi_store_point' then
		CurrentAction = 'taxi_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'taxi_pound_point' then
		CurrentAction = 'taxi_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'aircraft_garage_point' then
		CurrentAction = 'aircraft_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'aircraft_store_point' then
		CurrentAction = 'aircraft_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'aircraft_pound_point' then
		CurrentAction = 'aircraft_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'boat_garage_point' then
		CurrentAction = 'boat_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'boat_store_point' then
		CurrentAction = 'boat_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'boat_pound_point' then
		CurrentAction = 'boat_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	elseif zone == 'car_garage_point' then
		CurrentAction = 'car_garage_point'
		CurrentActionMsg = _U('press_to_enter')
		CurrentActionData = {}
	elseif zone == 'car_store_point' then
		CurrentAction = 'car_store_point'
		CurrentActionMsg = _U('press_to_delete')
		CurrentActionData = {}
	elseif zone == 'car_pound_point' then
		CurrentAction = 'car_pound_point'
		CurrentActionMsg = _U('press_to_impound')
		CurrentActionData = {}
	end
end)

-- Exited Marker
AddEventHandler('esx_advancedgarage:hasExitedMarker', function()
	ESX.UI.Menu.CloseAll()
	CurrentAction = nil
end)

-- Resource Stop
AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		ESX.UI.Menu.CloseAll()
	end
end)

-- Enter / Exit marker events & Draw Markers
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerCoords = GetEntityCoords(PlayerPedId())
		local isInMarker, letSleep, currentZone = false, true

		if Config.Ambulance.UseG then
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
				for k,v in pairs(Config.Ambulance.Garages) do
					local distance = #(playerCoords - v.Marker)
					local distance2 = #(playerCoords - v.Deleter)
					local distance3 = #(playerCoords - v.Deleter2)

					if distance < Config.Main.DrawDistance then
						letSleep = false

						if Config.Ambulance.Markers.Points.Type ~= -1 then
							DrawMarker(Config.Ambulance.Markers.Points.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Ambulance.Markers.Points.x, Config.Ambulance.Markers.Points.y, Config.Ambulance.Markers.Points.z, Config.Ambulance.Markers.Points.r, Config.Ambulance.Markers.Points.g, Config.Ambulance.Markers.Points.b, 100, false, true, 2, false, nil, nil, false)
						end

						if distance < Config.Ambulance.Markers.Points.x then
							isInMarker, this_Garage, currentZone = true, v, 'ambulance_garage_point'
						end
					end

					if distance2 < Config.Main.DrawDistance then
						letSleep = false

						if Config.Ambulance.Markers.Delete.Type ~= -1 then
							DrawMarker(Config.Ambulance.Markers.Delete.Type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Ambulance.Markers.Delete.x, Config.Ambulance.Markers.Delete.y, Config.Ambulance.Markers.Delete.z, Config.Ambulance.Markers.Delete.r, Config.Ambulance.Markers.Delete.g, Config.Ambulance.Markers.Delete.b, 100, false, true, 2, false, nil, nil, false)
						end

						if IsPedSittingInAnyVehicle(PlayerPedId()) then
							if distance2 < Config.Ambulance.Markers.Delete.x then
								isInMarker, this_Garage, currentZone = true, v, 'ambulance_store_point'
							end
						end
					end

					if distance3 < Config.Main.DrawDistance then
						letSleep = false

						if Config.Ambulance.Markers.Delete.Type ~= -1 then
							DrawMarker(Config.Ambulance.Markers.Delete.Type, v.Deleter2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Ambulance.Markers.Delete.x, Config.Ambulance.Markers.Delete.y, Config.Ambulance.Markers.Delete.z, Config.Ambulance.Markers.Delete.r, Config.Ambulance.Markers.Delete.g, Config.Ambulance.Markers.Delete.b, 100, false, true, 2, false, nil, nil, false)
						end

						if IsPedSittingInAnyVehicle(PlayerPedId()) then
							if distance3 < Config.Ambulance.Markers.Delete.x then
								isInMarker, this_Garage, currentZone = true, v, 'ambulance_store_point'
							end
						end
					end
				end
			end
		end

		if Config.Ambulance.UseP then
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
				for k,v in pairs(Config.Ambulance.Pounds) do
					local distance = #(playerCoords - v.Marker)

					if distance < Config.Main.DrawDistance then
						letSleep = false

						if Config.Ambulance.Markers.Pounds.Type ~= -1 then
							DrawMarker(Config.Ambulance.Markers.Pounds.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Ambulance.Markers.Pounds.x, Config.Ambulance.Markers.Pounds.y, Config.Ambulance.Markers.Pounds.z, Config.Ambulance.Markers.Pounds.r, Config.Ambulance.Markers.Pounds.g, Config.Ambulance.Markers.Pounds.b, 100, false, true, 2, false, nil, nil, false)
						end

						if distance < Config.Ambulance.Markers.Pounds.x then
							isInMarker, this_Garage, currentZone = true, v, 'ambulance_pound_point'
						end
					end
				end
			end
		end

		if Config.Police.UseG then
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
				for k,v in pairs(Config.Police.Garages) do
					local distance = #(playerCoords - v.Marker)
					local distance2 = #(playerCoords - v.Deleter)
					local distance3 = #(playerCoords - v.Deleter2)

					if distance < Config.Main.DrawDistance then
						letSleep = false

						if Config.Police.Markers.Points.Type ~= -1 then
							DrawMarker(Config.Police.Markers.Points.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Police.Markers.Points.x, Config.Police.Markers.Points.y, Config.Police.Markers.Points.z, Config.Police.Markers.Points.r, Config.Police.Markers.Points.g, Config.Police.Markers.Points.b, 100, false, true, 2, false, nil, nil, false)
						end

						if distance < Config.Police.Markers.Points.x then
							isInMarker, this_Garage, currentZone = true, v, 'police_garage_point'
						end
					end

					if distance2 < Config.Main.DrawDistance then
						letSleep = false

						if Config.Police.Markers.Delete.Type ~= -1 then
							DrawMarker(Config.Police.Markers.Delete.Type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Police.Markers.Delete.x, Config.Police.Markers.Delete.y, Config.Police.Markers.Delete.z, Config.Police.Markers.Delete.r, Config.Police.Markers.Delete.g, Config.Police.Markers.Delete.b, 100, false, true, 2, false, nil, nil, false)
						end

						if IsPedSittingInAnyVehicle(PlayerPedId()) then
							if distance2 < Config.Police.Markers.Delete.x then
								isInMarker, this_Garage, currentZone = true, v, 'police_store_point'
							end
						end
					end

					if distance3 < Config.Main.DrawDistance then
						letSleep = false

						if Config.Police.Markers.Delete.Type ~= -1 then
							DrawMarker(Config.Police.Markers.Delete.Type, v.Deleter2, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Police.Markers.Delete.x, Config.Police.Markers.Delete.y, Config.Police.Markers.Delete.z, Config.Police.Markers.Delete.r, Config.Police.Markers.Delete.g, Config.Police.Markers.Delete.b, 100, false, true, 2, false, nil, nil, false)
						end

						if IsPedSittingInAnyVehicle(PlayerPedId()) then
							if distance3 < Config.Police.Markers.Delete.x then
								isInMarker, this_Garage, currentZone = true, v, 'police_store_point'
							end
						end
					end
				end
			end
		end

		if Config.Police.UseP then
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
				for k,v in pairs(Config.Police.Pounds) do
					local distance = #(playerCoords - v.Marker)

					if distance < Config.Main.DrawDistance then
						letSleep = false

						if Config.Police.Markers.Pounds.Type ~= -1 then
							DrawMarker(Config.Police.Markers.Pounds.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Police.Markers.Pounds.x, Config.Police.Markers.Pounds.y, Config.Police.Markers.Pounds.z, Config.Police.Markers.Pounds.r, Config.Police.Markers.Pounds.g, Config.Police.Markers.Pounds.b, 100, false, true, 2, false, nil, nil, false)
						end

						if distance < Config.Police.Markers.Pounds.x then
							isInMarker, this_Garage, currentZone = true, v, 'police_pound_point'
						end
					end
				end
			end
		end

		if Config.Mechanic.UseG then
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
				for k,v in pairs(Config.Mechanic.Garages) do
					local distance = #(playerCoords - v.Marker)
					local distance2 = #(playerCoords - v.Deleter)

					if distance < Config.Main.DrawDistance then
						letSleep = false

						if Config.Mechanic.Markers.Points.Type ~= -1 then
							DrawMarker(Config.Mechanic.Markers.Points.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Mechanic.Markers.Points.x, Config.Mechanic.Markers.Points.y, Config.Mechanic.Markers.Points.z, Config.Mechanic.Markers.Points.r, Config.Mechanic.Markers.Points.g, Config.Mechanic.Markers.Points.b, 100, false, true, 2, false, nil, nil, false)
						end

						if distance < Config.Mechanic.Markers.Points.x then
							isInMarker, this_Garage, currentZone = true, v, 'mechanic_garage_point'
						end
					end

					if distance2 < Config.Main.DrawDistance then
						letSleep = false

						if Config.Mechanic.Markers.Delete.Type ~= -1 then
							DrawMarker(Config.Mechanic.Markers.Delete.Type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Mechanic.Markers.Delete.x, Config.Mechanic.Markers.Delete.y, Config.Mechanic.Markers.Delete.z, Config.Mechanic.Markers.Delete.r, Config.Mechanic.Markers.Delete.g, Config.Mechanic.Markers.Delete.b, 100, false, true, 2, false, nil, nil, false)
						end

						if IsPedSittingInAnyVehicle(PlayerPedId()) then
							if distance2 < Config.Mechanic.Markers.Delete.x then
								isInMarker, this_Garage, currentZone = true, v, 'mechanic_store_point'
							end
						end
					end
				end
			end
		end

		if Config.Mechanic.UseP then
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
				for k,v in pairs(Config.Mechanic.Pounds) do
					local distance = #(playerCoords - v.Marker)

					if distance < Config.Main.DrawDistance then
						letSleep = false

						if Config.Mechanic.Markers.Pounds.Type ~= -1 then
							DrawMarker(Config.Mechanic.Markers.Pounds.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Mechanic.Markers.Pounds.x, Config.Mechanic.Markers.Pounds.y, Config.Mechanic.Markers.Pounds.z, Config.Mechanic.Markers.Pounds.r, Config.Mechanic.Markers.Pounds.g, Config.Mechanic.Markers.Pounds.b, 100, false, true, 2, false, nil, nil, false)
						end

						if distance < Config.Mechanic.Markers.Pounds.x then
							isInMarker, this_Garage, currentZone = true, v, 'mechanic_pound_point'
						end
					end
				end
			end
		end

		if Config.Taxi.UseG then
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
				for k,v in pairs(Config.Taxi.Garages) do
					local distance = #(playerCoords - v.Marker)
					local distance2 = #(playerCoords - v.Deleter)

					if distance < Config.Main.DrawDistance then
						letSleep = false

						if Config.Taxi.Markers.Points.Type ~= -1 then
							DrawMarker(Config.Taxi.Markers.Points.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Taxi.Markers.Points.x, Config.Taxi.Markers.Points.y, Config.Taxi.Markers.Points.z, Config.Taxi.Markers.Points.r, Config.Taxi.Markers.Points.g, Config.Taxi.Markers.Points.b, 100, false, true, 2, false, nil, nil, false)
						end

						if distance < Config.Taxi.Markers.Points.x then
							isInMarker, this_Garage, currentZone = true, v, 'taxi_garage_point'
						end
					end

					if distance2 < Config.Main.DrawDistance then
						letSleep = false

						if Config.Taxi.Markers.Delete.Type ~= -1 then
							DrawMarker(Config.Taxi.Markers.Delete.Type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Taxi.Markers.Delete.x, Config.Taxi.Markers.Delete.y, Config.Taxi.Markers.Delete.z, Config.Taxi.Markers.Delete.r, Config.Taxi.Markers.Delete.g, Config.Taxi.Markers.Delete.b, 100, false, true, 2, false, nil, nil, false)
						end

						if IsPedSittingInAnyVehicle(PlayerPedId()) then
							if distance2 < Config.Taxi.Markers.Delete.x then
								isInMarker, this_Garage, currentZone = true, v, 'taxi_store_point'
							end
						end
					end
				end
			end
		end

		if Config.Taxi.UseP then
			if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
				for k,v in pairs(Config.Taxi.Pounds) do
					local distance = #(playerCoords - v.Marker)

					if distance < Config.Main.DrawDistance then
						letSleep = false

						if Config.Taxi.Markers.Pounds.Type ~= -1 then
							DrawMarker(Config.Taxi.Markers.Pounds.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Taxi.Markers.Pounds.x, Config.Taxi.Markers.Pounds.y, Config.Taxi.Markers.Pounds.z, Config.Taxi.Markers.Pounds.r, Config.Taxi.Markers.Pounds.g, Config.Taxi.Markers.Pounds.b, 100, false, true, 2, false, nil, nil, false)
						end

						if distance < Config.Taxi.Markers.Pounds.x then
							isInMarker, this_Garage, currentZone = true, v, 'taxi_pound_point'
						end
					end
				end
			end
		end

		if Config.Aircrafts.UseG then
			for k,v in pairs(Config.Aircrafts.Garages) do
				local distance = #(playerCoords - v.Marker)
				local distance2 = #(playerCoords - v.Deleter)

				if distance < Config.Main.DrawDistance then
					letSleep = false

					if Config.Aircrafts.Markers.Points.Type ~= -1 then
						DrawMarker(Config.Aircrafts.Markers.Points.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Aircrafts.Markers.Points.x, Config.Aircrafts.Markers.Points.y, Config.Aircrafts.Markers.Points.z, Config.Aircrafts.Markers.Points.r, Config.Aircrafts.Markers.Points.g, Config.Aircrafts.Markers.Points.b, 100, false, true, 2, false, nil, nil, false)
					end

					if distance < Config.Aircrafts.Markers.Points.x then
						isInMarker, this_Garage, currentZone = true, v, 'aircraft_garage_point'
					end
				end

				if distance2 < Config.Main.DrawDistance then
					letSleep = false

					if Config.Aircrafts.Markers.Delete.Type ~= -1 then
						DrawMarker(Config.Aircrafts.Markers.Delete.Type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Aircrafts.Markers.Delete.x, Config.Aircrafts.Markers.Delete.y, Config.Aircrafts.Markers.Delete.z, Config.Aircrafts.Markers.Delete.r, Config.Aircrafts.Markers.Delete.g, Config.Aircrafts.Markers.Delete.b, 100, false, true, 2, false, nil, nil, false)
					end

					if IsPedSittingInAnyVehicle(PlayerPedId()) then
						if distance2 < Config.Aircrafts.Markers.Delete.x then
							isInMarker, this_Garage, currentZone = true, v, 'aircraft_store_point'
						end
					end
				end
			end

			for k,v in pairs(Config.Aircrafts.Pounds) do
				local distance = #(playerCoords - v.Marker)

				if distance < Config.Main.DrawDistance then
					letSleep = false

					if Config.Aircrafts.Markers.Pounds.Type ~= -1 then
						DrawMarker(Config.Aircrafts.Markers.Pounds.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Aircrafts.Markers.Pounds.x, Config.Aircrafts.Markers.Pounds.y, Config.Aircrafts.Markers.Pounds.z, Config.Aircrafts.Markers.Pounds.r, Config.Aircrafts.Markers.Pounds.g, Config.Aircrafts.Markers.Pounds.b, 100, false, true, 2, false, nil, nil, false)
					end

					if distance < Config.Aircrafts.Markers.Pounds.x then
						isInMarker, this_Garage, currentZone = true, v, 'aircraft_pound_point'
					end
				end
			end
		end

		if Config.Boats.UseG then
			for k,v in pairs(Config.Boats.Garages) do
				local distance = #(playerCoords - v.Marker)
				local distance2 = #(playerCoords - v.Deleter)

				if distance < Config.Main.DrawDistance then
					letSleep = false

					if Config.Boats.Markers.Points.Type ~= -1 then
						DrawMarker(Config.Boats.Markers.Points.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Boats.Markers.Points.x, Config.Boats.Markers.Points.y, Config.Boats.Markers.Points.z, Config.Boats.Markers.Points.r, Config.Boats.Markers.Points.g, Config.Boats.Markers.Points.b, 100, false, true, 2, false, nil, nil, false)
					end

					if distance < Config.Boats.Markers.Points.x then
						isInMarker, this_Garage, currentZone = true, v, 'boat_garage_point'
					end
				end

				if distance2 < Config.Main.DrawDistance then
					letSleep = false

					if Config.Boats.Markers.Delete.Type ~= -1 then
						DrawMarker(Config.Boats.Markers.Delete.Type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Boats.Markers.Delete.x, Config.Boats.Markers.Delete.y, Config.Boats.Markers.Delete.z, Config.Boats.Markers.Delete.r, Config.Boats.Markers.Delete.g, Config.Boats.Markers.Delete.b, 100, false, true, 2, false, nil, nil, false)
					end

					if IsPedSittingInAnyVehicle(PlayerPedId()) then
						if distance2 < Config.Boats.Markers.Delete.x then
							isInMarker, this_Garage, currentZone = true, v, 'boat_store_point'
						end
					end
				end
			end

			for k,v in pairs(Config.Boats.Pounds) do
				local distance = #(playerCoords - v.Marker)

				if distance < Config.Main.DrawDistance then
					letSleep = false

					if Config.Boats.Markers.Pounds.Type ~= -1 then
						DrawMarker(Config.Boats.Markers.Pounds.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Boats.Markers.Pounds.x, Config.Boats.Markers.Pounds.y, Config.Boats.Markers.Pounds.z, Config.Boats.Markers.Pounds.r, Config.Boats.Markers.Pounds.g, Config.Boats.Markers.Pounds.b, 100, false, true, 2, false, nil, nil, false)
					end

					if distance < Config.Boats.Markers.Pounds.x then
						isInMarker, this_Garage, currentZone = true, v, 'boat_pound_point'
					end
				end
			end
		end

		if Config.Cars.UseG then
			for k,v in pairs(Config.Cars.Garages) do
				local distance = #(playerCoords - v.Marker)
				local distance2 = #(playerCoords - v.Deleter)

				if distance < Config.Main.DrawDistance then
					letSleep = false

					if Config.Cars.Markers.Points.Type ~= -1 then
						DrawMarker(Config.Cars.Markers.Points.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Cars.Markers.Points.x, Config.Cars.Markers.Points.y, Config.Cars.Markers.Points.z, Config.Cars.Markers.Points.r, Config.Cars.Markers.Points.g, Config.Cars.Markers.Points.b, 100, false, true, 2, false, nil, nil, false)
					end

					if distance < Config.Cars.Markers.Points.x then
						isInMarker, this_Garage, currentZone = true, v, 'car_garage_point'
					end
				end

				if distance2 < Config.Main.DrawDistance then
					letSleep = false

					if Config.Cars.Markers.Delete.Type ~= -1 then
						DrawMarker(Config.Cars.Markers.Delete.Type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Cars.Markers.Delete.x, Config.Cars.Markers.Delete.y, Config.Cars.Markers.Delete.z, Config.Cars.Markers.Delete.r, Config.Cars.Markers.Delete.g, Config.Cars.Markers.Delete.b, 100, false, true, 2, false, nil, nil, false)
					end

					if IsPedSittingInAnyVehicle(PlayerPedId()) then
						if distance2 < Config.Cars.Markers.Delete.x then
							isInMarker, this_Garage, currentZone = true, v, 'car_store_point'
						end
					end
				end
			end

			for k,v in pairs(Config.Cars.Pounds) do
				local distance = #(playerCoords - v.Marker)

				if distance < Config.Main.DrawDistance then
					letSleep = false

					if Config.Cars.Markers.Pounds.Type ~= -1 then
						DrawMarker(Config.Cars.Markers.Pounds.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Cars.Markers.Pounds.x, Config.Cars.Markers.Pounds.y, Config.Cars.Markers.Pounds.z, Config.Cars.Markers.Pounds.r, Config.Cars.Markers.Pounds.g, Config.Cars.Markers.Pounds.b, 100, false, true, 2, false, nil, nil, false)
					end

					if distance < Config.Cars.Markers.Pounds.x then
						isInMarker, this_Garage, currentZone = true, v, 'car_pound_point'
					end
				end
			end
		end

		if Config.Pvt.UseG then
			for k,v in pairs(Config.Pvt.Garages) do
				if not v.Private or has_value(userProperties, v.Private) then
					local distance = #(playerCoords - v.Marker)
					local distance2 = #(playerCoords - v.Deleter)

					if distance < Config.Main.DrawDistance then
						letSleep = false

						if Config.Pvt.Markers.Points.Type ~= -1 then
							DrawMarker(Config.Pvt.Markers.Points.Type, v.Marker, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Pvt.Markers.Points.x, Config.Pvt.Markers.Points.y, Config.Pvt.Markers.Points.z, Config.Pvt.Markers.Points.r, Config.Pvt.Markers.Points.g, Config.Pvt.Markers.Points.b, 100, false, true, 2, false, nil, nil, false)
						end

						if distance < Config.Pvt.Markers.Points.x then
							isInMarker, this_Garage, currentZone = true, v, 'car_garage_point'
						end
					end

					if distance2 < Config.Main.DrawDistance then
						letSleep = false

						if Config.Pvt.Markers.Delete.Type ~= -1 then
							DrawMarker(Config.Pvt.Markers.Delete.Type, v.Deleter, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Pvt.Markers.Delete.x, Config.Pvt.Markers.Delete.y, Config.Pvt.Markers.Delete.z, Config.Pvt.Markers.Delete.r, Config.Pvt.Markers.Delete.g, Config.Pvt.Markers.Delete.b, 100, false, true, 2, false, nil, nil, false)
						end

						if IsPedSittingInAnyVehicle(PlayerPedId()) then
							if distance2 < Config.Pvt.Markers.Delete.x then
								isInMarker, this_Garage, currentZone = true, v, 'car_store_point'
							end
						end
					end
				end
			end
		end

		if (isInMarker and not HasAlreadyEnteredMarker) or (isInMarker and LastZone ~= currentZone) then
			HasAlreadyEnteredMarker, LastZone = true, currentZone
			LastZone = currentZone
			TriggerEvent('esx_advancedgarage:hasEnteredMarker', currentZone)
		end

		if not isInMarker and HasAlreadyEnteredMarker then
			HasAlreadyEnteredMarker = false
			TriggerEvent('esx_advancedgarage:hasExitedMarker', LastZone)
		end

		if letSleep then
			Citizen.Wait(500)
		end
	end
end)

-- Key Controls
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = GetPlayerPed(-1)
		local playerVeh = GetVehiclePedIsIn(playerPed, false)
		local model = GetEntityModel(playerVeh)

		if CurrentAction then
			ESX.ShowHelpNotification(CurrentActionMsg)

			if IsControlJustReleased(0, 38) then
				if CurrentAction == 'ambulance_garage_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenGarageMenu('ambulance', 'none')
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_ambulance'))
					end
				elseif CurrentAction == 'ambulance_store_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
						if IsThisModelACar(model) or IsThisModelABicycle(model) or IsThisModelABike(model) or IsThisModelAHeli(model) then
							if (GetPedInVehicleSeat(playerVeh, -1) == playerPed) then
								OpenStoreMenu('ambulance', 'none')
							else
								ESX.ShowNotification(_U('driver_seat'))
							end
						else
							ESX.ShowNotification(_U('not_correct_veh'))
						end
					else
						ESX.ShowNotification(_U('must_ambulance'))
					end
				elseif CurrentAction == 'ambulance_pound_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenImpoundMenu('ambulance', 'none')
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_ambulance'))
					end
				elseif CurrentAction == 'police_garage_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenGarageMenu('police', 'none')
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_police'))
					end
				elseif CurrentAction == 'police_store_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
						if IsThisModelACar(model) or IsThisModelABicycle(model) or IsThisModelABike(model) or IsThisModelAHeli(model) then
							if (GetPedInVehicleSeat(playerVeh, -1) == playerPed) then
								OpenStoreMenu('police', 'none')
							else
								ESX.ShowNotification(_U('driver_seat'))
							end
						else
							ESX.ShowNotification(_U('not_correct_veh'))
						end
					else
						ESX.ShowNotification(_U('must_police'))
					end
				elseif CurrentAction == 'police_pound_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenImpoundMenu('police', 'none')
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_police'))
					end
				elseif CurrentAction == 'mechanic_garage_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenGarageMenu('mechanic', 'none')
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_mechanic'))
					end
				elseif CurrentAction == 'mechanic_store_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
						if IsThisModelACar(model) or IsThisModelABicycle(model) or IsThisModelABike(model) or IsThisModelAHeli(model) then
							if (GetPedInVehicleSeat(playerVeh, -1) == playerPed) then
								OpenStoreMenu('mechanic', 'none')
							else
								ESX.ShowNotification(_U('driver_seat'))
							end
						else
							ESX.ShowNotification(_U('not_correct_veh'))
						end
					else
						ESX.ShowNotification(_U('must_mechanic'))
					end
				elseif CurrentAction == 'mechanic_pound_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenImpoundMenu('mechanic', 'none')
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_mechanic'))
					end
				elseif CurrentAction == 'taxi_garage_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenGarageMenu('taxi', 'none')
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_taxi'))
					end
				elseif CurrentAction == 'taxi_store_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
						if IsThisModelACar(model) or IsThisModelABicycle(model) or IsThisModelABike(model) or IsThisModelAHeli(model) then
							if (GetPedInVehicleSeat(playerVeh, -1) == playerPed) then
								OpenStoreMenu('taxi', 'none')
							else
								ESX.ShowNotification(_U('driver_seat'))
							end
						else
							ESX.ShowNotification(_U('not_correct_veh'))
						end
					else
						ESX.ShowNotification(_U('must_taxi'))
					end
				elseif CurrentAction == 'taxi_pound_point' then
					if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
						if not IsPedSittingInAnyVehicle(PlayerPedId()) then
							OpenImpoundMenu('taxi', 'none')
						else
							ESX.ShowNotification(_U('cant_in_veh'))
						end
					else
						ESX.ShowNotification(_U('must_taxi'))
					end
				elseif CurrentAction == 'aircraft_garage_point' then
					if not IsPedSittingInAnyVehicle(PlayerPedId()) then
						OpenGarageMenu('civ', 'aircrafts')
					else
						ESX.ShowNotification(_U('cant_in_veh'))
					end
				elseif CurrentAction == 'aircraft_store_point' then
					if IsThisModelAHeli(model) or IsThisModelAPlane(model) then
						if (GetPedInVehicleSeat(playerVeh, -1) == playerPed) then
							OpenStoreMenu('civ', 'aircrafts')
						else
							ESX.ShowNotification(_U('driver_seat'))
						end
					else
						ESX.ShowNotification(_U('not_correct_veh'))
					end
				elseif CurrentAction == 'aircraft_pound_point' then
					if not IsPedSittingInAnyVehicle(PlayerPedId()) then
						OpenImpoundMenu('civ', 'aircrafts')
					else
						ESX.ShowNotification(_U('cant_in_veh'))
					end
				elseif CurrentAction == 'boat_garage_point' then
					if not IsPedSittingInAnyVehicle(PlayerPedId()) then
						OpenGarageMenu('civ', 'boats')
					else
						ESX.ShowNotification(_U('cant_in_veh'))
					end
				elseif CurrentAction == 'boat_store_point' then
					if (GetPedInVehicleSeat(playerVeh, -1) == playerPed) then
						OpenStoreMenu('civ', 'boats')
					else
						ESX.ShowNotification(_U('driver_seat'))
					end
				elseif CurrentAction == 'boat_pound_point' then
					if not IsPedSittingInAnyVehicle(PlayerPedId()) then
						OpenImpoundMenu('civ', 'boats')
					else
						ESX.ShowNotification(_U('cant_in_veh'))
					end
				elseif CurrentAction == 'car_garage_point' then
					if not IsPedSittingInAnyVehicle(PlayerPedId()) then
						OpenGarageMenu('civ', 'cars')
					else
						ESX.ShowNotification(_U('cant_in_veh'))
					end
				elseif CurrentAction == 'car_store_point' then
					if IsThisModelACar(model) or IsThisModelABicycle(model) or IsThisModelABike(model) or IsThisModelAQuadbike(model) then
						if (GetPedInVehicleSeat(playerVeh, -1) == playerPed) then
							OpenStoreMenu('civ', 'cars')
						else
							ESX.ShowNotification(_U('driver_seat'))
						end
					else
						ESX.ShowNotification(_U('not_correct_veh'))
					end
				elseif CurrentAction == 'car_pound_point' then
					if not IsPedSittingInAnyVehicle(PlayerPedId()) then
						OpenImpoundMenu('civ', 'cars')
					else
						ESX.ShowNotification(_U('cant_in_veh'))
					end
				end

				CurrentAction = nil
			end
		else
			Citizen.Wait(500)
		end
	end
end)

-- Create Blips
function CreateBlips()
	if Config.Aircrafts.UseG and Config.Aircrafts.Blips then
		for k,v in pairs(Config.Aircrafts.Garages) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite(blip, Config.Blips.Garages.Sprite)
			SetBlipColour(blip, Config.Blips.Garages.Color)
			SetBlipDisplay(blip, Config.Blips.Garages.Display)
			SetBlipScale(blip, Config.Blips.Garages.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(_U('blip_garage'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end

		for k,v in pairs(Config.Aircrafts.Pounds) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite(blip, Config.Blips.Pounds.Sprite)
			SetBlipColour(blip, Config.Blips.Pounds.Color)
			SetBlipDisplay(blip, Config.Blips.Pounds.Display)
			SetBlipScale(blip, Config.Blips.Pounds.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(_U('blip_pound'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end
	end

	if Config.Boats.UseG and Config.Boats.Blips then
		for k,v in pairs(Config.Boats.Garages) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite(blip, Config.Blips.Garages.Sprite)
			SetBlipColour(blip, Config.Blips.Garages.Color)
			SetBlipDisplay(blip, Config.Blips.Garages.Display)
			SetBlipScale(blip, Config.Blips.Garages.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(_U('blip_garage'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end

		for k,v in pairs(Config.Boats.Pounds) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite(blip, Config.Blips.Pounds.Sprite)
			SetBlipColour(blip, Config.Blips.Pounds.Color)
			SetBlipDisplay(blip, Config.Blips.Pounds.Display)
			SetBlipScale(blip, Config.Blips.Pounds.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(_U('blip_pound'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end
	end

	if Config.Cars.UseG and Config.Cars.Blips then
		for k,v in pairs(Config.Cars.Garages) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite(blip, Config.Blips.Garages.Sprite)
			SetBlipColour(blip, Config.Blips.Garages.Color)
			SetBlipDisplay(blip, Config.Blips.Garages.Display)
			SetBlipScale(blip, Config.Blips.Garages.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(_U('blip_garage'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end

		for k,v in pairs(Config.Cars.Pounds) do
			local blip = AddBlipForCoord(v.Marker)

			SetBlipSprite(blip, Config.Blips.Pounds.Sprite)
			SetBlipColour(blip, Config.Blips.Pounds.Color)
			SetBlipDisplay(blip, Config.Blips.Pounds.Display)
			SetBlipScale(blip, Config.Blips.Pounds.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(_U('blip_pound'))
			EndTextCommandSetBlipName(blip)
			table.insert(BlipList, blip)
		end
	end
end

-- Handles Private Blips
function DeletePrivateBlips()
	if PrivateBlips[1] ~= nil then
		for i=1, #PrivateBlips, 1 do
			RemoveBlip(PrivateBlips[i])
			PrivateBlips[i] = nil
		end
	end
end

function RefreshPrivateBlips()
	for zoneKey,zoneValues in pairs(Config.Pvt.Garages) do
		if zoneValues.Private and has_value(userProperties, zoneValues.Private) then
			local blip = AddBlipForCoord(zoneValues.Marker)

			SetBlipSprite(blip, Config.Blips.PGarages.Sprite)
			SetBlipColour(blip, Config.Blips.PGarages.Color)
			SetBlipDisplay(blip, Config.Blips.PGarages.Display)
			SetBlipScale(blip, Config.Blips.PGarages.Scale)
			SetBlipAsShortRange(blip, true)

			BeginTextCommandSetBlipName('STRING')
			AddTextComponentString(_U('blip_garage_private'))
			EndTextCommandSetBlipName(blip)
			table.insert(PrivateBlips, blip)
		end
	end
end

-- Handles Job Blips
function DeleteJobBlips()
	if JobBlips[1] ~= nil then
		for i=1, #JobBlips, 1 do
			RemoveBlip(JobBlips[i])
			JobBlips[i] = nil
		end
	end
end

function RefreshJobBlips()
	if Config.Ambulance.UseG and Config.Ambulance.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
			for k,v in pairs(Config.Ambulance.Garages) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite(blip, Config.Blips.JGarages.Sprite)
				SetBlipColour(blip, Config.Blips.JGarages.Color)
				SetBlipDisplay(blip, Config.Blips.JGarages.Display)
				SetBlipScale(blip, Config.Blips.JGarages.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString(_U('blip_ambulance_garage'))
				EndTextCommandSetBlipName(blip)
				table.insert(JobBlips, blip)
			end
		end
	end

	if Config.Ambulance.UseP and Config.Ambulance.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'ambulance' then
			for k,v in pairs(Config.Ambulance.Pounds) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite(blip, Config.Blips.JPounds.Sprite)
				SetBlipColour(blip, Config.Blips.JPounds.Color)
				SetBlipDisplay(blip, Config.Blips.JPounds.Display)
				SetBlipScale(blip, Config.Blips.JPounds.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString(_U('blip_ambulance_impound'))
				EndTextCommandSetBlipName(blip)
				table.insert(JobBlips, blip)
			end
		end
	end

	if Config.Police.UseG and Config.Police.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
			for k,v in pairs(Config.Police.Garages) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite(blip, Config.Blips.JGarages.Sprite)
				SetBlipColour(blip, Config.Blips.JGarages.Color)
				SetBlipDisplay(blip, Config.Blips.JGarages.Display)
				SetBlipScale(blip, Config.Blips.JGarages.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString(_U('blip_police_garage'))
				EndTextCommandSetBlipName(blip)
				table.insert(JobBlips, blip)
			end
		end
	end

	if Config.Police.UseP and Config.Police.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'police' then
			for k,v in pairs(Config.Police.Pounds) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite(blip, Config.Blips.JPounds.Sprite)
				SetBlipColour(blip, Config.Blips.JPounds.Color)
				SetBlipDisplay(blip, Config.Blips.JPounds.Display)
				SetBlipScale(blip, Config.Blips.JPounds.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString(_U('blip_police_impound'))
				EndTextCommandSetBlipName(blip)
				table.insert(JobBlips, blip)
			end
		end
	end

	if Config.Mechanic.UseG and Config.Mechanic.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			for k,v in pairs(Config.Mechanic.Garages) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite(blip, Config.Blips.JGarages.Sprite)
				SetBlipColour(blip, Config.Blips.JGarages.Color)
				SetBlipDisplay(blip, Config.Blips.JGarages.Display)
				SetBlipScale(blip, Config.Blips.JGarages.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString(_U('blip_mechanic_garage'))
				EndTextCommandSetBlipName(blip)
				table.insert(JobBlips, blip)
			end
		end
	end

	if Config.Mechanic.UseP and Config.Mechanic.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'mechanic' then
			for k,v in pairs(Config.Mechanic.Pounds) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite(blip, Config.Blips.JPounds.Sprite)
				SetBlipColour(blip, Config.Blips.JPounds.Color)
				SetBlipDisplay(blip, Config.Blips.JPounds.Display)
				SetBlipScale(blip, Config.Blips.JPounds.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString(_U('blip_mechanic_impound'))
				EndTextCommandSetBlipName(blip)
				table.insert(JobBlips, blip)
			end
		end
	end

	if Config.Taxi.UseG and Config.Taxi.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
			for k,v in pairs(Config.Taxi.Garages) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite(blip, Config.Blips.JGarages.Sprite)
				SetBlipColour(blip, Config.Blips.JGarages.Color)
				SetBlipDisplay(blip, Config.Blips.JGarages.Display)
				SetBlipScale(blip, Config.Blips.JGarages.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString(_U('blip_taxi_garage'))
				EndTextCommandSetBlipName(blip)
				table.insert(JobBlips, blip)
			end
		end
	end

	if Config.Taxi.UseP and Config.Taxi.Blips then
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'taxi' then
			for k,v in pairs(Config.Taxi.Pounds) do
				local blip = AddBlipForCoord(v.Marker)

				SetBlipSprite(blip, Config.Blips.JPounds.Sprite)
				SetBlipColour(blip, Config.Blips.JPounds.Color)
				SetBlipDisplay(blip, Config.Blips.JPounds.Display)
				SetBlipScale(blip, Config.Blips.JPounds.Scale)
				SetBlipAsShortRange(blip, true)

				BeginTextCommandSetBlipName('STRING')
				AddTextComponentString(_U('blip_taxi_impound'))
				EndTextCommandSetBlipName(blip)
				table.insert(JobBlips, blip)
			end
		end
	end
end
