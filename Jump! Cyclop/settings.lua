local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"
local data = require("myData")
local sound    = require"module_sound"
local background = {}
local t1,t2,t3,t4
local loadsave = require"loadsave"
local k = loadsave.loadTable("k.json",system.DocumentsDirectory)


function scene:create( event )
	local sceneGroup = self.view
	local function back( event )
		if event.phase == "ended" then
			composer.gotoScene("enter")
		end
	end
	local function bgmSwitch( event )
		if event.phase == "ended" then
			if k[1] == true then
				display.remove(t1)
				t1 = display.newText(sceneGroup,data.backgroundMusicOff[k[3]],data.width*0.5,data.height*0.4,nil,20)
				k[1] = false
			elseif k[1] == false then
				display.remove(t1)
				t1 = display.newText(sceneGroup,data.backgroundMusicOn[k[3]],data.width*0.5,data.height*0.4,nil,20)
				k[1] = true
			end
			loadsave.saveTable(k,"k.json",system.DocumentsDirectory)
		end
	end
	local function jsSwitch( event )
		if event.phase == "ended" then
			if k[2] == true then
				display.remove(t2)
				t2 = display.newText(sceneGroup,data.jumpsoundOff[k[3]],data.width*0.5,data.height*0.5,nil,20)
				k[2] = false
			elseif k[2] == false then
				display.remove(t2)
				t2 = display.newText(sceneGroup,data.jumpsoundOn[k[3]],data.width*0.5,data.height*0.5,nil,20)
				k[2] = true
			end
			loadsave.saveTable(k,"k.json",system.DocumentsDirectory)
		end
	end
	local function lgSwitch( event )
		if event.phase == "ended" then
			if k[3] == 1 then
				k[3] = 2
			elseif k[3] == 2 then
				k[3] = 1
			end
			loadsave.saveTable(k,"k.json",system.DocumentsDirectory)
			display.remove(t1)
			display.remove(t2)
			display.remove(t3)
			display.remove(t4)
			display.remove(background[1])
			display.remove(backButton)
			display.remove(bgmButton)
			display.remove(jsButton)
			display.remove(lgButton)
			display.remove(vsButton)
			composer.gotoScene("settings")
		end
	end
	background[1] = display.newRect(sceneGroup,data.width/2,data.height/2,data.width,data.height)
	background[1]:setFillColor(100/250,149/250,237/250)
	backButton = widget.newButton({
				width = data.width*0.22,
				height  = data.width*0.12,
				x = data.width*0.13,
				y = data.width*0.12,
				shape = "roundedRect",
				fillColor = {default = {0,0,1,0.4}, over = {0,0,1,0.6}},
				label = data.BACK[k[3]],
				labelColor = {default = {0,0,0}, over = {0,0,0}},
				onEvent = back
				})
	sceneGroup:insert(backButton)
	bgmButton = widget.newButton({
				width = data.width*0.7,
				height  = data.height*0.08,
				x = data.width*0.5,
				y = data.height*0.4,
				shape = "roundedRect",
				fillColor = {default = {0,0,1,0.4}, over = {0,0,1,0.6}},
				onEvent = bgmSwitch
				})
	sceneGroup:insert(bgmButton)
	jsButton = widget.newButton({
				width = data.width*0.7,
				height  = data.height*0.08,
				x = data.width*0.5,
				y = data.height*0.5,
				shape = "roundedRect",
				fillColor = {default = {0,0,1,0.4}, over = {0,0,1,0.6}},
				onEvent = jsSwitch
				})
	sceneGroup:insert(jsButton)
	lgButton = widget.newButton({
				width = data.width*0.7,
				height  = data.height*0.08,
				x = data.width*0.5,
				y = data.height*0.6,
				shape = "roundedRect",
				fillColor = {default = {0,0,1,0.4}, over = {0,0,1,0.6}},
				onEvent = lgSwitch
				})
	sceneGroup:insert(lgButton)
	vsButton = widget.newButton({
				width = data.width*0.7,
				height  = data.height*0.08,
				x = data.width*0.5,
				y = data.height*0.7,
				shape = "roundedRect",
				fillColor = {default = {0,0,1,0.4}, over = {0,0,1,0.6}},
				})
	sceneGroup:insert(vsButton)
	if k[1] == true then
		t1 = display.newText(sceneGroup,data.backgroundMusicOn[k[3]],data.width*0.5,data.height*0.4,nil,20)
	elseif k[1] == false then
		t1 = display.newText(sceneGroup,data.backgroundMusicOff[k[3]],data.width*0.5,data.height*0.4,nil,20)
	end
	if k[2] == true then
		t2 = display.newText(sceneGroup,data.jumpsoundOn[k[3]],data.width*0.5,data.height*0.5,nil,20)
	elseif k[2] == false then
		t2 = display.newText(sceneGroup,data.jumpsoundOff[k[3]],data.width*0.5,data.height*0.5,nil,20)
	end
	if k[3] == 1 then
		t3 = display.newText(sceneGroup,"language: English",data.width*0.5,data.height*0.6,nil,20)
	elseif k[3] == 2 then
		t3 = display.newText(sceneGroup,"语言：中文",data.width*0.5,data.height*0.6,nil,20)
	end
	t4 = display.newText(sceneGroup,data.version[k[3]].."1.1.1",data.width*0.5,data.height*0.7,nil,20)
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
		composer.removeScene("settings")
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