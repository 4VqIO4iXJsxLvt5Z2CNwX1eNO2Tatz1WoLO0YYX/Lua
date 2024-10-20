local sampev = require 'lib.samp.events'


function main()
if not isSampLoaded() or not isSampfuncsLoaded then return end 
while not isSampAvailable() do wait(100) end
sampRegisterChatCommand("brk", nrs)
sampRegisterChatCommand("unbrk", nre)
while true do
wait(0)
end 
end


function nrs()

	if isCharInAnyCar(PLAYER_PED) then
	 car = storeCarCharIsInNoSave(PLAYER_PED)
     health = getCarHealth(car)
    lua_thread.create(function()
        for i = health, 300, -50 do
            wait(0); setCarHealth(car, i)
			
        end
		sampAddChatMessage('{33CC99}Машина успешно сломана!', 0x996633)
    end)
	else
 sampAddChatMessage('{33CC99}Сядь в авто!', 0x996633)
end
end 

function nre(unhp)
 if isCharInAnyCar(PLAYER_PED) then
 car = storeCarCharIsInNoSave(playerPed)
  hpcar = getCarHealth(car)
lua_thread.create(function()
fixCar(car)
wait(200)
setCarHealth(car, unhp)
wait(200)
clearCharTasksImmediately(PLAYER_PED)
wait(100)
setCarHealth(car, unhp)
sampAddChatMessage('{33CC99}Вы установили {00FF00}'..unhp..' {33CC99} было {00FF00}'..hpcar..' {33CC99}хп', 0x996633)
end)
else
 sampAddChatMessage('{33CC99}Сядь в авто!', 0x996633)
end
end 