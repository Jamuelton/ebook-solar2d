local composer = require("composer")

local scene = composer.newScene()

local button = require("src.components.button")

local labImage, scientistImage, parkImage, centralImage

local audioHandle
local isPlaying = false

local backgroundMusic = audio.loadStream("src/assets/sounds/page5.mp3")

local function toggleAudio()
    if isPlaying == true then
        audio.stop(audioHandle)    
        backgroundMusic = nil
        isPlaying = false
    else
        backgroundMusic = audio.loadStream("src/assets/sounds/page5.mp3")
        audioHandle = audio.play(backgroundMusic)
        isPlaying = true
        
    end
end


local function resetScene()
    labImage.isVisible = true
    scientistImage.isVisible = true
    parkImage.isVisible = true

    if centralImage then
        centralImage:removeSelf()
        centralImage = nil
    end
end

local function changeImage(image)

    labImage.isVisible = false
    scientistImage.isVisible = false
    parkImage.isVisible = false

    if centralImage then
        centralImage:removeSelf()
        centralImage = nil
    end

    centralImage = display.newImageRect(scene.view, image, 681, 265)
    centralImage.x, centralImage.y = display.contentCenterX, display.contentCenterY + 310
    centralImage:addEventListener("touch", resetScene)
end

local function onTouch(event)
    if event.phase == "ended" then
        if event.target == labImage then
            changeImage("src/assets/page5/cientistaLab.png") 
        elseif event.target == parkImage then
            changeImage("src/assets/page5/cientistaParque.png") 
        end
    end
    return true
end



function scene:create(event)
    local sceneGroup = self.view
    
    local capa = display.newImageRect(sceneGroup, "src/assets/pages/Pag5.png", 768, 1024)
    capa.x = display.contentCenterX
    capa.y = display.contentCenterY

    labImage = display.newImageRect(sceneGroup, "src/assets/page5/laboratorio.png", 200, 162)
    labImage.x, labImage.y = display.contentCenterX - 250, display.contentCenterY + 300
    labImage:addEventListener("touch", onTouch)

    scientistImage = display.newImageRect(sceneGroup, "src/assets/page5/cientistas.png", 125, 249)
    scientistImage.x, scientistImage.y = display.contentCenterX, display.contentCenterY + 300

    parkImage = display.newImageRect(sceneGroup, "src/assets/page5/parque.png", 200, 162)
    parkImage.x, parkImage.y = display.contentCenterX + 250, display.contentCenterY + 300
    parkImage:addEventListener("touch", onTouch)
    
    local nextBtn = button.new(
        display.contentCenterX + 300,
        display.contentCenterY + 480,
        "src/assets/controllers/nextButton.png",
        function()
            composer.gotoScene("src.pages.contraCapa", { effect = "slideLeft", time = 800 })
        end
    )
    sceneGroup:insert(nextBtn)

    local backBtn = button.new(
        display.contentCenterX + -300,
        display.contentCenterY + 480,
        "src/assets/controllers/backButton.png",
        function()
            composer.gotoScene("src.pages.page4",{ effect = "slideRight", time = 800 })
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
   
end

function scene:show(event)
    if event.phase == "will" then
        resetScene()
    end
end

function scene:destroy(e)
    audio.stop()
    audio.dispose(backgroundMusic)
    backgroundMusic = nil
end

function scene:hide(event)
    if event.phase == "will" then
        audio.stop() 
        isPlaying = false 
    end
end

scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("destroy", scene)
scene:addEventListener("hide", scene)

return scene