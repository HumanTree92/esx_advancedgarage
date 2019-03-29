ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Make sure all Vehicles are Stored on restart
MySQL.ready(function()
	ParkVehicles()
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

-- Get Owned Properties
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedProperties', function(source, cb)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local properties = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_properties WHERE owner = @owner', {
		['@owner'] = xPlayer.getIdentifier()
	}, function(data)
		for _,v in pairs(data) do
			table.insert(properties, v.name)
		end
		cb(properties)
	end)
end)

-- Fetch Owned Aircrafts
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}

	if Config.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', {
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'aircraft',
			['@job']    = '',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedAircrafts)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', {
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'aircraft',
			['@job']    = ''
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedAircrafts, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedAircrafts)
		end)
	end
end)

-- Fetch Owned Boats
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedBoats', function(source, cb)
	local ownedBoats = {}

	if Config.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', {
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'boat',
			['@job']    = '',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedBoats, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedBoats)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', {
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'boat',
			['@job']    = ''
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedBoats, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedBoats)
		end)
	end
end)

-- Fetch Owned Cars
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedCars', function(source, cb)
	local ownedCars = {}
	
	if Config.DontShowPoundCarsInGarage == true then
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', {
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'car',
			['@job']    = '',
			['@stored'] = true
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
	else
		MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job', {
			['@owner']  = GetPlayerIdentifiers(source)[1],
			['@Type']   = 'car',
			['@job']    = ''
		}, function(data)
			for _,v in pairs(data) do
				local vehicle = json.decode(v.vehicle)
				table.insert(ownedCars, {vehicle = vehicle, stored = v.stored, plate = v.plate})
			end
			cb(ownedCars)
		end)
	end
end)

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
					['@owner']  = GetPlayerIdentifiers(source)[1],
					['@vehicle'] = json.encode(vehicleProps),
					['@plate']  = vehicleProps.plate
				}, function (rowsChanged)
					if rowsChanged == 0 then
						print(('esx_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(GetPlayerIdentifiers(source)[1]))
					end
					cb(true)
				end)
			else
				if Config.KickPossibleCheaters == true then
					if Config.UseCustomKickMessage == true then
						print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: '..vehiclemodel..'. Original Vehicle: '..originalvehprops.model):format(GetPlayerIdentifiers(source)[1]))
						DropPlayer(source, _U('custom_kick'))
						cb(false)
					else
						print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: '..vehiclemodel..'. Original Vehicle: '..originalvehprops.model):format(GetPlayerIdentifiers(source)[1]))
						DropPlayer(source, 'You have been Kicked from the Server for Possible Garage Cheating!!!')
						cb(false)
					end
				else
					print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: '..vehiclemodel..'. Original Vehicle: '..originalvehprops.model):format(GetPlayerIdentifiers(source)[1]))
					cb(false)
				end
			end
		else
			print(('esx_advancedgarage: %s attempted to store an vehicle they don\'t own!'):format(GetPlayerIdentifiers(source)[1]))
			cb(false)
		end
	end)
end)

-- Fetch Pounded Aircrafts
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedAircrafts', function(source, cb)
	local ownedAircrafts = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@Type']   = 'aircraft',
		['@job']    = '',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAircrafts, vehicle)
		end
		cb(ownedAircrafts)
	end)
end)

-- Fetch Pounded Boats
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedBoats', function(source, cb)
	local ownedBoats = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@Type']   = 'boat',
		['@job']    = '',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedBoats, vehicle)
		end
		cb(ownedBoats)
	end)
end)

-- Fetch Pounded Cars
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedCars', function(source, cb)
	local ownedCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@Type']   = 'car',
		['@job']    = '',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedCars, vehicle)
		end
		cb(ownedCars)
	end)
end)

-- Fetch Pounded Policing Vehicles
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedPolicingCars', function(source, cb)
	local ownedPolicingCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@job']    = 'police',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedPolicingCars, vehicle)
		end
		cb(ownedPolicingCars)
	end)
end)

-- Fetch Pounded Ambulance Vehicles
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedAmbulanceCars', function(source, cb)
	local ownedAmbulanceCars = {}

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
		['@owner'] = GetPlayerIdentifiers(source)[1],
		['@job']    = 'ambulance',
		['@stored'] = false
	}, function(data) 
		for _,v in pairs(data) do
			local vehicle = json.decode(v.vehicle)
			table.insert(ownedAmbulanceCars, vehicle)
		end
		cb(ownedAmbulanceCars)
	end)
end)

-- Check Money for Pounded Aircrafts
ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyAircrafts', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.AircraftPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Boats
ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyBoats', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.BoatPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Cars
ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyCars', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.CarPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Policing
ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyPolicing', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.PolicingPoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Check Money for Pounded Ambulance
ESX.RegisterServerCallback('esx_advancedgarage:checkMoneyAmbulance', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.get('money') >= Config.AmbulancePoundPrice then
		cb(true)
	else
		cb(false)
	end
end)

-- Pay for Pounded Aircrafts
RegisterServerEvent('esx_advancedgarage:payAircraft')
AddEventHandler('esx_advancedgarage:payAircraft', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.AircraftPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.AircraftPoundPrice)
end)

-- Pay for Pounded Boats
RegisterServerEvent('esx_advancedgarage:payBoat')
AddEventHandler('esx_advancedgarage:payBoat', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.BoatPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.BoatPoundPrice)
end)

-- Pay for Pounded Cars
RegisterServerEvent('esx_advancedgarage:payCar')
AddEventHandler('esx_advancedgarage:payCar', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.CarPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.CarPoundPrice)
end)

-- Pay for Pounded Policing
RegisterServerEvent('esx_advancedgarage:payPolicing')
AddEventHandler('esx_advancedgarage:payPolicing', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.PolicingPoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.PolicingPoundPrice)
end)

-- Pay for Pounded Ambulance
RegisterServerEvent('esx_advancedgarage:payAmbulance')
AddEventHandler('esx_advancedgarage:payAmbulance', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(Config.AmbulancePoundPrice)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.AmbulancePoundPrice)
end)

-- Pay to Return Broken Vehicles
RegisterServerEvent('esx_advancedgarage:payhealth')
AddEventHandler('esx_advancedgarage:payhealth', function(price)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeMoney(price)
	TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. price)
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
