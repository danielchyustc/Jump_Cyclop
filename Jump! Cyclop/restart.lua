local composer = require"composer"
local widget   = require"widget"
local Width    = display.contentWidth
local Height   = display.contentHeight
local scene    = composer.newScene()
local sceneGroup

function scene:create( event )
	sceneGroup = self.view
	local Name = composer.getSceneName("previous")
	composer.gotoScene(Name)
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
		composer.removeScene("restart")
	end
end

function scene:destroy( event )
	sceneGroup = self.view
end

scene:addEventListener( "create", scene )
scene:addEventListener( "show",   scene )
scene:addEventListener( "hide",   scene )
scene:addEventListener( "destroy",scene )

return scene