-- The plugin against a stand-in for Daylight UI's API (only what it calls).
-- Run from the repo root: luajit tests/skin_test.lua
local calls, scripts, timers = {}, {}, {}
CreateFrame = function()
    return { RegisterEvent = function() end, UnregisterAllEvents = function() end,
             SetScript = function(_, n, fn) scripts[n] = fn end }
end
C_Timer = { After = function(_, fn) timers[#timers + 1] = fn end }
local skin
DaylightUI = {
    RegisterPlugin = function(_, name, o) calls.plugin = name; calls.needs = o.needs end,
    API = { major = 1, minor = 10,
        For = function(name) return { RegisterSkin = function(addon, fn) calls.skinFor = addon; skin = fn; return true end } end },
}
assert(loadfile("Skin.lua"))("DeliveriesForever_DaylightUI")
assert(calls.plugin == "DeliveriesForever_DaylightUI", "registers as a Daylight UI plugin")
assert(skin == nil, "no skin before login: the panel is made at login")
scripts.OnEvent({ UnregisterAllEvents = function() end })   -- PLAYER_LOGIN
for _, fn in ipairs(timers) do fn() end
assert(calls.skinFor == "DeliveriesForever" and type(skin) == "function", "a skin for Deliveries Forever, once login is done")

local dressed = {}
local Kit = { Window = function(f) dressed.window = f end, Auto = function(f, o) dressed.auto = f end }
assert(skin(Kit) == false, "no panel yet: asked again later")
local hooked
_G.DeliveriesForeverPanel = { HookScript = function(_, n, fn) hooked = n end }
skin(Kit)
assert(dressed.window == DeliveriesForeverPanel and dressed.auto == DeliveriesForeverPanel, "the panel dressed: window shell and controls")
assert(hooked == "OnShow", "the picker list made later is dressed as the panel shows")
print("skin_test: ok")
