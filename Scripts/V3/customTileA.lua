leftMountainGUID = '9c62e7'
middleleftMountainGUID = '5c6fa2'
middlerightMountainGUID = '16f10a'
rightMountainGUID = 'b788ff'

aMountainZoneGuid = '5e5578'
bMountainZoneGuid = 'b5a6a6'
transferZoneGuid = 'ec91b6'

discardPileGUID = '540e3c'

boardGUID = '109a85'

function onLoad()
    dealCardParams = {
        click_function = "dealCards",
        function_owner = self,
        label          = "Discard leftmost mountain\n(if any) and replenish",
        position       = {-10.5, 17.8, 1.5},
        rotation       = {0, 0, 0},
        width          = 1900,
        height         = 500,
        font_size      = 150,
        color          = {0, 0, 0},
        font_color     = {1, 1, 1},
        tooltip        = "",
    }
    switchDecksParams = {
        click_function = "switchActiveDeck",
        function_owner = self,
        label          = "Swap mountain decks",
        position       = {-10.5, 17.8, 0.05},
        rotation       = {0, 0, 0},
        width          = 1900,
        height         = 500,
        font_size      = 150,
        color          = {0, 0, 0},
        font_color     = {1, 1, 1},
        tooltip        = "",
    }

    leftMountainArea = getObjectFromGUID(leftMountainGUID)
    middleleftMountainArea = getObjectFromGUID(middleleftMountainGUID)
    middlerightMountainArea = getObjectFromGUID(middlerightMountainGUID)
    rightMountainArea = getObjectFromGUID(rightMountainGUID)
    discardArea = getObjectFromGUID(discardPileGUID)

    activeZone = getObjectFromGUID(aMountainZoneGuid)
    inactiveZone = getObjectFromGUID(bMountainZoneGuid)
    transferZone = getObjectFromGUID(transferZoneGuid)

    board = getObjectFromGUID(boardGUID)

    discardLocation = discardArea.getPosition()

    aMountainsActive = true
    self.createButton(dealCardParams)
    self.createButton(switchDecksParams)
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

    -- Remove any items from the arrays that have a GUID of `boardGUID`
    for i = #leftDeck, 1, -1 do
      if leftDeck[i].getGUID() == boardGUID then
          table.remove(leftDeck, i)
      end
    end
    for i = #rightDeck, 1, -1 do
        if rightDeck[i].getGUID() == boardGUID then
            table.remove(rightDeck, i)
        end
    end

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

    -- Remove any items from the arrays that have a GUID of `boardGUID`
    for i = #activeDeck, 1, -1 do
        if activeDeck[i].getGUID() == boardGUID then
            table.remove(activeDeck, i)
        end
      end

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
    middleleftMountainCard = middleleftMountainArea.getObjects()
    middlerightMountainCard = middlerightMountainArea.getObjects()
    rightMountainCard = rightMountainArea.getObjects()

    -- Remove any items from the arrays that have a GUID of `boardGUID`
    for i = #leftMountainCard, 1, -1 do
        if leftMountainCard[i].getGUID() == boardGUID then
            table.remove(leftMountainCard, i)
        end
    end
    for i = #middleleftMountainCard, 1, -1 do
        if middleleftMountainCard[i].getGUID() == boardGUID then
            table.remove(middleleftMountainCard, i)
        end
    end
    for i = #middlerightMountainCard, 1, -1 do
        if middlerightMountainCard[i].getGUID() == boardGUID then
            table.remove(middlerightMountainCard, i)
        end
    end
    for i = #rightMountainCard, 1, -1 do
        if rightMountainCard[i].getGUID() == boardGUID then
            table.remove(rightMountainCard, i)
        end
    end

    leftMountainCardSize = #leftMountainCard
    middleleftMountainCardSize = #middleleftMountainCard
    middlerightMountainCardSize = #middlerightMountainCard
    rightMountainCardSize = #rightMountainCard

    if leftMountainCardSize ~= 0 or rightMountainCardSize ~= 0 or middleleftMountainCardSize ~= 0 or middlerightMountainCardSize ~= 0 then
        if leftMountainCardSize ~= 0 then
            leftMountainCard[1].setPositionSmooth(discardLocation)
        end
        if middleleftMountainCardSize ~= 0 then
            middleleftMountainCard[1].setPositionSmooth(leftMountainArea.getPosition())
    
            if middlerightMountainCardSize ~= 0 then
                middlerightMountainCard[1].setPositionSmooth(middleleftMountainArea.getPosition())
    
                if rightMountainCardSize ~= 0 then
                    rightMountainCard[1].setPositionSmooth(middlerightMountainArea.getPosition())
                else
                    dealCard(middlerightMountainArea.getPosition())
                end
            else
                if rightMountainCardSize ~= 0 then
                    rightMountainCard[1].setPositionSmooth(middleleftMountainArea.getPosition())
                else
                    dealCard(middleleftMountainArea.getPosition())
                end
        
                dealCard(middlerightMountainArea.getPosition())
            end
        else
            if middlerightMountainCardSize ~= 0 then
                middlerightMountainCard[1].setPositionSmooth(leftMountainArea.getPosition())
    
                if rightMountainCardSize ~= 0 then
                    rightMountainCard[1].setPositionSmooth(middleleftMountainArea.getPosition())
                else
                    dealCard(middleleftMountainArea.getPosition())
                end
            else
                if rightMountainCardSize ~= 0 then
                    rightMountainCard[1].setPositionSmooth(leftMountainArea.getPosition())
                else
                    dealCard(leftMountainArea.getPosition())
                end
                dealCard(middleleftMountainArea.getPosition())
            end
               dealCard(middlerightMountainArea.getPosition())
        end
    
        dealCard(rightMountainArea.getPosition())
    elseif leftMountainCardSize == 0 and rightMountainCardSize == 0 and middleleftMountainCardSize == 0 and middlerightMountainCardSize == 0 then
        dealCard(leftMountainArea.getPosition())
        dealCard(middleleftMountainArea.getPosition())
        dealCard(middlerightMountainArea.getPosition())
        dealCard(rightMountainArea.getPosition())
    end
end
