
local Surface = {
    FontCache = { },
    Materials = { }
}

local Scale = 1

//-/~ Scale
function Surface:Scale( Size )
    local val = math.floor( math.max( Size * ( math.min( ScrH( ), 1080 ) / ( 1440 ) ), 1) )
    val = val % 2 ~= 0 and val + 1 or val

    return val
end

function Surface:ScaleEven( Size )
    Size = self:Scale( Size )

    if Size % 2 ~= 0 then
        Size = Size + 1
    end

    return v
end

//-/~ CreateFont
function Surface:CreateFont( name, font, size, weight )
    self.FontCache[ name ] = self.FontCache[ name ] or {
        font = font,
        size = size,
        weight = weight
    }

    surface.CreateFont( "vs." .. name, {
        font = font,
        size = ( ScrH( ) / 1080 ) * size,
        antialias = true,
        weight = weight
    } )
end

//-/~ GetTextSize
function Surface:GetTextSize( Font, String )
    surface.SetFont( Font )
    return surface.GetTextSize( String )
end

//-/~ DrawText
function Surface:DrawText( String, Font, x, y, Color )
    surface.SetTextColor( Color )
    surface.SetTextPos( x, y )
    surface.SetFont( Font )
    surface.DrawText( String )
end

//-/~ DrawTexturedRectRotated
function Surface:DrawTexturedRectRotated( Mat, Color, x, y, w, h, Rotation )
    if not self.Materials[ Mat ] then
        self.Materials[ Mat ] = Material( Mat )
    end

    surface.SetDrawColor( Color )
    surface.SetMaterial( self.Materials[ Mat ] )
    surface.DrawTexturedRectRotated( x, y, w, h, Rotation )
end

//-/~ DrawRect
function Surface:DrawRect( x, y, w, h, Color )
    surface.SetDrawColor( Color )
    surface.DrawRect( x, y, w, h )
end

//-/~ DrawLine
function Surface:DrawLine( x, y, x2, y2, Color )
    surface.SetDrawColor( Color )
    surface.DrawLine( x, y, x2, y2 )
end

//-/~ DrawOutlinedRect
function Surface:DrawOutlinedRect( x, y, w, h, Thick, Color )
    surface.SetDrawColor( Color )
    surface.DrawOutlinedRect( x, y, w, h, Thick )
end

//-/~ DrawTexturedRect
function Surface:DrawTexturedRect( Mat, Color, x, y, w, h )
    if not self.Materials[ Mat ] then
        self.Materials[ Mat ] = Material( Mat )
    end

    surface.SetDrawColor( Color )
    surface.SetMaterial( self.Materials[ Mat ] )
    surface.DrawTexturedRect( x, y, w, h )
end

hook.Add( "OnScreenSizeChanged", "VectivusLib.Fonts", function( )
    for k, v in pairs( Surface.FontCache ) do
        Surface:CreateFont( k, v.font, v.size, v.weight )
    end
end )

return Surface