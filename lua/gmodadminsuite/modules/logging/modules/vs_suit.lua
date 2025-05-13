
// =============================================================================
// Equip & Drop
// =============================================================================

local MODULE        = GAS.Logging:MODULE( )
MODULE.Category     = "VS Suits"
MODULE.Name         = "Equip & Drop"
MODULE.Colour       = Color( 87, 39, 210 )

MODULE:Setup( function( ) 
    MODULE:Hook( "VectivusSuits.OnEquippedSuit", "GAS:Support", function( ply, suit )
        MODULE:Log( "{1} Equipped a(n) {2}", GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatEntity( suit ) )
    end )

    MODULE:Hook( "VectivusSuits.OnRemovedSuit", "GAS:Support", function( ply, suit )
        MODULE:Log( "{1} Dropped a(n) {2}", GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatEntity( suit ) )
    end )
end )

GAS.Logging:AddModule( MODULE )

// =============================================================================
// Destroyed
// =============================================================================

local MODULE        = GAS.Logging:MODULE( )
MODULE.Category     = "VS Suits"
MODULE.Name         = "Destroyed"
MODULE.Colour       = Color( 87, 39, 210 )

MODULE:Setup( function( ) 
    MODULE:Hook( "VectivusSuits.OnSuitDestroyed", "GAS:Support", function( ply, data, dmg )
        local suit = data.name
        local att = IsValid( dmg:GetAttacker( ) ) and dmg:GetAttacker( )

        if not att then return end

        if att:IsPlayer( ) then
            MODULE:Log( "{1} destroyed {2} {3}", GAS.Logging:FormatPlayer( att ), GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatEntity( suit ) )
        else
            MODULE:Log( "{1} destroyed {2} {3}", att, GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatEntity( suit ) )
        end
    end )
end )

GAS.Logging:AddModule( MODULE )

// =============================================================================
// Damage
// =============================================================================

local MODULE        = GAS.Logging:MODULE( )
MODULE.Category     = "VS Suits"
MODULE.Name         = "Damage"
MODULE.Colour       = Color( 87, 39, 210 )

MODULE:Setup( function( ) 
    MODULE:Hook( "VectivusSuits.OnTakeDamage", "GAS:Support", function( ply, dmg )
        local suit = ply:GetSuit( )
        local att = IsValid( dmg:GetAttacker( ) ) and dmg:GetAttacker( )
        if not att then return end

        if att:IsPlayer( ) then
            MODULE:Log( "{1} dealt {2} damage to {3} {4}", GAS.Logging:FormatPlayer( att ), GAS.Logging:FormatDamage( dmg ), GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatEntity( suit ) )
        else
            MODULE:Log( "{1} dealt {2} damage to {3} {4}", GAS.Logging:FormatEntity( att ), GAS.Logging:FormatDamage( dmg ), GAS.Logging:FormatPlayer( ply ), GAS.Logging:FormatEntity( suit ) )
        end
    end )
end )

GAS.Logging:AddModule( MODULE )