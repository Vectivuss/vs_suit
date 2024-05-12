
local ITEM = XeninInventory:CreateItemV2()
ITEM:SetMaxStack( 1 )

ITEM:AddEquip(function(_,p,t)
    if CLIENT then return true end
    local ee = ents.Create( "vs_suit_base" )
    ee:Spawn()
    for k, v in pairs( t.data or {} ) do
        ee["Set"..k](ee,v)
    end;ee:Use(p)
    return true
end, function(_,p,t)
    return !VectivusSuits.GetPlayerSuit(p), VectivusSuits.GetPlayerSuit(p) .. ", already equipped!"
end )

ITEM:AddDrop(function(_,_,e,t,_)
    for k, v in pairs( t and t.data or {} ) do
        e["Set"..k](e,v)
    end
end )

function ITEM:GetData( e )
    local t = {}
    for k, v in pairs( e:GetNetworkVars() or {} ) do
        t[k] = v
    end
    return t
end

function ITEM:GetName( e )
    local data = e.data or {}
    local t = VectivusSuits.GetSuitData( data["Suit"] )
    if !t then return "<INVALID>" end
    return t.name
end

ITEM:SetDescription( function( _, e )
    local data = e.data or {}
    local t = VectivusSuits.GetSuitData( data["Suit"] )
    if !t then return end
    local hp = data["SuitHealth"] or 0
    local ap = data["SuitArmor"] or 0
    local tbl =  {}
    tbl[1] = "Health: "..hp
    tbl[2] = "Armor: "..ap
    return tbl
end )

function ITEM:GetModel( e )
    local data = e.data or {}
    local t = VectivusSuits.GetSuitData( data["Suit"] )
    return t and t.model or "models/Items/item_item_crate.mdl"
end

ITEM:Register( "vs_suit_base" )
