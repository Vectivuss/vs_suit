
local gradient = Material( "vgui/gradient-l" )
local gradientDown = Material( "gui/gradient_down" )

local p

VectivusSuits.Colors = {
    [ "white" ]         = Color(255,255,255),
    [ "white01" ]       = Color(210,210,210),
    [ "white02" ]       = Color(200,200,200),
    [ "white03" ]       = Color(190,190,190),
    [ "white04" ]       = Color(200,200,200,100),
    [ "grey01" ]        = Color(200,200,200,100),
    [ "grey02" ]        = Color(155,155,155,55),
    [ "black01" ]       = Color(0,0,0,215),
    [ "black02" ]       = Color(0,0,0,222),
    [ "green01" ]       = Color(59,241,120),
    [ "green02" ]       = Color(88,216,131),
    [ "red01" ]         = Color(241,59,83),
    [ "background01" ]  = Color(16,8,21,250)
}

local function _SharedAbilityPaint( i, x, y, w, h )
    local abilityTbl = VectivusSuits.GetPlayerSuitTable( p ).abilities
    local bind = abilityTbl[ i ]
    bind = string.upper( input.GetKeyName( bind ) )

    local k = VectivusSuits.GetAbilityData( i )
    local cols = k and k.color
    local _i = VectivusSuits.GetPlayerAbilityCooldown( p, i )
    local ii = VectivusSuits.GetPlayerAbilities( p, i ) or 0
    local f = math.Clamp( math.Remap( ii - CurTime( ), 0, 4, 0, 1 ), 0, 1 )
    local b = (ii <= 0 and bind or ii)

    draw.RoundedBox( 6, x, y, w, h, Color(cols.r,cols.g,cols.b) )
    draw.RoundedBox( 6, x+2, y+2, w-4, h-4, color_black )

    draw.SimpleText( b, (ii>0&&"vs.suits.ui.45"||"vs.suits.ui.50"), x+(w*.5), y+(h*.45), _i and cols or VectivusSuits.Colors[ "white01" ], 1, 1 )

    surface.SetDrawColor(cols.r,cols.g,cols.b,(_i and 70 or 140))
    surface.SetMaterial(gradientDown)
    surface.DrawTexturedRect( x+2, y+1, w-2, h )
end

local function _SharedAbilityInfo( i, x, y, w, h )
    local xx, yy = input.GetCursorPos( )

    if xx == 0 or yy == 0 then return end
    local pos = {}

    pos[ i ] = {x=(xx>=x and xx<=x+w),y=(yy>=y and yy<=y+h),}

    if pos[ i ].x and pos[ i ].y then
        if not VectivusSuits.GetPlayerSuit( p ) then return end
        local abilityTbl = VectivusSuits.GetPlayerSuitTable( p ).abilities
        local t = VectivusSuits.GetAbilityData( i )
        if not t then return end

        local w, h = ScrW( ), ScrH( )
        local x, y, W, H = w / 2, y, VectivusLib:Scale( 550 ), VectivusLib:Scale( 220 )
        local hh = VectivusLib:Scale( 340 ) -- size ignore

        local words = string.Explode( " ", t.desc or "" )
        local lines = { }
        local lineIndex = 1
    
        for _, v in pairs( words ) do
            lines[ lineIndex ] = lines[ lineIndex ] or ""
            lines[ lineIndex ] = lines[ lineIndex ] .. " " .. v
            if string.len( lines[ lineIndex ] ) > 60 then 
                lineIndex = lineIndex + 1
                H = H + h*.01
            end
        end

        x, y = x-W/2, y-H-y*.02

        // panel frame
        draw.RoundedBox( 8, x, y, W, H, VectivusSuits.Colors[ "grey01" ] )
        draw.RoundedBox( 8, x+1, y+1, W-2, H-2, VectivusSuits.Colors[ "background01" ] )

        // ability
        _SharedAbilityPaint( i, x+h*.008, y+h*.01, hh*.2, hh*.2 ) 
        draw.SimpleText( t.name or k, "vs.suits.ui.30", x+h*.062, y+h*.005, VectivusSuits.Colors[ "white" ], 0, 3 )

        // stats info
        local _y = y+h*.062
        local _, yY = draw.SimpleText( "Start: " .. (t.start or 0) .. "s", "vs.suits.ui.22", x+h*.008, _y, VectivusSuits.Colors[ "white" ], 0, 3 )
        _y = _y + yY

        local _, yY = draw.SimpleText( "Cooldown: " .. (t.cooldown or 0) .. "s", "vs.suits.ui.22", x+h*.008, _y, VectivusSuits.Colors[ "white" ], 0, 3 )
        _y = _y + yY +10

        for _, v in pairs( lines ) do
            local _, yY = draw.SimpleText( v, "vs.suits.ui.22", x+4, _y, VectivusSuits.Colors[ "white" ], 0, 3 )
            _y = _y + yY
        end
    end
