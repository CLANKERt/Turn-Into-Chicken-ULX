if SERVER then
    util.AddNetworkString("ChickenEffects")
end
-- Main code to turn a player into a chicken
local chickenPlayers = {}
local function ulx_chicken(calling_ply, target_plys)
    for _, ply in ipairs(target_plys) do
        if not ply:IsValid() or not ply:Alive() then continue end

        if chickenPlayers[ply] then
            ULib.tsayError(calling_ply, ply:Nick() .. " is already a chicken!", true)
            continue
        end

        chickenPlayers[ply] = {
            model = ply:GetModel(),
            health = ply:Health(),
            armor = ply:Armor()
        }
        -- Code to turn player into a chicken or other models
        ply:SetModel("models/clankert/ragdolls/chicken.mdl")
        ply:SetHealth(10) --health set
        ply:SetArmor(0) --armor set
        ply:StripWeapons() --strip weapons cus why does the chicken cross the road idk be a chicken i geuss?!?!?


        net.Start("ChickenEffects")
        net.Send(ply)

        ulx.fancyLogAdmin(calling_ply, "#A turned #T into a chicken!", target_plys)
    end
end
-- client code
if CLIENT then
    net.Receive("ChickenEffects", function()
        local ply = LocalPlayer()
        surface.PlaySound("ambient/levels/labs/electric_explosion1.wav") -- play the sound when turning intoa chicken
        local effectdata = EffectData()
        effectdata:SetOrigin(ply:GetPos() + Vector(0,0,40)) 
        util.Effect("cball_explode", effectdata, true, true) -- the effect when turning into a chicken
    end)
end


--ULX/ULIB code to make this happen
local chicken = ulx.command("Fun", "ulx chicken", ulx_chicken, "!chick") -- command to turn into a chicken pun
chicken:addParam{ type=ULib.cmds.PlayersArg }
chicken:defaultAccess(ULib.ACCESS_ADMIN)
chicken:help("Turn a player into a chicken until death.")

-- if a player dies the models resets to prevuis model
hook.Add("PlayerDeath", "ChickenResetOnDeath", function(ply)
    if chickenPlayers[ply] then
        timer.Simple(0.1, function()
            if not IsValid(ply) then return end
            local data = chickenPlayers[ply]
            if data then
                ply:SetModel(data.model or "models/player/kleiner.mdl") --if model cant be found it defeult to this
                ply:SetHealth(data.health or 100)
                ply:SetArmor(data.armor or 0)
                chickenPlayers[ply] = nil
            end
        end)
    end
end)


