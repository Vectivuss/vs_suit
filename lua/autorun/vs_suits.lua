
VectivusSuits = VectivusSuits or { }

local IncludeSV = function( Path )
    if SERVER then
        return include( Path )
    end
end

local IncludeCL = function( Path )
    if SERVER then
        AddCSLuaFile( Path )
    else
        return include( Path )
    end
end

local IncludeSH = function( Path )
    if SERVER then
        AddCSLuaFile( Path )
    end
    return include( Path )
end

if not printf then
    printf = IncludeSH( "inventory/external/sh_printf.lua" )
end

function VectivusSuits.LoadFile( Directory, File )
    Directory = Directory or ""

    if File:StartsWith( "sv_" ) then
        return IncludeSV( Directory .. File )
    elseif File:StartsWith( "sh_" ) then
        return IncludeSH( Directory .. File )
    elseif File:StartsWith( "cl_" ) then
        return IncludeCL( Directory .. File )
    end
end

function VectivusSuits.LoadDirectory( Directory, Preload )
    Directory = Directory:match( "/$" ) and Directory or ( Directory .. "/" )

    local Files, Dirs = file.Find( Directory .. "*", "LUA" )
    local Start = math.Round( CurTime( ) )
    local PreLoadLookup = { }

    if Preload and istable( Preload ) then
        for i = 1, #Preload do
            local File = Preload[ i ]
            PreLoadLookup[ File ] = true

            if table.HasValue( Files, File ) then
                Inventory.LoadFile( Directory, File )
            end
        end
    end

    for i = 1, #Files do
        local File = Files[ i ]
        if not PreLoadLookup[ File ] then
            Inventory.LoadFile( Directory, File )
        end
    end

    local EndTime = ( CurTime( ) - Start )
    EndTime = math.Round( EndTime, 2 )

    printf( PRINT_INFO, "Loader", "Loaded %s Files from %s within %sms", #Files, Directory, EndTime )

    for i = 1, #Dirs do
        Inventory.LoadDirectory( Directory .. Dirs[ i ] )
    end
end

--- Load Assets ---

resource.AddFile( "resource/fonts/Purista" )

--- Classes ---



-- local function Initialize( )
--     LoadFile( nil, "sh_suits_main.lua" )

--     LoadDirectory( "vs_suits" )

--     LoadFile( nil, "sv_suits_config.lua" )

--     hook.Run( "VectivusSuits:OnLoaded" )
-- end

-- timer.Simple( 0, Initialize )