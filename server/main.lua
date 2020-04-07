ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Make sure all Vehicles are Stored on restart
MySQL.ready(function()
	if Config.ParkVehicles then
		ParkVehicles()
	else
		print('esx_advancedgarage: Parking Vehicles on restart is currently set to false.')
	end
end)

function ParkVehicles()
	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE `stored` = @stored', {
		['@stored'] = false
	}, function(rowsChanged)
		if rowsChanged > 0 then
			print(('esx_advancedgarage: %s vehicle(s) have been stored!'):format(rowsChanged))
		end
	end)
end

-- Add Command for Getting Properties
if Config.UseCommand then
	ESX.RegisterCommand('getgarages', 'user', function(xPlayer, args, showError)
		xPlayer.triggerEvent('esx_advancedgarage:getPropertiesC')
	end, true, {help = 'Get Private Garages', validate = false})
end

-- Add Print Command for Getting Properties
RegisterServerEvent('esx_advancedgarage:printGetProperties')
AddEventHandler('esx_advancedgarage:printGetProperties', function()
	print('Getting Properties')
end)

-- Get Owned Properties
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedProperties', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local properties = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE owner = @owner', {
		['@owner'] = xPlayer.identifier
	}, function(data)
		for _,v in pairs(data) do
			table.insert(properties, v.name)
		end
		cb(properties)
	end)
end)

-- Start of Ambulance Code
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedAmbulanceCars', function(source, cb)
	local ownedAmbulanceCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.ShowVehicleLocation then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'car',
			['@job'] = 'ambulance'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAmbulanceCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedAmbulanceCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'car',
			['@job'] = 'ambulance',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAmbulanceCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedAmbulanceCars)
		end)
	end
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOwnedAmbulanceAircrafts', function(source, cb)
	local ownedAmbulanceAircrafts = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.UsingAdvancedVehicleShop then
		if Config.ShowVehicleLocation then
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'aircraft',
				['@job'] = 'ambulance'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedAmbulanceAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'aircraft'})
				end
				cb(ownedAmbulanceAircrafts)
			end)
		else
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'aircraft',
				['@job'] = 'ambulance',
				['@stored'] = true
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedAmbulanceAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'aircraft'})
				end
				cb(ownedAmbulanceAircrafts)
			end)
		end
	else
		if Config.ShowVehicleLocation then
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'helicopter',
				['@job'] = 'ambulance'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedAmbulanceAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'helicopter'})
				end
				cb(ownedAmbulanceAircrafts)
			end)
		else
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'helicopter',
				['@job'] = 'ambulance',
				['@stored'] = true
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedAmbulanceAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'helicopter'})
				end
				cb(ownedAmbulanceAircrafts)
			end)
		end
	end
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedAmbulanceCars', function(source, cb)
	local ownedAmbulanceCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = xPlayer.identifier,
		['@job'] = 'ambulance',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAmbulanceCars, vehicle)
		end
		cb(ownedAmbulanceCars)
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyAmbulance', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.AmbulancePoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_advancedgarage:payAmbulance')
AddEventHandler('esx_advancedgarage:payAmbulance', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.AmbulancePoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.AmbulancePoundPrice)

	if Config.GiveSocietyMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(Config.AmbulancePoundPrice)
		end)
	end
end)
-- End of Ambulance Code

-- Start of Police Code
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedPoliceCars', function(source, cb)
	local ownedPoliceCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.ShowVehicleLocation then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'car',
			['@job'] = 'police'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedPoliceCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedPoliceCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'car',
			['@job'] = 'police',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedPoliceCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedPoliceCars)
		end)
	end
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOwnedPoliceAircrafts', function(source, cb)
	local ownedPoliceAircrafts = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.UsingAdvancedVehicleShop then
		if Config.ShowVehicleLocation then
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'aircraft',
				['@job'] = 'police'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedPoliceAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'aircraft'})
				end
				cb(ownedPoliceAircrafts)
			end)
		else
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'aircraft',
				['@job'] = 'police',
				['@stored'] = true
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedPoliceAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'aircraft'})
				end
				cb(ownedPoliceAircrafts)
			end)
		end
	else
		if Config.ShowVehicleLocation then
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'helicopter',
				['@job'] = 'police'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedPoliceAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'helicopter'})
				end
				cb(ownedPoliceAircrafts)
			end)
		else
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'helicopter',
				['@job'] = 'police',
				['@stored'] = true
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedPoliceAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate, vtype = 'helicopter'})
				end
				cb(ownedPoliceAircrafts)
			end)
		end
	end
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedPoliceCars', function(source, cb)
	local ownedPoliceCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = xPlayer.identifier,
		['@job'] = 'police',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedPoliceCars, vehicle)
		end
		cb(ownedPoliceCars)
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyPolice', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.PolicePoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_advancedgarage:payPolice')
AddEventHandler('esx_advancedgarage:payPolice', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.PolicePoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.PolicePoundPrice)

	if Config.GiveSocietyMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(Config.PolicePoundPrice)
		end)
	end
