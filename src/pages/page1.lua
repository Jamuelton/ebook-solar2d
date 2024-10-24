local composer = require("composer")

local scene = composer.newScene()

local button = require("src.components.button")

local images = {}

local currentIndex = 1

local function changeImage(sceneGroup, index)

    for i = 1, #images do
        images[i].isVisible = false
    end

    images[index].isVisible = true
end

-- local function onPinch(e)

--     if e.phase == "moved" then
--         local dx = math.abs(e.x - e.xStart)
--         local dy = math.abs(e.y - e.yStart)

--         if dx > 10 or dy > 10 then
--             if e.scale > 1.0 then
--                 if currenteIndex < #images then
--                     currenteIndex = currenteIndex + 1
--                 end
--
--                 changeImage(scene.view, currenteIndex)
--             elseif e.scale < 1.0 then
--                 if currenteIndex > 1 then
--                     currenteIndex = currenteIndex - 1    
--                 end
--
--                 changeImage(scene.view, currenteIndex)
--             end
--         end
--     end

--     return true
-- end 

local function onKeyPress(event)
    if event.phase == "down" then
        if event.keyName == "up" then
      
            if currentIndex < #images then
                currentIndex = currentIndex + 1
            end

            changeImage(scene.view, currentIndex)
        elseif event.keyName == "down" then

            if currentIndex > 1 then
                currentIndex = currentIndex - 1
            end

            changeImage(scene.view, currentIndex)
        end
    end
    return true
end


function scene:create(event)
    local sceneGroup = self.view
    
    local capa = display.newImageRect(sceneGroup, "src/assets/pages/pag1.png", 768, 1024)
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
        function()
            composer.gotoScene("src.pages.page1")
        end
    )
    sceneGroup:insert(soundBtn)

    Runtime:addEventListener("key", onKeyPress)
   
end

function scene:destroy(event)
    Runtime:removeEventListener("key", onKeyPress)
end

scene:addEventListener("create", scene)
scene:addEventListener("destroy", scene)

return scene