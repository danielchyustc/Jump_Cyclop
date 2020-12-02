local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"
local data = require("myData")
local sound    = require"module_sound"
local loadsave = require"loadsave"
local k = loadsave.loadTable("k.json",system.DocumentsDirectory)
local background = {}
local plank = {}
local playButton,settingsButton,text1



function scene:create( event )
	local sceneGroup = self.view
	local function play( event )
		if event.phase == "ended" then
			composer.gotoScene("menu")
		end
	end
	local function settings( event )
		if event.phase == "ended" then
			composer.gotoScene("settings")
		end
	end
	background[1] = display.newRect(sceneGroup,data.width/2,data.height/2,data.width,data.height)
	background[1]:setFillColor(100/250,149/250,237/250)
	background[2] = display.newImageRect(sceneGroup,"assets/enter.png",data.width,data.height*1.2)
	background[2].x = data.width/2
	background[2].y = data.height*0.4
	background[3] = display.newImageRect(sceneGroup,"logoCyclop.png",data.width*0.5,data.width*0.64)
	background[3].x = data.width*0.52
	background[3].y = data.height*0.26
	
	for i = 1,50 do
		background[3+i] = display.newRoundedRect(sceneGroup,data.width/2,data.height*0.39,data.width*(0.09*(50-i)/5),data.height*(0.012*(50-i)/5),data.width*(0.005*(50-i)/5))
		background[3+i]:setFillColor((103+i*3.1)/256,(153+i*2.1)/256,(243-i*4.9)/256)
	end

	
	text1 = display.newText(sceneGroup,"Jump! Cyclop",data.width/2,data.height*0.39,data.textFont,30)
	text1:setFillColor(0,0,0)
	
	playButton = widget.newButton({
				width = data.width*0.4,
				height  = data.height*0.08,
				x = data.width*0.5,
				y = data.height*0.5,
				shape = "roundedRect",
				fillColor = {default = {0,0,1,0.4}, over = {0,0,1,0.6}},
				label = data.PLAY[k[3]],
				labelColor = {default = {0,0,0}, over = {0,0,0}},
				onEvent = play
				})
	sceneGroup:insert(playButton)
	settingsButton = widget.newButton({
				width = data.width*0.4,
				height  = data.height*0.08,
				x = data.width*0.5,
				y = data.height*0.6,
				shape = "roundedRect",
				fillColor = {default = {0,0,1,0.4}, over = {0,0,1,0.6}},
				label = data.SETTINGS[k[3]],
				labelColor = {default = {0,0,0}, over = {0,0,0}},
				onEvent = settings
				})
	sceneGroup:insert(settingsButton)
	plank[1] = display.newImageRect(sceneGroup,"platformAsset/ice.png",data.plankWidth,data.plankHeight)
	plank[1].x = data.width*0.5
	plank[1].y = data.height*0.9
	plank[2] = display.newImageRect(sceneGroup,"platformAsset/swamp.png",data.plankWidth,data.plankHeight)
	plank[2].x = data.width*0.3
	plank[2].y = data.height*0.8
	plank[3] = display.newImageRect(sceneGroup,"platformAsset/sand.png",data.plankWidth,data.plankHeight)
	plank[3].x = data.width*0.7
	plank[3].y = data.height*0.75
	plank[4] = display.newImageRect(sceneGroup,"platformAsset/grass.png",data.plankWidth*0.7,data.plankHeight*0.7)
	plank[4].x = data.width*0.6
	plank[4].y = data.height*0.83
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		composer.removeScene("enter")
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	--sound.StopBGMusic()
	package.loaded["widget"] = nil
	package.loaded["myData"] = nil
	package.loaded["module_sound"] = nil
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene