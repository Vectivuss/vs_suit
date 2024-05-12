
--[[------------------------------------------
    @ Lib       » PlayerInitialSpawn
    @ Author    » Vectivus
--------------------------------------------]]

VectivusLib = VectivusLib or {}

gameevent.Listen( "player_activate" )
hook.Add( "player_activate", "VectivusLib.PlayerInitialSpawn", function( data )
	local p = Player(data.userid)
	if !p:IsValid(p) or !p:IsPlayer() then return end
	hook.Run( "VectivusLib:PlayerInitialSpawn", p )
end )
