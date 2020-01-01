CreateMaterial("colortexshp", "VertexLitGeneric", {
    ["$basetexture"] = "color/white",
    ["$model"] = 1,
    ["$translucent"] = 1,
    ["$vertexalpha"] = 1,
    ["$vertexcolor"] = 1
})

function GB:SpawnGrid()
    local grid = ClientsideModel("models/hunter/plates/plate6x6.mdl")
    if not IsValid(grid) then return end
    grid:DrawShadow(false)
    grid:SetPos(Vector(0, 0, 0))
    grid:SetMaterial("colortexshp", true)
    grid:Spawn()
end

GB:SpawnGrid()