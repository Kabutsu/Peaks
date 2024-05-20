RestGUID = "9a4734"
PrepareGUID = "7a4347"
ClimbGUID = "0902df"

local DieLevels = {
    REST = 1,
    PREPARE = 1,
    CLIMB = 1
}

local RotationOptions = {
    { x = 270, y = 90, z = 0 },
    { x = 0, y = 0, z = 90 },
    { x = 90, y = 270, z = 0 },
    { x = 0, y = 180, z = 270 }
}

local Dice = {
    { name = "REST", GUID = RestGUID, x = -1.2 },
    { name = "PREPARE", GUID = PrepareGUID, x = 0 },
    { name = "CLIMB", GUID = ClimbGUID, x = 1.2 }
}

local playerColor = "Red"
local playerColorRGB = {1, 1, 1}

function onLoad()
    for i = #Dice, 1, -1 do
        local die = Dice[i]
        local params = {
            click_function = "rotate" .. die.name,
            function_owner = self,
            label          = "Upgrade\n" .. die.name .. "\ndie",
            position       = {die.x, 0, 2.05},
            rotation       = {0, 0, 0},
            width          = 290,
            height         = 250,
            font_size      = 60,
            color          = {0, 0, 0},
            font_color     = {1, 1, 1},
            tooltip        = "",
        }
        self.createButton(params)
    end
end

local function informPlayer(message)
    broadcastToColor(
        message,
        playerColor,
        playerColorRGB)
end

local function rotateDie(dieName)
    DieLevels[dieName] = DieLevels[dieName] + 1

    if DieLevels[dieName] == #RotationOptions then
        informPlayer("\"" .. dieName .. "\" is fully upgraded!\nGain a flag.")
    elseif DieLevels[dieName] > #RotationOptions then
        DieLevels[dieName] = 1
    end

    local currentRotation = RotationOptions[DieLevels[dieName]]

    if dieName == "REST" then
        local restDie = getObjectFromGUID(Dice[1].GUID)
        restDie.setRotationSmooth({currentRotation.x, currentRotation.y, currentRotation.z})
    elseif dieName == "PREPARE" then
        local prepareDie = getObjectFromGUID(Dice[2].GUID)
        prepareDie.setRotationSmooth({currentRotation.x, currentRotation.y, currentRotation.z})
    elseif dieName == "CLIMB" then
        local climbDie = getObjectFromGUID(Dice[3].GUID)
        climbDie.setRotationSmooth({currentRotation.x, currentRotation.y, currentRotation.z})
    end
end

function rotateREST()
    rotateDie("REST")
end

function rotatePREPARE()
    rotateDie("PREPARE")
end

function rotateCLIMB()
    rotateDie("CLIMB")
end