local composer = require("composer")

local scene = composer.newScene()

local button = require("src.components.button")

local images = {}

local yearsText = {}

local deadsText = {}

local points = {}

local currentIndex = 1

local function changePeriod(index)
    
    for i = 1, #images do
        images[i].isVisible = false
    end

    images[index].isVisible = true

    for i = 1, #yearsText do
        yearsText[i].isVisible = false
    end

    yearsText[index].isVisible = true

    for i = 1, #deadsText do
        deadsText[i].isVisible = false
    end

    deadsText[index].isVisible = true
end

local function timePoint(sceneGroup, x, y, index)
    local point = display.newCircle(sceneGroup, x, y, 10)
    point:setFillColor(1, 0, 0)
    point.index = index
    table.insert(points, point)
end

local function onChangeTime(e)

    local marker = e.target

    if e.phase == "began" then
        display.getCurrentStage():setFocus(marker)
        marker.isFocus = true
    elseif e.phase == "moved" then
        
        if e.x >= points[1].x and e.x <= points[#points].x then
            marker.x = e.x
        end
    elseif e.phase == "ended" or e.phase == "cancelled" then
        
        local closestPoint = points[1]
        for i = 1, #points do
            if math.abs(marker.x - points[i].x) < math.abs(marker.x - closestPoint.x) then
                closestPoint = points[i]
            end
        end
        
        
        marker.x = closestPoint.x
        currentIndex = closestPoint.index
        changePeriod(currentIndex)
        
        display.getCurrentStage():setFocus(nil)
        marker.isFocus = false
    end
    return true
end

function scene:create(event)
    local sceneGroup = self.view
    
    local capa = display.newImageRect(sceneGroup, "src/assets/pages/pag2.png", 768, 1024)
    capa.x = display.contentCenterX
    capa.y = display.contentCenterY

    local timeline = display.newRect(sceneGroup, display.contentCenterX, display.contentCenterY + 260, 600, 10)
    timeline:setFillColor(255, 0, 0)

    local startX = timeline.x - (timeline.width / 2)
    local gap = timeline.width / 4
    for i = 1, 5 do
        timePoint(sceneGroup, startX + (gap * (i - 1)), timeline.y, i)
    end

    images[1] = display.newImageRect(sceneGroup, "src/assets/page2/atenas.png", 248, 132)
    images[2] = display.newImageRect(sceneGroup, "src/assets/page2/europa.png", 248, 132)
    images[3] = display.newImageRect(sceneGroup, "src/assets/page2/continente.png", 248, 132)
    images[4] = display.newImageRect(sceneGroup, "src/assets/page2/africa.png", 248, 132)
    images[5] = display.newImageRect(sceneGroup, "src/assets/page2/china.png", 248, 132)


    yearsText[1] = display.newText(sceneGroup, "430 - 427 a.C", display.contentCenterX - 300, display.contentCenterY + 230, native.systemFont, 24)
    yearsText[2] = display.newText(sceneGroup, "1347 - 1353", display.contentCenterX - 150, display.contentCenterY + 230, native.systemFont, 24)
    yearsText[3] = display.newText(sceneGroup, "1918 - 1919", display.contentCenterX , display.contentCenterY + 230, native.systemFont, 24)
    yearsText[4] = display.newText(sceneGroup, "2013 - 2016", display.contentCenterX + 150, display.contentCenterY + 230, native.systemFont, 24)
    yearsText[5] = display.newText(sceneGroup, "2020 - 2021", display.contentCenterX + 300, display.contentCenterY + 230, native.systemFont, 24)

    deadsText[1] = display.newText(sceneGroup, "35% da população de Atenas foi morta", display.contentCenterX - 300, display.contentCenterY + 380, 150, 200, native.systemFont, 24)
    deadsText[2] = display.newText(sceneGroup, "50 milhões de pessoas foram mortas na Europa", display.contentCenterX - 150, display.contentCenterY + 380, 150, 200, native.systemFont, 24)
    deadsText[3] = display.newText(sceneGroup, "50 milhões de pessoas foram mortas em todos os continentes", display.contentCenterX , display.contentCenterY + 380, 150, 200, native.systemFont, 24)
    deadsText[4] = display.newText(sceneGroup, "Último surto epidêmico, cerca de 12 mil pessoas faleceram", display.contentCenterX + 150, display.contentCenterY + 380, 150, 200, native.systemFont, 24)
    deadsText[5] = display.newText(sceneGroup, "Quase 7 milhões de pessoas foram mortas pelo vírus", display.contentCenterX + 300, display.contentCenterY + 380, 150, 200, native.systemFont, 24)
    
    
    images[1].x = display.contentCenterX
    images[1].y = display.contentCenterY + 350

    images[2].x = display.contentCenterX + 100
    images[2].y = display.contentCenterY + 350

    images[3].x = display.contentCenterX + 200
    images[3].y = display.contentCenterY + 350

    images[4].x = display.contentCenterX - 100
    images[4].y = display.contentCenterY + 350

    images[5].x = display.contentCenterX
    images[5].y = display.contentCenterY + 350
    
    for i = 1, #yearsText do
        yearsText[i]:setFillColor(0,0,0)
    end

    for i = 1, #deadsText do
        deadsText[i]:setFillColor(0,0,0)
    end
    

    changePeriod(1)

    local marker = display.newCircle(sceneGroup, points[1].x, timeline.y, 15)
    marker:setFillColor(0, 0, 1)

    marker:addEventListener("touch", onChangeTime)

    local nextBtn = button.new(
        display.contentCenterX + 300,
        display.contentCenterY + 480,
        "src/assets/controllers/nextButton.png",
        function()
            composer.gotoScene("src.pages.page3")
        end
    )
    sceneGroup:insert(nextBtn)

    local backBtn = button.new(
        display.contentCenterX + -300,
        display.contentCenterY + 480,
        "src/assets/controllers/backButton.png",
        function()
            composer.gotoScene("src.pages.page1")
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