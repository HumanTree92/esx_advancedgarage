ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Make sure all Vehicles are Stored on restart
MySQL.ready(function()
	if Config.Main.ParkVehicles then
		--ParkVehicles()
		MySQL.Async.execute('UPDATE owned_vehicles SET `stored` = true WHERE `stored` = @stored', {
			['@stored'] = false
		}, function(rowsChanged)
			if rowsChanged > 0 then
				print(('esx_advancedgarage: %s vehicle(s) have been stored!'):format(rowsChanged))
			end
		end)
	else
		print('esx_advancedgarage: Parking Vehicles on restart is currently set to false.')
	end
end)

-- Add Command for Getting Properties
if Config.Main.Commands then
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

-- Start of Garage Fetch Vehicles
ESX.RegisterServerCallback('esx_advancedgarage:getOwnedVehicles', function(source, cb, job, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if job == 'ambulance' then
		if type == 'cars' then
			local ownedAmbulanceCars = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'ambulance',
				['@category'] = 'cars'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedAmbulanceCars, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedAmbulanceCars)
			end)
		elseif type == 'helis' then
			local ownedAmbulanceHelis = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'aircraft',
				['@job'] = 'ambulance',
				['@category'] = 'helis'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedAmbulanceHelis, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedAmbulanceHelis)
			end)
		end
	elseif job == 'police' then
		if type == 'cars' then
			local ownedPoliceCars = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'police',
				['@category'] = 'cars'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedPoliceCars, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedPoliceCars)
			end)
		elseif type == 'helis' then
			local ownedPoliceHelis = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'aircraft',
				['@job'] = 'police',
				['@category'] = 'helis'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedPoliceHelis, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedPoliceHelis)
			end)
		end
	elseif job == 'mechanic' then
		if type == 'cars' then
			local ownedMechanicCars = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'mechanic',
				['@category'] = 'cars'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedMechanicCars, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedMechanicCars)
			end)
		end
	elseif job == 'civ' then
		if type == 'helis' then
			local ownedHelis = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'aircraft',
				['@job'] = 'civ',
				['@category'] = 'helis'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedHelis, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedHelis)
			end)
		elseif type == 'planes' then
			local ownedPlanes = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'aircraft',
				['@job'] = 'civ',
				['@category'] = 'planes'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedPlanes, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedPlanes)
			end)
		elseif type == 'boats' then
			local ownedBoats = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'boat',
				['@job'] = 'civ',
				['@category'] = 'boats'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedBoats, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedBoats)
			end)
		elseif type == 'subs' then
			local ownedSubs = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'boat',
				['@job'] = 'civ',
				['@category'] = 'subs'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedSubs, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedSubs)
			end)
		elseif type == 'box' then
			local ownedBox = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'box'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedBox, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedBox)
			end)
		elseif type == 'haul' then
			local ownedHaul = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'haul'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedHaul, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedHaul)
			end)
		elseif type == 'other' then
			local ownedOther = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'other'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedOther, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedOther)
			end)
		elseif type == 'trans' then
			local ownedTrans = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'trans'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedTrans, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedTrans)
			end)
		elseif type == 'cycles' then
			local ownedCycles = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'cycles'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedCycles, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedCycles)
			end)
		elseif type == 'compacts' then
			local ownedCompacts = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'compacts'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedCompacts, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedCompacts)
			end)
		elseif type == 'coupes' then
			local ownedCoupes = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'coupes'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedCoupes, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedCoupes)
			end)
		elseif type == 'motorcycles' then
			local ownedMotorcycles = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'motorcycles'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedMotorcycles, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedMotorcycles)
			end)
		elseif type == 'muscles' then
			local ownedMuscles = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'muscles'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedMuscles, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedMuscles)
			end)
		elseif type == 'offroads' then
			local ownedOffRoads = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'offroads'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedOffRoads, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedOffRoads)
			end)
		elseif type == 'sedans' then
			local ownedSedans = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'sedans'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedSedans, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedSedans)
			end)
		elseif type == 'sports' then
			local ownedSports = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'sports'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedSports, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedSports)
			end)
		elseif type == 'sportsclassics' then
			local ownedSportsClassics = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'sportsclassics'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedSportsClassics, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedSportsClassics)
			end)
		elseif type == 'supers' then
			local ownedSupers = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'supers'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedSupers, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedSupers)
			end)
		elseif type == 'suvs' then
			local ownedSUVs = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'suvs'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedSUVs, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedSUVs)
			end)
		elseif type == 'vans' then
			local ownedVans = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND category = @category', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@category'] = 'vans'
			}, function(data)
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(ownedVans, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel, stored = v.stored})
				end
				cb(ownedVans)
			end)
		end
	end
