RestDieGUID='9a4734'
RestDieLevel = 1
RestDieFaceOptions = { 1, 4, 6, 3 }
RestDieRotationOptions = {
    { x = 270, y = 0, z = 0 },
    { x = 0, y = 270, z = 90 },
    { x = 90, y = 180, z = 0 },
    { x = 0, y = 90, z = 270 }
}

playerColor = "White"


function onLoad()
    RestDieParams = {
        click_function = "rotateToNextFace",
        function_owner = self,
        label          = "Upgrade\nREST\ndie",
        position       = {-1.2, 0, 2.05},
        rotation       = {0, 0, 0},
        width          = 290,
        height         = 250,
        font_size      = 60,
        color          = {0, 0, 0},
        font_color     = {1, 1, 1},
        tooltip        = "",
    }
    self.createButton(RestDieParams)

    restDie = getObjectFromGUID(RestDieGUID)
    currentRotationIndex = 1
end

function rotateToNextFace()
    currentRotationIndex = currentRotationIndex + 1
    if currentRotationIndex > #RestDieFaceOptions then
        currentRotationIndex = 1
    end
    currentRotation = RestDieRotationOptions[currentRotationIndex]
    restDie.setRotationSmooth({currentRotation.x, currentRotation.y, currentRotation.z})
    --restDie.setRotationValue(RestDieFaceOptions[currentRotationIndex])
end

playerColor = "White"