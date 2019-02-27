
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),

        Asset( "ANIM", "anim/glace.zip" ),
        Asset( "ANIM", "anim/ghost_glace_build.zip" ),
}
local prefabs = {
	"glace_ice"
}

-- Custom starting items
local start_inv = {
	"ice",
	"ice",
	"ice"
}

local ice = nil

local spawn_ice = true

local ice_despawned = true

local last_x, last_y, last_z, x, y, z = 0, 0, 0, 0, 0, 0

local function IsInRange(value, range, offset)
	if value >= (range - offset) and range <= (range + offset) then
		return true
	end
	return false
end

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Glace is really fast
	if TUNING.glace.Speed == "NORMAL" then
		inst.components.locomotor.walkspeed = 8
		inst.components.locomotor.runspeed = 10
	else
		inst.components.locomotor.walkspeed = 4
		inst.components.locomotor.runspeed = 6
	end
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)

    if not inst:HasTag("playerghost") then
        onbecamehuman(inst)
    end
end

-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst)
	-- Glace is so cold that all his items are cooled.
	inst:AddTag("fridge")
	inst.MiniMapEntity:SetIcon( "glace.tex" )
end

-- He cools down extremly when he eats ice
local function onEat(inst, food)
	if food and food.prefab == "ice" then
		inst.components.temperature:SetTemperature(1)
		inst.components.temperature.maxtemp = 5
		if spawn_ice and ice_despawned then
			x, y, z = inst.Transform:GetWorldPosition()
			ice = SpawnPrefab("glace_ice")
			ice.persists = false
			ice.Transform:SetPosition(x, y, z)
			ice.AnimState:PlayAnimation("spawn")
			spawn_ice = false
			ice_despawned = false
			last_x = x
			last_y = y
			last_z = z
		end
	end
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "willow"
	
	-- Stats	
	inst.components.health:SetMaxHealth(100)
	inst.components.hunger:SetMax(65)
	inst.components.sanity:SetMax(220)


	-- Can't overheat, but is very vunerable to the cold
	inst.components.temperature.mintemp = -10
	inst.components.temperature.maxtemp = 35
	inst.components.temperature.hurtrate = 2.5
	inst.components.temperature.rate = 2
	
	-- Glace is a bit troubled by the dark. 
	inst.components.sanity.night_drain_mult = 2.5
	
	-- Damage multiplier
    	inst.components.combat.damagemultiplier = 1

	-- Glace is a freezer, so...
	inst:AddComponent("heater")
	inst.components.heater.heatfn = function() return -35 end
	inst.components.heater:SetThermics(false, true)
	
	-- Hunger rate; Glace has very good hunger management
	inst.components.hunger.hungerrate = 0.07
	
	inst.OnLoad = onload
    	inst.OnNewSpawn = onload

-- Glace likes to be among others. It makes him forget his worries.
	inst:DoPeriodicTask(2, function()
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 4 ,{"player"})
		if table.getn(ents) > 1 then
			inst.components.sanity:DoDelta(4)
			inst.components.sanity.night_drain_mult = 0
		else
			inst.components.sanity.night_drain_mult = 2.5
		end
	end)

	-- Butterflies are not fond of Glace
	inst:DoPeriodicTask(1, function()
		local x, y, z = inst.Transform:GetWorldPosition()
		local ents = TheSim:FindEntities(x, y, z, 2 ,{"butterfly"})
		for k, v in pairs(ents) do
			if not v.components.freezable:IsFrozen() then
				v.components.freezable:Freeze(3)
			end
		end
	end)

	-- Standing still creates an ice plane
	-- This plane freezes everything, save for players!
	inst:DoPeriodicTask(0, function()
		x, y, z = inst.Transform:GetWorldPosition()
		if not (IsInRange(x, last_x, 1) and IsInRange(z, last_z, 1)) then
			if not spawn_ice then
				ice.AnimState:PlayAnimation("despawn")
				inst:DoTaskInTime(1, function()
					ice:Remove()
					ice_despawned = true
				end)
				inst.components.temperature.maxtemp = 35
				spawn_ice = true
			end
		end
		x, y, z = inst.Transform:GetWorldPosition()
		last_x = x
		last_y = y
		last_z = z
	end)

	inst.components.eater:SetOnEatFn(onEat)

end

return MakePlayerCharacter("glace", prefabs, assets, common_postinit, master_postinit, start_inv)
