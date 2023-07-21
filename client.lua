
UseKMH = ((GetResourceMetadata(GetCurrentResourceName(), "use_kmh") == 'yes') and true or false)

multiplier = 2.236936
measurement = 'MPH'

if UseKMH then
    multiplier = 3.6
    measurement = 'KMH'
end

RegisterCommand("measurespeed", function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(playerPed, false)
    local done, started, timer = false, false, 0

    FreezeEntityPosition(vehicle, true)
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)

    CreateThread(function()
        while (not done) do
            if IsControlPressed(0, 71) then
                local vehicleSpeed = GetEntitySpeed(vehicle) * multiplier

                if (not started) then
                    started = true
                    FreezeEntityPosition(vehicle, false)
                end

                timer = timer + 0.01

                DrawMissionText(timer..'s', 50)
                Wait(10)

                if (vehicleSpeed >= 100.0) then done = true end
            elseif started and (not done) then
                done = true
                timer = 0
            else
                DrawMissionText('Start holding down ~b~W~s~ to get started!', 0)
            end

            Wait(0)
        end

        if done then
            if (timer > 0.0) then
                ShowNotification('The vehicle\'s 0-100 is: ' .. timer .. 's ' .. measurement)
            else
                ShowNotification('You released the accelerator too early.')
            end
        end
    end)
end, false)

function ShowNotification(msg)
	SetNotificationTextEntry('STRING')
	AddTextComponentString(msg)
	DrawNotification(0,1)
end

function DrawMissionText(msg, time)
	ClearPrints()
	BeginTextCommandPrint('STRING')
	AddTextComponentSubstringPlayerName(msg)
	EndTextCommandPrint(time, true)
end
