Citizen.CreateThread(function()
	repeat
		Citizen.Wait(1)
		if NetworkIsSessionStarted() then
			TriggerServerEvent("AyeSlot:")
			return
		end
	until false
end)