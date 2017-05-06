local assets =
{
	Asset( "ANIM", "anim/wollum.zip" ),
	Asset( "ANIM", "anim/ghost_wollum_build.zip" ),
}

local skins =
{
	normal_skin = "wollum",
	ghost_skin = "ghost_wollum_build",
}

local base_prefab = "wollum"

local tags = {"WOLLUM", "CHARACTER"}

return CreatePrefabSkin("wollum_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,
	
	skip_item_gen = true,
	skip_giftable_gen = true,
})