end

function VectivusSuits.HUDStats( )
    local cfg = VectivusSuits.Suits[ VectivusSuits.GetPlayerSuit( p ) ]
    if not cfg then return end

    local w, h = ScrW( ), ScrH( )
    local x, y, W, H = h*.01, h*.026, VectivusLib:Scale( 400 ), VectivusLib:Scale( 44 )

    local name = cfg.name
    local hp = VectivusSuits.GetVar( p, "SuitHealth" )
    local ap = VectivusSuits.GetVar( p, "SuitArmor" )

    surface.SetFont( "vs.suits.uib.22" )

    local txt = string.format( "+%s Health", hp )

    if ap > 0 then 
        txt = string.format( txt .. " | +%s Armor", ap ) 
    end

    if cfg.speed and cfg.speed > 0 then 
        txt = string.format( txt .. " | +%s RunSpeed", cfg.speed ) 
    end

    if cfg.jumpPower and cfg.jumpPower > 0 then 
        txt = string.format( txt .. " | +%s JumpPower", cfg.jumpPower ) 
    end

    local tW = surface.GetTextSize( name .. txt )

    draw.RoundedBox( 0, x, (y - H/2), tW+(w*.016), H, VectivusSuits.Config.SuitHUD_Background or VectivusSuits.Colors[ "black01" ] )

    local w, y = x + w*.003, (y-H/2) + (h*.015)
    local ww, yy = draw.SimpleText( name, "vs.suits.uib.22", w, (y-H/2)+y/2, VectivusSuits.Config.SuitHUD_Name or VectivusSuits.Colors[ "green01" ], 0, 1 )

    w= w + ww + (w*.1)

    surface.SetDrawColor( VectivusSuits.Colors[ "white01" ] )
    surface.DrawRect( w+(w*.05), y-(h*.01), W*.012, H-(h*.01) )

    w = w + W*.04

    draw.SimpleText( txt, "vs.suits.uib.22", w, (y-H/2)+y/2, VectivusSuits.Config.SuitHUD_Text or VectivusSuits.Colors[ "white03" ], 0, 1 )
end

function VectivusSuits.HUDAbility( )
    if not IsValid( p ) then
        p = LocalPlayer( )
    end

    local w, h = ScrW( ), ScrH( )
    local x, y, W, H = w/2, h, VectivusLib:Scale( 70 ), VectivusLib:Scale( 65 )

    if not VectivusSuits.GetPlayerSuit( p ) then return end

    local cc, xx, yy, ww, hh = x-W/2, 0, y-H-(h*.01), W, H
    local padding = 6
    local ability = VectivusSuits.GetPlayerSuitAbilityTable( p ) or { }
    local abilitiesCount = #ability

    xx = xx - abilitiesCount * ww / 2 + W / 2 -padding

    local t = VectivusSuits.GetPlayerSuitTable( p )

    for k, bind in pairs( t and t.abilities or { } ) do
        local Abilities = VectivusSuits.GetAbilityData( k )
        if not Abilities then break end

        _SharedAbilityPaint( k, cc+xx, yy, ww, hh )
        _SharedAbilityInfo( k, cc+xx, yy, ww, hh )
        xx = xx + ww + padding
    end
end

function VectivusSuits.HUDDropSuit( )
    local w, h = ScrW( ), ScrH( )
    local x, y, W, H = w/2, h, VectivusLib:Scale( 250 ), VectivusLib:Scale( 16 )

    if not VectivusSuits.GetPlayerSuit( p ) then return end

    local i = p:GetNWFloat( "VectivusSuits.DropSuitEnd", 0 )
    local f = math.Clamp( math.Remap( i-CurTime( ), 0, 4, 0, 1 ), 0, 1 )

    i = math.Clamp( math.Round( i - CurTime( ), 1 ), 0, 999999 )
    if i <= 0 then return end

    local xx, yy, ww, hh = x-W/2, (y-H/2)-(h*.15), W, H

    draw.SimpleText( "Dropping...", "vs.suits.ui.24", xx+(ww*.52), yy-(h*.02), VectivusSuits.Colors[ "white" ], 1, 1 )
    draw.SimpleText( i.."s", "vs.suits.ui.24", xx+(ww*.52), yy+(h*.03), VectivusSuits.Colors[ "white" ], 1, 1 )

    draw.RoundedBox( 0, xx, yy, ww, hh, VectivusSuits.Colors[ "black02" ] )

    surface.SetDrawColor( VectivusSuits.Colors[ "white02" ]) 
    surface.SetMaterial( gradient )
    surface.DrawTexturedRect( xx+2, yy+2, (ww-4)*f, hh-4 )
end

hook.Add( "HUDPaint", "VectivusSuits.HUDPaint", function( ) 
    VectivusSuits.HUDStats( )
    VectivusSuits.HUDAbility( )
    VectivusSuits.HUDDropSuit( ) 
end )