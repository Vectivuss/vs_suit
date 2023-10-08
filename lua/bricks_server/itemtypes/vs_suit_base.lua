
local ITEM = BRICKS_SERVER.Func.CreateItemType( "vs_suit_base" )

ITEM.GetItemData = function(e)
    local t = VectivusSuits.GetSuitData(e:GetSuit())
    local mdl = t and t.model or "models/Items/item_item_crate.mdl"
    local itemData = {"vs_suit_base",mdl,e:GetSuit(),e:GetSuitHealth(),e:GetSuitArmor()}
    return itemData, 1
end

ITEM.OnSpawn = function(p,pos,itemData,_)
    local e = ents.Create("vs_suit_base")
    if !IsValid(e) then return end
    e:Spawn()
    e:SetPos(pos)
    e:SetSuit(itemData[3])
    e:SetSuitHealth(itemData[4])
    e:SetSuitArmor(itemData[5])
end

ITEM.GetInfo = function(itemData)
    local t = VectivusSuits.GetSuitData( itemData[3] )
    if !t then return end
    local name = t.name or "<none"
    local hp = itemData[4] or 0
    local ap = itemData[5] or 0
    return { name, "Health: "..hp.."\nArmor: "..ap, (BRICKS_SERVER.CONFIG.INVENTORY.ItemRarities or {})["vs_suit_base"] }
end

ITEM.CanCombine = function(itemData1, itemData2) return false end

ITEM:Register()

if BRICKS_SERVER and BRICKS_SERVER.CONFIG and BRICKS_SERVER.CONFIG.INVENTORY and BRICKS_SERVER.CONFIG.INVENTORY.Whitelist then
    BRICKS_SERVER.CONFIG.INVENTORY.Whitelist[ "vs_suit_base" ] = { true, true }
end
