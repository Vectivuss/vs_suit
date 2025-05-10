
resource.AddFile( "resource/fonts/Purista.ttf" )

util.AddNetworkString( "vs.suits" )

local Suits = VectivusSuits

function Suits.CreateSuit( k, t )
    t.name = k
    Suits.Suits[ k ] = t
    Suits.GenerateSuits( )
end

function Suits.CreateSuitAbility( k, t )
    t.name = k
    Suits.Abilities[ k ] = t
end

function Suits.Sync( p )
    if not IsValid( p ) or not p:IsPlayer( ) then return end

    local s = VectivusLib:SanitizeTable( Suits.Suits )
    local ss = VectivusLib:SanitizeTable( Suits.Abilities )

    s = util.TableToJSON( s )
    ss = util.TableToJSON( ss )

    local tbl = { 
        suits = s, 
        abilities = ss 
    }

    tbl = util.Compress( util.TableToJSON( tbl ) )

    net.Start( "vs.suits" )
        net.WriteData( tbl, #tbl )
    net.Send( p )
end

hook.Add( "VectivusLib:PlayerFullySpawned", "VectivusSuits.Sync", Suits.Sync )

function Suits.SyncSuitData( )
    for _, p in player.Iterator( ) do
        Suits.Sync( p )
    end
end

function Suits.SetVar( e, k, v )
    local t = Suits.GetVar( e )

    t[ k ] = v

    e.VectivusSuits_Vars = t

    e:SetNWString( "VectivusSuits.Var."..tostring( k ), v )
end

function Suits.SpawnSuit( p, k )
    if not IsValid( p ) or not Suits.GetSuitData(k) then return end

    local trace = { }

    do // trace
        trace.start = p:EyePos( )
        trace.endpos = trace.start + p:GetAimVector( ) * 90
        trace.filter = p
    end

    local tr = util.TraceLine( trace )

    local e = ents.Create( "vs_suit_base" )
    if not IsValid( e ) then return end

    e:SetPos( tr.HitPos )
    e:Spawn( )

    if Suits.GetPlayerSuit( p ) then
        for kk, v in pairs( Suits.GetVar( p ) ) do
            e[ "Set" .. kk ]( e, v )
            Suits.SetVar( p, kk, nil )
        end
    else
        local t = Suits.GetSuitData( k )
        e:SetSuit( k )
        e:SetSuitHealth( t.health )
        e:SetSuitArmor( t.armor )
    end

    hook.Run( "VectivusSuits.SpawnedSuit", p, k )

    return e
end

function Suits.EquipSuit( p, k, e )
    if not IsValid( p ) or not p:IsPlayer( ) then return end

    local t = Suits.GetSuitData( k )
    
    e = IsValid( e ) and e or nil
    
    if e then SafeRemoveEntity( e ) end
    
    if not t then return end
    
    if hook.Run( "VectivusSuits.CanEquipSuit", p, k ) == false then return end
    
    p:EmitSound( "items/ammopickup.wav", 50, math.random( 90, 110 ), .2 )

    do // stats
        p:SetMaterial( "Models/effects/comball_tape" )

        if t.model then p:SetModel( t.model ) end
        if t.speed then p:SetRunSpeed( t.speed ) end
        if t.jumpPower then p:SetJumpPower( t.jumpPower ) end

        if e then
            for k, v in pairs( e:GetNetworkVars( ) or { } ) do
                Suits.SetVar( p, k, v )
            end
        else
            local e = Suits.SpawnSuit( p, k )
            e:Use( p )
        end

        if t.OnEquip then t.OnEquip( p ) end
    end

    p:SetNWString( "VectivusSuits.PlayerSuit", k )

    hook.Run( "VectivusSuits.OnEquippedSuit", p, k )
end

hook.Add( "VectivusSuits.OnEquippedSuit", "a", function( p )
    timer.Simple(.2, function( ) 
        if not IsValid( p ) then return end
        p:SetMaterial( "" )
    end )
end )

function Suits.RemoveSuit( p )
    if not IsValid( p ) or not p:IsPlayer( ) then return end

    local t = Suits.GetPlayerSuitTable( p )
    if not t then return end

    p.vs_suit_drop = nil

    hook.Run( "VectivusSuits.OnRemovedSuit", p )

    do // remove stats
        if p:Alive( ) then
            p:EmitSound( "buttons/lever6.wav", 50, math.random( 90, 110 ), .2 )

            hook.Call( "PlayerSetModel", GAMEMODE, p )

            p:SetRunSpeed( (GAMEMODE and GAMEMODE.Config and GAMEMODE.Config.runspeed ) or 300 )
            p:SetHealth( 100 )
            p:SetArmor( 0 )
            p:SetJumpPower( 200 )
        else
            hook.Run( "VectivusSuits.OnDeath", p, t )
        end
    end

    p:SetNWString( "VectivusSuits.PlayerSuit", "" )

    if t.OnRemove then t.OnRemove( p ) end
end

hook.Add( "PlayerSpawn", "VectivusSuits.RemoveSuit", Suits.RemoveSuit )
hook.Add( "PlayerDeath", "VectivusSuits.RemoveSuit", Suits.RemoveSuit )

function Suits.DropSuit( p, txt )
    if not IsValid(p) or not p:IsPlayer() then return end
    if not Suits.Config.DropSuit[ txt or "" ] then return end

    local k = Suits.GetPlayerSuit( p )
    if not k then return end

    if hook.Run( "VectivusSuits.CanDropSuit", p ) == false then return "" end

    p.vs_suit_drop = true

    p:SetNWFloat( "VectivusSuits.DropSuitEnd", CurTime() + Suits.Config.DropTime )

    timer.Create( "VectivusSuits.DropSuitEnd."..tostring(p), Suits.Config.DropTime, 1, function()
        if not IsValid( p ) or not p:IsPlayer( ) then return end
        if not p.vs_suit_drop then return end
    
        Suits.SpawnSuit( p, k )

        p:SetMaterial( "Models/effects/comball_tape" )

        Suits.RemoveSuit( p )

        p.vs_suit_drop = nil

        timer.Simple( .2, function() 
            if not IsValid(p) then return end
            p:SetMaterial( "" )
        end )
    end )

    return ""
end

hook.Add( "PlayerSay", "VectivusSuits.DropSuit", VectivusSuits.DropSuit )

hook.Add( "VectivusSuits.CanDropSuit", "a", function( p )
    // already dropping suit
    if p.vs_suit_drop then return false end

    // player is dead
    if not p:Alive( ) then return false end
end )

function Suits.OnTakeDamage( e, t )
    local p = IsValid( e ) and e:IsPlayer( ) and e
    if not IsValid( p ) or not p:IsPlayer( ) then return end

    local data = Suits.GetPlayerSuitTable( p )
    if not data then return end

    if hook.Run( "VectivusSuits.CanTakeDamage", p, t, data ) == false then t:SetDamage( 0 ) return end

    hook.Run( "VectivusSuits.OnTakeDamage", p, t )

    local tt = Suits.GetVar( p )

    local damage = t:GetDamage( )

    do // suit damage reduction
        local wep = t:GetWeapon( ) and t:GetWeapon( ):GetClass( )
        if wep and data.weapons then
            local Int = data.weapons[ wep ] or 1
            damage = math.floor(damage * (1 - (Int / 100)))
        end
    end

    do // armor
        local ap = tt.SuitArmor
        if ap then
            ap = ap - damage
            if ap <= 0 then
                ap = 0
            else
                damage = 0
            end
            Suits.SetVar( p, "SuitArmor", ap )
        end
    end

    do // health
        local hp = tt.SuitHealth
        if hp then
            hp = hp - damage
            if hp <= 0 then
                hp = 0
                hook.Run( "VectivusSuits.OnSuitDestroyed", p, data, t )
            else
                damage = 0
            end
            Suits.SetVar( p, "SuitHealth", hp )
        end
    end
end

hook.Add( "EntityTakeDamage", "VectivusSuits.OnTakeDamage", Suits.OnTakeDamage )

hook.Add( "VectivusSuits.OnSuitDestroyed", "a", function( p, data, t )
    p:EmitSound( "physics/glass/glass_impact_bullet4.wav" )
    Suits.RemoveSuit( p )
end )

hook.Add( "VectivusSuits.CanTakeDamage", "a", function( p, t )
    local inf = t:GetInflictor()
    if t:IsFallDamage() then return false end
    if inf and inf:GetClass() == "prop_physics" then return false end
end )

hook.Add( "VectivusSuits.OnTakeDamage", "a", function( p, t )
    do // Config OnTakeDamage
        local tt = Suits.GetPlayerSuitTable( p )
        if tt and tt.OnTakeDamage then tt.OnTakeDamage( p, t ) end
    end

    do // prevent suit dropping
        if p.vs_suit_drop then
            p:SetNWFloat( "VectivusSuits.DropSuitEnd", 0 )
            p.vs_suit_drop = nil
        end
    end

    do // Abilities
        local Ability = Suits.Abilities
        local att = t:GetAttacker( ) or nil
        local vic = Suits.GetPlayerSuitAbilityTable( p )

        if p == att then return end

        if att then
            local _att = ( att and Suits.GetPlayerSuitAbilityTable( att ) ) or { }

            for i, kk in pairs( _att ) do
                if not Ability[ kk or "" ] then continue end

                local ii = att.vss_ability_start and att.vss_ability_start[ kk ]

                if Ability[ kk ].OnAttack and ii then Ability[ kk ].OnAttack( att, p, t ) end // attacker
            end
        end

        if vic then
            for i, kk in pairs( vic ) do
                if not Ability[kk or ""] then continue end

                local ii = p.vss_ability_start and p.vss_ability_start[ kk ]

                if Ability[ kk ].OnAttacked and ii then Ability[ kk ].OnAttacked( p, att, t ) end // victim
            end
        end
    end
end )

hook.Add( "PlayerShouldTakeDamage", "VectivusSuits.NoDamgeWearingSuit", function(p)
    return not Suits.GetPlayerSuit( p ) and true or false
end )
