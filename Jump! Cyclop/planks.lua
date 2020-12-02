local M={}
local data = require"myData"

M.planks = {}
M.spikes = {}
M.timer  = {}
M.win    = {}

function M.winDot( camera,sceneGroup,screen,inputX,inputY,color )
	inputX = data.width*inputX
	inputY = (inputY-screen)*data.height
	M.win[#M.win+1] = display.newImageRect(sceneGroup,"platformAsset/lock_"..color..".png",data.plankWidth/2,data.plankWidth/2)
	M.win[#M.win].x      = inputX
	M.win[#M.win].y      = inputY
	M.win[#M.win].myName = "win"
	M.win[#M.win].type   = "win"
	physics.addBody(M.win[#M.win],"static",{bounce = 0, friction = 0})
	M.win[#M.win].isSensor = true
	camera:add(M.win[#M.win],1)
end

function M.cleanUp( ... )
	for i=1,#M.timer do
		timer.cancel(M.timer[i])
	end
end


function M.plankBasic( camera,sceneGroup,screen,inputX,inputY )
	inputX = data.width*inputX
	inputY = (inputY-screen)*data.height
	M.planks[#M.planks+1] = display.newImageRect(sceneGroup,"platformAsset/ice.png",data.plankWidth,data.plankHeight)
	M.planks[#M.planks].x        = inputX
	M.planks[#M.planks].y        = inputY
	M.planks[#M.planks].force    = data.basicPlankForce
	M.planks[#M.planks].myName   = "plank"
	M.planks[#M.planks].type     = "basic"
	M.planks[#M.planks].collType = "passthrough"
	physics.addBody(M.planks[#M.planks],"static",{bounce = 0,friction = 0})
	camera:add(M.planks[#M.planks],1)
end

function M.plankBoost( camera,sceneGroup,screen,inputX,inputY,boost )
	inputX = data.width*inputX
	inputY = (inputY-screen)*data.height
	M.planks[#M.planks+1] = display.newImageRect(sceneGroup,"platformAsset/swamp.png",data.plankWidth,data.plankHeight)
	M.planks[#M.planks].x        = inputX
	M.planks[#M.planks].y        = inputY
	M.planks[#M.planks].force    = data.basicPlankForce*1.6
	M.planks[#M.planks].myName   = "plank"
	M.planks[#M.planks].type     = "boost"
	M.planks[#M.planks].collType = "passthrough"
	physics.addBody(M.planks[#M.planks],"static",{bounce = 0,friction = 0})
	camera:add(M.planks[#M.planks],1)
end

local function remove( obj )
	display.remove(obj)
end

function M.plankBreak( camera,sceneGroup,screen,inputX,inputY )
	inputX = data.width*inputX
	inputY = (inputY-screen)*data.height
	M.planks[#M.planks+1] = display.newImageRect(sceneGroup,"platformAsset/sand.png",data.plankWidth,data.plankHeight)
	M.planks[#M.planks].x        = inputX
	M.planks[#M.planks].y        = inputY
	M.planks[#M.planks].myName   = "plank"
	M.planks[#M.planks].type     = "break"
	M.planks[#M.planks].collType = "passthrough"
	M.planks[#M.planks].force    = data.basicPlankForce
	physics.addBody(M.planks[#M.planks],"static",{bounce=0,friction=0})
	camera:add(M.planks[#M.planks],1)

    local obj=M.planks[#M.planks]
    function obj:fallApart()
    	display.remove(obj)
    	local randomWidthA=math.random(obj.width*0.2,obj.width*0.8)
    	local randomWidthB=obj.width-randomWidthA

    	local tempA=display.newImageRect(sceneGroup,"platformAsset/debrisWood_"..math.random(1,3)..".png",randomWidthA,data.plankHeight)
    	tempA.y=inputY
    	tempA.anchorX=0
    	tempA.x=inputX-obj.width/2
    	physics.addBody( tempA,"dynamic",{density=1})
    	camera:add(tempA,1)

    	local tempB=display.newImageRect(sceneGroup,"platformAsset/debrisWood_"..math.random(1,3)..".png",randomWidthB,data.plankHeight)
    	tempB.y=inputY
    	tempB.anchorX=1
    	tempB.x=inputX+obj.width/2
    	physics.addBody( tempB,"dynamic",{density=1})
    	camera:add(tempB,1)

    	transition.to(tempA,{time=800,onComplete=remove})
    	transition.to(tempB,{time=800,onComplete=remove})
    end
end

function M.plankSpike( camera,sceneGroup,screen,inputX,inputY,inputD )
	local image_name = "assets/spike.png"
	local image_outline = graphics.newOutline(2,image_name)
	if inputD == nil then
		inputD = 1
	end

	inputX = data.width*inputX
	inputY = (inputY-screen)*data.height
	M.planks[#M.planks+1] = display.newImageRect(sceneGroup,"platformAsset/grass.png",data.plankWidth,data.plankHeight)
	M.planks[#M.planks].x        = inputX
	M.planks[#M.planks].y        = inputY
	M.planks[#M.planks].force    = data.basicPlankForce
	M.planks[#M.planks].myName   = "plank"
	M.planks[#M.planks].type     = "spike"
	M.planks[#M.planks].collType = "passthrough"
	physics.addBody(M.planks[#M.planks],"static",{bounce = 0,friction = 0})
	camera:add(M.planks[#M.planks],1)

    for i = 1,inputD do
		M.spikes[#M.spikes+1] = display.newImageRect(sceneGroup,"assets/spike.png",data.spikeWidth,data.spikeHeight)
		M.spikes[#M.spikes].x = M.planks[#M.planks].x + (i-(inputD+1)/2) * data.spikeHeight
		M.spikes[#M.spikes].y = M.planks[#M.planks].y - data.plankHeight/2 - data.spikeHeight/2
		M.spikes[#M.spikes].myName = "spike"
		M.spikes[#M.spikes].type = "die"
		M.spikes[#M.spikes].collType = "passthrough"
		physics.addBody(M.spikes[#M.spikes],"static",{bounce = 0,friction = 0, outline = image_outline})
		camera:add(M.spikes[#M.spikes],1)
	end
end

local function xmoveListener( event )
	local obj = event.source.param.obj
	obj.x = obj.x+obj.direction
	if obj.x > data.width-data.plankWidth/2 and obj.direction > 0 then
		obj.direction = -obj.direction
	elseif obj.x < data.plankWidth/2 and obj.direction < 0 then
		obj.direction = -obj.direction
	end
end

local function ymoveListener( event )
	local obj = event.source.param.obj
	obj.y = obj.y+obj.direction
	if obj.y < obj.yLimit1 then
		obj.direction = -obj.direction
	elseif obj.y > obj.yLimit2 then
		obj.direction = -obj.direction
	end
end
function M.plankMove( camera,sceneGroup,screen,inputX,inputY,inputD )
	inputX = data.width*inputX
	inputY = (inputY-screen)*data.height
	M.planks[#M.planks+1] = display.newImageRect(sceneGroup,"platformAsset/grass.png",data.plankWidth,data.plankHeight)
	M.planks[#M.planks].x        = inputX
	M.planks[#M.planks].y        = inputY
	M.planks[#M.planks].force    = data.basicPlankForce
	M.planks[#M.planks].myName   = "plank"
	M.planks[#M.planks].type     = "move"
	M.planks[#M.planks].collType = "passthrough"
	M.planks[#M.planks].direction= inputD
	physics.addBody(M.planks[#M.planks],"static",{bounce = 0,friction = 0})
	camera:add(M.planks[#M.planks],1)
	
	M.timer[#M.timer+1] = timer.performWithDelay(1,xmoveListener,-1)
	M.timer[#M.timer].param = {obj = M.planks[#M.planks]}
end

function M.plankMove2( camera,sceneGroup,screen,inputX,inputY,inputD,yLimit1,yLimit2 )
	inputX = data.width*inputX
	inputY = (inputY-screen)*data.height
	M.planks[#M.planks+1] = display.newImageRect(sceneGroup,"platformAsset/grass.png",data.plankWidth,data.plankHeight)
	M.planks[#M.planks].x        = inputX
	M.planks[#M.planks].y        = inputY
	M.planks[#M.planks].force    = data.basicPlankForce
	M.planks[#M.planks].myName   = "plank"
	M.planks[#M.planks].type     = "move2"
	M.planks[#M.planks].collType = "passthrough"
	M.planks[#M.planks].direction= inputD
	M.planks[#M.planks].inputY   = inputY
	M.planks[#M.planks].yLimit1  = yLimit1-screen*data.height
	M.planks[#M.planks].yLimit2  = yLimit2-screen*data.height
	physics.addBody(M.planks[#M.planks],"static",{bounce = 0,friction = 0})
	camera:add(M.planks[#M.planks],1)
	
	M.timer[#M.timer+1] = timer.performWithDelay(1,ymoveListener,-1)
	M.timer[#M.timer].param = {obj = M.planks[#M.planks]}
end

local function spinLintener(event)
	local obj=event.source.param.obj
    obj.rotation=obj.rotation+1
end

function M.plankSpin(camera,sceneGroup,screen,inputX,inputY)
	inputX = inputX*data.width
	inputY = (inputY-screen)*data.height
	M.planks[#M.planks+1] = display.newRoundedRect(sceneGroup,0,0,data.plankWidth,data.plankHeight*3/4,data.plankCornerRadius)
	M.planks[#M.planks]:setFillColor(0.8,0.8,0.8)
	M.planks[#M.planks].x        = inputX
	M.planks[#M.planks].y        = inputY				
	M.planks[#M.planks].myName   = "plank"
	M.planks[#M.planks].type     = "spin"
	M.planks[#M.planks].collType = "passthrough"
	M.planks[#M.planks].force    = data.basicPlankForce
	physics.addBody(M.planks[#M.planks],"static",{bounce=0,friction=0})
	camera:add(M.planks[#M.planks],1)

	M.timer[#M.timer+1]=timer.performWithDelay(1,spinLintener,-1)
    M.timer[#M.timer].param={obj=M.planks[#M.planks]}
end

local function rotatingListener(event)
	local ox = event.source.param.ox
	local oy = event.source.param.oy
	local obj = event.source.param.obj
	local radius = event.source.param.radius
	obj.currentAngle = obj.currentAngle+2
	obj.x = ox+radius*math.cos(math.rad(obj.currentAngle/3))*math.cos(math.rad(obj.currentAngle))^2
	obj.y = oy+radius*math.sin(math.rad(obj.currentAngle/3))*math.cos(math.rad(obj.currentAngle))^2
end

local function rotatingListener2(event)
	local ox=event.source.param.ox
	local oy=event.source.param.oy
	local obj=event.source.param.obj
	local radius=event.source.param.radius
	obj.currentAngle=obj.currentAngle+1.5
	obj.x = ox+radius*math.cos(math.rad(obj.currentAngle))*math.tan(math.rad(obj.currentAngle))
	obj.y = oy+radius*math.sin(math.rad(obj.currentAngle))*math.cos(math.rad(obj.currentAngle))^3
end

function M.plankRotate(camera,sceneGroup,screen,inputX,inputY,radius)
	inputX = inputX*data.width
	inputY = (inputY-screen)*data.height
	radius = radius*data.width
	M.planks[#M.planks+1] = display.newImageRect(sceneGroup,"platformAsset/ice.png",data.plankWidth,data.plankHeight)
	M.planks[#M.planks].x        = inputX
	M.planks[#M.planks].y        = inputY			
	M.planks[#M.planks].myName   = "plank"
	M.planks[#M.planks].type     = "rotate"
	M.planks[#M.planks].collType = "passthrough"
	M.planks[#M.planks].force    = data.basicPlankForce
	physics.addBody(M.planks[#M.planks],"static",{bounce=0,friction=0})
	M.planks[#M.planks].currentAngle=90
	camera:add(M.planks[#M.planks],1)

	M.timer[#M.timer+1]=timer.performWithDelay(1,rotatingListener,-1)
    M.timer[#M.timer].param={ox=inputX,oy=inputY,obj=M.planks[#M.planks],radius=radius}
end

function M.plankRotate2(camera,sceneGroup,screen,inputX,inputY,radius)
	inputX = inputX*data.width
	inputY = (inputY-screen)*data.height
	radius = radius*data.width
	M.planks[#M.planks+1] = display.newImageRect(sceneGroup,"platformAsset/ice.png",data.plankWidth,data.plankHeight)
	M.planks[#M.planks].x        = inputX
	M.planks[#M.planks].y        = inputY
	M.planks[#M.planks].myName   = "plank"
	M.planks[#M.planks].type     = "rotate"
	M.planks[#M.planks].collType = "passthrough"
	M.planks[#M.planks].force    = data.basicPlankForce
	physics.addBody(M.planks[#M.planks],"static",{bounce=0,friction=0})
	M.planks[#M.planks].currentAngle=90
	camera:add(M.planks[#M.planks],1)

	M.timer[#M.timer+1]=timer.performWithDelay(1,rotatingListener2,-1)
    M.timer[#M.timer].param={ox=inputX,oy=inputY,obj=M.planks[#M.planks],radius=radius,sceneGroup=sceneGroup}
end

local function randomListener( event )
	local obj = event.source.param.obj
	obj.x = math.random(data.plankWidth/2,data.width-data.plankWidth/2)
end

function M.plankRandom( camera,sceneGroup,screen,inputX,inputY )
	inputX = data.width*inputX
	inputY = (inputY-screen)*data.height
	M.planks[#M.planks+1] = display.newImageRect(sceneGroup,"platformAsset/ice.png",data.plankWidth,data.plankHeight)
	M.planks[#M.planks].x        = inputX
	M.planks[#M.planks].y        = inputY
	M.planks[#M.planks].force    = data.basicPlankForce
	M.planks[#M.planks].myName   = "plank"
	M.planks[#M.planks].collType = "passthrough"
	physics.addBody(M.planks[#M.planks],"static",{bounce = 0,friction = 0})
	camera:add(M.planks[#M.planks],1)

	M.timer[#M.timer+1] = timer.performWithDelay(1000*1.6,randomListener,-1)
	M.timer[#M.timer].param = {obj = M.planks[#M.planks]}
end

function M.plankBlock(camera,sceneGroup,screen,inputX,inputY)
	inputX = inputX*data.width
	inputY = (inputY-screen)*data.height
	M.planks[#M.planks+1] = display.newRoundedRect(sceneGroup,0,0,data.plankWidth,data.plankHeight*3/4,data.plankCornerRadius)
	M.planks[#M.planks]:setFillColor(0,0,0)
	M.planks[#M.planks].x        = inputX
	M.planks[#M.planks].y        = inputY
	M.planks[#M.planks].myName   = "plank"
	M.planks[#M.planks].type     = "block"
	M.planks[#M.planks].collType = "block"
	M.planks[#M.planks].force    = data.basicPlankForce
	physics.addBody(M.planks[#M.planks],"static",{bounce=0,friction=0})
	camera:add(M.planks[#M.planks],1)
end

return M