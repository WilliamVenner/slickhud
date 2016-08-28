if (!slickHUD) then slickHUD = {Hunger = {},Minilog = {},Languages = {}} end

--// Admin usergroups.
--// This will detect superadmins and admins by default, but you can add more here
slickHUD.AdminUsergroups = {"admin","superadmin","moderator"}
--// Cop jobs.
--// These are DarkRP jobs that are assigned as cops.
--// Adding these to the actual DarkRP settings is automatically detected.
--// You most likely won't need to change this.
--// You can use TEAM_ variables and the job name (exact, case specific).
slickHUD.CopJobs = {TEAM_POLICE,"Civil Protection"}
--// Whether the black bar showing connects, disconnects etc. is visible
slickHUD.Minilog.Enabled = false
--// Hunger Bar
slickHUD.Hunger.Enabled = false
slickHUD.Hunger.BlinkAt = 10
slickHUD.Hunger.BlinkingColor = Color(255,84,81)

local function GetScrW()
	return ScrW()
end
local function GetScrH()
	return ScrH()
end

if (IsValid(slickHUD.Hud)) then slickHUD.Hud:Remove() end

surface.CreateFont("slickHUD_HUD_Roboto", {
	font = "Roboto",
	size = GetScrW() * 0.00833333333,
	weight = 700,
})

surface.CreateFont("slickHUD_HUD_Name_Roboto", {
	font = "Roboto",
	size = GetScrW() * 0.0104166667,
	weight = 700,
})

surface.CreateFont("slickHUD_HUD_Label_Roboto", {
	font = "Roboto",
	size = GetScrW() * 0.00833333333,
})

surface.CreateFont("slickHUD_HUD_Log_Roboto", {
	font = "Roboto",
	size = GetScrW() * 0.00833333333,
	shadow = true,
})

local function sizew(w)
	return (ScrW() * ((w or 0) / 1920))
end
local function sizeh(h)
	return (ScrH() * ((h or 0) / 1080))
end

hook.Remove("HUDShouldDraw","hud_disable")
hook.Add("HUDShouldDraw","hud_disable",function(hud)
	local huds = {"CHudHealth","CHudBattery","CHudSuitPower","CHudAmmo","CHudSecondaryAmmo","DarkRP_LocalPlayerHUD","DarkRP_Hungermod"}
	if (table.HasValue(huds,hud)) then return false else return nil end
end)

