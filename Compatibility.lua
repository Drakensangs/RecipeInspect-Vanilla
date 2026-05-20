local RI_CompatFrame = CreateFrame("Frame")
RI_CompatFrame:RegisterEvent("VARIABLES_LOADED")

RI_CompatFrame:SetScript("OnEvent", function()

    -- AtlasLoot
    if AtlasLootItem_OnClick then

        local RI_Orig_AtlasLootItem_OnClick = AtlasLootItem_OnClick

        function AtlasLootItem_OnClick(arg1)

            if  arg1 ~= "RightButton"
            and IsControlKeyDown()
            and this.itemID
            and this.itemID ~= 0
            then
                local firstChar = string.sub(tostring(this.itemID), 1, 1)

                if firstChar ~= "s" and firstChar ~= "e" then

                    local numericID = tonumber(this.itemID)

                    if numericID then
                        RI_PreviewItem(RecipeInspectDB[numericID] or numericID)
                        return
                    end
                end
            end

            RI_Orig_AtlasLootItem_OnClick(arg1)
        end

    end

    -- AtlasQuest
    if AtlasQuestItem_OnClick then

        local RI_Orig_AtlasQuestItem_OnClick = AtlasQuestItem_OnClick

        function AtlasQuestItem_OnClick(arg1)

            if  arg1 ~= "RightButton"
            and IsControlKeyDown()
            then
                local shownID

                if Allianceorhorde == 2 then
                    shownID = _G["Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."ID"..AQTHISISSHOWN.."_HORDE"]
                else
                    shownID = _G["Inst"..AQINSTANZ.."Quest"..AQSHOWNQUEST.."ID"..AQTHISISSHOWN]
                end

                if shownID then
                    local numericID = tonumber(shownID)

                    if numericID then
                        RI_PreviewItem(RecipeInspectDB[numericID] or numericID)
                        return
                    end
                end
            end

            RI_Orig_AtlasQuestItem_OnClick(arg1)
        end

    end

end)
