
local ITEM = BRICKS_SERVER.Func.CreateItemType( "vs_suit_base" )

ITEM.GetItemData = function( Ent )
    local t = VectivusSuits.GetSuit( Ent:GetSuit( ) )
    local mdl = t and t.model or "models/Items/item_item_crate.mdl"

    local itemData = {
        "vs_suit_base",
        mdl,
        Ent:GetSuit( ),
        Ent:GetSuitHealth( ),
        Ent:GetSuitArmor( )
    }

    return itemData, 1
end

ITEM.OnSpawn = function( p, pos, Data )
    local Ent = ents.Create("vs_suit_base")
    if not IsValid( Ent ) then return end

    Ent:SetSuit( Data[ 3 ] )
    Ent:SetSuitHealth( Data[ 4 ] )
    Ent:SetSuitArmor( Data[ 5 ] )
    Ent:SetPos( pos )
    Ent:Spawn( )
end

ITEM.GetInfo = function( Data )
    local t = VectivusSuits.GetSuit( Data[3] )
    if not t then return end

    local name = t.name or "<none"
    local hp = Data[ 4 ] or 0
    local ap = Data[ 5 ]  or 0

    return { name, "Health: "..hp.."\nArmor: "..ap, (BRICKS_SERVER.CONFIG.INVENTORY.ItemRarities or {})["vs_suit_base"] }
end

ITEM.CanCombine = function( Data1, Data2 ) return false end

ITEM:Register( )

if BRICKS_SERVER and BRICKS_SERVER.CONFIG and BRICKS_SERVER.CONFIG.INVENTORY and BRICKS_SERVER.CONFIG.INVENTORY.Whitelist then
    BRICKS_SERVER.CONFIG.INVENTORY.Whitelist[ "vs_suit_base" ] = { true, true }
end