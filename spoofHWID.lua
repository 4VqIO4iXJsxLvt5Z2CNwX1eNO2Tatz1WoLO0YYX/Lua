local hwid1 = ("UiQt2RdtiR5HDFqoGl58LqNdGTWLwg6PtNb2VKGS")
local hwid2 = ("7A6C9C6BE39E69AA2A50C9020137AD9BB2331FB5")

function onSendPacket(id, bs)
    if id == 215 then
        raknetBitStreamReadInt8(bs)
        raknetBitStreamReadInt8(bs)
        raknetBitStreamReadInt8(bs)
        local f = raknetBitStreamReadInt8(bs)
        if f == 51 then
            lua_thread.create(function()
                local bs = raknetNewBitStream()
                local bytes =  { 215, 1, 0, 51, 0, 0, 0, 0 }
                for i = 1, #bytes do
                    raknetBitStreamWriteInt8(bs, bytes[i])
                end
                raknetBitStreamWriteInt16(bs, hwid1:len())
                raknetBitStreamWriteInt16(bs, 0)
                raknetBitStreamWriteString(bs, hwid1)
                raknetBitStreamWriteInt16(bs, hwid2:len())
                raknetBitStreamWriteInt16(bs, 0)
                raknetBitStreamWriteString(bs, hwid2)
                raknetSendBitStream(bs)
                raknetDeleteBitStream(bs)
            end)
            return false
        end
    end
end