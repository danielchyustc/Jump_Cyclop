local M={}
local myData=require("myData")
M.player=nil
local myAnimation
local function gameLoop()
	if M.player~=nil then
		myAnimation.x=M.player.x
		myAnimation.y=M.player.y
		local vx,vy=M.player:getLinearVelocity()
		if vy<0 then
			if M.player.isFalling==true then
				M.player.isFalling=false
				myAnimation:setSequence("jump")
				myAnimation:play()
			end
		elseif vy>0 then
			if M.player.isFalling==false then
				M.player.isFalling=true
				myAnimation:setSequence("fall")
				myAnimation:play()
			end
		end
		if vx>0 then
			myAnimation.xScale=0.4
		else
			myAnimation.xScale=-0.4
		end
	else
		Runtime:removeEventListener("enterFrame",gameLoop)
	end
end

function M.createPlayer(sceneGroup)
	M.player=display.newRect(sceneGroup,
							 myData.width*0.5,
							 myData.height*0.75,
							 myData.playerWidth,
							 myData.playerWidth)
	M.player:setFillColor(1,1,1,0)
	M.player.strokeWidth=2
	M.player:setStrokeColor(1,1,1,0)
	physics.addBody(M.player,"dynamic",{bounce=0,friction=0,density=1,radius=myData.playerWidth/2})
	M.player.myName="player"
	M.player.isFalling=true

	local sheetData1={width=508/7,height=96,numFrames=16,sheetContentWidth=508,sheetContentHeight=288}
	local sheet1=graphics.newImageSheet("playerAsset/player.png",sheetData1)
	local sequenceData={
					{name="fall",sheet=sheet1,start=8,count=3,time=200,loopCount=0},
					{name="jump",sheet=sheet1,start=1,count=4,time=400,loopCount=1},
					}
	myAnimation=display.newSprite(sheet1,sequenceData)
	myAnimation.x=0
	myAnimation.y=0
	myAnimation:setSequence("fall")
	myAnimation:play()
	sceneGroup:insert(myAnimation)

	if 96>=myData.width*0.08*1.5 then
		myAnimation.xScale=(myData.width*0.08*1.5)/96
		myAnimation.yScale=(myData.width*0.08*1.5)/96
	else
		myAnimation.xScale=96/(myData.width*0.08*1.5)
		myAnimation.yScale=96/(myData.width*0.08*1.5)	
	end

	M.myAnimation=myAnimation
	Runtime:addEventListener("enterFrame",gameLoop)	
end

function M.cleanUp()
	Runtime:removeEventListener("enterFrame",gameLoop)
end

return M