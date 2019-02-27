local assets =
{
    Asset("ANIM", "anim/glace_ice_build.zip"),
}

local function fn()
    local inst = CreateEntity()

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("glace_ice")
    inst.AnimState:SetBuild("glace_ice_build")
    inst.AnimState:PlayAnimation("spawn")
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(1)
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)

    inst:DoPeriodicTask(0, function()
        local x, y, z = inst.Transform:GetWorldPosition()
        local freeze_ents = nil
        if TUNING.glace.Giants then
            freeze_ents = TheSim:FindEntities(x, y, z, 3, {"freezable"}, {"player"})
        else
            freeze_ents = TheSim:FindEntities(x, y, z, 3, {"freezable"}, {"player", "epic"})
        end
        for key, entity in pairs(freeze_ents) do
            if entity.components.freezable ~= nil and not entity.components.freezable:IsFrozen() then
                entity.components.freezable:Freeze(2)
            end
        end
    end)
    return inst
end

return Prefab("glace_ice", fn, assets)
