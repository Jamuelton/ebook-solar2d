local composer = require("composer")

local scene = composer.newScene()

local button = require("src.components.button")

local audioHandle
local isPlaying = false

local backgroundMusic = audio.loadStream("src/assets/sounds/capa.mp3")

local function toggleAudio()
    if isPlaying == true then
        print("chamou igual a true")
        print(isPlaying)
        audio.stop(audioHandle)    
        backgroundMusic = nil
        isPlaying = false
    else
        backgroundMusic = audio.loadStream("src/assets/sounds/capa.mp3")
        audioHandle = audio.play(backgroundMusic)
        isPlaying = true
        
    end
end

function scene:create(event)
    local sceneGroup = self.view
    
    local capa = display.newImageRect(sceneGroup, "src/assets/pages/Capa.png", 768, 1024)
    capa.x = display.contentCenterX
    capa.y = display.contentCenterY
    
    local nextBtn = button.new(
        display.contentCenterX + 300,
        display.contentCenterY + 480,
        "src/assets/controllers/nextButton.png",
        function()
            composer.gotoScene("src.pages.page1")
            
        end
    )
    sceneGroup:insert(nextBtn)

    local soundBtn = button.new(
        display.contentCenterX + 0,
        display.contentCenterY + 480,
        "src/assets/controllers/soundButton.png",
        toggleAudio
    )
    sceneGroup:insert(soundBtn)
    
   
end

function scene:destroy(e)
    audio.stop()
    audio.dispose(backgroundMusic)
    backgroundMusic = nil
end

function scene:hide(event)
    if event.phase == "will" then
        audio.stop(audioHandle) 
        isPlaying = false 
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("destroy", scene)
scene:addEventListener("hide", scene)

return scene
