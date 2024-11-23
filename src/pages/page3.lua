local composer = require("composer")

local scene = composer.newScene()

local button = require("src.components.button")

local currentIndex = 1

local images = {}

local audioHandle
local isPlaying = false

local backgroundMusic = audio.loadStream("src/assets/sounds/page3.mp3")

local function toggleAudio()
    if isPlaying == true then
        audio.stop(audioHandle)    
        backgroundMusic = nil
        isPlaying = false
    else
        backgroundMusic = audio.loadStream("src/assets/sounds/page3.mp3")
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

local function resetScene()
    for i = 1, #images do
        images[i].isVisible = false
    end
    
    images[1].isVisible = true
end

local function onShake(e)
    
    if math.abs(e.xInstant) > 1 or math.abs(e.yInstant) > 1 then
        
        if currentIndex < #images then
            currentIndex = currentIndex + 1
        else
            currentIndex = 1
        end
        changeImage(scene.view, currentIndex)
    end
end

function scene:create(event)
    local sceneGroup = self.view
    
    local capa = display.newImageRect(sceneGroup, "src/assets/pages/pag3.png", 768, 1024)
    capa.x = display.contentCenterX
    capa.y = display.contentCenterY

    images[1] = display.newImageRect(sceneGroup, "src/assets/page3/multidao.png", 425, 425)
    images[2] = display.newImageRect(sceneGroup, "src/assets/page3/separados.png", 425, 425)

    for i = 1, #images do
        images[i].x = display.contentCenterX
        images[i].y = display.contentCenterY + 180
        images[i].isVisible = false
    end

    changeImage(sceneGroup, currentIndex)
    
    local nextBtn = button.new(
        display.contentCenterX + 300,
        display.contentCenterY + 480,
        "src/assets/controllers/nextButton.png",
        function()
            composer.gotoScene("src.pages.page4")
        end
    )
    sceneGroup:insert(nextBtn)

    local backBtn = button.new(
        display.contentCenterX + -300,
        display.contentCenterY + 480,
        "src/assets/controllers/backButton.png",
        function()
            composer.gotoScene("src.pages.page2")
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

    Runtime:addEventListener("accelerometer", onShake)
   
end

function scene:destroy(event)
    Runtime:removeEventListener("accelerometer", onShake)
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
        audio.stop(audioHandle) 
        isPlaying = false 
    end
end

scene:addEventListener("show", scene)
scene:addEventListener("create", scene)
scene:addEventListener("destroy", scene)
scene:addEventListener("hide", scene)

return scene