
timer.Simple( 0, VectivusSuits.SyncSuitData ) -- Lua refresh support

//////////////////////////////////////////////////////////////////////////////////

// Version: 1.0.0

/////////////////////////////// Vectivus´s Suits /////////////////////////////

// Developed by Vectivus:
// http://steamcommunity.com/profiles/76561198371018204

// Documentation:
// http://vectivuss-organization.gitbook.io/vectivus-suits

//////////////////////////////////////////////////////////////////////////////////

local Suits = VectivusSuits

// How do i find keybinds? binds here https://wiki.facepunch.com/gmod/Enums/KEY

local Test = Suits.Create( )
Test:SetName( "Test Suit" )
Test:SetModel( "models/player/corpse1.mdl" )
Test:SetHealth( 300 )
Test:SetArmor( 100 )
Test:SetJumpPower( 300 )
Test:SetSpeed( 600 )

Test:SetWeapons( { // weapons that have % immunity, [weaponclass] = 1.1 (percentage)
    [ "weapon_rpg" ] = 1.4 -- 40% reduction to dmg
} )

Test:Abilities( {
    [ "Juggernaut" ] = KEY_V,
    [ "Regeneration" ] = KEY_B,
    [ "AntMan" ] = KEY_N,
} )

Test:Create( )

/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Suit Ability Config /////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

local Sonic = Suits.CreateAbility( )
Sonic:SetName( "Sonic" )
Sonic:SetDescription( "Gains a 50% speed boost allowing you to catch up to people or escape from danger" )
Sonic:SetStart( 2 ) // how long ability lasts ( float )
Sonic:SetCooldown( 6 )  // how long the cooldown lasts ( starts after ability ends )
Sonic:SetColor( Color(197,105,216) )

Sonic:OnActive( function( self, ply ) // player, ran once ability is activated
    ply:SetRunSpeed( ply:GetRunSpeed( ) * 1.5 )
end )

Sonic:OnEnd( function( self, ply ) // player, ran once ability finishes
    local t = ply:GetSuitTable( )
    if not t then return end
    ply:SetRunSpeed( t.speed )
end )

Sonic:Create( )


local Juggernaut = Suits.CreateAbility( )
Juggernaut:SetName( "Juggernaut" )
Juggernaut:SetDescription( "This provides 40% damage resistance from ALL types of damage" )
Juggernaut:SetStart( 4 )
Juggernaut:SetCooldown( 20 )
Juggernaut:SetColor( Color(135, 241, 241 ) )

Juggernaut:OnAttacked( function( self, ply, att, t ) // self obj, player, attacker, ctakedamageinfo
    t:SetDamage( t:GetDamage( ) / 1.4 )
end )

Juggernaut:Create( )


local AntMan = Suits.CreateAbility( )
AntMan:SetName( "AntMan" )
AntMan:SetDescription( "Shrinks you down to the size of an ant making it harder for opponents to hit you" )
AntMan:SetStart( 5 )
AntMan:SetCooldown( 30 )
AntMan:SetColor( Color( 68, 233, 53 ) )

AntMan:OnActive( function( self, ply )
    local i = .75
    ply:SetModelScale( i, .1 )
    ply:SetViewOffset( Vector( 0, 0, 64 * i ) )
    ply:SetViewOffsetDucked( Vector( 0, 0, 28 * i ) )
end )

AntMan:OnEnd( function( self, ply )
    local i = 1
    ply:SetModelScale( i, .1 )
    ply:SetViewOffset( Vector( 0, 0, 64 * i ) )
    ply:SetViewOffsetDucked( Vector( 0, 0, 28 * i ) )
end )

AntMan:Create( )


local Invisibility = Suits.CreateAbility( )
Invisibility:SetName( "Invisibility" )
Invisibility:SetDescription( "Turns your transparent making you somewhat invisible to others" )
Invisibility:SetStart( 6 )
Invisibility:SetCooldown( 17 )
Invisibility:SetColor( Color( 66, 162, 226 ) )

Invisibility:OnActive( function( self, ply )
    ply:SetMaterial( "Models/effects/comball_tape" )
    ply:SetColor( Color( 255, 0, 0 ) )
end )

Invisibility:OnEnd( function( self, ply )
    ply:SetMaterial( "" )
    ply:SetColor( color_white )
end )

Invisibility:Create( )


local Regeneration = Suits.CreateAbility( )
Regeneration:SetName( "Regeneration" )
Regeneration:SetDescription( "Gains suit 15AP every 0.8s however WONT exceed the suits max armor" )
Regeneration:SetStart( 4 )
Regeneration:SetCooldown( 20 )
Regeneration:SetColor( Color( 230, 47, 92 ) )

Regeneration:OnThink( function( self, ply )
    local Text = "vs_suits.Regeneration." .. tostring( ply )

    if timer.Exists( Text ) then return end

    timer.Create( Text, .8, 1, function( )
        local ap = Suits.GetVar( ply )["SuitArmor"] or 0

        local t = ply:GetSuitTable( )
        if not t then return end

        Suits.SetVar( ply, "SuitArmor", math.Clamp( ap + 15, 0, ( t.armor or 100 ) ) )
    end )
end )

Regeneration:Create( )