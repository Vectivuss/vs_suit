
![Logo](https://i.imgur.com/he9ZcWI.png)

## Vectivus´s Armor Suits

VS Suits (Vectivus Armor Suits) is a replacement for [Armor6](https://www.gmodstore.com/market/view/armor-suits-now-with-saving-options). Created by [Vectivus](github.com/vectivuss/). VS Suits was created as a modern system couterpart to Armor6, more compatability, features and designed towards large servers. A main feature to VS Suits is that the suit has it's own HP & AP which is seperate from the Player, This allows the player to have to repair/fix the suit by other means or use a different Armor. Apon the Armor reaching 0 Health it will break reverting the player back to their original stat

## Features
This a small comparision to VS Suits to Armor6 and since it's no longer updated or suported you can see the problems it has in current time. I will continue to support popular addons or if requested i shall support them if needed
| Feature       | VS Suit | Armor6 |
|:--------------|:-------------:|:-------------:
| Armor Suit Abilities    | ✔️ | ❌ |
| [VoidCases](https://www.gmodstore.com/market/view/voidcases-unboxing-system) | ✔️ | ✔️ |
| [ItemStore](https://www.gmodstore.com/market/view/itemstore-inventory-bank-and-trading-for-darkrp) | ✔️ | ❌ |
| [DarkRP](https://github.com/FPtje/DarkRP) | ✔️ | ✔️ |
| [Xenin inventory](https://www.gmodstore.com/market/view/xenin-inventory) | ✔️ | ❌ |
| [Brick's Essentials](https://www.gmodstore.com/market/view/bricks-essentials) | ✔️ | ❌ |

## Addon Documentation
https://vectivuss-organization.gitbook.io/vectivus-suits

## How do i create armor?
You will require some basic gLua knowledge in order to fully create suits however if you wish to make ones that only affect: Health, Armor, Movement then gLua knowledge isn't required. A 'test armor' has been left in the configuration file with some advanced features already present for those who know what they're doing
```lua
VectivusSuits.CreateSuit( "Example", { -- name of Armor
    model = "models/player/corpse1.mdl", -- playermodel
    health = 300, -- total health
    armor = 100, -- total armor
    jumpPower = 300, -- height can jump
    speed = 600, -- running speed
} )
```

## Installation
* Download the latest instance of [VS Suits](https://github.com/Vectivuss/vs_suit/releases), mainly to avoid potential bugs or glitches and remain up to date
* Place `vs_suits_<version>` within your servers `garrysmod/addons` dirrectory and you're finished
* To Configure the addon head over to: `garrysmod/addons/vs_suits_<version>/sv_suits_config.lua` or `garrysmod/addons/vs_suits_<version>/sh_suits_main.lua`


## Media

### Abilities
![Logo](https://i.imgur.com/6T2Y7pn.png)
![Logo](https://i.imgur.com/cLU8UdC.png);![Logo](https://i.imgur.com/ua9DXop.png)
### Player HUD
![Logo](https://i.imgur.com/lXxEGMy.png)
### Armor Crate
![Logo](https://i.imgur.com/3Wmdsh2.png)
