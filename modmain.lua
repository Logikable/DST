AddPrefabPostInit("rocks", function(inst)
	inst:AddComponent("edible")
	inst.components.edible.foodtype = GLOBAL.FOODTYPE.ROCKTYPE
	inst.components.edible.healthvalue = 0
	inst.components.edible.sanityvalue = 0
	inst.components.edible.hungervalue = 3.125
end)