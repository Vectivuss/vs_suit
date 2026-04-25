
local PLAYER = FindMetaTable( "Player" )
local PSuit = { }

AccessorFunc( PSuit, "Player", "Player" )

function PSuit.New( ply )
    local Suit = Table.Copy( PSuit )
    Suit:SetPlayer( ply )

    return Suit
end

function PSuit:SetHealth( Int )
    if CLIENT then return end
    self:GetPlayer( ):SetNWInt( "VSuit.Health", Int )
end

function PSuit:GetHealth( )
    return self:GetPlayer( ):GetNWInt( "VSuit.Health", 0 )
end

function PSuit:Set( Key )
    if CLIENT then return end
    self:GetPlayer( ):SetNWString( "VSuit", Key )
end

function PSuit:Get( )
    local Key = self:GetPlayer( ):GetNWString( "VSuit", "" )
    return Key ~= "" and Key or nil
end

function PSuit:GetData( )
    local Key = self:Get( )
    return Key and VectivusSuits.GetSuit( Key )
end

function PLAYER:Suits( )
    if not self.vs_suit then
        self.vs_suit = PSuit.New( self )
    end

    return self.vs_suit
end