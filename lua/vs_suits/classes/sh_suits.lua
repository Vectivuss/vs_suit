
local SUIT = { }    
SUIT.__index = SUIT

AccessorFunc( SUIT, "Name", "Name", FORCE_STRING )
AccessorFunc( SUIT, "Model", "Model", FORCE_STRING )

AccessorFunc( SUIT, "Health", "Health", FORCE_NUMBER )
AccessorFunc( SUIT, "Armor", "Armor", FORCE_NUMBER )
AccessorFunc( SUIT, "JumpPower", "JumpPower", FORCE_NUMBER )
AccessorFunc( SUIT, "Speed", "Speed", FORCE_NUMBER )

AccessorFunc( SUIT, "Weapons", "Weapons" )
AccessorFunc( SUIT, "Abilities", "Abilities" )

AccessorFunc( SUIT, "OnTakeDamage", "OnTakeDamage" )
AccessorFunc( SUIT, "OnEquip", "OnEquip" )
AccessorFunc( SUIT, "OnRemove", "OnRemove" )

function Suits.Create( )
    return setmetatable( { }, SUIT )
end