timer.Remove("WaitForHUDCreation")
timer.Create("WaitForHUDCreation",1,0,function()
	if (IsValid(slickHUD.Hud)) then
		timer.Remove("WaitForHUDCreation")
		slickHUD.Hud:SetSize(GetScrW(),GetScrH())
		slickHUD.Hud.Paint = function() end

		slickHUD.Hud.Tex = vgui.Create("DPanel",slickHUD.Hud)
		slickHUD.Hud.Tex:SetSize(GetScrW() * 0.21875,GetScrH() * 0.16666666666)
		local HudTex = Material("slickHUD/hud.png")
		slickHUD.Hud.Tex.Paint = function(self)
			surface.SetDrawColor(Color(255,255,255))
			surface.SetMaterial(HudTex)
			surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())

			slickHUD.Hud.Tex:AlignBottom(0)
		end

		slickHUD.Hud.License = vgui.Create("DImage",slickHUD.Hud)
		slickHUD.Hud.License:SetSize(GetScrW() * 0.01666666666,GetScrH() * 0.02962962962)
		slickHUD.Hud.License:AlignLeft(slickHUD.Hud.Tex:GetWide() - 5)
		slickHUD.Hud.License:SetImage("icon16/page_white_text.png")
		hook.Remove("Think","slickHUD_license")
		hook.Add("Think","slickHUD_license",function()
			if (IsValid(slickHUD.Hud.License)) then
				slickHUD.Hud.License:SetVisible(LocalPlayer():getDarkRPVar("HasGunlicense"))
				if (IsValid(slickHUD.Hud.Ammo)) then
					slickHUD.Hud.License:AlignLeft(slickHUD.Hud.Tex:GetWide() - 5 + slickHUD.Hud.Ammo:GetWide())
				end
				slickHUD.Hud.License:AlignBottom(slickHUD.Hud.Tex:GetTall() - (GetScrH() * 0.03611111111))
			end
		end)

		slickHUD.Hud.WantedColor = Color(255,255,255)
		slickHUD.Hud.WantedMode = false
		slickHUD.Hud.Wanted = vgui.Create("DImage",slickHUD.Hud)
		slickHUD.Hud.Wanted:SetSize(GetScrW() * 0.03333333333,GetScrH() * 0.05925925925)
		slickHUD.Hud.Wanted:SetImage("slickHUD/wanted.png")
		slickHUD.Hud.Wanted:AlignTop(32)
		slickHUD.Hud.Wanted:CenterHorizontal()
		slickHUD.Hud.Wanted.Text = vgui.Create("DLabel",slickHUD.Hud)
		slickHUD.Hud.Wanted.Text:SetFont("slickHUD_HUD_Name_Roboto")
		slickHUD.Hud.Wanted.Text:SetText("")
		slickHUD.Hud.Wanted.Text:SizeToContents()
		slickHUD.Hud.Wanted.Text:CenterHorizontal()
		hook.Remove("Think","slickHUD_wanted")
		hook.Add("Think","slickHUD_wanted",function()
			if (IsValid(slickHUD.Hud.Wanted)) then
				if (LocalPlayer():getDarkRPVar("wanted") == true) then
					slickHUD.Hud.Wanted.Text:SetTextColor(slickHUD.Hud.WantedColor)
					slickHUD.Hud.Wanted.Text:SetText("You are wanted! Reason:")
					slickHUD.Hud.Wanted.Text:SizeToContents()
					slickHUD.Hud.Wanted.Text:CenterHorizontal()
					slickHUD.Hud.Wanted.Text:AlignTop(64 + 32 + 10)
				end
			end
		end)
		slickHUD.Hud.Wanted.Reason = vgui.Create("DLabel",slickHUD.Hud)
		slickHUD.Hud.Wanted.Reason:SetFont("slickHUD_HUD_Name_Roboto")
		slickHUD.Hud.Wanted.Reason:SetText("")
		slickHUD.Hud.Wanted.Reason:SizeToContents()
		slickHUD.Hud.Wanted.Reason:CenterHorizontal()
		hook.Remove("Think","slickHUD_wantedreason")
		hook.Add("Think","slickHUD_wantedreason",function()
			if (IsValid(slickHUD.Hud.Wanted)) then
				if (LocalPlayer():getDarkRPVar("wanted") == true) then
					slickHUD.Hud.Wanted.Reason:SetTextColor(slickHUD.Hud.WantedColor)
					slickHUD.Hud.Wanted.Reason:SetText(LocalPlayer():getDarkRPVar("wantedReason"))
					slickHUD.Hud.Wanted.Reason:SizeToContents()
					slickHUD.Hud.Wanted.Reason:CenterHorizontal()
					slickHUD.Hud.Wanted.Reason:AlignTop(64 + 32 + 10 + 20)
				end
				slickHUD.Hud.Wanted:SetVisible(LocalPlayer():getDarkRPVar("wanted") or false)
				slickHUD.Hud.Wanted.Text:SetVisible(LocalPlayer():getDarkRPVar("wanted") or false)
				slickHUD.Hud.Wanted.Reason:SetVisible(LocalPlayer():getDarkRPVar("wanted") or false)
			end
		end)
		timer.Remove("slickhud_wanted_colour")
		timer.Create("slickhud_wanted_colour",0.00001,0,function()
			if (IsValid(slickHUD.Hud) and slickHUD.Hud.WantedColor ~= nil and slickHUD.Hud.WantedMode ~= nil) then
				if (slickHUD.Hud.WantedMode == false) then
					slickHUD.Hud.WantedColor = Color(255,slickHUD.Hud.WantedColor.g - 1,slickHUD.Hud.WantedColor.b - 1)
				else
					slickHUD.Hud.WantedColor = Color(255,slickHUD.Hud.WantedColor.g + 1,slickHUD.Hud.WantedColor.b + 1)
				end
				if (slickHUD.Hud.WantedColor.g == 0 or slickHUD.Hud.WantedColor.g == 255) then
					slickHUD.Hud.WantedMode = !slickHUD.Hud.WantedMode
				end
			end
		end)

		slickHUD.Hud.HUDPanel = vgui.Create("DPanel",slickHUD.Hud.Tex)
		slickHUD.Hud.HUDPanel:SetSize(GetScrW() * 0.20833333333,GetScrH() * 0.14814814814)
		slickHUD.Hud.HUDPanel:Center()
		slickHUD.Hud.HUDPanel.Paint = function(self) end

		slickHUD.Hud.ModelPanelUnder = vgui.Create("DPanel",slickHUD.Hud.HUDPanel)
		slickHUD.Hud.ModelPanelUnder:SetSize(GetScrW() * 0.05208333333,GetScrH() * 0.13888888888)
		slickHUD.Hud.ModelPanelUnder:AlignLeft(8)
		slickHUD.Hud.ModelPanelUnder:AlignTop(6)
		slickHUD.Hud.ModelPanelUnder.Paint = function(self) end
		slickHUD.Hud.ModelPanel = vgui.Create("DModelPanel",slickHUD.Hud.ModelPanelUnder)
		slickHUD.Hud.ModelPanel:Dock(FILL)
		slickHUD.Hud.ModelPanel:SetModel(LocalPlayer():GetModel())
		slickHUD.Hud.ModelPanel.Think = function()
			slickHUD.Hud.ModelPanel:SetModel(LocalPlayer():GetModel())
			local bodygroups = ""
			for i=0,LocalPlayer():GetNumBodyGroups() do
				bodygroups = bodygroups .. LocalPlayer():GetBodygroup(i)
			end
			slickHUD.Hud.ModelPanel.Entity:SetBodyGroups(bodygroups)
		end
		slickHUD.Hud.ModelPanel.LayoutEntity = function() return false end
		slickHUD.Hud.ModelPanel:SetFOV(40)
		local angl = 60
		slickHUD.Hud.ModelPanel:SetCamPos(Vector(30,-15,angl))
		slickHUD.Hud.ModelPanel:SetLookAt(Vector(0,0,(angl - 4)))
		slickHUD.Hud.ModelPanel.Entity:SetEyeTarget(Vector(200,200,110))
		function slickHUD.Hud.ModelPanel.Entity:GetPlayerColor() return LocalPlayer():GetPlayerColor() end

		local yPart = (GetScrH() * 0.02314814814)
		local alignBottomPlus = sizeh(10)
		if (slickHUD.Hunger.Enabled == true) then
			yPart = (GetScrH() * 0.01805555555)
			alignBottomPlus = sizeh(5)
		end

		local health = 0
		if (LocalPlayer():Health() < 0) then
			health = 0
		else
			health = LocalPlayer():Health()
		end
		local Armor = 0
		if (LocalPlayer():Armor() < 0) then
			Armor = 0
		else
			Armor = LocalPlayer():Armor()
		end

		slickHUD.Hud.ArmorBar = vgui.Create("DPanel",slickHUD.Hud.HUDPanel)
		slickHUD.Hud.ArmorBar:SetSize(slickHUD.Hud.HUDPanel:GetWide() - slickHUD.Hud.ModelPanelUnder:GetWide() - (GetScrW() * 0.01041666666),yPart)
		slickHUD.Hud.ArmorBar:AlignLeft(slickHUD.Hud.ModelPanelUnder:GetWide() + (GetScrW() * 0.00859375))
		slickHUD.Hud.ArmorBar:AlignBottom(2)
		slickHUD.Hud.ArmorBar.Paint = function(self)
			surface.SetDrawColor(Color(0,0,0,(255 / 2)))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
		end

		slickHUD.Hud.ArmorBar.Armor = vgui.Create("DPanel",slickHUD.Hud.ArmorBar)
		slickHUD.Hud.ArmorBar.Armor:SetSize(((math.Clamp(LocalPlayer():Armor(),0,100) / 100) * (slickHUD.Hud.ArmorBar:GetWide() - 2)),slickHUD.Hud.ArmorBar:GetTall() - 2)
		slickHUD.Hud.ArmorBar.Armor:AlignLeft(1)
		slickHUD.Hud.ArmorBar.Armor:CenterVertical()
		slickHUD.Hud.ArmorBar.Armor.Paint = function(self)
			surface.SetDrawColor(Color(38,110,255))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		end
		slickHUD.Hud.ArmorBar.Armor.RunNoArmorAnim = nil
		slickHUD.Hud.ArmorBar.Armor.Text = vgui.Create("DLabel",slickHUD.Hud.ArmorBar.Armor)
		slickHUD.Hud.ArmorBar.Armor.Text:SetText("Armour" .. " » " .. Armor)
		slickHUD.Hud.ArmorBar.Armor.Text:SetTextColor(Color(255,255,255))
		slickHUD.Hud.ArmorBar.Armor.Text:SetFont("slickHUD_HUD_Roboto")
		slickHUD.Hud.ArmorBar.Armor.Text:SizeToContents()
		slickHUD.Hud.ArmorBar.Armor.Text:Center()
		slickHUD.Hud.ArmorBar.Armor.Text.LastArmor = Armor
		slickHUD.Hud.ArmorBar.Armor.Text.Think = function()
			if (LocalPlayer():Armor() < 0) then
				Armor = 0
			else
				Armor = LocalPlayer():Armor()
			end
			slickHUD.Hud.ArmorBar.Armor.RunNoArmorAnim = nil
			if (slickHUD.Hud.ArmorBar.Armor.Text.LastArmor ~= Armor) then
				slickHUD.Hud.ArmorBar.Armor.Text.LastArmor = Armor
				slickHUD.Hud.ArmorBar.Armor:Stop()
				local w = ((math.Clamp(Armor,0,100) / 100) * (slickHUD.Hud.ArmorBar:GetWide() - 2))
				slickHUD.Hud.ArmorBar.Armor:SizeTo(w,(slickHUD.Hud.ArmorBar:GetTall() - 2),0.5)
			end
			if (Armor >= 60) then
				slickHUD.Hud.ArmorBar.Armor:AlignLeft(1)
				slickHUD.Hud.ArmorBar.Armor:CenterVertical()
				slickHUD.Hud.ArmorBar.Armor.Text:SetParent(slickHUD.Hud.ArmorBar.Armor)
				slickHUD.Hud.ArmorBar.Armor.Text:SetText("Armour" .. " » " .. Armor)
				slickHUD.Hud.ArmorBar.Armor.Text:SizeToContents()
				slickHUD.Hud.ArmorBar.Armor.Text:Center()
			else
				slickHUD.Hud.ArmorBar.Armor.Text:SetParent(slickHUD.Hud.ArmorBar)
				slickHUD.Hud.ArmorBar.Armor.Text:SetText("Armour" .. " » " .. Armor)
				slickHUD.Hud.ArmorBar.Armor.Text:SizeToContents()
				slickHUD.Hud.ArmorBar.Armor.Text:Center()
			end
		end

		slickHUD.Hud.HealthBar = vgui.Create("DPanel",slickHUD.Hud.HUDPanel)
		slickHUD.Hud.HealthBar:SetSize(slickHUD.Hud.HUDPanel:GetWide() - slickHUD.Hud.ModelPanelUnder:GetWide() - (GetScrW() * 0.01041666666),yPart)
		slickHUD.Hud.HealthBar:AlignLeft(slickHUD.Hud.ModelPanelUnder:GetWide() + (GetScrW() * 0.00859375))
		slickHUD.Hud.HealthBar:AlignBottom(slickHUD.Hud.ArmorBar:GetTall() + alignBottomPlus)
		slickHUD.Hud.HealthBar.Paint = function(self)
			surface.SetDrawColor(Color(0,0,0,(255 / 2)))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
		end

		slickHUD.Hud.HealthBar.Health = vgui.Create("DPanel",slickHUD.Hud.HealthBar)
		slickHUD.Hud.HealthBar.Health:SetSize((((math.Clamp(LocalPlayer():Health(),0,100) / 100) * (slickHUD.Hud.HealthBar:GetWide() - 2)) / 2),slickHUD.Hud.HealthBar:GetTall() - 2)
		slickHUD.Hud.HealthBar.Health:AlignLeft(1)
		slickHUD.Hud.HealthBar.Health:CenterVertical()
		slickHUD.Hud.HealthBar.Health.Paint = function(self)
			surface.SetDrawColor(Color(255,84,81))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		end
		slickHUD.Hud.HealthBar.Health.Text = vgui.Create("DLabel",slickHUD.Hud.HealthBar.Health)
		slickHUD.Hud.HealthBar.Health.Text:SetText("Health" .. " » " .. health)
		slickHUD.Hud.HealthBar.Health.Text:SetTextColor(Color(255,255,255))
		slickHUD.Hud.HealthBar.Health.Text:SetFont("slickHUD_HUD_Roboto")
		slickHUD.Hud.HealthBar.Health.Text:SizeToContents()
		slickHUD.Hud.HealthBar.Health.Text:Center()
		local function healthFunc()
			if (LocalPlayer():Health() < 0) then
				health = 0
			else
				health = LocalPlayer():Health()
			end
			if (LocalPlayer():Armor() < 0) then
				Armor = 0
			else
				Armor = LocalPlayer():Armor()
			end
			slickHUD.Hud.HealthBar.Health.RunHealthAnim = nil
			if (slickHUD.Hud.HealthBar.Health.Text.LastHealth ~= health) then
				slickHUD.Hud.HealthBar.Health.Text.LastHealth = health
				slickHUD.Hud.HealthBar.Health:Stop()
				local w = ((math.Clamp(health,0,100) / 100) * (slickHUD.Hud.HealthBar:GetWide() - 2))
				slickHUD.Hud.HealthBar.Health:SizeTo(w,(slickHUD.Hud.HealthBar:GetTall() - 2),0.5)
			end
			if (health >= 60) then
				slickHUD.Hud.HealthBar.Health:AlignLeft(1)
				slickHUD.Hud.HealthBar.Health:CenterVertical()
				slickHUD.Hud.HealthBar.Health.Text:SetParent(slickHUD.Hud.HealthBar.Health)
				slickHUD.Hud.HealthBar.Health.Text:SetText("Health" .. " » " .. health)
				slickHUD.Hud.HealthBar.Health.Text:SizeToContents()
				slickHUD.Hud.HealthBar.Health.Text:Center()
			else
				slickHUD.Hud.HealthBar.Health.Text:SetParent(slickHUD.Hud.HealthBar)
				slickHUD.Hud.HealthBar.Health.Text:SetText("Health" .. " » " .. health)
				slickHUD.Hud.HealthBar.Health.Text:SizeToContents()
				slickHUD.Hud.HealthBar.Health.Text:Center()
			end
		end
		slickHUD.Hud.HealthBar.Health.Text.Think = healthFunc
		healthFunc()

		if (slickHUD.Hunger.Enabled == true) then
			slickHUD.Hud.HungerBar = vgui.Create("DPanel",slickHUD.Hud.HUDPanel)
			slickHUD.Hud.HungerBar:SetSize(slickHUD.Hud.HUDPanel:GetWide() - slickHUD.Hud.ModelPanelUnder:GetWide() - (GetScrW() * 0.01041666666),yPart)
			slickHUD.Hud.HungerBar:AlignLeft(slickHUD.Hud.ModelPanelUnder:GetWide() + (GetScrW() * 0.00859375))
			slickHUD.Hud.HungerBar:AlignBottom(slickHUD.Hud.ArmorBar:GetTall() + (GetScrH() * 0.00462962962) + slickHUD.Hud.HealthBar:GetTall() + (GetScrH() * 0.00462962962))
			slickHUD.Hud.HungerBar.Paint = function(self)
				surface.SetDrawColor(Color(0,0,0,(255 / 2)))
				surface.DrawRect(0,0,self:GetWide(),self:GetTall())
				surface.SetDrawColor(Color(0,0,0))
				surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
			end

			slickHUD.Hud.HungerBar.Hunger = vgui.Create("DPanel",slickHUD.Hud.HungerBar)
			slickHUD.Hud.HungerBar.Hunger:SetSize(((math.Clamp(LocalPlayer():getDarkRPVar("Energy"),0,100) / 100) * ((slickHUD.Hud.HUDPanel:GetWide() - slickHUD.Hud.ModelPanelUnder:GetWide() - (GetScrW() * 0.01041666666)) - 2)),yPart - 2)
			slickHUD.Hud.HungerBar.Hunger:AlignLeft(1)
			slickHUD.Hud.HungerBar.Hunger:CenterVertical()
			slickHUD.Hud.HungerBar.Hunger.Paint = function(self)
				surface.SetDrawColor(Color(14,189,71))
				surface.DrawRect(0,0,self:GetWide(),self:GetTall())
			end
			local Hunger = 0
			if (LocalPlayer():getDarkRPVar("Energy") < 0) then
				Hunger = 0
			else
				Hunger = math.Round(LocalPlayer():getDarkRPVar("Energy"))
			end
			slickHUD.Hud.HungerBar.Hunger.RunNoHungerAnim = nil
			slickHUD.Hud.HungerBar.Hunger.Text = vgui.Create("DLabel",slickHUD.Hud.HungerBar.Hunger)
			slickHUD.Hud.HungerBar.Hunger.Text:SetText("Hunger" .. " » " .. math.Round(Hunger))
			slickHUD.Hud.HungerBar.Hunger.Text:SetTextColor(Color(255,255,255))
			slickHUD.Hud.HungerBar.Hunger.Text:SetFont("slickHUD_HUD_Roboto")
			slickHUD.Hud.HungerBar.Hunger.Text:SizeToContents()
			slickHUD.Hud.HungerBar.Hunger.Text:Center()
			slickHUD.Hud.HungerBar.Hunger.Text.LastHunger = Hunger
			slickHUD.Hud.HungerBar.Hunger.Text.Think = function()
				if (IsValid(slickHUD.Hud.HungerBar)) then
					if (LocalPlayer():getDarkRPVar("Energy") < 0) then
						Hunger = 0
					else
						Hunger = math.Round(LocalPlayer():getDarkRPVar("Energy"))
					end
					slickHUD.Hud.HungerBar.Hunger.RunNoHungerAnim = nil
					if (slickHUD.Hud.HungerBar.Hunger.Text.LastHunger ~= Hunger) then
						slickHUD.Hud.HungerBar.Hunger.Text.LastHunger = Hunger
						slickHUD.Hud.HungerBar.Hunger:Stop()
						local w = ((math.Clamp(Hunger,0,100) / 100) * (slickHUD.Hud.HungerBar:GetWide() - 2))
						slickHUD.Hud.HungerBar.Hunger:SizeTo(w,(slickHUD.Hud.HungerBar:GetTall() - 2),0.5)
					end
					if (Hunger <= slickHUD.Hunger.BlinkAt and IsValid(slickHUD.Hud.HungerBar.Blinker)) then
						slickHUD.Hud.HungerBar.Blinker:SetVisible(true)
					else
						slickHUD.Hud.HungerBar.Blinker:SetVisible(false)
					end
					if (Hunger <= 0) then
						slickHUD.Hud.HungerBar.Hunger.Text:SetParent(slickHUD.Hud.HungerBar)
						slickHUD.Hud.HungerBar.Hunger.Text:SetText("Starving!")
						slickHUD.Hud.HungerBar.Hunger.Text:SizeToContents()
						slickHUD.Hud.HungerBar.Hunger.Text:Center()
					else
						if (Hunger >= 60) then
							slickHUD.Hud.HungerBar.Hunger:AlignLeft(1)
							slickHUD.Hud.HungerBar.Hunger:CenterVertical()
							slickHUD.Hud.HungerBar.Hunger.Text:SetParent(slickHUD.Hud.HungerBar.Hunger)
							slickHUD.Hud.HungerBar.Hunger.Text:SetText("Hunger" .. " » " .. math.Round(Hunger))
							slickHUD.Hud.HungerBar.Hunger.Text:SizeToContents()
							slickHUD.Hud.HungerBar.Hunger.Text:Center()
						else
							slickHUD.Hud.HungerBar.Hunger.Text:SetParent(slickHUD.Hud.HungerBar)
							slickHUD.Hud.HungerBar.Hunger.Text:SetText("Hunger" .. " » " .. math.Round(Hunger))
							slickHUD.Hud.HungerBar.Hunger.Text:SizeToContents()
							slickHUD.Hud.HungerBar.Hunger.Text:Center()
						end
					end
				end
			end

			if (LocalPlayer():getDarkRPVar("Energy") < 0) then
				Hunger = 0
			else
				Hunger = LocalPlayer():getDarkRPVar("Energy")
			end
			slickHUD.Hud.HungerBar.Blinker = vgui.Create("DPanel",slickHUD.Hud.HungerBar)
			slickHUD.Hud.HungerBar.Blinker:Dock(FILL)
			slickHUD.Hud.HungerBar.Blinker.VisibleP = false
			slickHUD.Hud.HungerBar.Blinker.Paint = function(self)
				if (slickHUD.Hunger) then
					local colx = slickHUD.Hunger.BlinkingColor
					if (slickHUD.Hud.HungerBar.Blinker.VisibleP) then
						colx.a = 255
					else
						colx.a = 0
					end
					surface.SetDrawColor(colx)
					surface.DrawRect(0,0,self:GetWide(),self:GetTall())
					surface.SetDrawColor(Color(0,0,0))
					surface.DrawOutlinedRect(0,0,self:GetWide(),self:GetTall())
				end
			end
			slickHUD.Hud.HungerBar.Blinker:SetVisible(false)
			timer.Remove("hungerbarblink_slickHUD")
			timer.Create("hungerbarblink_slickHUD",0.25,0,function()
				if (IsValid(slickHUD.Hud.HungerBar)) then
					if (IsValid(slickHUD.Hud.HungerBar.Blinker)) then
						slickHUD.Hud.HungerBar.Blinker.VisibleP = !slickHUD.Hud.HungerBar.Blinker.VisibleP
					end
				end
			end)
		end

		slickHUD.Hud.NameL = vgui.Create("DLabel",slickHUD.Hud.HUDPanel)
		slickHUD.Hud.NameL:SetTextColor(Color(255,255,255))
		slickHUD.Hud.NameL:SetFont("slickHUD_HUD_Name_Roboto")
		slickHUD.Hud.NameL.Think = function()
			if (string.len(LocalPlayer():Nick()) > 30) then
				slickHUD.Hud.NameL:SetText(string.sub(LocalPlayer():Nick(),1,27) .. "...")
			else
				slickHUD.Hud.NameL:SetText(LocalPlayer():Nick())
			end
			slickHUD.Hud.NameL:SizeToContents()
			slickHUD.Hud.NameL:AlignLeft(slickHUD.Hud.ModelPanelUnder:GetWide() + (GetScrW() * 0.00859375))
			slickHUD.Hud.NameL:AlignTop(5)
		end

		slickHUD.Lightbulb = vgui.Create("DImage",slickHUD.Hud.HUDPanel)
		slickHUD.Lightbulb:SetSize(GetScrW() * 0.00833333333,GetScrH() * 0.01481481481)
		slickHUD.Lightbulb:AlignLeft(slickHUD.Hud.ModelPanelUnder:GetWide() - ((GetScrW() * 0.00833333333) / 2))
		slickHUD.Lightbulb:AlignTop(10)
		slickHUD.Lightbulb:SetImage("icon16/lightbulb.png")
		hook.Remove("Think","hudflashlight")
		hook.Add("Think","hudflashlight",function()
			if (IsValid(slickHUD.Lightbulb)) then
				if (LocalPlayer():FlashlightIsOn()) then
					slickHUD.Lightbulb:SetVisible(true)
				else
					slickHUD.Lightbulb:SetVisible(false)
				end
			end
		end)

		local function comma_value(amount)
			local formatted = amount
			while true do
				formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
				if (k==0) then
					break
				end
			end
			return formatted
		end

		slickHUD.Hud.ServerLogFrame = vgui.Create("DPanel",slickHUD.Hud)
		slickHUD.Hud.ServerLogFrame:SetVisible(slickHUD.Minilog.Enabled)
		slickHUD.Hud.ServerLogFrame:SetSize(slickHUD.Hud.HUDPanel:GetWide() + (GetScrW() * 0.00208333333),GetScrH() * 0.02222222222)
		slickHUD.Hud.ServerLogFrame:AlignLeft(GetScrW() * 0.00520833333)
		slickHUD.Hud.ServerLogFrame.Paint = function(self)
			surface.SetDrawColor(Color(0,0,0,(255 * 0.75)))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		end
		slickHUD.Hud.ServerLogFrame.Think = function()
			slickHUD.Hud.ServerLogFrame:AlignBottom(slickHUD.Hud.HUDPanel:GetTall() + (GetScrH() * 0.01111111111))
		end
		local serverLogIDG = 0
		local function addServerLog(txt)
			serverLogIDG = serverLogIDG + 1
			local serverLogID = serverLogIDG
			if (IsValid(slickHUD.Hud)) then
				if (IsValid(slickHUD.Hud.ServerLogFrame)) then
					if (IsValid(slickHUD.Hud.ServerLogFrame.CurLog)) then
						local curLog = slickHUD.Hud.ServerLogFrame.CurLog
						curLog:Stop()
						curLog:MoveTo(5,-(slickHUD.Hud.ServerLogFrame:GetTall() - 6),(curLog.TimeItTook or 0.5),0,-1,function()
							curLog:Remove()
						end)
					end
				end
			end
			slickHUD.Hud.ServerLogFrame.CurLog = nil
			slickHUD.Hud.ServerLogFrame.CurLog = vgui.Create("DLabel",slickHUD.Hud.ServerLogFrame)
			local thisLog = slickHUD.Hud.ServerLogFrame.CurLog
			thisLog:SetTextColor(Color(255,255,255))
			thisLog:SetFont("slickHUD_HUD_Log_Roboto")
			thisLog:SetText(txt)
			thisLog:SizeToContents()
			thisLog:SetWide(slickHUD.Hud.ServerLogFrame:GetWide() - 6)
			thisLog:SetPos(-(thisLog:GetWide()),((slickHUD.Hud.ServerLogFrame:GetTall() / 2) - (thisLog:GetTall() / 2)))
			thisLog:Stop()
			thisLog.TimeItTook = 0
			timer.Remove("timeittook_" .. serverLogID)
			timer.Create("timeittook_" .. serverLogID,0.01,0,function()
				if (thisLog.TimeItTook ~= nil) then
					thisLog.TimeItTook = thisLog.TimeItTook + 0.01
				else
					timer.Remove("timeittook_" .. serverLogID)
				end
			end)
			thisLog:MoveTo(4,((slickHUD.Hud.ServerLogFrame:GetTall() / 2) - (thisLog:GetTall() / 2)),0.5,0,-1,function()
				timer.Remove("timeittook_" .. serverLogID)
			end)
		end
		net.Receive("slickHUD_log",function()
			local len = net.ReadString()
			local msg = net.ReadData(tonumber(len))
			local decompressed = util.Decompress(msg)
			addServerLog(decompressed)
		end)
		hook.Remove("PlayerBindPress","slickHUD_closelogs")
		hook.Add("PlayerBindPress","slickHUD_closelogs",function(ply,bind,pressed)
			if (bind == "messagemode" and pressed == true) then
				slickHUD.Hud.ServerLogFrame:Stop()
				local x,y = slickHUD.Hud.ServerLogFrame:GetPos()
				slickHUD.Hud.ServerLogFrame:MoveTo(x,(GetScrH() - (slickHUD.Hud.HUDPanel:GetTall() + 13)),0.5)
			end
		end)
		hook.Remove("FinishChat","slickHUD_openlogs")
		hook.Add("FinishChat","slickHUD_openlogs",function(ply,txt)
			slickHUD.Hud.ServerLogFrame:Stop()
			local x,y = slickHUD.Hud.ServerLogFrame:GetPos()
			slickHUD.Hud.ServerLogFrame:MoveTo(x,(GetScrH() - (slickHUD.Hud.HUDPanel:GetTall() + 13) - 24),0.5)
		end)

		slickHUD.PlayersOnlineImage = vgui.Create("DImage",slickHUD.Hud.HUDPanel)
		slickHUD.PlayersOnlineImage:SetSize(GetScrW() * 0.00833333333,GetScrH() * 0.01481481481)
		slickHUD.PlayersOnlineImage:SetImage("icon16/user.png")
		slickHUD.PlayersOnlineImage:AlignRight(5)
		slickHUD.PlayersOnlineImage:AlignTop((GetScrW() * 0.0104166667) + 10)
		slickHUD.PlayersOnlineImage.Text = vgui.Create("DLabel",slickHUD.Hud.HUDPanel)
		slickHUD.PlayersOnlineImage.Text:SetFont("slickHUD_HUD_Label_Roboto")
		slickHUD.PlayersOnlineImage.Text:SetTextColor(Color(255,255,255))
		slickHUD.PlayersOnlineImage.Text.Think = function()
			slickHUD.PlayersOnlineImage.Text:SetText(#player.GetAll())
			slickHUD.PlayersOnlineImage.Text:SizeToContents()
			slickHUD.PlayersOnlineImage.Text:AlignRight(5 + slickHUD.PlayersOnlineImage:GetWide() + 5)
			slickHUD.PlayersOnlineImage.Text:AlignTop((GetScrW() * 0.0104166667) + 10)
		end

		slickHUD.AdminsOnlineImage = vgui.Create("DImage",slickHUD.Hud.HUDPanel)
		slickHUD.AdminsOnlineImage:SetSize(GetScrW() * 0.00833333333,GetScrH() * 0.01481481481)
		slickHUD.AdminsOnlineImage:SetImage("icon16/shield.png")
		slickHUD.AdminsOnlineImage:AlignRight(5)
		slickHUD.AdminsOnlineImage:AlignTop(((GetScrW() * 0.0104166667) + 10) + ((slickHUD.AdminsOnlineImage:GetTall()) + 5) * 1)
		slickHUD.AdminsOnlineImage.Text = vgui.Create("DLabel",slickHUD.Hud.HUDPanel)
		slickHUD.AdminsOnlineImage.Text:SetFont("slickHUD_HUD_Label_Roboto")
		slickHUD.AdminsOnlineImage.Text:SetTextColor(Color(255,255,255))
		slickHUD.AdminsOnlineImage.Text.Think = function()
			local adminCount = 0
			for _,v in pairs(player.GetAll()) do
				if (not IsValid(v)) then return end
				if (v:IsAdmin() or v:IsSuperAdmin() or table.HasValue(slickHUD.AdminUsergroups,v:GetUserGroup()) or table.HasValue(slickHUD.AdminUsergroups,v:GetNWString("usergroup"))) then
					adminCount = adminCount + 1
				end
			end
			slickHUD.AdminsOnlineImage.Text:SetText(adminCount)
			slickHUD.AdminsOnlineImage.Text:SizeToContents()
			slickHUD.AdminsOnlineImage.Text:AlignRight(5 + slickHUD.AdminsOnlineImage:GetWide() + 5)
			slickHUD.AdminsOnlineImage.Text:AlignTop(((GetScrW() * 0.0104166667) + 10) + ((slickHUD.AdminsOnlineImage:GetTall()) + 5) * 1)
		end

		slickHUD.CopsOnlineImage = vgui.Create("DImage",slickHUD.Hud.HUDPanel)
		slickHUD.CopsOnlineImage:SetSize(GetScrW() * 0.00833333333,GetScrH() * 0.01481481481)
		slickHUD.CopsOnlineImage:SetImage("slickHUD/police.png")
		slickHUD.CopsOnlineImage:AlignRight(5)
		slickHUD.CopsOnlineImage:AlignTop(((GetScrW() * 0.0104166667) + 10) + ((slickHUD.AdminsOnlineImage:GetTall()) + 5) * 2)
		slickHUD.CopsOnlineImage.Text = vgui.Create("DLabel",slickHUD.Hud.HUDPanel)
		slickHUD.CopsOnlineImage.Text:SetFont("slickHUD_HUD_Label_Roboto")
		slickHUD.CopsOnlineImage.Text:SetTextColor(Color(255,255,255))
		slickHUD.CopsOnlineImage.Text.Think = function()
			local copCount = 0
			for _,v in pairs(player.GetAll()) do
				if (not IsValid(v)) then return end
				local jobtbl = v:getJobTable()
				if (jobtbl == nil) then return end
				if (v:isCP() or table.HasValue(slickHUD.CopJobs,jobtbl.name) or table.HasValue(slickHUD.CopJobs,jobtbl.team)) then
					copCount = copCount + 1
				end
			end
			slickHUD.CopsOnlineImage.Text:SetText(copCount)
			slickHUD.CopsOnlineImage.Text:SizeToContents()
			slickHUD.CopsOnlineImage.Text:AlignRight(5 + slickHUD.AdminsOnlineImage:GetWide() + 5)
			slickHUD.CopsOnlineImage.Text:AlignTop(((GetScrW() * 0.0104166667) + 10) + ((slickHUD.AdminsOnlineImage:GetTall()) + 5) * 2)
		end

		slickHUD.CashImage = vgui.Create("DImage",slickHUD.Hud.HUDPanel)
		slickHUD.CashImage:SetSize(GetScrW() * 0.00833333333,GetScrH() * 0.01481481481)
		slickHUD.CashImage:SetImage("icon16/money.png")
		slickHUD.CashImage:AlignLeft(slickHUD.Hud.ModelPanelUnder:GetWide() + (GetScrW() * 0.00859375))
		slickHUD.CashImage:AlignTop((GetScrW() * 0.0104166667) + 10)
		slickHUD.Cash = vgui.Create("DLabel",slickHUD.Hud.HUDPanel)
		slickHUD.Cash:SetTextColor(Color(255,255,255))
		slickHUD.Cash:SetFont("slickHUD_HUD_Label_Roboto")
		slickHUD.Cash:SetText("$0")
		slickHUD.Cash:SizeToContents()
		slickHUD.Cash.CashNum = 0
		slickHUD.Cash.Think = function()
			if (tonumber(LocalPlayer():getDarkRPVar("money")) ~= slickHUD.Cash.CashNum) then
				slickHUD.Cash.CashNum = Lerp(0.05,slickHUD.Cash.CashNum,tonumber(LocalPlayer():getDarkRPVar("money")))
			end
			slickHUD.Cash:SetText("$" .. comma_value(math.Round(slickHUD.Cash.CashNum)))
			slickHUD.Cash:SizeToContents()
			slickHUD.Cash:AlignLeft(slickHUD.Hud.ModelPanelUnder:GetWide() + (GetScrW() * 0.00859375) + (GetScrW() * 0.00833333333) + 5)
			slickHUD.Cash:AlignTop((GetScrW() * 0.0104166667) + 10)
		end

		slickHUD.SalaryImage = vgui.Create("DImage",slickHUD.Hud.HUDPanel)
		slickHUD.SalaryImage:SetSize(GetScrW() * 0.00833333333,GetScrH() * 0.01481481481)
		slickHUD.SalaryImage:SetImage("icon16/money_add.png")
		slickHUD.SalaryImage:AlignLeft(slickHUD.Hud.ModelPanelUnder:GetWide() + (GetScrW() * 0.00859375))
		slickHUD.SalaryImage:AlignTop(((GetScrW() * 0.0104166667) + 10) + ((slickHUD.CashImage:GetTall()) + 5) * 1)
		slickHUD.Salary = vgui.Create("DLabel",slickHUD.Hud.HUDPanel)
		slickHUD.Salary:SetTextColor(Color(255,255,255))
		slickHUD.Salary:SetFont("slickHUD_HUD_Label_Roboto")
		slickHUD.Salary.SalaryNum = 0
		slickHUD.Salary.Think = function()
			if (LocalPlayer():getJobTable().salary ~= slickHUD.Salary.SalaryNum) then
				slickHUD.Salary.SalaryNum = Lerp(0.05,slickHUD.Salary.SalaryNum,LocalPlayer():getJobTable().salary)
			end
			slickHUD.Salary:SetText("$" .. comma_value(math.Round(slickHUD.Salary.SalaryNum)))
			slickHUD.Salary:SizeToContents()
			slickHUD.Salary:AlignLeft(slickHUD.Hud.ModelPanelUnder:GetWide() + (GetScrW() * 0.00859375) + (GetScrW() * 0.00833333333) + 5)
			slickHUD.Salary:AlignTop(((GetScrW() * 0.0104166667) + 10) + ((slickHUD.CashImage:GetTall()) + 5) * 1)
		end

		slickHUD.JobImage = vgui.Create("DImage",slickHUD.Hud.HUDPanel)
		slickHUD.JobImage:SetSize(GetScrW() * 0.00833333333,GetScrH() * 0.01481481481)
		slickHUD.JobImage:SetImage("icon16/vcard.png")
		slickHUD.JobImage:AlignLeft(slickHUD.Hud.ModelPanelUnder:GetWide() + (GetScrW() * 0.00859375))
		slickHUD.JobImage:AlignTop(((GetScrW() * 0.0104166667) + 10) + ((slickHUD.CashImage:GetTall()) + 5) * 2)
		slickHUD.Job = vgui.Create("DLabel",slickHUD.Hud.HUDPanel)
		slickHUD.Job:SetTextColor(Color(255,255,255))
		slickHUD.Job:SetFont("slickHUD_HUD_Label_Roboto")
		slickHUD.Job.Think = function()
			slickHUD.Job:SetText(LocalPlayer():getJobTable().name or "Unknown")
			slickHUD.Job:SizeToContents()
			slickHUD.Job:AlignLeft(slickHUD.Hud.ModelPanelUnder:GetWide() + (GetScrW() * 0.00859375) + (GetScrW() * 0.00833333333) + 5)
			slickHUD.Job:AlignTop(((GetScrW() * 0.0104166667) + 10) + ((slickHUD.CashImage:GetTall()) + 5) * 2)
		end

		slickHUD.Hud.Ammo = vgui.Create("DPanel",slickHUD.Hud)
		slickHUD.Hud.Ammo:SetSize(0,sizeh(166))
		slickHUD.Hud.Ammo.IsOpen = false
		slickHUD.Hud.Ammo.HasAnimated = true
		slickHUD.Hud.Ammo:AlignLeft(sizew(410))
		slickHUD.Hud.Ammo:SetZPos(-1)
		slickHUD.Hud.Ammo:AlignBottom(sizeh(7))
		slickHUD.Hud.Ammo.Paint = function(self)
			surface.SetDrawColor(Color(69,80,91))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
			surface.SetDrawColor(Color(0,0,0))
			surface.DrawLine(0,self:GetTall(),0,0)
		end

		local function getAmmoFromWeapon(wep)
			if (wep:GetPrimaryAmmoType() ~= nil) then
				if (wep.Base == "fas2_base") then
					return LocalPlayer():GetAmmoCount(wep.Primary.Ammo)
				end
				return LocalPlayer():GetAmmoCount(wep:GetPrimaryAmmoType())
			else
				return 0
			end
		end

		local function getAmmoFromWeaponSecondary(wep)
			if (IsValid(wep)) then
				if (wep:GetPrimaryAmmoType() ~= nil) then
					if (wep.Base == "fas2_base") then
						return LocalPlayer():GetAmmoCount(wep.Secondary.Ammo)
					end
					return LocalPlayer():GetAmmoCount(wep:GetSecondaryAmmoType())
				else
					return 0
				end
			end
		end

		slickHUD.Hud.Ammo.NoAmmoClip1 = vgui.Create("DPanel",slickHUD.Hud.Ammo)
		slickHUD.Hud.Ammo.NoAmmoClip1:SetZPos(2)
		slickHUD.Hud.Ammo.NoAmmoClip1:SetSize(sizew(160),sizeh(35))
		slickHUD.Hud.Ammo.NoAmmoClip1.Paint = function(self)
			surface.SetDrawColor(Color(255,84,81,255))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		end
		slickHUD.Hud.Ammo.NoAmmoClip1:SetPos(sizew(-160),0)

		slickHUD.Hud.Ammo.NoAmmoClip1.Text = vgui.Create("DLabel",slickHUD.Hud.Ammo.NoAmmoClip1)
		slickHUD.Hud.Ammo.NoAmmoClip1.Text:SetText("DEPLETED")
		slickHUD.Hud.Ammo.NoAmmoClip1.Text:SetFont("slickHUD_HUD_Roboto")
		slickHUD.Hud.Ammo.NoAmmoClip1.Text:SizeToContents()
		slickHUD.Hud.Ammo.NoAmmoClip1.Text:Center()
		slickHUD.Hud.Ammo.NoAmmoClip1.Text:SetTextColor(Color(255,255,255))

		slickHUD.Hud.Ammo.Clip1Text = vgui.Create("DLabel",slickHUD.Hud.Ammo)
		slickHUD.Hud.Ammo.Clip1Text:SetFont("slickHUD_HUD_Roboto")
		slickHUD.Hud.Ammo.Clip1Text.Think = function()
			if (IsValid(slickHUD.Hud.Ammo)) then
				if (IsValid(LocalPlayer():GetActiveWeapon())) then
					slickHUD.Hud.Ammo.Clip1Text:SetText(LocalPlayer():GetActiveWeapon():Clip1())
					slickHUD.Hud.Ammo.Clip1Text:SizeToContents()
					slickHUD.Hud.Ammo.Clip1Text:CenterHorizontal()
					slickHUD.Hud.Ammo.Clip1Text:AlignTop(sizeh(40))
				end
			end
		end

		hook.Remove("Think","nobulletsslide")
		hook.Add("Think","nobulletsslide",function()
			if (IsValid(LocalPlayer():GetActiveWeapon())) then
				if (IsValid(slickHUD.Hud)) then
					if (IsValid(slickHUD.Hud.Ammo)) then
						if (IsValid(slickHUD.Hud.Ammo.NoAmmoClip1)) then
							if (LocalPlayer():GetActiveWeapon():Clip1() == 0) then
								if (slickHUD.Hud.Ammo.NoAmmoClip1.AnimationFini == nil) then
									slickHUD.Hud.Ammo.NoAmmoClip1.AnimationFini = true
									slickHUD.Hud.Ammo.NoAmmoClip1:Stop()
									slickHUD.Hud.Ammo.NoAmmoClip1:MoveTo(0,0,0.5)
								end
							else
								if (slickHUD.Hud.Ammo.NoAmmoClip1.AnimationFini == true) then
									slickHUD.Hud.Ammo.NoAmmoClip1.AnimationFini = nil
									slickHUD.Hud.Ammo.NoAmmoClip1:Stop()
									slickHUD.Hud.Ammo.NoAmmoClip1:MoveTo(sizew(-160),0,0.5)
								end
							end
						end
					end
				end
			end
		end)

		slickHUD.Hud.Ammo.Bullets = {}
		local function RunBullets()
			if (IsValid(slickHUD.Hud)) then
				if (IsValid(slickHUD.Hud.Ammo)) then
					if (IsValid(LocalPlayer():GetActiveWeapon())) then
						if (LocalPlayer():GetActiveWeapon() ~= slickHUD.Hud.Ammo.CurWeapon) then
							slickHUD.Hud.Ammo.CurWeapon = LocalPlayer():GetActiveWeapon()
							for _,v in pairs(slickHUD.Hud.Ammo.Bullets) do v:Remove() end
							slickHUD.Hud.Ammo.Bullets = {}
							local LastClip1 = LocalPlayer():GetActiveWeapon():Clip1()
							if (LocalPlayer():GetActiveWeapon():Clip1() < 23) then
								getClip1 = LocalPlayer():GetActiveWeapon():Clip1()
							end
							local bulletTex = Material("slickHUD/bullet.png")
							for i=1,LocalPlayer():GetActiveWeapon():Clip1(),1 do
								local newBullet = vgui.Create("DPanel",slickHUD.Hud.Ammo)
								newBullet:SetSize(sizew(7),sizeh(25))
								newBullet:AlignLeft((sizew(6) * (i)))
								newBullet:AlignTop(sizeh(5))
								newBullet.Paint = function(self)
									surface.SetMaterial(bulletTex)
									surface.SetDrawColor(Color(255,255,255,255))
									surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
								end
								table.insert(slickHUD.Hud.Ammo.Bullets,newBullet)
							end
							hook.Remove("Think","hudammochecker_shot")
							hook.Add("Think","hudammochecker_shot",function()
								if (IsValid(LocalPlayer():GetActiveWeapon())) then
									if (LocalPlayer():GetActiveWeapon():Clip1() ~= LastClip1) then
										if (LocalPlayer():GetActiveWeapon():Clip1() >= LastClip1) then
											LastClip1 = LocalPlayer():GetActiveWeapon():Clip1()
											for i,v in pairs(slickHUD.Hud.Ammo.Bullets) do
												v:Stop()
												local shotBullet = v
												if (IsValid(shotBullet)) then
													local x,y = shotBullet:GetPos()
													shotBullet:MoveTo(sizew(205),y,1)
													timer.Simple(1,function()
														shotBullet:Remove()
													end)
												end
											end
											slickHUD.Hud.Ammo.Bullets = {}
											for i=1,LastClip1,1 do
												local newBullet = vgui.Create("DPanel",slickHUD.Hud.Ammo)
												newBullet:SetSize(sizew(7),sizeh(25))
												newBullet:AlignLeft(sizew(205))
												newBullet:AlignTop(sizeh(5))
												newBullet.Paint = function(self)
													surface.SetMaterial(bulletTex)
													surface.SetDrawColor(Color(255,255,255,255))
													surface.DrawTexturedRect(0,0,self:GetWide(),self:GetTall())
												end
												newBullet:MoveTo((sizew(6) * (i)),sizeh(5),1 + (i / 10))
												table.insert(slickHUD.Hud.Ammo.Bullets,newBullet)
											end
										else
											LastClip1 = LocalPlayer():GetActiveWeapon():Clip1()
											for _,v in pairs(slickHUD.Hud.Ammo.Bullets) do v:Stop() end
											local shotBullet = slickHUD.Hud.Ammo.Bullets[1]
											if (IsValid(shotBullet)) then
												table.remove(slickHUD.Hud.Ammo.Bullets,1)
												local x,y = shotBullet:GetPos()
												shotBullet:MoveTo(x,y - sizeh(30),0.5)
												timer.Simple(0.5,function()
													shotBullet:Remove()
												end)
												for i,v in pairs(slickHUD.Hud.Ammo.Bullets) do
													local x,y = v:GetPos()
													v:Stop()
													v:MoveTo(i * 6,y,0.5)
												end
											end
										end
									end
								end
							end)
						end
					else
						if (#slickHUD.Hud.Ammo.Bullets ~= 0) then
							hook.Remove("Think","hudammochecker_shot")
							for _,v in pairs(slickHUD.Hud.Ammo.Bullets) do v:Remove() end
							slickHUD.Hud.Ammo.Bullets = {}
						end
					end
				end
			end
		end
		RunBullets()
		hook.Remove("Think","hudammochecker")
		hook.Add("Think","hudammochecker",RunBullets)

		-- "80db6c9a9d3ef7b8daa40a3477437ab837810c5ec6169fcf"

		local function roundUpFully(amount)
			if (string.find(tostring(amount),"%.")) then
				return math.floor(amount) + 1
			else
				return amount
			end
		end

		slickHUD.Hud.Ammo.Magazines = {}
		slickHUD.Hud.Ammo.Magazines.Mags = {}
		slickHUD.Hud.Ammo.Magazines.LastWeapon = nil
		slickHUD.Hud.Ammo.Magazines.LastMagCount = nil
		slickHUD.Hud.Ammo.Magazines.Text = vgui.Create("DLabel",slickHUD.Hud.Ammo)
		slickHUD.Hud.Ammo.Magazines.Text:SetTextColor(Color(255,255,255))
		slickHUD.Hud.Ammo.Magazines.Text:SetFont("slickHUD_HUD_Roboto")
		slickHUD.Hud.Ammo.Magazines.Text.Think = function()
			if (IsValid(LocalPlayer():GetActiveWeapon())) then
				slickHUD.Hud.Ammo.Magazines.Text:SetText(roundUpFully(getAmmoFromWeapon(LocalPlayer():GetActiveWeapon()) / LocalPlayer():GetActiveWeapon():GetMaxClip1()))
				slickHUD.Hud.Ammo.Magazines.Text:SizeToContents()
				slickHUD.Hud.Ammo.Magazines.Text:AlignTop(sizeh(66) + sizeh(25) + sizeh(10))
				slickHUD.Hud.Ammo.Magazines.Text:CenterHorizontal()
			end
		end

		slickHUD.Hud.Ammo.NoMags = vgui.Create("DPanel",slickHUD.Hud.Ammo)
		slickHUD.Hud.Ammo.NoMags:SetZPos(2)
		slickHUD.Hud.Ammo.NoMags:SetSize(sizew(160),sizeh(35))
		slickHUD.Hud.Ammo.NoMags.Paint = function(self)
			surface.SetDrawColor(Color(255,84,81,255))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		end
		slickHUD.Hud.Ammo.NoMags:SetPos(sizew(-160),sizeh(61))
		hook.Remove("Think","nomagsslide")
		hook.Add("Think","nomagsslide",function()
			if (IsValid(LocalPlayer():GetActiveWeapon())) then
				if (IsValid(slickHUD.Hud)) then
					if (IsValid(slickHUD.Hud.Ammo)) then
						if (IsValid(slickHUD.Hud.Ammo.NoMags)) then
							if (roundUpFully(getAmmoFromWeapon(LocalPlayer():GetActiveWeapon()) / LocalPlayer():GetActiveWeapon():GetMaxClip1()) == 0) then
								if (slickHUD.Hud.Ammo.NoMags.AnimationFini == nil) then
									slickHUD.Hud.Ammo.NoMags.AnimationFini = true
									slickHUD.Hud.Ammo.NoMags:Stop()
									slickHUD.Hud.Ammo.NoMags:MoveTo(0,sizeh(61),0.5)
								end
							else
								if (slickHUD.Hud.Ammo.NoMags.AnimationFini == true) then
									slickHUD.Hud.Ammo.NoMags.AnimationFini = nil
									slickHUD.Hud.Ammo.NoMags:Stop()
									slickHUD.Hud.Ammo.NoMags:MoveTo(sizew(-160),sizeh(61),0.5)
								end
							end
						end
					end
				end
			end
		end)

		slickHUD.Hud.Ammo.NoMags.Text = vgui.Create("DLabel",slickHUD.Hud.Ammo.NoMags)
		slickHUD.Hud.Ammo.NoMags.Text:SetText("MAGS DEPLETED")
		slickHUD.Hud.Ammo.NoMags.Text:SetFont("slickHUD_HUD_Roboto")
		slickHUD.Hud.Ammo.NoMags.Text:SizeToContents()
		slickHUD.Hud.Ammo.NoMags.Text:Center()
		slickHUD.Hud.Ammo.NoMags.Text:SetTextColor(Color(255,255,255))

		local function createMags(amount)
			for _,v in pairs(slickHUD.Hud.Ammo.Magazines.Mags) do v:Remove() end
			slickHUD.Hud.Ammo.Magazines.Mags = {}

			for i=1,amount,1 do
				local newMag = vgui.Create("DImage",slickHUD.Hud.Ammo)
				table.insert(slickHUD.Hud.Ammo.Magazines.Mags,newMag)
				newMag:SetSize(sizew(16),sizeh(25))
				newMag:AlignTop(sizew(66))
				newMag:AlignLeft(sizew(16) * i - sizew(9))
				newMag:SetImage("slickHUD/magazine.png")
			end
		end

		hook.Remove("Think","hudmagazinechecker")
		hook.Add("Think","hudmagazinechecker",function()
			if (IsValid(LocalPlayer():GetActiveWeapon())) then
				if (slickHUD.Hud ~= nil) then
					if (slickHUD.Hud.Ammo ~= nil) then
						if (roundUpFully(getAmmoFromWeapon(LocalPlayer():GetActiveWeapon()) / LocalPlayer():GetActiveWeapon():GetMaxClip1()) ~= slickHUD.Hud.Ammo.Magazines.LastMagCount or LocalPlayer():GetActiveWeapon() ~= slickHUD.Hud.Ammo.Magazines.LastWeapon) then
							if (slickHUD.Hud.Ammo.Magazines.LastMagCount == nil or LocalPlayer():GetActiveWeapon() ~= slickHUD.Hud.Ammo.Magazines.LastWeapon) then
								slickHUD.Hud.Ammo.Magazines.LastWeapon = LocalPlayer():GetActiveWeapon()
								slickHUD.Hud.Ammo.Magazines.LastMagCount = roundUpFully(getAmmoFromWeapon(LocalPlayer():GetActiveWeapon()) / LocalPlayer():GetActiveWeapon():GetMaxClip1())
								createMags(slickHUD.Hud.Ammo.Magazines.LastMagCount)
							elseif (slickHUD.Hud.Ammo.Magazines.LastMagCount >= roundUpFully(getAmmoFromWeapon(LocalPlayer():GetActiveWeapon()) / LocalPlayer():GetActiveWeapon():GetMaxClip1())) then
								slickHUD.Hud.Ammo.Magazines.LastMagCount = roundUpFully(getAmmoFromWeapon(LocalPlayer():GetActiveWeapon()) / LocalPlayer():GetActiveWeapon():GetMaxClip1())
								local usedMag = slickHUD.Hud.Ammo.Magazines.Mags[1]
								if (!usedMag) then return end
								table.remove(slickHUD.Hud.Ammo.Magazines.Mags,1)
								local x,y = usedMag:GetPos()
								usedMag:MoveTo(sizew(-21),y,0.5)
								timer.Simple(0.5,function()
									usedMag:Remove()
								end)
								for _,v in pairs(slickHUD.Hud.Ammo.Magazines.Mags) do
									local x,y = v:GetPos()
									v:MoveTo(x - sizew(16),y,0.5)
								end
							elseif (slickHUD.Hud.Ammo.Magazines.LastMagCount <= roundUpFully(getAmmoFromWeapon(LocalPlayer():GetActiveWeapon()) / LocalPlayer():GetActiveWeapon():GetMaxClip1())) then
								slickHUD.Hud.Ammo.Magazines.LastMagCount = roundUpFully(getAmmoFromWeapon(LocalPlayer():GetActiveWeapon()) / LocalPlayer():GetActiveWeapon():GetMaxClip1())
								local newMag = vgui.Create("DImage",slickHUD.Hud.Ammo)
								table.insert(slickHUD.Hud.Ammo.Magazines.Mags,newMag)
								newMag:SetSize(sizew(16),sizeh(25))
								newMag:AlignTop(sizeh(66))
								newMag:AlignLeft(sizew(125))
								newMag:SetImage("slickHUD/magazine.png")
								newMag:MoveTo(#slickHUD.Hud.Ammo.Magazines.Mags * 16 - sizew(9),sizeh(66),0.5)
							end
						end
						if (#slickHUD.Hud.Ammo.Magazines.Mags ~= roundUpFully(getAmmoFromWeapon(LocalPlayer():GetActiveWeapon()) / LocalPlayer():GetActiveWeapon():GetMaxClip1())) then
							slickHUD.Hud.Ammo.Magazines.LastWeapon = LocalPlayer():GetActiveWeapon()
							slickHUD.Hud.Ammo.Magazines.LastMagCount = roundUpFully(getAmmoFromWeapon(LocalPlayer():GetActiveWeapon()) / LocalPlayer():GetActiveWeapon():GetMaxClip1())
							createMags(slickHUD.Hud.Ammo.Magazines.LastMagCount)
						end
					end
				end
			end
		end)

		slickHUD.Hud.Ammo.Clip2Panel = vgui.Create("DPanel",slickHUD.Hud.Ammo)
		slickHUD.Hud.Ammo.Clip2Panel:SetSize(sizew(160),sizeh(40))
		slickHUD.Hud.Ammo.Clip2Panel:AlignLeft(sizew(-160))
		slickHUD.Hud.Ammo.Clip2Panel:AlignBottom(0)
		slickHUD.Hud.Ammo.Clip2Panel.Paint = function(self)
			surface.SetDrawColor(Color(37,43,50))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		end

		slickHUD.Hud.Ammo.Clip2PanelNone = vgui.Create("DPanel",slickHUD.Hud.Ammo)
		slickHUD.Hud.Ammo.Clip2PanelNone:SetSize(sizew(160),sizeh(40))
		slickHUD.Hud.Ammo.Clip2PanelNone:AlignLeft(sizew(-160))
		slickHUD.Hud.Ammo.Clip2PanelNone:AlignBottom(0)
		slickHUD.Hud.Ammo.Clip2PanelNone.Paint = function(self)
			surface.SetDrawColor(Color(255,84,81))
			surface.DrawRect(0,0,self:GetWide(),self:GetTall())
		end
		slickHUD.Hud.Ammo.Clip2PanelNone.Text = vgui.Create("DLabel",slickHUD.Hud.Ammo.Clip2PanelNone)
		slickHUD.Hud.Ammo.Clip2PanelNone.Text:SetFont("slickHUD_HUD_Roboto")
		slickHUD.Hud.Ammo.Clip2PanelNone.Text:SetTextColor(Color(255,255,255))
		slickHUD.Hud.Ammo.Clip2PanelNone.Text:SetText("NO SECONDARY")
		slickHUD.Hud.Ammo.Clip2PanelNone.Text:SizeToContents()
		slickHUD.Hud.Ammo.Clip2PanelNone.Text:Center()
		slickHUD.Hud.Ammo.Clip2PanelNone.Text.FirstSetup = true

		slickHUD.Hud.Ammo.Clip2Panel.Text = vgui.Create("DLabel",slickHUD.Hud.Ammo.Clip2Panel)
		slickHUD.Hud.Ammo.Clip2Panel.Text:SetFont("slickHUD_HUD_Roboto")
		slickHUD.Hud.Ammo.Clip2Panel.Text:SetTextColor(Color(255,255,255))
		local function Clip2PanelThink()
			if (IsValid(LocalPlayer():GetActiveWeapon())) then
				if (getAmmoFromWeaponSecondary(LocalPlayer():GetActiveWeapon()) == 0) then
					if (slickHUD.Hud.Ammo.Clip2Panel.AnimatedFinished == nil) then
						slickHUD.Hud.Ammo.Clip2Panel.AnimatedFinished = true
						local x,y = slickHUD.Hud.Ammo.Clip2Panel:GetPos()
						slickHUD.Hud.Ammo.Clip2Panel:MoveTo(sizew(-160),y,0.5)
						slickHUD.Hud.Ammo.Clip2PanelNone:MoveTo(0,y,0.5)
					end
				else
					if (slickHUD.Hud.Ammo.Clip2Panel.AnimatedFinished == true or slickHUD.Hud.Ammo.Clip2PanelNone.Text.FirstSetup == true) then
						slickHUD.Hud.Ammo.Clip2PanelNone.Text.FirstSetup = false
						slickHUD.Hud.Ammo.Clip2Panel.AnimatedFinished = nil
						local x,y = slickHUD.Hud.Ammo.Clip2Panel:GetPos()
						slickHUD.Hud.Ammo.Clip2Panel:MoveTo(0,y,0.5)
						slickHUD.Hud.Ammo.Clip2PanelNone:MoveTo(sizew(-160),y,0.5)
					end
					if (LocalPlayer():GetActiveWeapon():Clip2() ~= -1) then
						slickHUD.Hud.Ammo.Clip2Panel.Text:SetText("Secondary: " .. LocalPlayer():GetActiveWeapon():Clip2() .. "/" .. getAmmoFromWeaponSecondary(LocalPlayer():GetActiveWeapon()))
					else
						slickHUD.Hud.Ammo.Clip2Panel.Text:SetText("Secondary: " .. getAmmoFromWeaponSecondary(LocalPlayer():GetActiveWeapon()))
					end
					slickHUD.Hud.Ammo.Clip2Panel.Text:SizeToContents()
					slickHUD.Hud.Ammo.Clip2Panel.Text:Center()
				end
			end
		end
		Clip2PanelThink()
		slickHUD.Hud.Ammo.Clip2Panel.Text.Think = Clip2PanelThink

		slickHUD.Hud.Ammo.Think = function()
			local allow = false
			if (IsValid(LocalPlayer():GetActiveWeapon())) then
				if (#LocalPlayer():GetActiveWeapon():GetTable() > 0) then
					if (LocalPlayer():GetActiveWeapon():GetTable().Primary.ClipSize ~= nil and LocalPlayer():GetActiveWeapon():GetTable().Primary.ClipSize ~= -1) then
						allow = true
					end
					if (LocalPlayer():GetActiveWeapon():GetTable().Secondary.ClipSize ~= nil and LocalPlayer():GetActiveWeapon():GetTable().Secondary.ClipSize ~= -1) then
						allow = true
					end
				else
					if (LocalPlayer():GetActiveWeapon():GetMaxClip1() > 0 and LocalPlayer():GetActiveWeapon():Clip1() > -1) then
						allow = true
					end
					if (LocalPlayer():GetActiveWeapon():GetMaxClip2() > 0 and LocalPlayer():GetActiveWeapon():Clip2() > -1) then
						allow = true
					end
				end
			end
			if (allow == true) then
				if (slickHUD.Hud.Ammo.IsOpen == false) then
					slickHUD.Hud.Ammo.HasAnimated = nil
				end
				if (slickHUD.Hud.Ammo.HasAnimated == nil) then
					slickHUD.Hud.Ammo.HasAnimated = true
					slickHUD.Hud.Ammo.IsOpen = true
					slickHUD.Hud.Ammo:Stop()
					slickHUD.Hud.Ammo:SizeTo(sizew(160),sizeh(166),0.5)
				end
			else
				if (slickHUD.Hud.Ammo.IsOpen == true) then
					slickHUD.Hud.Ammo.HasAnimated = nil
				end
				if (slickHUD.Hud.Ammo.HasAnimated == nil) then
					slickHUD.Hud.Ammo.HasAnimated = true
					slickHUD.Hud.Ammo.IsOpen = false
					slickHUD.Hud.Ammo:Stop()
					slickHUD.Hud.Ammo:SizeTo(0,sizeh(166),0.5)
				end
			end
		end
	else
		slickHUD.Hud = vgui.Create("DPanel")
		slickHUD.Hud.Paint = function() end
	end
end)
