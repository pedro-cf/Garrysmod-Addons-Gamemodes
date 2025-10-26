local PANEL = {}
local calc = 0


AccessorFunc(PANEL, "InfoHeight", "InfoHeight")

local icon = surface.GetTextureID("gui/silkicons/shield")
local xmas = surface.GetTextureID("gui/silkicons/mistletoev2")

function PANEL:Init()
	self.AutoSize = false
	
	self.Info = ""
	self.InfoHeight = 14
end

function PANEL:SetData(data)
	self.Data = data
	self.Info = data.Name
	self.Inv = data.inv
	self:SetMaterial(data.Material)
	
	if self.Inv then
		self.BarColor = Color(100, 100, 100, 125)
		self.TextColor = Color(255,255,255,255)
	else
		if LocalPlayer():PS_CanAfford(self.Data.Cost) then
			self.BarColor = Color(0, 50, 0, 125)
			self.TextColor = Color(0,255,0,255)
		else
			self.BarColor = Color(50, 0, 0, 125)
			self.TextColor = Color(255,0,0,255)
		end
	end
end

function PANEL:PaintOver()
local ord = ScrH()/2 - (ScrH()*0.55)/2 + 70
local ordy = ord + (ScrH()*0.55)*0.8 - 55
	if self.Data.AdminOnly then
		surface.SetTexture(icon)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(0, 0, 16, 16)
	end
		
	if self.Data.Christmas then
		surface.SetTexture(xmas)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(0, 0, 16, 16)
	end
	
	if self.Data.Donator then
		draw.SimpleTextOutlined("D", "KCV20", mmove, 0, Color(0,191,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, Color(0,0,0,255))
	end
	
	surface.SetDrawColor(self.BarColor.r, self.BarColor.g, self.BarColor.b, self.BarColor.a)
	surface.DrawRect(0, self:GetTall() - self.InfoHeight, self:GetWide(), self.InfoHeight)
	draw.SimpleText(self.Info, "DefaultSmall", self:GetWide() / 2, self:GetTall() - (self.InfoHeight / 2) - 1, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:OnCursorEntered()
	if self.Sell then
		calc = self.Data.Cost*0.25
		self.Info = "Sell: " .. calc
	else
		self.Info = "Buy: " .. self.Data.Cost
	end
end

function PANEL:OnCursorExited()
	self.Info = self.Data.Name
end

vgui.Register("DShopMaterial", PANEL, "Material")