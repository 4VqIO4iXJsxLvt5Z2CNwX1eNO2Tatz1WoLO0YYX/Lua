require 'lib.moonloader'
require 'lib.sampfuncs'
local wolic = false
local sampev = require 'lib.samp.events'

function main()
	repeat wait(0) until isSampAvailable()
	wait(10000)
	sampAddChatMessage('{FFFF00}[Seat ARP] {F0F8FF}��������! �����: {8A2BE2}Beliy {F0F8FF}�������: {FF0000}/wolic [Licenses]{FF0000}, {FF0000}/seat [idcar]', -1)
	sampRegisterChatCommand("seat", sit)
	sampRegisterChatCommand("wolic", function()
		wolic = not wolic
		if wolic then
			wolic = true
			sampAddChatMessage('{FFFF00}[Seat ARP] {FF1493}������ � ���� ���� ����� �� ����� ���������.', -1)
		else
			wolic = false
			sampAddChatMessage('{FFFF00}[Seat ARP] {FF1493}�� �������� ������� � ��� ��� ��������!', -1)
		end
	end)
	wait(-1)
end


function sit(arg) 
	lua_thread.create(function()
		local carid = tonumber(arg)
		if carid ~= nil then
			local _, car = sampGetCarHandleBySampVehicleId(carid)
			if _ then
				local cpX, cpY, cpZ = getCarCoordinates(car)
				setCharCoordinates(PLAYER_PED, cpX, cpY, cpZ)
				wait(500)
				setCharCoordinates(PLAYER_PED, cpX, cpY+3, cpZ-1)
				--[[setVirtualKeyDown(0x47, true)
				wait(1)
				setVirtualKeyDown(0x47, false)]]
				sampSendEnterVehicle(carid, true)
				wait(1000)
				warpCharIntoCar(PLAYER_PED, car)
				sampAddChatMessage(string.format('{FFFF00}[Seat ARP] {FF1493}�� ������� ���� � ����. {8A17E5}%s', carid), -1)
			else
				sampAddChatMessage('{FFFF00}[Seat ARP] {FF1493}��� ��� ���� ������,������� �����.', -1)
			end
		elseif carid == '' or carid == nil then
			sampAddChatMessage('{FFFF00}[Seat ARP] {8FBC8F}������, �� �� ��������� ��� carid.', -1)
		end
	end)
end


function sampev.onSetPlayerPos(position)
	if wolic and position then
		return false
	end
end


function sampev.onServerMessage(color, text)
	if wolic and text:find("%[������%] %{FF1493%}�������� � ��� ��� �������� �� ��������%, ������� �� �� ������ ������ ��� ����%.") or text:find('���� ��������� ������%!') or text:find('� ��� ��� ������ �� ����� ����������%!') or text:find('��������� ��������� �������� ������ �� ����� ������%!') or text:find('���� ��������� ��� ��������%!') or text:find('�������� � ��� ��� �������� �� ������%, ������� �� �� ������ ������ ���� ���������%!') or text:find('�������� � ��� ��� �������� �� �������� ���������, ������� �� �� ������ ������ ���� ���������%!') then
		return false
	end
end


function sampev.onRemovePlayerFromVehicle()
	if wolic then
		return false
	end
end