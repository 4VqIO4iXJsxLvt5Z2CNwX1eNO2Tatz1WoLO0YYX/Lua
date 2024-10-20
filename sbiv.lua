

local wm = require 'windows.message'
local vkeys = require 'vkeys'


function main()
  while not isSampAvailable() do wait(0) end
    addEventHandler('onWindowMessage', function(msg, wparam, lparam)    
      if msg == 523 then      
          if wparam == vkeys.VK_X and not sampIsCursorActive() then 
            if isCharOnFoot(PLAYER_PED) then 
              setCharVelocity(PLAYER_PED, 0.0, 0.0, 0.0)
              sampSetSpecialAction(0)     
			        setPlayerControl(PLAYER_HANDLE, true)
	            freezeCharPosition(PLAYER_PED, false)
	            clearCharTasksImmediately(PLAYER_PED)
            end 
          end
      end
  end) 
  wait(-1)     
end 