end)
-- End of Police Code

-- Start of Aircraft Code
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.ShowVehicleLocation then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'aircraft',
			['@job'] = 'civ'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedAircrafts)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'aircraft',
			['@job'] = 'civ',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedAircrafts)
		end)
	end
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
		['@owner'] = xPlayer.identifier,
		['@Type'] = 'aircraft',
		['@job'] = 'civ',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAircrafts, vehicle)
		end
		cb(ownedAircrafts)
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyAircrafts', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.AircraftPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_advancedgarage:payAircraft')
AddEventHandler('esx_advancedgarage:payAircraft', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.AircraftPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.AircraftPoundPrice)

	if Config.GiveSocietyMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(Config.AircraftPoundPrice)
		end)
	end
end)
-- End of Aircraft Code

-- Start of Boat Code
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedBoats', function(source, cb)
	local ownedBoats = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.ShowVehicleLocation then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'boat',
			['@job'] = 'civ'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedBoats, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedBoats)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'boat',
			['@job'] = 'civ',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedBoats, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedBoats)
		end)
	end
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedBoats', function(source, cb)
	local ownedBoats = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
		['@owner'] = xPlayer.identifier,
		['@Type'] = 'boat',
		['@job'] = 'civ',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedBoats, vehicle)
		end
		cb(ownedBoats)
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyBoats', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.BoatPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_advancedgarage:payBoat')
AddEventHandler('esx_advancedgarage:payBoat', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.BoatPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.BoatPoundPrice)

	if Config.GiveSocietyMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(Config.BoatPoundPrice)
		end)
	end
end)
-- End of Boat Code

-- Start of Car Code
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedCars', function(source, cb)
	local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	if Config.ShowVehicleLocation then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'car',
			['@job'] = 'civ'
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
			['@owner'] = xPlayer.identifier,
			['@Type'] = 'car',
			['@job'] = 'civ',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
	end
end)

ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedCars', function(source, cb)
	local ownedCars = {}
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
		['@owner'] = xPlayer.identifier,
		['@Type'] = 'car',
		['@job'] = 'civ',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, vehicle)
		end
		cb(ownedCars)
	end)
end)

ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyCars', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.getMoney() >= Config.CarPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

RegisterServerEvent('esx_advancedgarage:payCar')
AddEventHandler('esx_advancedgarage:payCar', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.CarPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.CarPoundPrice)

	if Config.GiveSocietyMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(Config.CarPoundPrice)
		end)
	end
end)
-- End of Car Code

-- Store Vehicles
ESX.RegisterServerCallback('esx_advancedgarage:storeVehicle', function (source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND @plate = plate', {
		['@owner'] = xPlayer.identifier,
		['@plate'] = vehicleProps.plate
	}, function (result)
		if result[1] ~= nil then
			local originalvehprops = json.decode(result[1].vehicle)
			if originalvehprops.model == vehiclemodel then
				MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE owner = @owner AND plate = @plate', {
					['@owner'] = xPlayer.identifier,
					['@vehicle'] = json.encode(vehicleProps),
					['@plate'] = vehicleProps.plate
				}, function (rowsChanged)
					if rowsChanged == 0 then
						print(('esx_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(xPlayer.identifier))
					end
					cb(true)
				end)
			else
				if Config.KickPossibleCheaters == true then
					if Config.UseCustomKickMessage == true then
						print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: ' .. originalvehprops.model):format(xPlayer.identifier))

						DropPlayer(source, _U('custom_kick'))
						cb(false)
					else
						print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: ' .. originalvehprops.model):format(xPlayer.identifier))

						DropPlayer(source, 'You have been Kicked from the Server for Possible Garage Cheating!!!')
						cb(false)
					end
				else
					print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: ' .. vehiclemodel .. '. Original Vehicle: '.. originalvehprops.model):format(xPlayer.identifier))
					cb(false)
				end
			end
		else
			print(('esx_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(xPlayer.identifier))
			cb(false)
		end
	end)
end)

-- Pay to Return Broken Vehicles
RegisterServerEvent('esx_advancedgarage:payhealth')
AddEventHandler('esx_advancedgarage:payhealth', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(price)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. price)

	if Config.GiveSocietyMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(price)
		end)
	end
end)

-- Modify State of Vehicles
RegisterServerEvent('esx_advancedgarage:setVehicleState')
AddEventHandler('esx_advancedgarage:setVehicleState', function(plate, state)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = @stored WHERE plate = @plate', {
		['@stored'] = state,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)
