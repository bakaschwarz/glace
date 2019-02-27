local function fn()
    local inst = CreateEntity()
    --inst.entity:AddTransform()
    inst.entity:AddNetwork()
    MakeInventoryPhysics(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    return inst
end

return Prefab("frozen_", fn, {})