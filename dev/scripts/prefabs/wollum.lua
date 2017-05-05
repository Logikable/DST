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
	if food.prefab == "yellowgem" then
		inst.Light:Enable(true)
		inst:DoTaskInTime(8 * 60, function(inst)	-- full day is 8 minutes
			inst.Light:Enable(false)
			end)
	end
	if food.prefab == "orangegem" then
		inst:PushEvent("yawn", { grogginess = 4, knockoutduration = TUNING.MANDRAKE_SLEEP_TIME})
		inst.components.sleeper:AddSleepiness(7, TUNING.MANDRAKE_SLEEP_TIME)
	end

	-- effects of eating food - hunger, health, sanity
	if FOODS[food.prefab] then
		inst.components.hunger:DoDelta(FOODS[food.prefab].hunger - food.components.edible.hungervalue)
		inst.components.health:DoDelta(FOODS[food.prefab].health)
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

	-- changes up his diet a bit so it only allows minerals
	inst.components.eater:SetDiet({FOODTYPE.ELEMENTAL, FOODTYPE.WOLLUM}, {FOODTYPE.ELEMENTAL, FOODTYPE.WOLLUM})
	inst.components.eater:SetOnEatFn(OnEat)

	-- glows in the dark after eating orange gem; must be enabled
	inst.entity:AddLight()
	inst.Light:SetIntensity(0.8)
	inst.Light:SetRadius(1.5)
	inst.Light:SetFalloff(0.5)

	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 1
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 0.5 * TUNING.WILSON_HUNGER_RATE
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
    -- default food values
	FOODS.rocks = {hunger=TUNING.CALORIES_TINY, health=0, sanity=0}
	FOODS.cutstone = {hunger=TUNING.CALORIES_LARGE, health=TUNING.HEALING_SMALL, sanity=0}
	FOODS.flint = {hunger=TUNING.CALORIES_SMALL, health=TUNING.HEALING_TINY, sanity=0}
	FOODS.nitre = {hunger=TUNING.CALORIES_MEDSMALL, health=-TUNING.HEALING_MEDSMALL, sanity=0}
	FOODS.goldnugget = {hunger=TUNING.CALORIES_TINY, health=0, sanity=TUNING.SANITY_MED}
	FOODS.marble = {hunger=TUNING.CALORIES_MED, health=TUNING.HEALING_TINY, sanity=0}
	FOODS.moonrocknugget = {hunger=TUNING.CALORIES_MED, health=TUNING.HEALING_SMALL, sanity=TUNING.SANITY_TINY}
	FOODS.redgem = {hunger=TUNING.CALORIES_MEDSMALL, health=TUNING.HEALING_MED, sanity=TUNING.SANITY_MED}
	FOODS.bluegem = {hunger=TUNING.CALORIES_MEDSMALL, health=TUNING.HEALING_MEDSMALL, sanity=TUNING.SANITY_LARGE}
	FOODS.purplegem = {hunger=TUNING.CALORIES_HUGE, health=TUNING.HEALING_LARGE, sanity=-TUNING.SANITY_LARGE}
	FOODS.greengem = {hunger=TUNING.CALORIES_MEDSMALL, health=TUNING.HEALING_TINY, sanity=TUNING.SANITY_HUGE}
	FOODS.yellowgem = {hunger=TUNING.CALORIES_MEDSMALL, health=TUNING.HEALING_MEDSMALL, sanity=-TUNING.SANITY_MED}
	FOODS.orangegem = {hunger=TUNING.CALORIES_HUGE, health=TUNING.HEALING_MEDLARGE, sanity=TUNING.SANITY_MEDLARGE}
	FOODS.opalpreciousgem = {hunger=TUNING.CALORIES_SUPERHUGE, health=TUNING.HEALING_SUPERHUGE, sanity=TUNING.SANITY_HUGE}
	FOODS.thulecite_pieces = {hunger=TUNING.CALORIES_SMALL, health=TUNING.HEALING_MEDSMALL, sanity=-TUNING.SANITY_SMALL}
	FOODS.thulecite = {hunger=TUNING.CALORIES_MEDSMALL, health=TUNING.HEALING_HUGE, sanity=-TUNING.SANITY_LARGE}
end

return MakePlayerCharacter("wollum", prefabs, assets, common_postinit, master_postinit, start_inv)
