restTileGUID = '469cb9'
prepareTileOneGUID = '48bac6'
prepareTileTwoGUID = '5aaa44'
climbTileOneGUID = '10abcb'
climbTileTwoGUID = 'ee7278'

restTileLevel = 0
prepareTileLevel = 0
climbTileLevel = 0

restSpinnerGUID = 'b80951'
prepareSpinnerGUID = 'ec6398'
climbSpinnerOneGUID = '87a855'
climbSpinnerTwoGUID = '4009a2'

restSpinnerOptions = { 2, 4, 6, 9 }
prepareSpinnerOptions = { 0, 1, 2, 3 }
climbSpinnerOptions = { { 1, 1 }, { 2, 2 }, { 3, 3 }, { 3, 1 } }
restSpinnerLevel = 1
prepareSpinnerLevel = 1
climbSpinnerLevel = 1

playerColor = "Blue"
mainButtonColor = { r=0, g=0.53, b=0.91 }
undoButtonColor = { r=0, g=0.33, b=0.71 }
buttonTextColor = { 1, 1, 1 }

mainButtonWidth = 380
mainButtonHeight = 140
mainButtonFontSize = 35

undoButtonWidth = 170
undoButtonHeight = 65
undoButtonFontSize = 28

fullUpgradeText = " is already fully upgraded"
fullDegradeText = " is already at its lowest level"

local function informPlayer(message)
	broadcastToColor(
		message,
		playerColor,
		mainButtonColor)
end

local function generateButton(actionName, upgradeType, buttonPosition, isMainButton)
	local buttonParams
	if isMainButton then
		buttonParams = {
			click_function = "upgrade" .. actionName .. upgradeType,
			function_owner = self,
			label = "Upgrade " .. actionName .. " " .. upgradeType,
			position = buttonPosition,
			rotation = {0, 0, 0},
			width = mainButtonWidth,
			height = mainButtonHeight,
			font_size = mainButtonFontSize,
			color = mainButtonColor,
			font_color = buttonTextColor
		}
	else
		buttonParams = {
			click_function = "downgrade" .. actionName .. upgradeType,
			function_owner = self,
			label = "(Undo)",
			position = buttonPosition,
			rotation = {0, 0, 0},
			width = undoButtonWidth,
			height = undoButtonHeight,
			font_size = undoButtonFontSize,
			color = undoButtonColor,
			font_color = buttonTextColor
		}
	end
	return buttonParams
end

local function moveTile(tile, moveAmount)
	local tileStartPosition = tile.getPosition()
	
	local newTilePosition = {
		x = tileStartPosition.x,
		y = tileStartPosition.y,
		z = tileStartPosition.z - moveAmount
	}

	tile.setPositionSmooth(newTilePosition)
end

function onLoad(save_state)
    restTile = getObjectFromGUID(restTileGUID)
	prepareTileOne = getObjectFromGUID(prepareTileOneGUID)
	prepareTileTwo = getObjectFromGUID(prepareTileTwoGUID)
	climbTileOne = getObjectFromGUID(climbTileOneGUID)
	climbTileTwo = getObjectFromGUID(climbTileTwoGUID)

	restSpinner = getObjectFromGUID(restSpinnerGUID)
	prepareSpinner = getObjectFromGUID(prepareSpinnerGUID)
	climbSpinnerOne = getObjectFromGUID(climbSpinnerOneGUID)
	climbSpinnerTwo = getObjectFromGUID(climbSpinnerTwoGUID)
	
	restSpinner.setValue(tostring(restSpinnerOptions[restSpinnerLevel]))
	prepareSpinner.setValue(tostring(prepareSpinnerOptions[prepareSpinnerLevel]))
	climbSpinnerOne.setValue(tostring(climbSpinnerOptions[climbSpinnerLevel][1]))
	climbSpinnerTwo.setValue(tostring(climbSpinnerOptions[climbSpinnerLevel][2]))

	self.createButton(generateButton("Rest", "Tile", {2, 0, -0.8}, true))
	self.createButton(generateButton("Rest", "Tile", {1.85, 0, -0.5}, false))
	self.createButton(generateButton("Rest", "Dial", {3, 0, -0.8}, true))
	self.createButton(generateButton("Rest", "Dial", {2.85, 0, -0.5}, false))

	self.createButton(generateButton("Prepare", "Tile", {2, 0, -0.1}, true))
	self.createButton(generateButton("Prepare", "Tile", {1.85, 0, 0.2}, false))
	self.createButton(generateButton("Prepare", "Dial", {3, 0, -0.1}, true))
	self.createButton(generateButton("Prepare", "Dial", {2.85, 0, 0.2}, false))

	self.createButton(generateButton("Climb", "Tile", {2, 0, 0.6}, true))
	self.createButton(generateButton("Climb", "Tile", {1.85, 0, 0.9}, false))
	self.createButton(generateButton("Climb", "Dial", {3, 0, 0.6}, true))
	self.createButton(generateButton("Climb", "Dial", {2.85, 0, 0.9}, false))
