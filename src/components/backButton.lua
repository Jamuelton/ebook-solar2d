local backButton = {}

function backButton.new(onTapFunction)
    local buttonGroup = display.newGroup()

    
    local buttonImage = display.newImageRect(buttonGroup, "src/assets/controllers/backButton.png", 150, 39)
    buttonImage.x = display.contentCenterX + -300 
    buttonImage.y = display.contentCenterY + 480

    
    function buttonImage:tap()
        if onTapFunction then
            onTapFunction()
        end
    end
    buttonImage:addEventListener("tap", buttonImage)

    return buttonGroup
end

return backButton