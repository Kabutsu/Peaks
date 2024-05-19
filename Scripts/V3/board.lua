aMountainGuid = 'e917cf'
bMountainGuid = 'aca1eb'
bonusCardsGuid = 'ec9a78'
companionCardsGuid = '91eb6f'
boostCardsGuid = '639969'
--AICardsGuid = '6f1570'


--[[ The onLoad event is called after the game save finishes loading. --]]
function onLoad()
    aMountainDeck = getObjectFromGUID(aMountainGuid)
    bMountainDeck = getObjectFromGUID(bMountainGuid)
    bonusCardDeck = getObjectFromGUID(bonusCardsGuid)
    companionCardDeck = getObjectFromGUID(companionCardsGuid)
    boostCardDeck = getObjectFromGUID(boostCardsGuid)
--    AICardDeck = getObjectFromGUID(AICardsGuid)



    aMountainDeck.shuffle()
    bMountainDeck.shuffle()
    bonusCardDeck.shuffle()
    companionCardDeck.shuffle()
    boostCardDeck.shuffle()
--    AICardDeck.shuffle()

end

--[[ The onUpdate event is called once per frame. --]]
function onUpdate()

end

function setUp()
    
end
