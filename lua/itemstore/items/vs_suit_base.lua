
ITEM.Model = "models/items/item_item_crate.mdl"
ITEM.Stackable = false
ITEM.DropStack = false
ITEM.Base = "base_darkrp"

function ITEM:GetName()
    local k = self:GetData( "Suit" )
    local t = VectivusSuits.GetSuitData( k )
    return (t and t.name or "<INVALID>")
end
function ITEM:GetDescription()
    local k = self:GetData( "Suit" )
    local t = VectivusSuits.GetSuitData( k )
    if !t then return end
    local health = self:GetData( "SuitHealth" )
    local armor = self:GetData( "SuitArmor" )
    return t.name .. "\n\n" .. "Health: " .. health .. "\n" .. "Armor: " .. armor
end
function ITEM:Use( p )
    if DarkRP and p:isArrested() or VectivusSuits.GetPlayerSuit(p) then return false end
    local e = ents.Create( "vs_suit_base" )
    e:Spawn()
    e:SetSuit( self:GetData( "Suit" ) )
    e:SetSuitHealth( self:GetData( "SuitHealth" ) )
    e:SetSuitArmor( self:GetData( "SuitArmor" ) )
    e:Use(p)
    return true
end

function ITEM:CanPickup( p, e )
	return true
end
function ITEM:CanMerge( e )
	return false
end
function ITEM:SaveData( e )
    for k, v in pairs( e:GetNetworkVars() or {} ) do
        self:SetData( k, v )
    end
end
function ITEM:LoadData( e )
    e:SetSuit( self:GetData( "Suit" ) )
    e:SetSuitHealth( self:GetData( "SuitHealth" ) )
    e:SetSuitArmor( self:GetData( "SuitArmor" ) )
end