end)
-- End of Garage Fetch Vehicles

-- Start of Impound Fetch Vehicles
ESX.RegisterServerCallback('esx_advancedgarage:getOutOwnedVehicles', function(source, cb, job, type)
	local xPlayer = ESX.GetPlayerFromId(source)

	if job == 'ambulance' then
		if type == 'cars' then
			local outAmbulanceCars = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'ambulance',
				['@stored'] = false
			}, function(data) 
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(outAmbulanceCars, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel})
				end
				cb(outAmbulanceCars)
			end)
		elseif type == 'helis' then
			local outAmbulanceHelis = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'aircraft',
				['@job'] = 'ambulance',
				['@stored'] = false
			}, function(data) 
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(outAmbulanceHelis, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel})
				end
				cb(outAmbulanceHelis)
			end)
		end
	elseif job == 'police' then
		if type == 'cars' then
			local outPoliceCars = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'police',
				['@stored'] = false
			}, function(data) 
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(outPoliceCars, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel})
				end
				cb(outPoliceCars)
			end)
		elseif type == 'helis' then
			local outPoliceHelis = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', {
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'aircraft',
				['@job'] = 'police',
				['@stored'] = false
			}, function(data) 
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(outPoliceHelis, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel})
				end
				cb(outPoliceHelis)
			end)
		end
	elseif job == 'mechanic' then
		if type == 'cars' then
			local outMechanicCars = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND job = @job AND `stored` = @stored', {
				['@owner'] = xPlayer.identifier,
				['@job'] = 'mechanic',
				['@stored'] = false
			}, function(data) 
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(outMechanicCars, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel})
				end
				cb(outMechanicCars)
			end)
		end
	elseif job == 'civ' then
		if type == 'aircrafts' then
			local outCivAircrafts = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'aircraft',
				['@job'] = 'civ',
				['@stored'] = false
			}, function(data) 
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(outCivAircrafts, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel})
				end
				cb(outCivAircrafts)
			end)
		elseif type == 'boats' then
			local outCivBoats = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'boat',
				['@job'] = 'civ',
				['@stored'] = false
			}, function(data) 
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(outCivBoats, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel})
				end
				cb(outCivBoats)
			end)
		elseif type == 'cars' then
			local outCivCars = {}
			MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND Type = @Type AND job = @job AND `stored` = @stored', { -- job = NULL
				['@owner'] = xPlayer.identifier,
				['@Type'] = 'car',
				['@job'] = 'civ',
				['@stored'] = false
			}, function(data) 
				for _,v in pairs(data) do
					local vehicle = json.decode(v.vehicle)
					table.insert(outCivCars, {vehicle = vehicle, plate = v.plate, vehName = v.name, fuel = v.fuel})
				end
				cb(outCivCars)
			end)
		end
	end
end)
-- End of Impound Fetch Vehicles

