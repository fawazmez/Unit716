-----------------------------------------------------------------------------------------
--
-- gameScene.lua
--
-- Created By: Amin Zeina 
-- Created On: May 2018
-----------------------------------------------------------------------------------------
local composer = require( "composer" )
local physics = require( "physics" )
local json = require( "json" )
local tiled = require( "com.ponywolf.ponytiled" )

local scene = composer.newScene()

-- Forward reference
local ninjaBoy = nil
local map = nil
local rightArrow = nil

-- Function to chaneg sequence 

local function onRightArrowClicked( event )
    if ( event.phase == "began" ) then 
        if ninjaBoy.sequence ~= "run" then 
            ninjaBoy.sequence = "run"
            ninjaBoy:setSequence( "runBoy" )
            ninjaBoy:play()
        end    
    
    elseif ( event.phase == "ended" ) then   
        if ninjaBoy.sequence ~= "idle" then 
            ninjaBoy.sequence = "idle"
            ninjaBoy:setSequence( "idleBoy" )
            ninjaBoy:play()
        end 
    end 
    
    return true    
end

-- move ninja
local function moveNinjaRight( event )
    if ninjaBoy.sequence == "runBoy" then
        transition.moveBy( ninjaBoy, {
            x = 10,
            y = 0,
            time = 0
            } )
    end     
    
    return true
end

-- create()
function scene:create( event )
 
    local sceneGroup = self.view

    physics.start()
	physics.setGravity( 0, 20 )

    -- show map 
    local filename = "assets/maps/level0.json"
    local mapData = json.decodeFile( system.pathForFile( filename, system.ResourceDirectory ) )
    map = tiled.new( mapData, "assets/maps" )

    local sheetOptionsIdleBoy = require( "assets.spritesheets.ninjaBoy.ninjaBoyIdle" )
    local sheetBoyIdle = graphics.newImageSheet( "./assets/spritesheets/ninjaBoy/ninjaBoyIdle.png", sheetOptionsIdleBoy:getSheet() )

    local sheetOptionsRunBoy = require( "assets.spritesheets.ninjaBoy.ninjaBoyRun" )
    local sheetBoyRun = graphics.newImageSheet( "./assets/spritesheets/ninjaBoy/ninjaBoyRun.png", sheetOptionsRunBoy:getSheet() )

    local sheetOptionsJumpBoy = require( "assets.spritesheets.ninjaBoy.ninjaBoyJump" )
    local sheetBoyJump = graphics.newImageSheet( "./assets/spritesheets/ninjaBoy/ninjaBoyJump.png", sheetOptionsJumpBoy:getSheet() )

    local sheetOptionsThrowBoy = require( "assets.spritesheets.ninjaBoy.ninjaBoyThrow" )
    local sheetBoyThrow = graphics.newImageSheet( "./assets/spritesheets/ninjaBoy/ninjaBoyThrow.png", sheetOptionsThrowBoy:getSheet() )
    
    local sequence_data = {
        {
            name = "idleBoy",
            start = 1, 
            count = 10,
            time = 800, 
            loopCount = 0,
            sheet = sheetBoyIdle
        },
        {
            name = "runBoy",
            start = 1, 
            count = 10,
            time = 800, 
            loopCount = 0,
            sheet = sheetBoyRun
        },
        {
            name = "jumpBoy",
            start = 1, 
            count = 10,
            time = 800, 
            loopCount = 0,
            sheet = sheetBoyJump
        },
        {
            name = "throwBoy",
            start = 1, 
            count = 10,
            time = 800, 
            loopCount = 0,
            sheet = sheetBoyThrow
        }
    }


    -- show ninjaBoy
    ninjaBoy = display.newSprite( sheetBoyIdle, sequence_data )
    ninjaBoy.x = display.contentWidth / 2 
    ninjaBoy.y = 0
    ninjaBoy.sequence = "idle"
    ninjaBoy.isFixedRotation = true
    ninjaBoy.id = "ninja Boy"
    physics.addBody( ninjaBoy, "dynamic", { 
        friction = 0.5, 
        bounce = 0.3 
        } )
    ninjaBoy:setSequence( "idleBoy" )
    ninjaBoy:play()

    rightArrow = display.newImage( "./assets/sprites/rightButton.png" )
    rightArrow.x = 300
    rightArrow.y = 1300
    rightArrow.id = "right Arrow"
    rightArrow.alpha = 0.7

    sceneGroup:insert( map )
    sceneGroup:insert( ninjaBoy )
    sceneGroup:insert( rightArrow )

end

-- show()
function scene:show( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
	 
    elseif ( phase == "did" ) then
        rightArrow:addEventListener( "touch", onRightArrowClicked )
        Runtime:addEventListener( "enterFrame", moveNinjaRight )
 
    end
end
 
 
-- hide()
function scene:hide( event )
 
    local sceneGroup = self.view
    local phase = event.phase
 
    if ( phase == "will" ) then
        -- Code here runs when the scene is on screen (but is about to go off screen)
 
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen
        rightArrow:removeEventListener( "touch", onRightArrowClicked )
        Runtime:removeEventListener( "enterFrame", moveNinjaRight )
    end
end
 
 
-- destroy()
function scene:destroy( event )
 
    local sceneGroup = self.view
    -- Code here runs prior to the removal of scene's view
 
end
 
 
-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------
 
return scene