local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

PrefabFiles = {
	"glace",
    "glace_ice",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/glace.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/glace.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/glace.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/glace.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/glace_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/glace_silho.xml" ),

    Asset( "IMAGE", "bigportraits/glace.tex" ),
    Asset( "ATLAS", "bigportraits/glace.xml" ),
	
	Asset( "IMAGE", "images/map_icons/glace.tex" ),
	Asset( "ATLAS", "images/map_icons/glace.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_glace.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_glace.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_glace.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_glace.xml" ),

}

STRINGS.CHARACTER_TITLES.glace = "The Freezer"
STRINGS.CHARACTER_NAMES.glace = "Glace"
STRINGS.CHARACTER_DESCRIPTIONS.glace = "* Has a cold heart\n* Hates winter\n* Likes to be among friends"
STRINGS.CHARACTER_QUOTES.glace = "\"Must be the winter...\""

STRINGS.CHARACTERS.GLACE = require "speech_glace"

STRINGS.NAMES.GLACE = "Glace"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.GLACE = 
{
	GENERIC = "It's Glace! I'm already freezing!",
	ATTACKER = "Glace is so cold hearted...",
	MURDERER = "Murderer!",
	REVIVER = "So your heart is warm after all.",
	GHOST = "Glace is even colder now.",
}

TUNING = GLOBAL.TUNING

TUNING.glace = {
    Giants = GetModConfigData("GIANTS"),
    Speed = GetModConfigData("SPEED")
}

AddMinimapAtlas("images/map_icons/glace.xml")

AddModCharacter("glace", "MALE")
