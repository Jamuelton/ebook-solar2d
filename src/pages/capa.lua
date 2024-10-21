local composer = require("composer")

local scene = composer.newScene()

local button = require("src.components.button")

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

    local lastBtn = button.new(
        display.contentCenterX + -300,
        display.contentCenterY + 480,
        "src/assets/controllers/lastButton.png",
        function()
            composer.gotoScene("src.pages.contraCapa")
        end
    )
    sceneGroup:insert(lastBtn)

    local soundBtn = button.new(
        display.contentCenterX + 0,
        display.contentCenterY + 480,
        "src/assets/controllers/soundButton.png",
        function()
            composer.gotoScene("src.pages.page1")
        end
    )
    sceneGroup:insert(soundBtn)
    
   
end

scene:addEventListener("create", scene)

return scene
