local demobrowser;
local speedInstance;
local refresh = 100; -- refresh 100 ms; Smaller - smoother
local web = {
  browser;

}

local clock = getTickCount()

function create()
  demobrowser = guiCreateBrowser(0.82, 0.7, 0.3, 0.3, true, true, true)
  speedInstance = demobrowser:getBrowser()
  addEventHandler("onClientBrowserCreated", speedInstance, load, false)
end

-- Refresh browser(arrow)
function render()
    if localPlayer.vehicle then 
        if getTickCount() - clock > refresh then
            clock = getTickCount();
            local rpm = getVehicleRPM(localPlayer.vehicle)
            local rpm = rpm/1000
            if rpm > 7 then rpm = 7 end
            -- call JS Function: drawSpeedo(speed, MaxSpeed, gear, rpm)
            execute(("drawSpeedo(%0.1f,%d,%d,%0.1f);"):format(getElementSpeed(localPlayer.vehicle) * 2,revelant((CarsSpeed[getElementModel(localPlayer.vehicle)-399]*2)),getFormatGear(), rpm))
        end
    else
      triggerEvent("onClientVehicleStartExit",getRootElement(),localPlayer, false, false ,true)
    end 
end




function getFormatGear()
  return getVehicleCurrentGear(localPlayer.vehicle)
end


-- if load speedometr
function load(web)
  loadBrowserURL(speedInstance, "http://mta/local/speedometr.html")

   -- if BrowserDocumentReady
   addEventHandler("onClientBrowserDocumentReady", speedInstance,
   function ()
        -- start move render arrow speedometr
        addEventHandler ("onClientRender", root, render)
   end)
end



function onClientResourceStart()
  if localPlayer.vehicle then create(); end 
end 

addEventHandler("onClientResourceStart", resourceRoot, onClientResourceStart)


function execute(eval)
  executeBrowserJavascript(speedInstance, eval)
end 



addEventHandler("onClientVehicleEnter", getRootElement(),
    function(thePlayer, seat)
        if thePlayer == localPlayer and seat == 0 then create(); end
    end
)

function destroySpeed()
    if isElement(demobrowser) then 
        demobrowser:destroy()
    end
    if isElement(speedInstance) then 
        speedInstance:destroy()
    end
    
    removeEventHandler ("onClientRender", root, render)
end


function exitingVehicle(player, seat, door, skip)
	  if player == localPlayer and (seat == 0 and door == 0) or skip then
      destroySpeed()
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), exitingVehicle)


