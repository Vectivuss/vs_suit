
ITEM.Model = "models/items/item_item_crate.mdl"
ITEM.Stackable = false
ITEM.DropStack = false
ITEM.Base = "base_darkrp"

function ITEM:GetName( )
    local k = self:GetData( "Suit" )
    local t = VectivusSuits.GetSuit( k )
    return ( t and t.name or "<INVALID>" )
end

function ITEM:GetDescription( )
    local k = self:GetData( "Suit" )

    local t = VectivusSuits.GetSuit( k )
    if not t then return end

    local health = self:GetData( "SuitHealth" )
    local armor = self:GetData( "SuitArmor" )

    return t.name .. "\n\n" .. "Health: " .. health .. "\n" .. "Armor: " .. armor
end

function ITEM:Use( p )
    if DarkRP and p:isArrested( ) or p:GetSuit( ) then return false end

    local Ent = ents.Create( "vs_suit_base" )

    Ent:SetSuit( self:GetData( "Suit" ) )
    Ent:SetSuitHealth( self:GetData( "SuitHealth" ) )
    Ent:SetSuitArmor( self:GetData( "SuitArmor" ) )
    Ent:Spawn( )

    Ent:Use( p )

    return true
end

function ITEM:CanPickup( p, Ent )
	return true
end

function ITEM:CanMerge( Ent )
	return false
end

function ITEM:SaveData( Ent )
    for k, v in pairs( Ent:GetNetworkVars( ) or { } ) do
        self:SetData( k, v )
    end
end

function ITEM:LoadData( Ent )
    Ent:SetSuit( self:GetData( "Suit" ) )
    Ent:SetSuitHealth( self:GetData( "SuitHealth" ) )
    Ent:SetSuitArmor( self:GetData( "SuitArmor" ) )
end