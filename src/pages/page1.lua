system.activate("multitouch")

local composer = require("composer")

local scene = composer.newScene()

local button = require("src.components.button")

local images = {}

local currentIndex = 1

local audioHandle
local isPlaying = false

local backgroundMusic = audio.loadStream("src/assets/sounds/page1.mp3")

local function toggleAudio()
    if isPlaying == true then
        audio.stop(audioHandle)    
        backgroundMusic = nil
        isPlaying = false
    else
        backgroundMusic = audio.loadStream("src/assets/sounds/page1.mp3")
        audioHandle = audio.play(backgroundMusic)
        isPlaying = true
        
    end
end

local function changeImage(sceneGroup, index)

    for i = 1, #images do
        images[i].isVisible = false
    end

    images[index].isVisible = true
end

local ball

local function onPinch(e)

    if e.phase == "moved" then
        local dx = math.abs(e.x - e.xStart)
        local dy = math.abs(e.y - e.yStart)

        

        if dx > 10 and dy > 10 then
            
            if e.scale > 1.1 then
                ball.isVisible = true
                if currentIndex < #images then
                    currentIndex = currentIndex + 1
                end
    
                changeImage(scene.view, currentIndex)
            elseif e.scale < 0.9 then
                if currentIndex > 1 then
                    currentIndex = currentIndex - 1
                end
    
                changeImage(scene.view, currentIndex)
            end
        end
    elseif e.phase == "ended" or e.phase == "cancelled" then
        -- Esconde a bola vermelha quando o gesto termina
        ball.isVisible = false
    end

    return true
end 

-- local function onKeyPress(event)
--     if event.phase == "down" then
--         if event.keyName == "up" then
      
--             if currentIndex < #images then
--                 currentIndex = currentIndex + 1
--             end

--             changeImage(scene.view, currentIndex)
--         elseif event.keyName == "down" then

--             if currentIndex > 1 then
--                 currentIndex = currentIndex - 1
--             end

--             changeImage(scene.view, currentIndex)
--         end
--     end
--     return true
-- end

local function resetScene()
    for i = 1, #images do
        images[i].isVisible = false
    end
    
    images[1].isVisible = true
end


function scene:create(event)
    local sceneGroup = self.view
    
    local capa = display.newImageRect(sceneGroup, "src/assets/pages/Pag1.png", 768, 1024)
    capa.x = display.contentCenterX
    capa.y = display.contentCenterY

    images[1] = display.newImageRect(sceneGroup,"src/assets/page1/pandemia.png",425,425)
    images[2] = display.newImageRect(sceneGroup,"src/assets/page1/epidemia.png",425,425)
    images[3] = display.newImageRect(sceneGroup,"src/assets/page1/endemia.png",425,425)
    
    for i = 1, #images do
        images[i].x = display.contentCenterX
        images[i].y = display.contentCenterY + 210
        images[i].isVisible = false
    end

    changeImage(sceneGroup,currentIndex)

    local nextBtn = button.new(
        display.contentCenterX + 300,
        display.contentCenterY + 480,
        "src/assets/controllers/nextButton.png",
        function()
            composer.gotoScene("src.pages.page2")
        end
    )
    sceneGroup:insert(nextBtn)

    local backBtn = button.new(
        display.contentCenterX + -300,
        display.contentCenterY + 480,
        "src/assets/controllers/backButton.png",
        function()
            composer.gotoScene("src.pages.capa")
        end
    )
    sceneGroup:insert(backBtn)

    local soundBtn = button.new(
        display.contentCenterX + 0,
        display.contentCenterY + 480,
        "src/assets/controllers/soundButton.png",
        toggleAudio
    )
    sceneGroup:insert(soundBtn)

    ball = display.newCircle(sceneGroup, display.contentWidth - 50, 50, 20)
    ball:setFillColor(0, 0, 1) -- Cor vermelha
    ball.isVisible = false

    Runtime:addEventListener("touch", onPinch)
   
end

function scene:destroy(event)
    Runtime:removeEventListener("touch", onPinch)
    audio.stop()
    audio.dispose(backgroundMusic)
    backgroundMusic = nil
end

function scene:show(event)
    if event.phase == "will" then
        resetScene()
    end
end

function scene:hide(event)
    if event.phase == "will" then
        audio.stop() 
        isPlaying = false 
    end
end

scene:addEventListener("show", scene)
scene:addEventListener("create", scene)
scene:addEventListener("destroy", scene)
scene:addEventListener("hide", scene)

return scene