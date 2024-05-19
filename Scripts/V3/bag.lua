tileBagGuid = 'bb91e7'

function onLoad()
    setupParams = {
        click_function = "setup",
        function_owner = self,
        label          = "Setup",
        position       = {0, 0.5, -2.5},
        rotation       = {0, 180, 0},
        width          = 800,
        height         = 400,
        font_size      = 200,
        color          = {0, 0, 0},
        font_color     = {1, 1, 1},
        tooltip        = "",
    }
    self.createButton(setupParams)
end

function setup(obj, color, alt_click)
    restTileBag = getObjectFromGUID(tileBagGuid)
    restTileBag.shuffle()

--North America
    local takenRestTile = restTileBag.takeObject({
    position = {x = -10.6, y = 1.2, z = 2.7},rotation = {0, 180, 0}})
    takenRestTile.setLock(true)

--South America
    local takenRestTile = restTileBag.takeObject({
    position = {x = -7.4, y = 1.2, z = -3.1},rotation = {0, 180, 0}})
    takenRestTile.setLock(true)

--europe
    local takenRestTile = restTileBag.takeObject({
    position = {x = -4.8, y = 1.2, z = 3.6},rotation = {0, 180, 0}})
    takenRestTile.setLock(true)

--africa
    local takenRestTile = restTileBag.takeObject({
    position = {x = 1.3, y = 1.2, z = -1.2},rotation = {0, 180, 0}})
    takenRestTile.setLock(true)

--Asia
    local takenRestTile = restTileBag.takeObject({
    position = {x = 6.8, y = 1.2, z = 4},rotation = {0, 180, 0}})
    takenRestTile.setLock(true)

--oceania
    local takenRestTile = restTileBag.takeObject({
    position = {x = 2.9, y = 1.2, z = -3.7},rotation = {0, 180, 0}})
    takenRestTile.setLock(true)
end
