
gameevent.Listen( "player_activate" )

hook.Add( "player_activate", "VectivusLib:PlayerFullySpawned", function( data )
    local p = Player( data.userid )

    timer.Simple( 1, function( )
        if not IsValid( p ) or not p:IsPlayer( ) or p:IsBot( ) then return end
        hook.Run( "VectivusLib:PlayerFullySpawned", p )
    end )
end )
