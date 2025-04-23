local f = CreateFrame("Frame")

local chefsHatId = 46349
local previousHelmId

local isCastingCookingFire = false
local cookingWindowOpened = false

local function hasCookingProfession()
    local skillLine = GetTradeSkillLine()
    return skillLine and skillLine == "Cooking"
end

local function EquipChefsHatIfNeeded()
    local helmSlot = GetInventoryItemID("player", 1)
    if helmSlot and helmSlot ~= chefsHatId then
        previousHelmId = helmSlot
        EquipItemByName(chefsHatId)
    end
end

local function RestorePreviousHelm()
    if previousHelmId then
        EquipItemByName(previousHelmId)
        previousHelmId = nil
    end
end

local function onEvent(self, event, arg1, arg2)
    if event == "TRADE_SKILL_SHOW" then
        cookingWindowOpened = true
        if not isCastingCookingFire and hasCookingProfession() then
            EquipChefsHatIfNeeded()
        end

    elseif event == "TRADE_SKILL_CLOSE" then
        cookingWindowOpened = false
        RestorePreviousHelm()

    elseif (event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_CHANNEL_START") and arg1 == "player" then
        local spellName = UnitCastingInfo("player")
        if spellName == GetSpellInfo(818) then
            isCastingCookingFire = true
        end

    elseif event == "UNIT_SPELLCAST_STOP" and arg1 == "player" then
        if isCastingCookingFire then
            isCastingCookingFire = false
            if cookingWindowOpened and hasCookingProfession() then
                C_Timer.After(0.1, EquipChefsHatIfNeeded)
            end
        end
    end
end

f:RegisterEvent("TRADE_SKILL_SHOW")
f:RegisterEvent("TRADE_SKILL_CLOSE")
f:RegisterEvent("UNIT_SPELLCAST_START")
f:RegisterEvent("UNIT_SPELLCAST_STOP")
f:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
f:SetScript("OnEvent", onEvent)
