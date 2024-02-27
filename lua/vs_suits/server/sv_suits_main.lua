
resource.AddWorkshop("3048032975")

function VectivusSuits.CreateSuit( k, t )
    timer.Simple( 0, function()
        t.name = k
        VectivusSuits.Suits[k] = t
        VectivusSuits.GenerateSuits()
    end )
end
function VectivusSuits.CreateSuitAbility( k, t )
    t.name = k
    VectivusSuits.Abilities[k] = t
end

util.AddNetworkString( "vs.suits" )
function VectivusSuits.Sync( p )
    if !IsValid(p) or !p:IsPlayer() then return end
    local s = util.Compress(util.TableToJSON(VectivusLib:SanitizeTable(VectivusSuits.Suits)))
    local ss = util.Compress(util.TableToJSON(VectivusLib:SanitizeTable(VectivusSuits.Abilities)))
    net.Start( "vs.suits" )
        net.WriteUInt(#s,12)
        net.WriteData(s,#s)
        net.WriteUInt(#ss,12)
        net.WriteData(ss,#ss)
    net.Send( p )
end
hook.Add( "VectivusLib:PlayerInitialSpawn", "VectivusSuits.Sync", VectivusSuits.Sync )

function VectivusSuits.SyncSuitData()
    for _, p in pairs( player.GetAll() ) do
        VectivusSuits.Sync( p )
    end
end

function VectivusSuits.SetVar( e, k, v )
    local t = VectivusSuits.GetVar( e )
    t[k] = v
    e.VectivusSuits_Vars = t
    e:SetNWString( "VectivusSuits.Var."..tostring(k), v )
end
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

function VectivusSuits.SpawnSuit( p, k )
    if !IsValid(p) or !VectivusSuits.GetSuitData(k) then return end
    local trace = {}
    do // trace
        trace.start = p:EyePos()
        trace.endpos = trace.start+p:GetAimVector()*90
        trace.filter = p
    end
    local tr = util.TraceLine(trace)

    local e = ents.Create( "vs_suit_base" )
    if !IsValid(e) then return end
    e:SetPos(tr.HitPos)
    e:Spawn()

    if VectivusSuits.GetPlayerSuit(p) then
        for kk, v in pairs(VectivusSuits.GetVar(p)) do
            e["Set"..kk](e,v)
            VectivusSuits.SetVar(p,kk,nil)
        end
    else
        local t = VectivusSuits.GetSuitData(k)
        e:SetSuit(k)
        e:SetSuitHealth(t.health)
        e:SetSuitArmor(t.armor)
    end
    hook.Run( "VectivusSuits.SpawnedSuit", p, k )

    return e
end

function VectivusSuits.EquipSuit( p, k, e )
    if !IsValid(p) or !p:IsPlayer() then return end
    local t = VectivusSuits.GetSuitData( k )
    e = IsValid( e ) and e or nil
    if e then SafeRemoveEntity( e ) end
    if !t then return end
    if hook.Run( "VectivusSuits.CanEquipSuit", p, k ) == false then return end
    p:EmitSound( "items/ammopickup.wav", 50, math.random(90,110), .2 )
    do // stats
        p:SetMaterial( "Models/effects/comball_tape" )
        if t.model then p:SetModel( t.model ) end
        if t.speed then p:SetRunSpeed( t.speed ) end
        if t.jumpPower then p:SetJumpPower( t.jumpPower ) end
        if e then
            for k, v in pairs( e:GetNetworkVars() or {} ) do
                VectivusSuits.SetVar( p, k, v )
            end
        else
            local e = VectivusSuits.SpawnSuit( p, k )
            e:Use( p )
        end
        if t.OnEquip then t.OnEquip( p ) end
    end
    p:SetNWString( "VectivusSuits.PlayerSuit", k )
    hook.Run( "VectivusSuits.OnEquippedSuit", p, k )
end
hook.Add( "VectivusSuits.OnEquippedSuit", "a", function(p)
    timer.Simple(.2, function() 
        if !IsValid(p) then return end
        p:SetMaterial("")
    end)
end )

function VectivusSuits.RemoveSuit( p )
    if !IsValid(p) or !p:IsPlayer() then return end
    local t = VectivusSuits.GetPlayerSuitTable( p )
    if !t then return end
    do // remove stats
        if p:Alive() then
            p:EmitSound("buttons/lever6.wav",50, math.random(90,110), .2 )
            hook.Call( "PlayerSetModel", GAMEMODE, p )
            p:SetRunSpeed((GAMEMODE and GAMEMODE.Config and GAMEMODE.Config.runspeed) or 300)
            p:SetHealth(100)
            p:SetArmor(0)
            p:SetJumpPower(200)
        end
    end
    p:SetNWString( "VectivusSuits.PlayerSuit", "" )
    do // OnRemove func
        if t.OnRemove then t.OnRemove( p ) end
    end
    hook.Run( "VectivusSuits.OnRemovedSuit", p, k )
    p.vs_suit_drop = nil
end
hook.Add( "PlayerSpawn", "VectivusSuits.RemoveSuit", VectivusSuits.RemoveSuit )
hook.Add( "PlayerDeath", "VectivusSuits.RemoveSuit", VectivusSuits.RemoveSuit )

hook.Add( "VectivusSuits.OnRemovedSuit", "a", function( p, k )
    do // remove active abiities
        p.vs_suit_ability_start = p.vs_suit_ability_start or {}
        p.vs_suit_ability_end = p.vs_suit_ability_end or {}
        for ability, _ in pairs( p.vs_suit_ability_start ) do
            VectivusSuits.SetPlayerAbilities( p, ability, 0 )
            VectivusSuits.SetPlayerAbilityCooldown( p, ability, false )
            -- local t = VectivusSuits.Abilities[ability]
            -- if t.OnEnd then print(p) t.OnEnd(p) end
        end
    end
end )

function VectivusSuits.DropSuit( p, txt )
    if !IsValid(p) or !p:IsPlayer() then return end
    if !VectivusSuits.Config.DropSuit[txt or ""] then return end
    local k = VectivusSuits.GetPlayerSuit(p)
    if !k then return end
    if hook.Run( "VectivusSuits.CanDropSuit", p ) == false then return "" end
    p.vs_suit_drop = true
    p:SetNWFloat( "VectivusSuits.DropSuitEnd", CurTime()+4 )
    timer.Create( "VectivusSuits.DropSuitEnd."..tostring(p), 4, 1, function()
        if !IsValid(p) or !p:IsPlayer() then return end
        if !p.vs_suit_drop then return end
        do // create suit
            VectivusSuits.SpawnSuit( p, k )
        end
        p:SetMaterial( "Models/effects/comball_tape" )
        VectivusSuits.RemoveSuit( p )
        p.vs_suit_drop = nil
        timer.Simple( .2, function() 
            if !IsValid(p) then return end
            p:SetMaterial("")
        end)
    end )
    return ""
end
hook.Add( "PlayerSay", "VectivusSuits.DropSuit", VectivusSuits.DropSuit )
hook.Add( "VectivusSuits.CanDropSuit", "a", function( p )
    do // already dropping suit
        if p.vs_suit_drop then return false end
    end
    do // player is dead
        if !p:Alive() then return false end
    end
end )
function VectivusSuits.OnTakeDamage( e, t )
    local p = IsValid( e ) and e:IsPlayer() and e
    if !IsValid(p) or !p:IsPlayer() then return end
    local tt = VectivusSuits.GetVar( p )
    hook.Run( "VectivusSuits.OnTakeDamage", p, t )
    local data = VectivusSuits.GetPlayerSuitTable( p )
    if !data then return end
    if hook.Run( "VectivusSuits.CanTakeDamage", p, t, data ) == false then t:SetDamage( 0 ) return end
    local damage = math.floor( t:GetDamage() )
    do // suit damage reduction
        local wep = t:GetAttacker() and IsValid(t:GetAttacker()) and (t:GetAttacker():IsPlayer() or t:GetAttacker():IsNPC()) and (IsValid(t:GetAttacker():GetActiveWeapon()) and t:GetAttacker():GetActiveWeapon():GetClass()) or nil
        if wep and data.weapons then
            data.weapons[wep] = data.weapons[wep] or 1
            damage = math.floor(damage/data.weapons[wep] or 1) 
        end
    end
    do // armor
        local ap = tt.SuitArmor
        if ap then
            ap = ap - damage
            if ap < 0 then
                ap = 0
            end
            VectivusSuits.SetVar( p, "SuitArmor", ap )
        end
    end
    do // health
        local hp = tt.SuitHealth
        if hp then
            hp = hp - damage
            if hp < 0 then
                hp = 0
                VectivusSuits.RemoveSuit(p)
                p:EmitSound("physics/glass/glass_impact_bullet4.wav")
            end
            VectivusSuits.SetVar( p, "SuitHealth", hp )
        end
    end
end
hook.Add( "EntityTakeDamage", "VectivusSuits.OnTakeDamage", VectivusSuits.OnTakeDamage )
hook.Add( "VectivusSuits.CanTakeDamage", "a", function( p, t )
    local inf = t:GetInflictor()
    if t:IsFallDamage() then return false end
    if inf and inf:GetClass() == "prop_physics" then return false end
end )
hook.Add( "VectivusSuits.OnTakeDamage", "a", function( p, t )
    do // Config OnTakeDamage
        local tt = VectivusSuits.GetPlayerSuitTable( p )
        if tt and tt.OnTakeDamage then tt.OnTakeDamage( p, t ) end
    end
    do // prevent suit dropping
        if p.vs_suit_drop then
            p:SetNWFloat( "VectivusSuits.DropSuitEnd", 0 )
            p.vs_suit_drop = nil
        end
    end
    do // Abilities
        local _tt = VectivusSuits.Abilities
        local att = IsValid( t:GetAttacker() ) and t:GetAttacker() or nil
        local vic = VectivusSuits.GetPlayerSuitAbilityTable( p ) or nil
        local _att = (att and VectivusSuits.GetPlayerSuitAbilityTable(att)) or {}
        if p == att then return end
        if att then
            for i, kk in pairs(_att) do
                if !_tt[kk or ""] then continue end
                local ii = att.vs_suit_ability_start and att.vs_suit_ability_start[kk]
                if _tt[kk].OnAttack and ii then _tt[kk].OnAttack( att, p, t ) end // attacker
            end
        end
        if vic then
            for i, kk in pairs(vic) do
                if !_tt[kk or ""] then continue end
                local ii = p.vs_suit_ability_start and p.vs_suit_ability_start[kk]
                if _tt[kk].OnAttacked and ii then _tt[kk].OnAttacked( p, att, t ) end // victim
            end
        end
    end
end )

hook.Add( "PlayerShouldTakeDamage", "VectivusSuits.NoDamgeWearingSuit", function(p)
    return !VectivusSuits.GetPlayerSuit(p) and true or false
end )
