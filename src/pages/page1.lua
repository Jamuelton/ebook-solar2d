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
    if isPlaying then
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

local finger1, finger2
local initialDistance
local isZooming = false

local function calculateDistance(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end

local function onTouch(event)
    if event.phase == "began" then
        -- Registrar os toques iniciais como finger1 e finger2
        if not finger1 then
            finger1 = event
        elseif not finger2 then
            finger2 = event
            isZooming = true
            initialDistance = calculateDistance(finger1.x, finger1.y, finger2.x, finger2.y)
        end
    elseif event.phase == "moved" and isZooming then
        -- Atualizar a posição de finger1 e finger2 durante o movimento
        if finger1 and event.id == finger1.id then
            finger1 = event
        elseif finger2 and event.id == finger2.id then
            finger2 = event
        end

        -- Verificar se finger1 e finger2 estão definidos antes de calcular a distância
        if finger1 and finger2 then
            local currentDistance = calculateDistance(finger1.x, finger1.y, finger2.x, finger2.y)
            local scale = currentDistance / initialDistance

            -- Detectar o movimento de pinça
            if scale > 1.1 and currentIndex < #images then
                currentIndex = currentIndex + 1
                changeImage(scene.view, currentIndex)
            elseif scale < 0.9 and currentIndex > 1 then
                currentIndex = currentIndex - 1
                changeImage(scene.view, currentIndex)
            end

            initialDistance = currentDistance
        end
    elseif event.phase == "ended" or event.phase == "cancelled" then
        -- Limpar os toques quando o gesto termina
        if finger1 and event.id == finger1.id then
            finger1 = nil
        elseif finger2 and event.id == finger2.id then
            finger2 = nil
        end

        -- Desativar o zoom se um ou ambos os toques forem levantados
        if not finger1 or not finger2 then
            isZooming = false
        end
    end
    return true
end


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

    images[1] = display.newImageRect(sceneGroup, "src/assets/page1/pandemia.png", 425, 425)
    images[2] = display.newImageRect(sceneGroup, "src/assets/page1/epidemia.png", 425, 425)
    images[3] = display.newImageRect(sceneGroup, "src/assets/page1/endemia.png", 425, 425)

    for i = 1, #images do
        images[i].x = display.contentCenterX
        images[i].y = display.contentCenterY + 210
        images[i].isVisible = false
    end

    changeImage(sceneGroup, currentIndex)

    local nextBtn = button.new(
        display.contentCenterX + 300,
        display.contentCenterY + 480,
        "src/assets/controllers/nextButton.png",
        function()
            composer.gotoScene("src.pages.page2", { effect = "slideLeft", time = 800 })
        end
    )
    sceneGroup:insert(nextBtn)

    local backBtn = button.new(
        display.contentCenterX - 300,
        display.contentCenterY + 480,
        "src/assets/controllers/backButton.png",
        function()
            composer.gotoScene("src.pages.capa",{ effect = "slideRight", time = 800 })
        end
    )
    sceneGroup:insert(backBtn)

    local soundBtn = button.new(
        display.contentCenterX,
        display.contentCenterY + 480,
        "src/assets/controllers/soundButton.png",
        toggleAudio
    )
    sceneGroup:insert(soundBtn)

    Runtime:addEventListener("touch", onTouch)
end

function scene:destroy(event)
    Runtime:removeEventListener("touch", onTouch)
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