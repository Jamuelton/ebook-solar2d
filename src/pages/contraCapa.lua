local composer = require("composer")

local scene = composer.newScene()

local button = require("src.components.button")

function scene:create(event)
    local sceneGroup = self.view
    
    local capa = display.newImageRect(sceneGroup, "src/assets/pages/contraCapa.png", 768, 1024)
    capa.x = display.contentCenterX
    capa.y = display.contentCenterY
    
    local firstBtn = button.new(
        display.contentCenterX + 300,
        display.contentCenterY + 480,
        "src/assets/controllers/firstButton.png",
        function()
            composer.gotoScene("src.pages.capa")
        end
    )
    sceneGroup:insert(firstBtn)

    local backBtn = button.new(
        display.contentCenterX + -300,
        display.contentCenterY + 480,
        "src/assets/controllers/backButton.png",
        function()
            composer.gotoScene("src.pages.page4")
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
   
end

scene:addEventListener("create", scene)

return scene