
net.Receive( "vs.suits", function( len )
    local data = net.ReadData( len )
    data = util.Decompress( data )
    data = util.JSONToTable( data or "" ) or { }

    local suits = util.JSONToTable( data.suits or "" ) or { }
    local abilities = util.JSONToTable( data.abilities or "" ) or { }

    VectivusSuits.Suits = suits
    VectivusSuits.Abilities = abilities

    VectivusSuits.GenerateSuits( )
end )