end

function upgradeRestTile()
	if restTileLevel == 0 then
		moveTile(restTile, 0.55)
		restTileLevel = restTileLevel + 1
	else
		informPlayer("\"Rest\"" .. fullUpgradeText)
	end
end

function upgradeRestDial()
	if restSpinnerLevel < #restSpinnerOptions then
		restSpinnerLevel = restSpinnerLevel + 1
		restSpinner.setValue(tostring(restSpinnerOptions[restSpinnerLevel]))
	else
		informPlayer("\"Rest\" Spinner" .. fullUpgradeText)
	end
end

function downgradeRestTile()
	if restTileLevel == 1 then
		moveTile(restTile, -0.55)
		restTileLevel = restTileLevel - 1
	else
		informPlayer("\"Rest\"" .. fullDegradeText)
	end
end

function downgradeRestDial()
	if restSpinnerLevel > 1  then
		restSpinnerLevel = restSpinnerLevel - 1
		restSpinner.setValue(tostring(restSpinnerOptions[restSpinnerLevel]))
	else
		informPlayer("\"Rest\" Spinner" .. fullDegradeText)
	end
end

function upgradePrepareTile()
	if prepareTileLevel == 0 or prepareTileLevel == 1 then
		if prepareTileLevel == 0 then
			moveTile(prepareTileOne, 0.85)
		else
			moveTile(prepareTileTwo, 0.85)
		end
		prepareTileLevel = prepareTileLevel + 1
	else
		informPlayer("\"Prepare\"" .. fullUpgradeText)
	end
end

function upgradePrepareDial()
	if prepareSpinnerLevel < #prepareSpinnerOptions then
		prepareSpinnerLevel = prepareSpinnerLevel + 1
		prepareSpinner.setValue(tostring(prepareSpinnerOptions[prepareSpinnerLevel]))
	else
		informPlayer("\"Prepare\" Spinner" .. fullUpgradeText)
	end
end

function downgradePrepareTile()
	if prepareTileLevel == 1 or prepareTileLevel == 2 then
		if prepareTileLevel == 1 then
			moveTile(prepareTileOne, -0.85)
		else
			moveTile(prepareTileTwo, -0.85)
		end
		prepareTileLevel = prepareTileLevel - 1
	else
		informPlayer("\"Prepare\"" .. fullDegradeText)
	end
end

function downgradePrepareDial()
	if prepareSpinnerLevel > 1  then
		prepareSpinnerLevel = prepareSpinnerLevel - 1
		prepareSpinner.setValue(tostring(prepareSpinnerOptions[prepareSpinnerLevel]))
	else
		informPlayer("\"Prepare\" Spinner" .. fullDegradeText)
	end
end

function upgradeClimbTile()
    if climbTileLevel == 0 or climbTileLevel == 1 then
		if climbTileLevel == 0 then
			moveTile(climbTileOne, 0.85)
		else
			moveTile(climbTileTwo, 0.85)
		end
		climbTileLevel = climbTileLevel + 1
	else
		informPlayer("\"Climb\"" .. fullUpgradeText)
	end
end

function upgradeClimbDial()
	if climbSpinnerLevel < #climbSpinnerOptions then
		climbSpinnerLevel = climbSpinnerLevel + 1
		climbSpinnerOne.setValue(tostring(climbSpinnerOptions[climbSpinnerLevel][1]))
		climbSpinnerTwo.setValue(tostring(climbSpinnerOptions[climbSpinnerLevel][2]))
	else
		informPlayer("\"Climb\" Spinner" .. fullUpgradeText)
	end
end

function downgradeClimbTile()
    if climbTileLevel == 1 or climbTileLevel == 2 then
		if climbTileLevel == 1 then
			moveTile(climbTileOne, -0.85)
		else
			moveTile(climbTileTwo, -0.85)
		end
		climbTileLevel = climbTileLevel - 1
	else
		informPlayer("\"Climb\"" .. fullDegradeText)
	end
end

function downgradeClimbDial()
	if climbSpinnerLevel > 1  then
		climbSpinnerLevel = climbSpinnerLevel - 1
		climbSpinnerOne.setValue(tostring(climbSpinnerOptions[climbSpinnerLevel][1]))
		climbSpinnerTwo.setValue(tostring(climbSpinnerOptions[climbSpinnerLevel][2]))
	else
		informPlayer("\"Climb\" Spinner" .. fullDegradeText)
	end
end