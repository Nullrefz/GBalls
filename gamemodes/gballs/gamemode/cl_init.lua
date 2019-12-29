include('sh_init.lua')

function GM:SetupWorldFog()
    render.FogMode(1) 
    render.FogStart(0)
    render.FogEnd(10000)
    render.FogMaxDensity(.1)
    render.FogColor(0,150,255)
    return true
end