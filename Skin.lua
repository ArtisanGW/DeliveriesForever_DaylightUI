-- Deliveries Forever Skin: Daylight UI's look on Deliveries Forever's panel.
-- A separate addon. Deliveries Forever stays a vanilla addon that knows nothing
-- of this one: the panel is found from outside by its global name, and dressed
-- through Daylight UI's public API (DaylightUI.API, RegisterSkin and its Kit).

local ADDON = ...
local DUI = DaylightUI
local API = DUI and DUI.API
if not (API and API.major == 1 and DUI.RegisterPlugin and API.For) then return end

DUI:RegisterPlugin(ADDON, {
    needs = { 1, 1 },
    short = "Deliveries",
    color = "66bbff",
    blurb = "Daylight UI's look on Deliveries Forever's mailbox panel.",
})
local me = API.For(ADDON)

local PANEL = "DeliveriesForeverPanel"   -- Deliveries Forever's panel, by its global name

local function dress(Kit)
    local panel = _G[PANEL]
    if not panel then return false end   -- not made yet: asked again later
    Kit.Window(panel)   -- its art off, Daylight UI's window shell, title font and close X
    Kit.Auto(panel)     -- the buttons inside
    -- The picker list is made on the first click, inside the panel: dressed as it shows.
    panel:HookScript("OnShow", function() Kit.Auto(panel, { shownOnly = true }) end)
end

-- Deliveries Forever builds its panel at login, after Daylight UI's skins first
-- look. A skin registered once login is done is tried at once, so register then.
local login = CreateFrame("Frame")
login:RegisterEvent("PLAYER_LOGIN")
login:SetScript("OnEvent", function(self)
    self:UnregisterAllEvents()
    C_Timer.After(0, function() me.RegisterSkin("DeliveriesForever", dress) end)
end)
