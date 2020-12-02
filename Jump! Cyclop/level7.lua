local composer = require"composer"
local LG       = require"levelGenerator"
local data     = require"myData"
local player   = require"player"
local perspective = require"perspective"
local sound    = require"module_sound"
local tools    = require"tools"
local physics  = require"physics"
local ln       = 7
local Cyclop, myAnimation
physics.start()
physics.setGravity(0,data.gravity)
local camera = perspective.createView()
camera:setParallax(1,0.9,0.8,0.7,0.6,0.5,0.4,0.3)

local scene    = composer.newScene()
local sceneGroup

function onTilt( event )
	px,py = Cyclop:getLinearVelocity()
	Cyclop:setLinearVelocity(event.xGravity*700,py)
	Cyclop.rotation = Cyclop.rotation + event.xGravity*10
end

function scene:create( event )
	sceneGroup = self.view
	background = display.newRect(sceneGroup,data.width/2,data.height,data.width,data.height)
	background.anchorY = 1
	background:setFillColor(100/250,149/250,237/250)

	LG.level7(sceneGroup,camera)
	player.createPlayer(sceneGroup)
	Cyclop = player.player
	myAnimation = player.myAnimation

	tools.playBGMusic(ln)
	tools.stop(sceneGroup,ln)
	tools.position(sceneGroup,Cyclop,ln)
	tools.collision(sceneGroup,Cyclop,ln)
	
	camera:add(Cyclop,1)
	camera:add(myAnimation,1)
	camera:layer(1):setCameraOffset(0,data.height*0.3)
	camera.damping = 60
	camera:setFocus(Cyclop)
	camera:track()
	sceneGroup:insert(camera)
	camera:setBounds(data.width*0.5,data.width*0.5,data.height,false)

	system.setAccelerometerInterval(100)
	Runtime:addEventListener("accelerometer",onTilt)
	tools.track(sceneGroup,Cyclop,ln)
	tools.createBackground(camera,30)
end

function scene:show( event )
	sceneGroup = self.view
	if event.phase == "will" then

	elseif event.phase == "did" then

	end
end 

function scene:hide( event )
	sceneGroup = self.view
	if event.phase == "will" then

	elseif event.phase == "did" then
		composer.removeScene("level"..ln)
	end
end

function scene:destroy( event )
	sceneGroup = self.view
	tools.timerClear()
	LG.cleanUp()
	player.cleanUp()
	physics.pause()
	camera:destroy()
	Runtime:removeEventListener("accelerometer",onTilt)
	display.remove(Cyclop)
	display.remove(myAnimation)
	display.remove(camera)
	package.loaded["player"] = nil
	package.loaded["levelGenerator"] = nil
	package.loaded["module_sound"] = nil
	package.loaded["tools"] = nil
	package.loaded["perspective"] = nil
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show",   scene )
scene:addEventListener( "hide",   scene )
scene:addEventListener( "destroy",scene )

return scene