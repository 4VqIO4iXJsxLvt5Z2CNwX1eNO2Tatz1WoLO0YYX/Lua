local encoding = require('encoding')
encoding.default = 'CP1251'
local u8 = encoding.UTF8

local active = false

local massActive = false

local vehicleHandle = nil

local targetId = -1

local isProcessing = false

local massNotified = false

function rand()
    math.randomseed(os.clock())
    return math.random(0, 50) / 100
end

function sendBulletSync(playerID)
    if getCurrentCharWeapon(1) ~= 34 then 
        return 
    end

    local data = allocateMemory(70)

    local t_type = 1
    local t_id = playerID
    if rand() < 0.25 then 
        t_type = 0
        t_id = 65535
    end

    setStructElement(data, 0, 1, t_type, false)
    setStructElement(data, 1, 2, t_id, false)

    local pX, pY, pZ = getActiveCameraCoordinates()
    setStructFloatElement(data, 3, pX, false)
    setStructFloatElement(data, 7, pY, false)
    setStructFloatElement(data, 11, pZ, false)

    setStructFloatElement(data, 15, pX + rand(), false)
    setStructFloatElement(data, 19, pY + rand(), false)
    setStructFloatElement(data, 23, pZ + rand(), false)

    setStructFloatElement(data, 27, rand(), false)
    setStructFloatElement(data, 31, rand(), false)
    setStructFloatElement(data, 35, rand(), false)

    setStructElement(data, 39, 1, 34, false)

    sampSendBulletData(data)
    freeMemory(data)

    setCharAmmo(1, 34, getAmmoInCharWeapon(1, 34) - 1)

    lua_thread.create(function()
        wait(1)
        sampSendGiveDamage(playerID, 85, 34, 3)
    end)
end

function search(radius)
    local inSphere = {}
    if not radius then return {} end
    local Mx, My, Mz = getCharCoordinates(PLAYER_PED)

    for _, v in pairs(getAllChars()) do
        local x, y, z = getCharCoordinates(v)
        if getDistanceBetweenCoords3d(Mx, My, Mz, x, y, z) <= tonumber(radius) and v ~= PLAYER_PED then
            local result, id = sampGetPlayerIdByCharHandle(v)
            if result and not isCharDead(v) and not sampIsPlayerNpc(id) then
                inSphere[#inSphere + 1] = id
            end
        end
    end

    return inSphere
end

function main()
    while not isSampAvailable() do wait(100) end

    sampRegisterChatCommand('cfuk', function(t)
        active = not active
        t = tonumber(t)
        if active then
            if t and t > -1 then
                targetId = t
                if isCharInAnyCar(PLAYER_PED) then
                    vehicleHandle = storeCarCharIsInNoSave(PLAYER_PED)
                end
            else
                sampAddChatMessage(u8:decode"Неверный ID", -1)
                active = false
            end
        else
            sampAddChatMessage(u8:decode"Игрок открыл свой подарок!", -1)
            targetId = -1
        end
    end)

    sampRegisterChatCommand('cdmg', function()
	     if isCharInAnyCar(PLAYER_PED) then
         vehicleHandle = storeCarCharIsInNoSave(PLAYER_PED)
         end
        if not massActive then
            massActive = true
            sampAddChatMessage(u8:decode"Начинаем массово раздавать подарки игрокам!", -1)
            lua_thread.create(function()
                while massActive do
                    if not isProcessing then
                        isProcessing = true
                        local nearbyPlayers = search(100)
                        if #nearbyPlayers > -1 then
                            for _, playerId in ipairs(nearbyPlayers) do
                                printStringNow("Mass gift giving ID >> " .. playerId, 1000)
                                sampSendTakeDamage(65535, 0, 0, 3)
                                sampSendDeathByPlayer(65535, 0)
                                wait(500)
                                giveWeaponToChar(PLAYER_PED, 34, 99999)
                                wait(450)
                                sendBulletSync(playerId)

                                if vehicleHandle and doesVehicleExist(vehicleHandle) then
                                    warpCharIntoCar(PLAYER_PED, vehicleHandle)
                                    removeWeaponFromChar(PLAYER_PED, 34)
                                end
                            end
                        else
                            if not massNotified then
                                sampAddChatMessage(u8:decode"Некому отправить подарки :(", -1)
                                massNotified = true
                            end
                            massActive = false
                        end
                        isProcessing = false
                    end
                end
            end)
        else
            massActive = false
            sampAddChatMessage(u8:decode"Перестали дарить подарки", -1)
            isProcessing = false
            removeWeaponFromChar(PLAYER_PED, 34)
            massNotified = false
        end
    end)

    while true do
        wait(0)

        if active and not isProcessing then
            isProcessing = true
            if targetId > -1 then
                sampSendTakeDamage(65535, 0, 0, 3)
                sampSendDeathByPlayer(65535, 0)
                wait(500)
                giveWeaponToChar(PLAYER_PED, 34, 99999)
                wait(450)
                sendBulletSync(targetId)

                if vehicleHandle and doesVehicleExist(vehicleHandle) then
                    warpCharIntoCar(PLAYER_PED, vehicleHandle)
                    removeWeaponFromChar(PLAYER_PED, 34)
                end
            else
                sampAddChatMessage(u8:decode"Шото не то по айди", -1)
            end

            isProcessing = false
            removeWeaponFromChar(PLAYER_PED, 34)
        end
    end
end
