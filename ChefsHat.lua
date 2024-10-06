local f = CreateFrame("Frame")

local chefsHatId = 46349
local previousHelmId

local function hasCookingProfession()
    local skillLine = GetTradeSkillLine()
    return skillLine and skillLine == "Cooking"
end

local function onEvent(self, event, ...)
    if event == "TRADE_SKILL_SHOW" then
        if hasCookingProfession() then
            local helmSlot = GetInventoryItemID("player", 1)
            if helmSlot and helmSlot ~= chefsHatId then
                previousHelmId = helmSlot
                EquipItemByName(chefsHatId)
            end
        end
    elseif event == "TRADE_SKILL_CLOSE" then
        if previousHelmId then
            EquipItemByName(previousHelmId)
            previousHelmId = nil
        end
    end
end

f:RegisterEvent("TRADE_SKILL_SHOW")
f:RegisterEvent("TRADE_SKILL_CLOSE")
f:SetScript("OnEvent", onEvent)