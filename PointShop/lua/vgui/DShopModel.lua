local PANEL = {}
local calc = 0
local mmove = 0
local item = ""

AccessorFunc(PANEL, "InfoHeight", "InfoHeight")

local icon = surface.GetTextureID("gui/silkicons/shield")
local xmas = surface.GetTextureID("gui/silkicons/mistletoev2")


function PANEL:Init()
	self:SetCamPos(Vector(0, 30, 0))
	self:SetLookAt(Vector(0, 0, 0))
	
	self.Info = ""
	self.InfoHeight = 14
end

function PANEL:SetSkin(id)
	self.Entity:SetSkin(id)
end

function PANEL:SetData(data)
	self.Data = data
	self.Info = data.Name
	self.Inv = data.inv
	self:SetModel(data.Model)
	
	if data.Skin then
		self:SetSkin(data.Skin)
	end
	
	if self.Description then
		self:SetTooltip(data.Description)
	end
	
	self.dir = 200
	if math.random(0, 10) > 5 then self.dir = -self.dir end
	
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
	
	local PrevMins, PrevMaxs = self.Entity:GetRenderBounds()
    self:SetCamPos(PrevMins:Distance(PrevMaxs) * Vector(0.75, 0.75, 0.5))
    self:SetLookAt((PrevMaxs + PrevMins) / 2)
end

function PANEL:LayoutEntity(ent)
	if self.Hovered then
		ent:SetAngles(Angle(0, RealTime() * self.dir, 0))
	end
end

function PANEL:Paint()
local ord = ScrH()/2 - (ScrH()*0.55)/2 + 70
local ordy = ord + (ScrH()*0.55)*0.8 - 55
render.SetScissorRect( 0, ord, ScrW(), ordy, true )
    if ( !IsValid( self.Entity ) ) then return end
    
    local x, y = self:LocalToScreen( 0, 0 )
    
    self:LayoutEntity( self.Entity )
    
    cam.Start3D( self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, self:GetSize() )
    cam.IgnoreZ( true )
    
    render.SuppressEngineLighting( true )
    render.SetLightingOrigin( self.Entity:GetPos() )
    render.ResetModelLighting( self.colAmbientLight.r/255, self.colAmbientLight.g/255, self.colAmbientLight.b/255 )
    render.SetColorModulation( self.colColor.r/255, self.colColor.g/255, self.colColor.b/255 )
    render.SetBlend( self.colColor.a/255 )
    
    for i=0, 6 do
        local col = self.DirectionalLight[ i ]
        if ( col ) then
            render.SetModelLighting( i, col.r/255, col.g/255, col.b/255 )
        end
    end
        
    self.Entity:DrawModel()
    
    render.SuppressEngineLighting( false )
    cam.IgnoreZ( false )
    cam.End3D()
    
    self.LastPaint = RealTime()
render.SetScissorRect( 0, ord, ScrW(), ordy, false )
end

function PANEL:PaintOver()
local ord = ScrH()/2 - (ScrH()*0.55)/2 + 70
local ordy = ord + (ScrH()*0.55)*0.8 - 55
	if self.Data.AdminOnly then
		surface.SetTexture(icon)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(0, 0, 16, 16)
		mmove = 18
	end
	
	if self.Data.Christmas then
		surface.SetTexture(xmas)
		surface.SetDrawColor(255, 255, 255, 255)
		surface.DrawTexturedRect(mmove, 0, 16, 16)
	end
	
	if self.Data.Donator then
		draw.SimpleTextOutlined("D", "KCV20", mmove, 0, Color(0,191,255,255), TEXT_ALIGN_LEFT, TEXT_ALIGN_LEFT, 1.5, Color(0,0,0,255))
	end
	
	surface.SetDrawColor(self.BarColor.r, self.BarColor.g, self.BarColor.b, self.BarColor.a)
	surface.DrawRect(0, self:GetTall() - self.InfoHeight, self:GetWide(), self.InfoHeight)
	draw.SimpleText(self.Info, "DefaultSmall", self:GetWide() / 2, self:GetTall() - (self.InfoHeight / 2) - 1, self.TextColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

function PANEL:OnCursorEntered()
	self.Hovered = true
	if self.Sell then
		calc = self.Data.Cost*0.25
		self.Info = "Sell: " .. calc
	else
		self.Info = "Buy: " .. self.Data.Cost
	end
end

function PANEL:OnCursorExited()
	self.Hovered = false
	self.Info = self.Data.Name
end

vgui.Register("DShopModel", PANEL, "DModelPanel")