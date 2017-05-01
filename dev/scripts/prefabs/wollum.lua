local MakePlayerCharacter = require "prefabs/player_common"

local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = {}

-- Custom starting items
local start_inv = {
}

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when reviving from ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "wollum_speed_mod", 1)
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "wollum_speed_mod")
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon("wollum.tex")
end

FOODS = {}

local function OnEat(inst, food)
	if FOODS[food.prefab] then
		if inst.components.hunger <= inst.components.hunger.max - food.components.edible.hungervalue then
			inst.components.hunger:DoDelta(FOODS[food.prefab].hunger)
		end
		inst.components.hunger:DoDelta(FOODS[food.prefab].hunger - food.components.edible.hungervalue)
		inst.components.health:DoDelta(FOODS[food.prefab].health - food.components.edible.healthvalue)
		inst.components.sanity:DoDelta(FOODS[food.prefab].sanity)
	end
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "willow"
	
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- Stats	
	inst.components.health:SetMaxHealth(300)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(200)

	inst.components.eater:SetDiet({FOODTYPE.ELEMENTAL}, {FOODTYPE.ELEMENTAL})
	inst.components.eater:SetOnEatFn(OnEat)

	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 1
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
	FOODS.rocks = {hunger=3.125, health=0, sanity=0}
	FOODS.cutstone = {hunger=7.5, health=3, sanity=0}
	FOODS.flint = {hunger=1.875, health=1, sanity=0}
	FOODS.nitre = {hunger=9.375, health=0, sanity=-5}
	FOODS.goldnugget = {hunger=0, health=0, sanity=5}
	FOODS.marble = {hunger=20, health=0, sanity=0}
	FOODS.redgem = {hunger=32.5, health=30, sanity=5}
	FOODS.bluegem = {hunger=25, health=5, sanity=5}
	FOODS.purplegem = {hunger=75, health=60, sanity=-15}
	FOODS.opalpreciousgem = {hunger=150, health=300, sanity=200}
	FOODS.thulecite_pieces = {hunger=0, health=12, sanity=-5}
	FOODS.thulecite = {hunger=0, health=75, sanity=-20}
end

return MakePlayerCharacter("wollum", prefabs, assets, common_postinit, master_postinit, start_inv)
