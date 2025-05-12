
local Suits = VectivusSuits

function Suits.SetPlayerAbilities( p, i, v )
    if not IsValid( p ) or not p:IsPlayer( ) then return end
    if not p:GetSuit( ) then return end

    p:SetNWFloat( "VectivusSuits.Ability." .. tostring( i ), CurTime( ) + v )
end

function Suits.SetPlayerAbilityCooldown( p, i, v )
    if not IsValid( p ) or not p:IsPlayer( ) then return end
    if not p:GetSuit( ) then return end

    p:SetNWBool( "VectivusSuits.Ability.Cooldown." .. tostring( i ), v )
end

function Suits.OnThink( )
    if timer.Exists( "VectivusSuits.OnThink" ) then return end
    timer.Create( "VectivusSuits.OnThink", .1, 1, function( ) end )

    for _, p in player.Iterator( ) do
        local t = p:GetSuitTable( )
        if not t then continue end

        do // Config OnThink
            if t and t.OnThink then t.OnThink( t, p ) end
        end

        do // Abilities
            local _t = p:GetSuitAbilities( )
            local tt = Suits.Abilities
        
            for i, kk in pairs( _t ) do
                if not tt[kk or ""] then continue end

                local ii = p.vss_ability_start and p.vss_ability_start[ kk ]

                if tt[ kk or "" ].OnThink and ii then tt[ kk or "" ].OnThink( t, p ) end
                if tt[ kk or "" ].OnPassive then tt[ kk or "" ].OnPassive( t, p ) end
            end
        end
    end
end

hook.Add( "Think", "VectivusSuits.OnThink", VectivusSuits.OnThink )

hook.Add( "canArrest", "VectivusSuits.CanArrest", function( _, p )
    return p:GetSuit( ) and false
end )

function Suits.SuitAbility( p, k )
    if not IsValid( p ) or not p:IsPlayer( ) then return end

    local t = Suits.Abilities

    local tt = p:GetSuitTable( )
    if not tt then return end

    if hook.Run( "VectivusSuits.CanDropSuit", p ) == false then return end

    p.vss_ability_start = p.vss_ability_start or { }
    p.vss_ability_end = p.vss_ability_end or { }

    for ability, bind in pairs( tt and tt.abilities or { } ) do

        if k == bind then
            t = t[ ability ]

            do // Checks
                if ( p.vss_ability_start[ ability ] or p.vss_ability_end[ ability ] ) then 
                    p:EmitSound( "buttons/button16.wav", 50, math.random( 90, 110 ), .2 )
                    return
                end
            end

            do // Start
                p.vss_ability_start[ ability ] = true
                if t.OnActive then t.OnActive( t, p ) end

                Suits.SetPlayerAbilities( p, ability, t.start )

                p:EmitSound( "buttons/button15.wav", 50, math.random( 90, 110 ), .2 )

                timer.Create( "VectivusSuits.Ability" .. tostring( ability ) .. "End." .. tostring( p ), ( t.start or 0 ), 1, function( )
                    if not IsValid( p ) or not p.vss_ability_start then return end

                    Suits.SetPlayerAbilities( p, ability, t.cooldown )
                    Suits.SetPlayerAbilityCooldown( p, ability, true )

                    if t.OnEnd then t.OnEnd( t, p ) end

                    p.vss_ability_start[ ability ] = nil
                    p.vss_ability_end[ ability ] = true
                end )
            end

            do // End
                timer.Create( "VectivusSuits.Ability" .. tostring( ability ) .. "Cooldown." .. tostring( p ), t.start + ( t.cooldown or 0 ), 1, function( )
                    if not IsValid( p ) or not p.vss_ability_end then return end
                    Suits.SetPlayerAbilityCooldown( p, ability, false )
                    p.vss_ability_end[ ability ] = nil
                end )
            end
        end
    end

end

hook.Add( "PlayerButtonDown", "VectivusSuits.SuitAbility", VectivusSuits.SuitAbility )

hook.Add( "VectivusSuits.OnDeath", "a", function( p, k )
    local t = Suits.GetSuit( k )

    do // remove active abiities
        p.vss_ability_start = p.vss_ability_start or { }
        p.vss_ability_end = p.vss_ability_end or { }

        local t = { }

        table.Merge( t, p.vss_ability_start)
        table.Merge( t, p.vss_ability_end)

        for i = 1, 3 do
            for ability, _ in pairs( t ) do
                Suits.SetPlayerAbilities( p, ability, 0 )
                Suits.SetPlayerAbilityCooldown( p, ability, false )
            end
        end

        p.vss_ability_start, p.vss_ability_end = nil, nil
    end
end )