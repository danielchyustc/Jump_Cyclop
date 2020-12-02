M = {}
local data = require"myData"
local widget = require"widget"
local composer = require"composer"
local physics = require"physics"
local sound = require"module_sound"
local loadsave = require"loadsave"
local k = loadsave.loadTable("k.json",system.DocumentsDirectory)
local stopRect, stopButton, menuButton, resumeButton, restartButton
local jumptimer1, jumptimer2, breaktimer
local t = 26
local a
local position = {}
local long = {36.25,34.15,30.6,31,30.8,29.6,30.9,30.2,31,31}

local bgImage = {}
local imageSize = {
	{width = 255/476, height = 221/476},
	{width = 620/1116, height = 496/1116},
	{width = 284/601, height = 317/601},
	{width = 211/402, height = 191/402},
	{width = 306/541, height = 235/541},
	{width = 222/349, height = 127/349},
}
function M.createBackground( camera,sceneNumber )
	local rightCount = math.random(50,75)
	for i = 1,rightCount do
		local indexRight = math.random(1,6)
		local cRight = math.random(2,6)
		bgImage[#bgImage+1] = display.newImageRect("assets/"..indexRight.."R.png",
										data.width*0.8*imageSize[indexRight].width,
										data.width*0.8*imageSize[indexRight].height)
		bgImage[#bgImage].anchorX = 1
		bgImage[#bgImage].x = data.width
		bgImage[#bgImage].y = math.random(-sceneNumber*data.height,data.height)
		bgImage[#bgImage]:setFillColor(1,1,1,0.45-0.05*cRight)
		camera:add(bgImage[#bgImage],cRight)
	end

	local leftCount = math.random(50,75)
	for i = 1,leftCount do
		local indexLeft = math.random(1,6)
		local cLeft = math.random(2,6)
		bgImage[#bgImage+1] = display.newImageRect("assets/"..indexLeft.."L.png",
										data.width*0.8*imageSize[indexLeft].width,
										data.width*0.8*imageSize[indexLeft].height)
		bgImage[#bgImage].anchorX = 0
		bgImage[#bgImage].x = 0
		bgImage[#bgImage].y = math.random(-sceneNumber*data.height,data.height)
		bgImage[#bgImage]:setFillColor(1,1,1,0.45-0.05*cLeft)
		camera:add(bgImage[#bgImage],cLeft)
	end
end

function M.playBGMusic( ln )
	if k[1] == true then
		sound.playBGMusic(ln)
	end
end

function M.position( sceneGroup,Cyclop,level )
	local p = 0
	local text = display.newText(sceneGroup,"0%",data.width*0.9,data.height*0.07,nil,30)
	display.newText(sceneGroup,data.level[k[3]]..level,data.width*0.5,data.height*0.07,nil,30)
	function playerPosition(  )
		display.remove(text)
		p = math.ceil(100*(1-Cyclop.y/data.height)/long[level])-1
		text = display.newText(sceneGroup,""..math.min(math.max(p,0),100).."%",data.width*0.9,data.height*0.07,nil,30)
	end
	Runtime:addEventListener("enterFrame",playerPosition)
	
end

function M.stop( sceneGroup,level )
	local function goToMenu( event )
		if event.phase == "ended" then
			display.remove(stopRect)
			display.remove(text)
			display.remove(menuButton)
			display.remove(resumeButton)
			display.remove(restartButton)
			composer.gotoScene("menu")
			a = nil
		end
	end
	local function resume( event )
		if event.phase == "ended" then
			physics.start()
			display.remove(stopRect)
			display.remove(text)
			display.remove(menuButton)
			display.remove(resumeButton)
			display.remove(restartButton)
			sound.playBGMusic(level)
			a = nil
		end
	end
	local function restart( event )
		if event.phase == "ended" then
			display.remove(stopRect)
			display.remove(text)
			display.remove(menuButton)
			display.remove(resumeButton)
			display.remove(restartButton)
			composer.removeScene(data.level[k[3]]..level)
			composer.gotoScene("restart")
			a = nil
		end
	end
	local function goToStop( event )
		if event.phase == "ended" and a == nil then
			physics.pause()
			if k[1] == true then
				sound.stopBGMusic()
			end
			stopRect = display.newRoundedRect(sceneGroup,data.width/2,data.height*0.48,data.width*0.5,data.height*0.36,data.width*0.04)
			text = display.newText(sceneGroup,data.level[k[3]]..level,data.width/2,data.height*0.33,nil,20)
			text:setFillColor(0,0,0)
			stopRect:setFillColor(1,1,1,0.5)
			menuButton = widget.newButton({
				width = data.width*0.4,
				height  = data.height*0.08,
				x = data.width*0.5,
				y = data.height*0.4,
				shape = "roundedRect",
				fillColor = {default = {1,1,1,0.8}, over = {1,1,1,0.8}},
				label = data.MENU[k[3]],
				labelColor = {default = {0,0,0}, over = {0,0,0}},
				onEvent = goToMenu
				})
			sceneGroup:insert(menuButton)
			resumeButton = widget.newButton({
				width = data.width*0.4,
				height  = data.height*0.08,
				x = data.width*0.5,
				y = data.height*0.5,
				shape = "roundedRect",
				fillColor = {default = {1,1,1,0.8}, over = {1,1,1,0.8}},
				label = data.RESUME[k[3]],
				labelColor = {default = {0,0,0}, over = {0,0,0}},
				onEvent = resume
				})
			sceneGroup:insert(resumeButton)
			restartButton = widget.newButton({
				width = data.width*0.4,
				height  = data.height*0.08,
				x = data.width*0.5,
				y = data.height*0.6,
				shape = "roundedRect",
				fillColor = {default = {1,1,1,0.8}, over = {1,1,1,0.8}},
				label = data.RESTART[k[3]],
				labelColor = {default = {0,0,0}, over = {0,0,0}},
				onEvent = restart
				})
			sceneGroup:insert(restartButton)
			a = 1
		end
	end
	stopButton = widget.newButton({
		width = data.width*0.12,
		height  = data.width*0.12,
		x = data.width*0.08,
		y = data.width*0.12,
		shape = "roundedRect",
		fillColor = {default = {1,1,1,0.5}, over = {1,1,1,0.5}},
		label = "| |",
		labelColor = {default = {0,0,0}, over = {0,0,0}},
		onEvent = goToStop
		})
	sceneGroup:insert(stopButton)
end

function M.fail( sceneGroup,level )
	local function goToMenu( event )
		if event.phase == "ended" then
			display.remove(stopRect)
			display.remove(text)
			display.remove(menuButton)
			display.remove(restartButton)
			composer.gotoScene("menu")
		end
	end
	local function restart( event )
		if event.phase == "ended" then
			display.remove(stopRect)
			display.remove(text)
			display.remove(menuButton)
			display.remove(restartButton)
			composer.removeScene("level"..level)
			composer.gotoScene("restart")
		end
	end
	physics.pause()
	a = 0
	if k[1] == true then
		sound.stopBGMusic()
	end
	stopRect = display.newRoundedRect(sceneGroup,data.width/2,data.height*0.48,data.width*0.5,data.height*0.26,data.width*0.04)
	text = display.newText(sceneGroup,data.FAILED[k[3]],data.width/2,data.height*0.38,nil,20)
	text:setFillColor(1,0,0)
	stopRect:setFillColor(1,1,1,0.5)
	menuButton = widget.newButton({
		width = data.width*0.4,
		height  = data.height*0.08,
		x = data.width*0.5,
		y = data.height*0.45,
		shape = "roundedRect",
		fillColor = {default = {1,1,1,0.8}, over = {1,1,1,0.8}},
		label = data.MENU[k[3]],
		labelColor = {default = {0,0,0}, over = {0,0,0}},
			onEvent = goToMenu
		})
	sceneGroup:insert(menuButton)
	restartButton = widget.newButton({
		width = data.width*0.4,
		height  = data.height*0.08,
		x = data.width*0.5,
		y = data.height*0.55,
		shape = "roundedRect",
		fillColor = {default = {1,1,1,0.8}, over = {1,1,1,0.8}},
		label = data.RESTART[k[3]],
		labelColor = {default = {0,0,0}, over = {0,0,0}},
		onEvent = restart
		})
	sceneGroup:insert(restartButton)	
end

function M.succeed( sceneGroup,level )
	local function goToMenu( event )
		if event.phase == "ended" then
			display.remove(stopRect)
			display.remove(text)
			display.remove(menuButton)
			display.remove(nextButton)
			display.remove(restartButton)
			composer.gotoScene("menu")
		end
	end
	local function next( event )
		if event.phase == "ended" then
			display.remove(stopRect)
			display.remove(text)
			display.remove(menuButton)
			display.remove(nextButton)
			display.remove(restartButton)
			composer.removeScene("level"..level)
			composer.gotoScene("level"..level+1)
		end
	end
	local function restart( event )
		if event.phase == "ended" then
			display.remove(stopRect)
			display.remove(text)
			display.remove(menuButton)
			display.remove(nextButton)
			display.remove(restartButton)
			composer.removeScene(data.level[k[3]]..level)
			composer.gotoScene("restart")
		end
	end
	physics.pause()
	if k[1] == true then
		sound.stopBGMusic()
	end
	a = 0
	stopRect = display.newRoundedRect(sceneGroup,data.width/2,data.height*0.48,data.width*0.5,data.height*0.36,data.width*0.04)
	stopRect:setFillColor(1,1,1,0.5)
	text = display.newText(sceneGroup,data.SUCCEEDED[k[3]],data.width/2,data.height*0.28,nil,20)
	text:setFillColor(0,1,0)
	menuButton = widget.newButton({
		width = data.width*0.4,
		height  = data.height*0.08,
		x = data.width*0.5,
		y = data.height*0.4,
		shape = "roundedRect",
		fillColor = {default = {1,1,1,0.8}, over = {1,1,1,0.8}},
		label = data.MENU[k[3]],
		labelColor = {default = {0,0,0}, over = {0,0,0}},
		onEvent = goToMenu
		})
	sceneGroup:insert(menuButton)
	nextButton = widget.newButton({
		width = data.width*0.4,
		height  = data.height*0.08,
		x = data.width*0.5,
		y = data.height*0.5,
		shape = "roundedRect",
		fillColor = {default = {1,1,1,0.8}, over = {1,1,1,0.8}},
		label = data.NEXT[k[3]],
		labelColor = {default = {0,0,0}, over = {0,0,0}},
		onEvent = next
		})
	sceneGroup:insert(nextButton)
	restartButton = widget.newButton({
		width = data.width*0.4,
		height  = data.height*0.08,
		x = data.width*0.5,
		y = data.height*0.6,
		shape = "roundedRect",
		fillColor = {default = {1,1,1,0.8}, over = {1,1,1,0.8}},
		label = data.RESTART[k[3]],
		labelColor = {default = {0,0,0}, over = {0,0,0}},
		onEvent = restart
		})
	sceneGroup:insert(restartButton)	
end

function M.collision( sceneGroup,Cyclop,level )
	local function localPreCollision( self,event )
		if "passthrough" == event.other.collType  then
			if event.other.type == "move2" and event.other.direction < 0 then
				if self.y+self.height*0.5 > event.other.y - event.other.height*0.5 + 3 then
					if event.contact then
						event.contact.isEnabled = false
					end
				end
			else
				if self.y+self.height*0.5 > event.other.y - event.other.height*0.5 + 1 then
					if event.contact then
						event.contact.isEnabled = false
					end
				end
			end
		end
	end
	function jump( self,force )
		if t >= 8 then
			jumptimer1 = timer.performWithDelay(1,function()
				if k[2] == true then
					sound.jump()
				end
				self:applyForce( 0,force,Cyclop.x,Cyclop.y )
			end)
			t = 0
		end
	end
	function onLocalCollision( self,event )
		if event.phase == "began" then
			if self.myName == "player" then
				if self.jumpapplied == false then
					self.jumpapplied = true
				end
				if event.other.myName == "plank" then
					if  self.y + self.height/2 < event.other.y - event.other.height/2 + 1  then
						self:setLinearVelocity(0,0)
						jump(self,event.other.force)
						jumptimer2 = timer.performWithDelay(50,function()
							t = t + 1
							position[t] = self.height
						end,100)
					end
					if event.other.type == "break" then
						if  self.y + self.height/2 < event.other.y - event.other.height/2 + 1 then
						breaktimer = timer.performWithDelay(20,function(  )
							event.other:fallApart()
							end)
						end
					end
				elseif event.other.type == "die" then
					if self.y + self.height/2 < event.other.y - event.other.height/2 + 1 then
						M.fail(sceneGroup,level)
					end
				elseif event.other.myName == "win" then
					local loadsave = require"loadsave"
					local levels = loadsave.loadTable("levels.json",system.DocumentsDirectory)
					levels[math.min(level+1,9)] = true
					loadsave.saveTable(levels,"levels.json",system.DocumentsDirectory)
					M.succeed(sceneGroup,level)
				end
			end
		end
	end
	Cyclop.preCollision = localPreCollision
	Cyclop:addEventListener("preCollision")
	Cyclop.collision = onLocalCollision
	Cyclop:addEventListener("collision")
end

function M.track(sceneGroup,Cyclop,level)
	function resetPlayer(  )
		if Cyclop.x <= 0 then
			Cyclop.x = Cyclop.x + data.width
		elseif Cyclop.x >= data.width then
			Cyclop.x = Cyclop.x - data.width
		end
		local px, py = Cyclop:localToContent(0,0)
		if py > data.height*1.2  and a == nil then
			M.fail(sceneGroup,level)
		end
	end
	Runtime:addEventListener("enterFrame",resetPlayer)
end

function M.timerClear()
	if k[1] == true then
		sound.stopBGMusic()
	end
	if jumptimer1 ~= nil then
		timer.cancel(jumptimer1)
	end
	if jumptimer2 ~= nil then
		timer.cancel(jumptimer2)
	end
	if breaktimer ~= nil then
		timer.cancel(breaktimer)
	end
	Runtime:removeEventListener("enterFrame",resetPlayer)
	Runtime:removeEventListener("enterFrame",playerPosition)
end

return M