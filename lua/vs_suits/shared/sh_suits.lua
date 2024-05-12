
VectivusSuits = VectivusSuits or {}
VectivusSuits.Suits = VectivusSuits.Suits or {}
VectivusSuits.Abilities = VectivusSuits.Abilities or {}

function VectivusSuits.GetSuitData( k )
    return VectivusSuits.Suits[k or ""] or nil
end
function VectivusSuits.GetAbilityData( k )
    return VectivusSuits.Abilities[k or ""] or nil
end

function VectivusSuits.GetPlayerSuit( p )
    if !IsValid(p) or !p:IsPlayer() then return end
    local s = p:GetNWString( "VectivusSuits.PlayerSuit", "" )
    return s != "" and s or nil
end

function VectivusSuits.GetPlayerSuitTable( p )
    return IsValid( p ) and VectivusSuits.GetSuitData(VectivusSuits.GetPlayerSuit(p)) or nil
end

function VectivusSuits.GetPlayerSuitAbilityTable( p )
    if !IsValid(p) or !p:IsPlayer() then return end
    if !VectivusSuits.GetPlayerSuit( p ) then return end
    local t = VectivusSuits.GetPlayerSuitTable( p )
    return table.GetKeys(t and t.abilities or {}) or nil
end

function VectivusSuits.GetPlayerAbilities( p, i )
    if !IsValid(p) or !p:IsPlayer() then return end
    if !VectivusSuits.GetPlayerSuit( p ) then return end
    local ii = p:GetNWFloat( "VectivusSuits.Ability."..tostring(i), 0 )
    ii = math.Clamp( math.Round(ii-CurTime(), 1), 0, 999999 )
    return ii
end
function VectivusSuits.GetPlayerAbilityCooldown( p, i )
    if !IsValid(p) or !p:IsPlayer() then return end
    if !VectivusSuits.GetPlayerSuit( p ) then return end
    return p:GetNWBool( "VectivusSuits.Ability.Cooldown."..tostring(i), false )
end
function VectivusSuits.GetVar( e, k )
    if !IsValid( e ) then return end
    if SERVER then
        return e.VectivusSuits_Vars or {}
    end
    return e:GetNWString( "VectivusSuits.Var."..tostring( k ), "" )
end

function VectivusSuits.GenerateSuits()
    for k, t in pairs( VectivusSuits.Suits ) do
        local ENT = {}
        ENT.Base = "vs_suit_base"
        ENT.PrintName = t.name
        ENT.Category = "Vectivus´s Suits"
        ENT.Spawnable = true
        if SERVER then ENT.Suit = k end
        scripted_ents.Register( ENT, string.lower(string.Replace(k," ","_")) )
    end
    if CLIENT then RunConsoleCommand( "spawnmenu_reload" ) end
end VectivusSuits.GenerateSuits()
