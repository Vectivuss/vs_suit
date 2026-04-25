
gameevent.Listen( "player_activate" )

local function PlayerSpawn( ply )
    hook.Run( "VectivusLib:PlayerFullySpawned", ply )
end

hook.Add( "player_activate", "VectivusLib:PlayerFullySpawned", function( data )
    local ply = Player( data.userid )

    if not IsValid( ply ) or not ply:IsPlayer( ) then return end
    if ply:IsBot( ) then PlayerSpawn( ply ) return end

    local Retries, MaxRetries = 0, 3
    local sid64 = ply:SteamID64( )

    local function PlayerLoader( )
        if not IsValid( ply ) then
            timer.Remove( "vs.InitialSpawn." .. sid64 )
            return
        end

        if ply:IsFullyAuthenticated( ) then
            timer.Remove( "vs.InitialSpawn." .. sid64 )
            PlayerSpawn( ply )
        else
            Retries = Retries + 1
            if Retries >= MaxRetries then
                timer.Remove( "vs.InitialSpawn." .. sid64 )

                printf( PRINT_WARN, "PlayerFullySpawned", "%s failed to fully authenticate after %s retries", ply:Name( ), MaxRetries )
            end
        end
    end

    timer.Create( "vs.InitialSpawn." .. sid64, 1, MaxRetries, PlayerLoader )
end )