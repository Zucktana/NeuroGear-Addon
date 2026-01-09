if not NeuroGearDB then NeuroGearDB = {} end

SLASH_NEUROGEAR1 = "/neuro"
SlashCmdList["NEUROGEAR"] = function(msg)
    local _, _, command, rest = string.find(msg, "^(%S*)%s*(.-)$")
    
    if command == "save" and rest ~= "" then
        NeuroGear_SavePreset(rest)
    elseif command == "export" and rest ~= "" then
        NeuroGear_ShowExport(rest)
    else
        DEFAULT_CHAT_FRAME:AddMessage("|cff9b59b6[NeuroGear]|r Usage:")
        DEFAULT_CHAT_FRAME:AddMessage("  /neuro save [name]   - Save current gear")
        DEFAULT_CHAT_FRAME:AddMessage("  /neuro export [name] - Get code for Discord")
    end
end

function NeuroGear_SavePreset(name)
    local gear = {}
    for i=1, 18 do
        local link = GetInventoryItemLink("player", i)
        if link then
            local _, _, id = string.find(link, "item:(%d+):")
            if id then table.insert(gear, id) else table.insert(gear, "0") end
        else
            table.insert(gear, "0")
        end
    end
    NeuroGearDB[name] = table.concat(gear, ",")
    DEFAULT_CHAT_FRAME:AddMessage("|cff9b59b6[NeuroGear]|r Preset '" .. name .. "' saved!")
end

function NeuroGear_ShowExport(name)
    if not NeuroGearExportFrame then
        local f = CreateFrame("Frame", "NeuroGearExportFrame", UIParent)
        f:SetWidth(450)
        f:SetHeight(150)
        f:SetPoint("CENTER", UIParent, "CENTER")
        f:SetBackdrop({
            bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
            edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
            tile = true, tileSize = 32, edgeSize = 32,
            insets = { left = 11, right = 12, top = 12, bottom = 11 }
        })
        f:EnableMouse(true)
        f:SetMovable(true)
        f:RegisterForDrag("LeftButton")
        f:SetScript("OnDragStart", function() this:StartMoving() end)
        f:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
        f:Hide()

        local t = f:CreateFontString(nil, "ARTWORK", "GameFontNormal")
        t:SetPoint("TOP", 0, -15)
        t:SetText("Copy this code (Ctrl+A -> Ctrl+C) for Discord:")

        local b = CreateFrame("Button", nil, f, "UIPanelButtonTemplate")
        b:SetWidth(100)
        b:SetHeight(30)
        b:SetPoint("BOTTOM", 0, 15)
        b:SetText("Close")
        b:SetScript("OnClick", function() NeuroGearExportFrame:Hide() end)

        local eb = CreateFrame("EditBox", nil, f)
        eb:SetPoint("TOPLEFT", 25, -45)
        eb:SetPoint("BOTTOMRIGHT", -25, 55)
        eb:SetFontObject("ChatFontNormal")
        eb:SetTextInsets(5,5,5,5)
        eb:SetScript("OnEscapePressed", function() this:GetParent():Hide() end)
        
        local bg = eb:CreateTexture(nil, "BACKGROUND")
        bg:SetAllPoints(eb)
        bg:SetTexture(0, 0, 0, 0.5)
        f.editBox = eb
    end

    local data = NeuroGearDB[name]
    if not data then
        DEFAULT_CHAT_FRAME:AddMessage("Preset not found. Did you /neuro save " .. name .. " first?")
        return
    end

    NeuroGearExportFrame:Show()
    NeuroGearExportFrame.editBox:SetText(data)
    NeuroGearExportFrame.editBox:HighlightText()
    NeuroGearExportFrame.editBox:SetFocus()
end