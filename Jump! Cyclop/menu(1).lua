local composer = require( "composer" )
local scene = composer.newScene()
local widget = require "widget"
local myData = require("myData")
local sound    = require"module_sound"
local loadsave=require("loadsave")
local levels=loadsave.loadTable("levels.json",system.DocumentsDirectory)
local levelDif=loadsave.loadTable("levelDif.json",system.DocumentsDirectory)
local k = loadsave.loadTable("k.json",system.DocumentsDirectory)
local playBtn={}
local playBtnBG={}
local playBtnNumber={}
local backButton

-- ScrollView listener
local function scrollListener( event )
 
    local phase = event.phase
    if ( phase == "began" ) then print( "Scroll view was touched" )
    elseif ( phase == "moved" ) then print( "Scroll view was moved" )
    elseif ( phase == "ended" ) then print( "Scroll view was released" )
    end

    return true
end


local bgImage={}
local imageSizeR={
	{width=255/476,height=221/476},
	{width=620/1116,height=496/1116},
	{width=284/601,height=317/601},
	{width=211/402,height=191/402},
	{width=306/541,height=235/541},
	{width=222/349,height=127/349},
}
local function createBackground( ... )
	
	local rightCount=math.random(3,5)
	for i=1,rightCount do 
		local index=math.random(1,6)
		bgImage[#bgImage+1]=display.newImageRect("assets/"..index.."R.png",
										myData.width*0.8*imageSizeR[index].width,
										myData.width*0.8*imageSizeR[index].height)
		bgImage[#bgImage].anchorX=1
		bgImage[#bgImage].x=myData.width
		bgImage[#bgImage]:setFillColor( 1,1,1,0.3 )
		bgImage[#bgImage].y=math.random(0,myData.height*2)
		scrollView:insert( bgImage[#bgImage])
	end 

	local leftCount=math.random(3,5)
	for i=1,leftCount do 
		local index=math.random(1,6)
		bgImage[#bgImage+1]=display.newImageRect("assets/"..index.."L.png",
										myData.width*0.8*imageSizeR[index].width,
										myData.width*0.8*imageSizeR[index].height)
		bgImage[#bgImage].anchorX=0
		bgImage[#bgImage].x=0
		bgImage[#bgImage]:setFillColor( 1,1,1,0.3 )
		bgImage[#bgImage].y=math.random(0,myData.height*2)
		scrollView:insert( bgImage[#bgImage])
	end




end


function scene:create( event )
	local sceneGroup = self.view
	local function back( event )
		if event.phase == "ended" then
			composer.gotoScene("enter")
		end
	end
	scrollView = widget.newScrollView(
	    {
	        top = 0,
	        left = 0,
	        width = myData.width,
	        height = myData.height,
	        scrollWidth = myData.width,
	        scrollHeight = myData.height*2,
	        horizontalScrollDisabled=true,
	        backgroundColor={100/255,149/255,247/255},
	        listener = scrollListener
	    }
	)
	sceneGroup:insert(scrollView)

	local function playBtnTouch( event )
		if event.phase=="began" then 
			print("button clicked")
			transition.to(event.target.bg,{alpha=1,xScale=1,yScale=1,time=500})
		elseif  event.phase=="moved" then 
			print("button clicked")
			transition.to(event.target.bg,{alpha=0,xScale=0.1,yScale=0.1,time=500})
		elseif  event.phase=="ended" then
			transition.to(event.target.bg,{alpha=1,xScale=20,yScale=20,time=1000})
			local function easy( event )
				if event.phase == "ended" then
					levelDif[event.target.level] = 1
					loadsave.saveTable(levelDif,"levelDif.json",system.DocumentsDirectory)
					composer.gotoScene("level"..event.target.level)
				end
			end
			local function hard( event )
				if event.phase == "ended" then
					levelDif[event.target.level] = 2
					loadsave.saveTable(levelDif,"levelDif.json",system.DocumentsDirectory)
					composer.gotoScene("level"..event.target.level)
				end
			end
			local alterRect = display.newRoundedRect(sceneGroup,data.width/2,data.height*0.48,data.width*0.5,data.height*0.26,data.width*0.04)
			local text = display.newText(sceneGroup,data.level[k[3]]..event.target.level,data.width/2,data.height*0.38,nil,20)
			text:setFillColor(1,0,0)
			alterRect:setFillColor(1,1,1,0.5)
			local easyButton = widget.newButton({
				width = data.width*0.4,
				height  = data.height*0.08,
				x = data.width*0.5,
				y = data.height*0.45,
				shape = "roundedRect",
				fillColor = {default = {1,1,1,0.8}, over = {1,1,1,0.8}},
				label = data.EASY[k[3]],
				labelColor = {default = {0,0,0}, over = {0,0,0}},
				onEvent = easy
				})
			sceneGroup:insert(easyButton)
			local hardButton = widget.newButton({
				width = data.width*0.4,
				height  = data.height*0.08,
				x = data.width*0.5,
				y = data.height*0.55,
				shape = "roundedRect",
				fillColor = {default = {1,1,1,0.8}, over = {1,1,1,0.8}},
				label = data.HARD[k[3]],
				labelColor = {default = {0,0,0}, over = {0,0,0}},
				onEvent = hard
				})
			sceneGroup:insert(hardButton)
		else 
			transition.to(event.target.bg,{alpha=0,xScale=0.1,yScale=0.1,time=500})
		end 
		return true
	end

	createBackground()

	for i=1,10 do 
		playBtn[i]=display.newCircle( sceneGroup, myData.width*0.5, myData.height*0.1, myData.width*0.1 )
		playBtn[i].y=myData.height*0.1+myData.width*0.3*(i-1)
		playBtn[i]:setFillColor( 0,0,0,0.1 )
		playBtn[i].strokeWidth=2
		playBtn[i]:setStrokeColor( 1,1,1 )
		scrollView:insert(playBtn[i])
		playBtn[i].level=i

		playBtnNumber[i]=display.newText( sceneGroup,i, myData.width*0.5, myData.height*0.1,myData.textFont,myData.width*0.15)
		playBtnNumber[i].y=playBtn[i].y
		playBtnNumber[i].x=playBtn[i].x
		playBtnNumber[i]:setFillColor( 1,1,1,1 )
		scrollView:insert(playBtnNumber[i])

		playBtnBG[i]=display.newCircle( sceneGroup, myData.width*0.5, myData.height*0.1, myData.width*0.1 )
		playBtnBG[i].y=myData.height*0.1+myData.width*0.3*(i-1)
		playBtnBG[i]:setFillColor( 1,1,1,1 )

		if levels[i]==false then
			playBtnBG[i].xScale=1
			playBtnBG[i].yScale=1
			playBtnBG[i].alpha=0.9
		else
			playBtnBG[i].xScale=0.1
			playBtnBG[i].yScale=0.1
			playBtnBG[i].alpha=0
			playBtn[i].bg=playBtnBG
			playBtn[i]:addEventListener("touch",playBtnTouch)
		end

		scrollView:insert(playBtnBG[i])

	end 

	for i=1,10 do 
		playBtnBG[i]:toFront( )
	end 
	scrollView:setScrollHeight( myData.height*2 )

	backButton = widget.newButton({
				width = myData.width*0.22,
				height  = myData.width*0.12,
				x = myData.width*0.13,
				y = myData.width*0.12,
				shape = "roundedRect",
				fillColor = {default = {0,0,1,0.4}, over = {0,0,1,0.6}},
				label = myData.BACK[k[3]],
				labelColor = {default = {0,0,0}, over = {0,0,0}},
				onEvent = back
				})
	sceneGroup:insert(backButton)

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
		composer.removeScene("menu")
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	package.loaded["widget"] = nil
	package.loaded["SammyData"] = nil
	package.loaded["loadsave"] = nil
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