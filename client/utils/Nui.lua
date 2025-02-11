local isUIToggle = true
local uiReady = promise.new()
function sendUIMessage(message)
	Citizen.Await(uiReady)
	SendNUIMessage(message)
end

RegisterNUICallback("uiReady", function(data, cb)
	uiReady:resolve(true)

	cb('ok')
end)

RegisterNetEvent("voice_toggleui:toggle")
AddEventHandler('voice_toggleui:toggle', function(toggle)
	isUIToggle = toggle
	sendUIMessage({uiEnabled = toggle})
end)

Citizen.CreateThread(function() 
	while true do
		Citizen.Wait(0)
		if IsPauseMenuActive() then
			sendUIMessage({uiEnabled = false})
		elseif not IsPauseMenuActive() and isUIToggle then
			sendUIMessage({uiEnabled = true})
		end
	end
end)
