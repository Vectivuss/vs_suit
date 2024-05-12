
net.Receive( "vs.suits", function( len )
    local data = net.ReadData( len )
    data = util.Decompress(data)
    data = util.JSONToTable( data or "" ) or {}

    do // Suit Data
        local suits = util.JSONToTable( data.suits or "" ) or {}
        VectivusSuits.Suits = suits
    end

    do // Suit Ability Data
        local abilities = util.JSONToTable( data.abilities or "" ) or {}
        VectivusSuits.Abilities = abilities
    end

    do // Populate SpawnMenu, Suit ENTs
        VectivusSuits.GenerateSuits()
    end
end )
