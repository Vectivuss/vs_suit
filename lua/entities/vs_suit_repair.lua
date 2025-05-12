
AddCSLuaFile( )

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "[ SUIT REPAIR ]"
ENT.Category = "Vectivus´s Suits"
ENT.Spawnable = true

if CLIENT then return end

function ENT:Initialize( )
    self:SetModel( "models/items/battery.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )

    if IsValid( self:GetPhysicsObject( ) ) then
        self:GetPhysicsObject( ):Wake( )
    end
end

function ENT:OnRemove( )
	local e = EffectData( )
	e:SetStart( self:GetPos( ) )
	e:SetOrigin( self:GetPos( ) )

    util.Effect( "StunstickImpact", e, true, true )

    self:EmitSound( "buttons/lever4.wav", 50, math.random( 90, 110 ), .2 )
	self:Remove( )
end

function ENT:Touch( e )
    if self.repair then return end

    e = IsValid( e ) and e
    if not e then return end

    local c = e:GetClass( )
    if c != "vs_suit_base" then return end

    self.repair = true

    SafeRemoveEntity( self )

    local t = VectivusSuits.GetSuit( e:GetSuit( ) )
    if not t then return end

    e:SetSuitHealth( t.health )
    e:SetSuitArmor( t.armor )
end