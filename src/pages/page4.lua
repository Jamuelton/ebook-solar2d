local composer = require("composer")

local scene = composer.newScene()

local physics = require("physics")

local button = require("src.components.button")

local isMoving = false

local audioHandle
local isPlaying = false

local backgroundMusic = audio.loadStream("src/assets/sounds/page4.mp3")

local function toggleAudio()
    if isPlaying == true then
        audio.stop(audioHandle)    
        backgroundMusic = nil
        isPlaying = false
    else
        backgroundMusic = audio.loadStream("src/assets/sounds/page4.mp3")
        audioHandle = audio.play(backgroundMusic)
        isPlaying = true
        
    end
end



physics.start()
physics.setGravity(0, 0)

local infect
local people = {}
local locations = {}

local minX, maxX = 50, display.contentWidth - 50 
local minY, maxY = display.contentCenterY + 50, display.contentHeight - 100 

local function moveInfect()
    if not isMoving then return end
    local randomX = math.random(minX, maxX)
    local randomY = math.random(minY, maxY)
    transition.to(infect, {
        x = randomX,
        y = randomY,
        time = 1500,
        onComplete = moveInfect
    })
end

local function onCollide(event)
    if event.phase == "began" then
        local obj1 = event.object1
        local obj2 = event.object2

        
        if (obj1 == infect and obj2.isPerson) or (obj2 == infect and obj1.isPerson) then
            local person = obj1.isPerson and obj1 or obj2
            person.fill = { type = "image", filename = "src/assets/page4/infectado.png"}
            person.isPerson = false 

        
        elseif (obj1 == infect and obj2.isLocation) or (obj2 == infect and obj1.isLocation) then
            local location = obj1.isLocation and obj1 or obj2

            
            if location.name == "school" then
                location.fill = { type = "image", filename = "src/assets/page4/escolafechado.png" }
            elseif location.name == "hospital" then
                location.fill = { type = "image", filename = "src/assets/page4/hospitalfechado.png" }
            elseif location.name == "market" then
                location.fill = { type = "image", filename = "src/assets/page4/mercadofechado.png" }
            end

            location.isLocation = false
        end
    end
end

local function resetScene()
   
    for _, person in ipairs(people) do
        person.fill = {type = "image" , filename = "src/assets/page4/normal.png" }
        person.isPerson = true
    end

   
    for _, location in ipairs(locations) do
        if location.name == "school" then
            location.fill = { type = "image", filename = "src/assets/page4/escolaaberto.png" }
        elseif location.name == "hospital" then
            location.fill = { type = "image", filename = "src/assets/page4/hospitalaberto.png" }
        elseif location.name == "market" then
            location.fill = { type = "image", filename = "src/assets/page4/mercadoaberto.png" }
        end
        location.isLocation = true 
    end

    
    infect.x, infect.y = display.contentCenterX, display.contentCenterY + 300
end



local function startMovement(event)
    if event.phase == "began" and not isMoving then
        isMoving = true 
        moveInfect()
        
    end
    return true 
end

print(isMoving)

function scene:create(event)
    local sceneGroup = self.view
    
    local capa = display.newImageRect(sceneGroup, "src/assets/pages/pag4.png", 768, 1024)
    capa.x = display.contentCenterX
    capa.y = display.contentCenterY

    infect = display.newImageRect(sceneGroup,"src/assets/page4/infectado.png",30,50 )
    infect.x, infect.y = display.contentCenterX, display.contentCenterY + 300
    physics.addBody(infect, "dynamic", { radius = 15 })
    infect.isFixedRotation = true
    infect.isSensor = true

    infect:addEventListener("touch", startMovement)

    for i = 1, 10 do
        local person = display.newImageRect(sceneGroup, "src/assets/page4/normal.png", 30, 50)
        person.x, person.y = math.random(minX, maxX), math.random(minY, maxY)
        physics.addBody(person, "static", { radius = 15 })
        person.isPerson = true
        table.insert(people, person)
    end

    local school = display.newImageRect(sceneGroup, "src/assets/page4/escolaaberto.png", 120, 120)
    school.x, school.y = display.contentCenterX + 300, display.contentCenterY + 380 
    school.name = "school"
    school.isLocation = true
    physics.addBody(school, "static")
    table.insert(locations, school)

    local hospital = display.newImageRect(sceneGroup, "src/assets/page4/hospitalaberto.png", 120, 120)
    hospital.x, hospital.y = display.contentCenterX - 300, display.contentCenterY + 380 
    hospital.name = "hospital"
    hospital.isLocation = true
    physics.addBody(hospital, "static")
    table.insert(locations, hospital)

    local market = display.newImageRect(sceneGroup, "src/assets/page4/mercadoaberto.png", 120, 120)
    market.x, market.y = display.contentCenterX , display.contentCenterY + 100
    market.name = "market"
    market.isLocation = true
    physics.addBody(market, "static")
    table.insert(locations, market)

    moveInfect()

    Runtime:addEventListener("collision", onCollide)
    
    local nextBtn = button.new(
        display.contentCenterX + 300,
        display.contentCenterY + 480,
        "src/assets/controllers/nextButton.png",
        function()
            composer.gotoScene("src.pages.page5")
        end
    )
    sceneGroup:insert(nextBtn)

    local backBtn = button.new(
        display.contentCenterX + -300,
        display.contentCenterY + 480,
        "src/assets/controllers/backButton.png",
        function()
            composer.gotoScene("src.pages.page3")
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

function scene:destroy(event)
    Runtime:removeEventListener("collision", onCollide)
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