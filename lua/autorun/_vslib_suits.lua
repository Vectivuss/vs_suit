
local IncludeSV = SERVER and include or function( ) end
local IncludeCL = CLIENT and include or AddCSLuaFile
local IncludeSH = function( path ) IncludeSV( path ) IncludeCL( path ) end

local function LoadFile( Directory, File )
    Directory = Directory or ""

    if File:StartsWith( "sv_" ) then
        IncludeSV( Directory .. File )
    elseif File:StartsWith( "sh_" ) then
        IncludeSH( Directory .. File )
    elseif File:StartsWith( "cl_" ) then
        IncludeCL( Directory .. File )
    end
end

local function LoadDirectory( Directory )
    Directory = Directory:match( "/$" ) and Directory or ( Directory .. "/" )

    local files, Dirs = file.Find( Directory .. "*", "LUA" )

    for i = 1, #files do
        LoadFile( Directory, files[ i ] )
    end

    MsgC( Color( 146, 103, 255 ), "[ Vectivus : Suits ] ", color_white, ( "[%s] Files: %s" ):format( Directory, table.concat( files, ", " ) ) .. "\n" )

    for i = 1, #Dirs do
        LoadDirectory( Directory .. Dirs[ i ] )
    end
end

VectivusSuits = VectivusSuits or {
    Suits = { },
    Abilities = { },
    Config = { }
}

local function Initialize( )
    LoadFile( nil, "sh_suits_main.lua" )

    LoadDirectory( "vs_suits" )

    LoadFile( nil, "sv_suits_config.lua" )
end

timer.Simple( 0, Initialize )