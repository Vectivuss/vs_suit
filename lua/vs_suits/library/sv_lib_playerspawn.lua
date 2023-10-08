
--[[------------------------------------------
    @ Lib       » PlayerInitialSpawn
    @ Author    » Vectivus
--------------------------------------------]]

VectivusLib = VectivusLib or {}

hook.Add( "PlayerSpawn", "VectivusLib.PlayerInitialSpawn", function( p )
    if p.VectivusLib_PlayerInitialSpawn then return end
    p.VectivusLib_PlayerInitialSpawn = true
	hook.Add( "SetupMove", p, function( self, pl, _, cmd )
		if self == pl and not cmd:IsForced() then
			hook.Run( "VectivusLib:PlayerInitialSpawn", self )
			hook.Remove( "SetupMove", self )
		end
	end )
end )
