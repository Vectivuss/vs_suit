
VectivusLib = VectivusLib or {}

local scaledFonts = scaledFonts or {}

function VectivusLib:Scale( i )
    return math.max( i*(ScrH()/1440), 1 )
end

function VectivusLib:RegisterFont( name, font, size, weight )
    surface.CreateFont( "vs." .. name, {
        font = font,
        size = size,
        weight = weight or 500,
    })
end

function VectivusLib:CreateFont( name, font, size, weight )
    scaledFonts[ name ] = {
        font = font,
        size = size,
        weight = weight,
    }
    self:RegisterFont( name, font, self:Scale( size ), weight )
end

hook.Add( "OnScreenSizeChanged", "VectivusLib:RegisterFont", function()
    timer.Simple( 1, function()
        for k, v in pairs( scaledFonts ) do
            print( "[   VectivusLib:Fonts - Updated:    ]", k )
            VectivusLib:CreateFont( k, v.font, v.size, v.weight )
        end
    end )
end )

do
    VectivusLib:CreateFont( "suits.ui.22", "Purista", 22 )
    VectivusLib:CreateFont( "suits.uib.22", "Purista", 22, 600 )
    VectivusLib:CreateFont( "suits.ui.24", "Purista", 24 )
    VectivusLib:CreateFont( "suits.ui.30", "Purista", 30 )
    VectivusLib:CreateFont( "suits.ui.45", "Purista", 45 )
    VectivusLib:CreateFont( "suits.ui.50", "Purista", 50 )
    VectivusLib:RegisterFont( "suits.ui.44", "Purista", 44 ) -- world
end
