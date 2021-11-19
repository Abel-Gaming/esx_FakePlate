ESX              = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(250)
	end
end)

RegisterCommand(Config.Command, function(source, args, rawCommand)
	KeyboardInput('Plate Text', '', 5)
end, false)

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
	AddTextEntry('FMMC_KEY_TIP1', TextEntry)
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult()
		Citizen.Wait(500)
		blockinput = false
		ChangePlateText(result)
	else
		Citizen.Wait(500)
		blockinput = false
		return nil
	end
end

function ChangePlateText(newplatetext)
	-- Get the player position
	local playerCoords = GetEntityCoords(PlayerPedId())

	-- Get the closest vehicle
	local vehicle = ESX.Game.GetClosestVehicle(playerCoords)

	-- Get the vehicle coords
	local vehicleCoords = GetEntityCoords(vehicle)

	-- Check the distance
	if #(playerCoords - vehicleCoords) <= 5 then
		-- Set the vehicle plate
		ESX.Game.SetVehicleProperties(vehicle, {
        	plate = newplatetext
    	})

		-- Show notification
		ESX.ShowNotification('~g~[SUCCESS]~w~ The plate has been changed to ~b~' .. newplatetext)
	end
end
