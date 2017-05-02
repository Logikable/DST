PrefabFiles = {
	"wollum",
	"wollum_none",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/wollum.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/wollum.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/wollum.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/wollum.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/wollum_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/wollum_silho.xml" ),

    Asset( "IMAGE", "bigportraits/wollum.tex" ),
    Asset( "ATLAS", "bigportraits/wollum.xml" ),
	
	Asset( "IMAGE", "images/map_icons/wollum.tex" ),
	Asset( "ATLAS", "images/map_icons/wollum.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_wollum.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_wollum.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_wollum.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_wollum.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_wollum.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_wollum.xml" ),
	
	Asset( "IMAGE", "images/names_wollum.tex" ),
    Asset( "ATLAS", "images/names_wollum.xml" ),
	
    Asset( "IMAGE", "bigportraits/wollum_none.tex" ),
    Asset( "ATLAS", "bigportraits/wollum_none.xml" ),

}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local FOODTYPE = GLOBAL.FOODTYPE

-- changing up data about existing items
FOODTYPE.WOLLUM = "WOLLUM"
AddPrefabPostInit("cutstone", function(inst)
	inst:AddComponent("edible")
	inst.components.edible.hungervalue = 0
	inst.components.edible.foodtype = FOODTYPE.WOLLUM
	end)
AddPrefabPostInit("marble", function(inst)
	inst:AddComponent("edible")
	inst.components.edible.hungervalue = 0
	inst.components.edible.foodtype = FOODTYPE.WOLLUM
	end)

ELEMENTALFOOD = {"rocks", "cutstone", "flint", "nitre", "goldnugget", "marble", "moonrocknugget", "redgem", "bluegem",
	"purplegem", "greengem", "yellowgem", "orangegem", "opalpreciousgem", "thulecite_pieces", "thulecite"}

for i = 1, #ELEMENTALFOOD do
	AddPrefabPostInit(ELEMENTALFOOD[i], function(inst)
		inst.components.edible.healthvalue = 0
		end)
end

-- The character select screen lines
STRINGS.CHARACTER_TITLES.wollum = "The Sample Character"
STRINGS.CHARACTER_NAMES.wollum = "Wollum"
STRINGS.CHARACTER_DESCRIPTIONS.wollum = "*Rock\n*Hard"
STRINGS.CHARACTER_QUOTES.wollum = "\"Quote\""

-- Custom speech strings
STRINGS.CHARACTERS.WOLLUM = require "speech_wollum"

-- The character's name as appears in-game 
STRINGS.NAMES.WOLLUM = "Wollum"

AddMinimapAtlas("images/map_icons/wollum.xml")

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("wollum", "NEUTRAL")