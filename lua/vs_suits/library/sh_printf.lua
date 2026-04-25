
PRINT_DEBUG     = 1
PRINT_INFO      = 2
PRINT_WARN      = 3
PRINT_ERROR     = 4

local scheme = {
    { name = "DEBUG", color = Color( 0, 200, 150 ) },
    { name = "INFO",  color = Color( 70, 135, 255 ) },
    { name = "WARN",  color = Color( 255, 130, 90 ) },
    { name = "ERROR", color = Color( 250, 55, 40 ) },
}

local Len = 0

for _, v in pairs(scheme) do
    if #v.name > Len then Len = #v.name end
end

local Text      = SERVER and "[ Server ]" or "[ Client ]"
local RealmC    = SERVER and Color( 5, 170, 250 ) or Color( 225, 170, 10 )
local Grey      = Color( 180, 180, 180 )
local Pink      = Color( 219, 115, 214 ) 

return function( Level, Module, Format, ... )
    local Lvl = scheme[ Level ] or scheme[ 2 ]
    local LvlName, LvlColor = Lvl.name, Lvl.color

    local Padding = string.format( "%-" .. Len .. "s", LvlName )

    local t = os.date( "*t" )
    local ms = math.floor( SysTime( ) * 1000 ) % 1000

    local timeStr = string.format( "%02d-%02d-%04d %02d:%02d:%02d.%03d ", t.day, t.month, t.year, t.hour, t.min, t.sec, ms )
    local text = ( #{ ... } > 0 ) and string.format( Format, ... ) or Format

    MsgC( Grey, timeStr, RealmC, Text .. " ", LvlColor, Padding, Grey, " --> ", Pink, Module, Grey, " : ", color_white, text, "\n" )
end