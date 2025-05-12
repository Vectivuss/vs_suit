
local ITEM = XeninInventory:CreateItemV2( )
ITEM:SetMaxStack( 1 )

ITEM:AddEquip(function( _, p, t )
    if CLIENT then return true end

    local Ent = ents.Create( "vs_suit_base" )
    Ent:Spawn( )

    for k, v in pairs( t.data or { } ) do
        Ent[ "Set" .. k ]( Ent, v )
    end

    Ent:Use( p )

    return true
end, function( _, p, t )
    local Suit = p:GetSuit( )
    return not Suit, Suit .. ", already equipped!"
end )

ITEM:AddDrop(function( _, _, Ent, t, _ )
    for k, v in pairs( t and t.data or { } ) do
        Ent[ "Set" .. k ]( Ent, v )
    end
end )

function ITEM:GetData( Ent )
    local t = {}

    for k, v in pairs( Ent:GetNetworkVars( ) or { } ) do
        t[ k ] = v
    end

    return t
end

function ITEM:GetName( Ent )
    local data = Ent.data or { }

    local t = VectivusSuits.GetSuit( data[ "Suit" ] )
    if not t then return "<INVALID>" end

    return t.name
end

ITEM:SetDescription( function( _, Ent )
    local data = Ent.data or { }

    local t = VectivusSuits.GetSuit( data[ "Suit" ] )
    if not t then return end

    local hp = data["SuitHealth"] or 0
    local ap = data["SuitArmor"] or 0

    local tbl =  { }

    tbl[ 1 ] = "Health: " .. hp
    tbl[ 2 ] = "Armor: " .. ap

    return tbl
end )

function ITEM:GetModel( Ent )
    local data = Ent.data or { }
    local t = VectivusSuits.GetSuit( data[ "Suit" ] )
    return t and t.model or "models/Items/item_item_crate.mdl"
end

ITEM:Register( "vs_suit_base" )