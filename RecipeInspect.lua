-- RecipeInspect
if not RecipeInspectDB then
    RecipeInspectDB = {}
end

local RI_DressUpInitialized = nil

local function RI_GetItemID(link)

    if not link then
        return nil
    end

    local _, _, itemID =
        string.find(link, "item:(%d+)")

    if itemID then
        return tonumber(itemID)
    end

    return nil
end

local function RI_InitializeDressUp()

    if RI_DressUpInitialized then
        return
    end

    if not DressUpFrame then
        return
    end

    if not DressUpModel then
        return
    end

    ShowUIPanel(DressUpFrame)

    DressUpModel:SetUnit("player")

    DressUpModel:Undress()

    DressUpModel:Dress()

    RI_DressUpInitialized = 1
end

function RI_PreviewItem(itemID)

    if not itemID then
        return
    end

    if AuctionFrame
    and AuctionFrame:IsVisible()
    and AuctionDressUpModel
    then
        AuctionDressUpFrame:Show()
        AuctionDressUpModel:SetUnit("player")
        AuctionDressUpModel:Undress()
        AuctionDressUpModel:Dress()
        AuctionDressUpModel:TryOn(itemID)
        return
    end

    RI_InitializeDressUp()

    ShowUIPanel(DressUpFrame)

    DressUpModel:TryOn(itemID)
end

local function RI_HandleRecipe(link)

    local recipeID =
        RI_GetItemID(link)

    if not recipeID then
        return nil
    end

    local craftedID =
        RecipeInspectDB[recipeID]

    if not craftedID then
        return nil
    end

    RI_PreviewItem(craftedID)

    return 1
end

local RI_Original_SetItemRef =
    SetItemRef

function SetItemRef(link, text, button)

    if IsControlKeyDown() then

        if RI_HandleRecipe(link) then
            return
        end
    end

    RI_Original_SetItemRef(
        link,
        text,
        button
    )
end

local RI_Original_ContainerFrameItemButton_OnClick =
    ContainerFrameItemButton_OnClick

function ContainerFrameItemButton_OnClick(button)

    if button == "LeftButton"
    and IsControlKeyDown() then

        local bag =
            this:GetParent():GetID()

        local slot =
            this:GetID()

        local link =
            GetContainerItemLink(
                bag,
                slot
            )

        if link then

            if RI_HandleRecipe(link) then

                return
            end
        end
    end

    RI_Original_ContainerFrameItemButton_OnClick(
        button
    )
end

local RI_Original_HandleModifiedItemClick =
    HandleModifiedItemClick

function HandleModifiedItemClick(link)

    if IsControlKeyDown() then

        if RI_HandleRecipe(link) then
            return 1
        end
    end

    if RI_Original_HandleModifiedItemClick then

        return RI_Original_HandleModifiedItemClick(
            link
        )
    end
end

local RI_Original_DressUpItemLink =
    DressUpItemLink

function DressUpItemLink(link)

    if IsControlKeyDown() then

        if RI_HandleRecipe(link) then
            return
        end
    end

    RI_Original_DressUpItemLink(link)
end


local RI_Original_DressUpFrame_Hide =
    DressUpFrame.Hide

function DressUpFrame:Hide()

    RI_DressUpInitialized = nil

    RI_Original_DressUpFrame_Hide(self)
end

