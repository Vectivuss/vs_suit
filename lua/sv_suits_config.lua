
timer.Simple( 0, VectivusSuits.SyncSuitData )

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

Suits.CreateSuit( "Test Suit", {
    model = "models/player/corpse1.mdl",
    health = 300,
    armor = 100,
    jumpPower = 300,
    speed = 600,
    weapons = { // weapons that have % immunity, [weaponclass] = 1.1 (percentage)
        ["weapon_rpg"] = 1.4 -- 40% reduction to dmg
    },
    abilities = { // [abilitykey] = KeyBind
        ["Juggernaut"] = KEY_V,
        ["Regeneration"] = KEY_B,
        ["AntMan"] = KEY_N,
    },
} )

/////////////////////////////////////////////////////////////////////////////////
/////////////////////////////// Suit Ability Config /////////////////////////////
//////////////////////////////////////////////////////////////////////////////////

Suits.CreateSuitAbility( "Sonic", {
    desc = "Gains a 50% speed boost allowing you to catch up to people or escape from danger",
    start = 2, // how long ability lasts ( float )
    cooldown = 6, // how long the cooldown lasts ( starts after ability ends )
    color = Color(197,105,216),
    OnActive = function( p ) // player, ran once ability is activated
        p:SetRunSpeed( p:GetRunSpeed() * 1.5 )
    end,
    OnEnd = function( p ) // player, ran once ability finishes
        local t = Suits.GetPlayerSuitTable( p )
        if !t then return end
        p:SetRunSpeed( t.speed )
    end,
} )

Suits.CreateSuitAbility( "Juggernaut", {
    desc = "This provides 40% damage resistance from ALL types of damage",
    start = 4,
    cooldown = 20,
    color = Color(135, 241, 241),
    OnAttacked = function( p, att, t ) // victim, attacker, CTakeDamageInfo
        t:SetDamage( t:GetDamage() / 1.4 )

        print( "debug", p, att, t )
    end,
} )

Suits.CreateSuitAbility( "AntMan", {
    desc = "Shrinks you down to the size of an ant making it harder for opponents to hit you",
    start = 5,
    cooldown = 30,
    color = Color(68,233,53),
    OnActive = function( p )
        local i = .75
        p:SetModelScale( i, .1 )
        p:SetViewOffset(Vector(0, 0, 64 * i))
        p:SetViewOffsetDucked(Vector(0, 0, 28 *i))
    end,
    OnEnd = function( p )
        local i = 1
        p:SetModelScale( i, .1 )
        p:SetViewOffset(Vector(0, 0, 64 * i))
        p:SetViewOffsetDucked(Vector(0, 0, 28 *i))
    end,
} )

Suits.CreateSuitAbility( "Invisibility", {
    desc = "Turns your transparent making you somewhat invisible to others",
    start = 6,
    cooldown = 17,
    color = Color(66,162,226),
    OnActive = function( p )
        p:SetMaterial("Models/effects/comball_tape")
        p:SetColor(Color(255,0,0))
    end,
    OnEnd = function( p )
        p:SetMaterial("")
        p:SetColor(Color(255,255,255))
    end,
} )

Suits.CreateSuitAbility( "Regeneration", {
    desc = "Gains suit 15AP every 0.8s however WONT exceed the suits max armor",
    start = 4,
    cooldown = 20,
    color = Color(230,47,92),
    OnThink = function( p )
        if timer.Exists( "vs_suits.Regeneration."..tostring(p) ) then return end
        timer.Create( "vs_suits.Regeneration."..tostring(p), .8, 1, function()
            local ap = Suits.GetVar( p )["SuitArmor"] or 0
            local t = Suits.GetPlayerSuitTable( p )
            if !t then return end
            Suits.SetVar( p, "SuitArmor", math.Clamp( ap+15, 0, (t.armor or 100) ) )
        end )
    end,
} )