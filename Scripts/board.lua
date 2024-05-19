leftMountainGUID = 'b85a9c'
middleMountainGUID = '8b9e30'
rightMountainGUID = 'd097c7'

aMountainZoneGuid = '613b40'
bMountainZoneGuid = 'b54d56'
transferZoneGuid = '6422d5'

discardPileGUID = 'c83e26'

textColor = { r=1, g=1, b=1 }
buttonRotaion = {0, 0, 0}
buttonHeight = 350
buttonFontSize = 100
buttonColor = { r=0, g=0, b=0 }

dealCardButton = {
    click_function = "dealCards",
    function_owner = self,
    label = "Deal Cards",
    position = {-10.25, 0, -3.7},
    rotation = buttonRotation,
    width = 850,
    height = buttonHeight,
    font_size = buttonFontSize,
    color = buttonColor,
    font_color = textColor
}

switchDecksButton = {
    click_function = "switchActiveDeck",
    function_owner = self,
    label = "Switch Active Mountains",
    position = {-10.6, 0, -2.7},
    rotation = buttonRotation,
    width = 1200,
    height = buttonHeight,
    font_size = buttonFontSize,
    color = buttonColor,
    font_color = textColor
}

function onLoad(save_state)
    leftMountainArea = getObjectFromGUID(leftMountainGUID)
    middleMountainArea = getObjectFromGUID(middleMountainGUID)
    rightMountainArea = getObjectFromGUID(rightMountainGUID)
    discardArea = getObjectFromGUID(discardPileGUID)

    activeZone = getObjectFromGUID(aMountainZoneGuid)
    inactiveZone = getObjectFromGUID(bMountainZoneGuid)
    transferZone = getObjectFromGUID(transferZoneGuid)

    discardLocation = discardArea.getPosition()

    aMountainsActive = true
    
    self.createButton(dealCardButton)
    self.createButton(switchDecksButton)
end

function moveAfterTime(moveWhat, moveTo, moveAfter)
    Wait.time(
        function()
            moveWhat.setPositionSmooth(moveTo.getPosition())
        end,
        moveAfter,
        1
    )
end

function switchActiveDeck()
    leftDeck = activeZone.getObjects()
    rightDeck = inactiveZone.getObjects()

    if #leftDeck ~= 0 then
        if #rightDeck ~=0 then
            leftDeck[1].setPositionSmooth(transferZone.getPosition())
            moveAfterTime(rightDeck[1], activeZone, 0.5)
            moveAfterTime(leftDeck[1], inactiveZone, 1)
        else
            leftDeck[1].setPositionSmooth(inactiveZone.getPosition())
        end
    elseif #rightDeck ~= 0 then
        rightDeck[1].setPositionSmooth(activeZone.getPosition())
    end

    if aMountainsActive then
        aMountainsActive = false
        broadcastToAll("'B' Mountain deck is now active", textColor)
    else
        aMountainsActive = true
        broadcastToAll("'A' Mountain deck is now active", textColor)
    end
end

local function dealCard(moveTo)
	activeDeck = activeZone.getObjects()

    if #activeDeck ~= 0 then
        if activeDeck[1].name == "DeckCustom" or activeDeck[1].name == "Deck" then
            activeDeck[1].takeObject({
                position = moveTo,
                flip = true
            })
        elseif activeDeck[1].name == "Card" then
            activeDeck[1].flip()
            activeDeck[1].setPositionSmooth(moveTo)
        end
    else
        discardDeck = discardArea.getObjects()
        if #discardDeck ~= 0 then
            discardDeck[1].shuffle()
            discardDeck[1].setPositionSmooth(activeZone.getPosition())

            Wait.time(
                function()
                    discardDeck[1].takeObject({
                        position = moveTo,
                    })
                    discardDeck[1].flip()
                end,
                1,
                1)
        else
            broadcastToAll("No cards left to deal!", textColor)
        end
    end
end

function dealCards()
    leftMountainCard = leftMountainArea.getObjects()
    middleMountainCard = middleMountainArea.getObjects()
    rightMountainCard = rightMountainArea.getObjects()

    leftMountainCardSize = #leftMountainCard
    middleMountainCardSize = #middleMountainCard
    rightMountainCardSize = #rightMountainCard

    if leftMountainCardSize ~= 0 or rightMountainCardSize ~= 0 or middleMountainCardSize ~= 0 then
        if leftMountainCardSize ~= 0 then
            leftMountainCard[1].setPositionSmooth(discardLocation)
        end
    
        if middleMountainCardSize ~= 0 then
            middleMountainCard[1].setPositionSmooth(leftMountainArea.getPosition())
    
            if rightMountainCardSize ~= 0 then
                rightMountainCard[1].setPositionSmooth(middleMountainArea.getPosition())
            else
                dealCard(middleMountainArea.getPosition())
            end
        else
            if rightMountainCardSize ~= 0 then
                rightMountainCard[1].setPositionSmooth(leftMountainArea.getPosition())
            else
                dealCard(leftMountainArea.getPosition())
            end
    
            dealCard(middleMountainArea.getPosition())
        end
    
        dealCard(rightMountainArea.getPosition())
    elseif leftMountainCardSize == 0 and rightMountainCardSize == 0 and middleMountainCardSize == 0 then
        dealCard(leftMountainArea.getPosition())
        dealCard(middleMountainArea.getPosition())
        dealCard(rightMountainArea.getPosition())
    end
end
