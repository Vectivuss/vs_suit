
VectivusSuits = VectivusSuits or {}

function VectivusSuits.OnThink()
    if timer.Exists( "VectivusSuits.OnThink" ) then return end
    timer.Create( "VectivusSuits.OnThink", .1, 1, function() end )
    for _, p in pairs( player.GetAllSuits() ) do
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
                        if !IsValid(p) then return end
                        VectivusSuits.SetPlayerAbilities( p, ability, t.cooldown )
                        p.vs_suit_ability_start[ability] = nil
                        p.vs_suit_ability_end[ability] = true
                        VectivusSuits.SetPlayerAbilityCooldown( p, ability, true )
                        if t.OnEnd then t.OnEnd( p ) end
                    end )
                end
                do // End
                    timer.Create( "VectivusSuits.Ability"..tostring(ability).."Cooldown."..tostring(p), t.start+(t.cooldown or 0), 1, function()
                        if !IsValid( p ) then return end
                        p.vs_suit_ability_end[ability] = nil
                        VectivusSuits.SetPlayerAbilityCooldown( p, ability, false )
                    end )
                end
            end
        end
    end
end
hook.Add( "PlayerButtonDown", "VectivusSuits.SuitAbility", VectivusSuits.SuitAbility )
