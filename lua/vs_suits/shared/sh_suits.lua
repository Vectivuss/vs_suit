
local Suits = VectivusSuits
local PMeta = FindMetaTable( "Player" )

function VectivusSuits.GetSuit( k )
    return VectivusSuits.Suits[ k or "" ] or nil
end

function VectivusSuits.GetSuitByClass( Class )
    local Get

    for Suit, t in pairs( VectivusSuits.Suits ) do
        if t.class == Class then
            Get = VectivusSuits.GetSuit( Suit )
            break
        end
    end

    return Get
end

function VectivusSuits.GetAbility( k )
    return VectivusSuits.Abilities[ k or "" ] or nil
end

function PMeta:GetSuit( )
    local s = self:GetNWString( "VectivusSuits.PlayerSuit", "" )
    return s != "" and s or nil
end

function PMeta:GetSuitTable( )
    local Suit = self:GetSuit( )
    if not Suit then return end

    return VectivusSuits.GetSuit( Suit )
end

function PMeta:GetSuitAbilities( )
    local Table = self:GetSuitTable( )
    if not Table then return end

    return table.GetKeys( Table.abilities or { } )
end

function VectivusSuits.GetPlayerAbilities( p, i )
    if not IsValid( p ) or not p:IsPlayer( ) then return end
    if not p:GetSuit( ) then return end

    local ii = p:GetNWFloat( "VectivusSuits.Ability." .. tostring( i ), 0 )
    ii = math.Clamp( math.Round( ii - CurTime( ), 1 ), 0, 999999 )

    return ii
end

function VectivusSuits.GetPlayerAbilityCooldown( p, i )
    if not IsValid( p ) or not p:IsPlayer( ) then return end
    if not p:GetSuit( ) then return end

    return p:GetNWBool( "VectivusSuits.Ability.Cooldown." .. tostring( i ), false )
end

function VectivusSuits.GetVar( Ent, k )
    if not IsValid( Ent ) then return end

    if SERVER then
        return Ent.VectivusSuits_Vars or { }
    end

    return Ent:GetNWString( "VectivusSuits.Var." .. tostring( k ), "" )
end

function VectivusSuits.GenerateSuits( )
    for k, t in pairs( VectivusSuits.Suits ) do
        local ENT = { }
        ENT.Base = "vs_suit_base"
        ENT.PrintName = t.name
        ENT.Category = "Vectivus´s Suits"
        ENT.Spawnable = true

        if SERVER then 
            ENT.Suit = k 
        end

        scripted_ents.Register( ENT, t.class )
    end
    if CLIENT then RunConsoleCommand( "spawnmenu_reload" ) end
end 

VectivusSuits.GenerateSuits( )