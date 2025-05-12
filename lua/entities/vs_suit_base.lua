
AddCSLuaFile( )

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "[ SUIT BASE ]"
ENT.Category = "Vectivus´s Suits"
ENT.Spawnable = false

function ENT:Draw( )
	self:DrawModel( )

	local p = LocalPlayer( )

	if p:GetPos( ):Distance( self:GetPos( ) ) > 350 then return end

	local pos = self:LocalToWorld( Vector( 0, 0, 33 ) ) +Vector( 0, 0, math.sin( CurTime( ) * 2 + self:EntIndex( ) ) )
	local ang = self:LocalToWorldAngles(Angle(0,180,90))

	pos = pos + Vector( 0, 0, 12 )

	local t = VectivusSuits.GetSuit( self:GetSuit( ) )

	cam.Start3D2D( pos, ang, 0.1 )
		local text = t and t.name or "<INVALID>"
		surface.SetFont( "vs.suits.ui.44" )
		local tW, _ = surface.GetTextSize( text ) + 35

		draw.RoundedBox( 0, -tW / 2, -50, tW, 50, Color( 0, 0, 0, 188 ) )
		draw.SimpleText( text, "vs.suits.ui.44", 0, -28, Color( 88, 216, 131 ), 1, 1 )

		surface.SetDrawColor( color_black )
        surface.DrawOutlinedRect( -tW / 2, -50, tW, 50, 1 )
	cam.End3D2D( )
end

function ENT:SetupDataTables( )
	self:NetworkVar( "String", 1, "Suit" )
	self:NetworkVar( "Int", 2, "SuitHealth" )
	self:NetworkVar( "Int", 3, "SuitArmor" )

	if SERVER then
		self:SetSuit( "" )
		self:SetSuitHealth( 1 )
		self:SetSuitArmor( 0 )
	end
end

if CLIENT then return end

function ENT:SpawnFunction( _, tr, class )
	if not tr.Hit then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 33
	local Ent = ents.Create( "vs_suit_base" )

	if self.Suit then Ent:SetSuit( self.Suit ) end

	local Get = VectivusSuits.GetSuit( Ent:GetSuit( ) )

	if Get then
		Ent:SetSuitHealth( Get.health )
		Ent:SetSuitArmor( Get.armor )
	end

	Ent:SetPos( SpawnPos )
	Ent:Spawn( )

	return Ent
end

function ENT:Initialize( )
	print( "debug", self, self:GetSuit( ) )

	if self:GetSuit( ) == "" then
		local Get = VectivusSuits.GetSuitByClass( self:GetClass( ) )
		if not Get then return end

		self:SetSuit( Get.name )
		self:SetSuitHealth( Get.health )
		self:SetSuitArmor( Get.armor )
	end

    self:SetModel( "models/items/item_item_crate.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_VPHYSICS )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )

    if IsValid( self:GetPhysicsObject( ) ) then
        self:GetPhysicsObject( ):Wake( )
    end

	if VectivusSuits.Config.AutoDropRepar then
		self:SetSuitHealth( Get.health )
		self:SetSuitArmor( Get.armor )
	end
end

function ENT:Use( p )
    if self.USED then return end
	if p:GetSuit( ) then return end

	self.USED = true

	VectivusSuits.EquipSuit( p, self:GetSuit( ), self )
end