-- Start of Impound Pay
ESX.RegisterServerCallback('esx_advancedgarage:payImpound', function(source, cb, job, type, attempt)
	local xPlayer = ESX.GetPlayerFromId(source)

	if job == 'ambulance' then
		if type == 'both' then
			if attempt == 'check' then
				if xPlayer.getMoney() >= Config.Ambulance.PoundP then
					cb(true)
				else
					cb(false)
				end
			else
				xPlayer.removeMoney(Config.Ambulance.PoundP)
				TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.Ambulance.PoundP)
				if Config.Main.GiveSocMoney then
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
						account.addMoney(Config.Ambulance.PoundP)
					end)
				end
				cb()
			end
		end
	elseif job == 'police' then
		if type == 'both' then
			if attempt == 'check' then
				if xPlayer.getMoney() >= Config.Police.PoundP then
					cb(true)
				else
					cb(false)
				end
			else
				xPlayer.removeMoney(Config.Police.PoundP)
				TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.Police.PoundP)
				if Config.Main.GiveSocMoney then
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
						account.addMoney(Config.Police.PoundP)
					end)
				end
				cb()
			end
		end
	elseif job == 'mechanic' then
		if type == 'both' then
			if attempt == 'check' then
				if xPlayer.getMoney() >= Config.Mechanic.PoundP then
					cb(true)
				else
					cb(false)
				end
			else
				xPlayer.removeMoney(Config.Mechanic.PoundP)
				TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.Mechanic.PoundP)
				if Config.Main.GiveSocMoney then
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
						account.addMoney(Config.Mechanic.PoundP)
					end)
				end
				cb()
			end
		end
	elseif job == 'civ' then
		if type == 'aircrafts' then
			if attempt == 'check' then
				if xPlayer.getMoney() >= Config.Aircrafts.PoundP then
					cb(true)
				else
					cb(false)
				end
			else
				xPlayer.removeMoney(Config.Aircrafts.PoundP)
				TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.Aircrafts.PoundP)
				if Config.Main.GiveSocMoney then
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
						account.addMoney(Config.Aircrafts.PoundP)
					end)
				end
				cb()
			end
		elseif type == 'boats' then
			if attempt == 'check' then
				if xPlayer.getMoney() >= Config.Boats.PoundP then
					cb(true)
				else
					cb(false)
				end
			else
				xPlayer.removeMoney(Config.Boats.PoundP)
				TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.Boats.PoundP)
				if Config.Main.GiveSocMoney then
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
						account.addMoney(Config.Boats.PoundP)
					end)
				end
				cb()
			end
		elseif type == 'cars' then
			if attempt == 'check' then
				if xPlayer.getMoney() >= Config.Cars.PoundP then
					cb(true)
				else
					cb(false)
				end
			else
				xPlayer.removeMoney(Config.Cars.PoundP)
				TriggerClientEvent('esx:showNotification', source, _U('you_paid') .. Config.Cars.PoundP)
				if Config.Main.GiveSocMoney then
					TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
						account.addMoney(Config.Cars.PoundP)
					end)
				end
				cb()
			end
		end
	end
end)
-- End of Impound Pay

-- Store Vehicles
ESX.RegisterServerCallback('esx_advancedgarage:storeVehicle', function (source, cb, vehicleProps)
	local ownedCars = {}
	local vehplate = vehicleProps.plate:match("^%s*(.-)%s*$")
	local vehiclemodel = vehicleProps.model
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll('SELECT * FROM owned_vehicles WHERE owner = @owner AND plate = @plate', {
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
				if Config.Main.KickCheaters then
					if Config.Main.CustomKickMsg then
						print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: %s | Original Vehicle: %s '):format(xPlayer.identifier, vehiclemodel, originalvehprops.model))

						DropPlayer(source, _U('custom_kick'))
						cb(false)
					else
						print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: %s | Original Vehicle: %s '):format(xPlayer.identifier, vehiclemodel, originalvehprops.model))

						DropPlayer(source, 'You have been Kicked from the Server for Possible Garage Cheating!!!')
						cb(false)
					end
				else
					print(('esx_advancedgarage: %s attempted to Cheat! Tried Storing: %s | Original Vehicle: %s '):format(xPlayer.identifier, vehiclemodel, originalvehprops.model))
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

	if Config.Main.GiveSocMoney then
		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_mechanic', function(account)
			account.addMoney(price)
		end)
	end
end)

-- Rename Vehicle
RegisterServerEvent('esx_advancedgarage:renameVehicle')
AddEventHandler('esx_advancedgarage:renameVehicle', function(plate, name)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET name = @name WHERE plate = @plate', {
		['@name'] = name,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
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

-- Set Fuel Level
RegisterServerEvent('esx_advancedgarage:setVehicleFuel')
AddEventHandler('esx_advancedgarage:setVehicleFuel', function(plate, fuel)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE owned_vehicles SET fuel = @fuel WHERE plate = @plate', {
		['@fuel'] = fuel,
		['@plate'] = plate
	}, function(rowsChanged)
		if rowsChanged == 0 then
			print(('esx_advancedgarage: %s exploited the garage!'):format(xPlayer.identifier))
		end
	end)
end)
