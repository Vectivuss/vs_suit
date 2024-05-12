
VectivusSuits = VectivusSuits or {}

function VectivusSuits.SetPlayerAbilities( p, i, v )
    if !IsValid(p) or !p:IsPlayer() then return end
    if !VectivusSuits.GetPlayerSuit( p ) then return end
    p:SetNWFloat( "VectivusSuits.Ability."..tostring(i), CurTime()+v )
end
function VectivusSuits.SetPlayerAbilityCooldown( p, i, v )
    if !IsValid(p) or !p:IsPlayer() then return end
    if !VectivusSuits.GetPlayerSuit( p ) then return end
    p:SetNWBool( "VectivusSuits.Ability.Cooldown."..tostring(i), v )
end

function VectivusSuits.OnThink()
    if timer.Exists( "VectivusSuits.OnThink" ) then return end
    timer.Create( "VectivusSuits.OnThink", .1, 1, function() end )
    for _, p in ipairs( VectivusSuits.GetAllPlayers() ) do
        local t = VectivusSuits.GetPlayerSuitTable(p)
        do // Config OnThink
            if t and t.OnThink then t.OnThink( p, t ) end
        end
        do // Abilities
            local _t = VectivusSuits.GetPlayerSuitAbilityTable( p ) or {}
            local tt = VectivusSuits.Abilities
            for i, kk in pairs(_t) do
                if !tt[kk or ""] then continue end
                local ii = p.vs_suit_ability_start and p.vs_suit_ability_start[kk]
                if tt[kk or ""].OnThink and ii then tt[kk or ""].OnThink( p, t ) end
                if tt[kk or ""].OnPassive then tt[kk or ""].OnPassive( p, t ) end
            end
        end
    end
end
hook.Add( "Think", "VectivusSuits.OnThink", VectivusSuits.OnThink )

hook.Add( "canArrest", "VectivusSuits.CanArrest", function( _, p )
    return VectivusSuits.GetPlayerSuit( p ) and false
end )

function VectivusSuits.SuitAbility( p, k )
    if !IsValid(p) or !p:IsPlayer() then return end
    if !VectivusSuits.GetPlayerSuit( p ) then return end
    local t = VectivusSuits.Abilities
    if hook.Run( "VectivusSuits.CanDropSuit", p ) == false then return end
    p.vs_suit_ability_start = p.vs_suit_ability_start or {}
    p.vs_suit_ability_end = p.vs_suit_ability_end or {}
    do // Ability
        local tt = VectivusSuits.GetPlayerSuitTable(p)
        for ability, bind in pairs(tt and tt.abilities or {}) do
            if k==bind then
                t = t[ability]
                do // Checks
                    if (p.vs_suit_ability_start[ability] or p.vs_suit_ability_end[ability]) then 
                        p:EmitSound( "buttons/button16.wav", 50, math.random(90,110), .2 )
                        return
                    end
                end
                do // Start
                    p.vs_suit_ability_start[ability] = true
                    if t.OnActive then t.OnActive( p ) end
                    VectivusSuits.SetPlayerAbilities( p, ability, t.start )
                    p:EmitSound( "buttons/button15.wav", 50, math.random(90,110), .2 )
                    timer.Create( "VectivusSuits.Ability"..tostring(ability).."End."..tostring(p), (t.start or 0), 1, function()
                        if !IsValid(p) or !p.vs_suit_ability_start then return end
                        VectivusSuits.SetPlayerAbilities( p, ability, t.cooldown )
                        VectivusSuits.SetPlayerAbilityCooldown( p, ability, true )
                        if t.OnEnd then t.OnEnd( p ) end
                        p.vs_suit_ability_start[ability] = nil
                        p.vs_suit_ability_end[ability] = true
                    end )
                end
                do // End
                    timer.Create( "VectivusSuits.Ability"..tostring(ability).."Cooldown."..tostring(p), t.start+(t.cooldown or 0), 1, function()
                        if !IsValid(p) or !p.vs_suit_ability_end then return end
                        VectivusSuits.SetPlayerAbilityCooldown( p, ability, false )
                        p.vs_suit_ability_end[ability] = nil
                    end )
                end
            end
        end
    end
end
hook.Add( "PlayerButtonDown", "VectivusSuits.SuitAbility", VectivusSuits.SuitAbility )

hook.Add( "VectivusSuits.OnDeath", "a", function( p, t )
    do // remove active abiities
        p.vs_suit_ability_start = p.vs_suit_ability_start or {}
        p.vs_suit_ability_end = p.vs_suit_ability_end or {}

        local t = {}
        table.Merge(t,p.vs_suit_ability_start)
        table.Merge(t,p.vs_suit_ability_end)

        for i=1, 3 do
            for ability, _ in pairs( t ) do
                VectivusSuits.SetPlayerAbilities( p, ability, 0 )
                VectivusSuits.SetPlayerAbilityCooldown( p, ability, false )
            end
        end
        p.vs_suit_ability_start, p.vs_suit_ability_end = nil, nil
    end
end )
