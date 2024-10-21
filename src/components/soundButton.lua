local soundButton = {}

function soundButton.new(onTapFunction)
    local buttonGroup = display.newGroup()

    
    local buttonImage = display.newImageRect(buttonGroup, "src/assets/controllers/soundButton.png", 150, 39)
    buttonImage.x = display.contentCenterX + 0 
    buttonImage.y = display.contentCenterY + 480

    
    function buttonImage:tap()
        if onTapFunction then
            onTapFunction()
        end
    end
    buttonImage:addEventListener("tap", buttonImage)

    return buttonGroup
end

return soundButton