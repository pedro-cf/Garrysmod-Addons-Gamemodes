/*   _                                
    ( )                              
   _| |   __   _ __   ___ ___     _ _
 /'_` | /'__`\( '__)/' _ ` _ `\ /'_` )
( (_| |(  ___/| |   | ( ) ( ) |( (_| |
`\__,_)`\____)(_)   (_) (_) (_)`\__,_)
 
*/
local PANEL = {}
local IID = ""
local posy = 0
local angy = 0
 
AccessorFunc( PANEL, "m_fAnimSpeed",    "AnimSpeed" )
AccessorFunc( PANEL, "Entity",                  "Entity" )
AccessorFunc( PANEL, "vCamPos",                 "CamPos" )
AccessorFunc( PANEL, "fFOV",                    "FOV" )
AccessorFunc( PANEL, "vLookatPos",              "LookAt" )
AccessorFunc( PANEL, "colAmbientLight", "AmbientLight" )
AccessorFunc( PANEL, "colColor",                "Color" )
AccessorFunc( PANEL, "bAnimated",               "Animated" )
 
 
/*---------------------------------------------------------
   Name: Init
---------------------------------------------------------*/
function PANEL:Init()
 
        self.Entity = nil
        self.LastPaint = 0
        self.DirectionalLight = {}
       
        self:SetCamPos( Vector( 50, 50, 50 ) )
        self:SetLookAt( Vector( 0, 0, 40 ) )
        self:SetFOV( 70 )
       
        self:SetText( "" )
        self:SetAnimSpeed( 0.5 )
        self:SetAnimated( false )
       
        self:SetAmbientLight( Color( 50, 50, 50 ) )
       
        self:SetDirectionalLight( BOX_TOP, Color( 255, 255, 255 ) )
        self:SetDirectionalLight( BOX_FRONT, Color( 255, 255, 255 ) )
       
        self:SetColor( Color( 255, 255, 255, 255 ) )
 
end
 
/*---------------------------------------------------------
   Name: SetDirectionalLight
---------------------------------------------------------*/
function PANEL:SetDirectionalLight( iDirection, color )
        self.DirectionalLight[iDirection] = color
end

 
/*---------------------------------------------------------
   Name: OnSelect
---------------------------------------------------------*/
function PANEL:SetModel( strModelName )
 
        // Note - there's no real need to delete the old
        // entity, it will get garbage collected, but this is nicer.
        if ( IsValid( self.Hat ) ) then
                self.Hat:Remove()
                self.Hat = nil              
        end
		
		if ( IsValid( self.Entity ) ) then
                self.Entity:Remove()
                self.Entity = nil              
        end
       
        // Note: Not in menu dll
        if ( !ClientsideModel ) then return end
       
        self.Entity = ClientsideModel( strModelName, RENDER_GROUP_OPAQUE_ENTITY )
        if ( !IsValid(self.Entity) ) then return end
       
        self.Entity:SetNoDraw( true )
		
		for id, item_id in pairs(LocalPlayer():PS_GetItems()) do
			local item = POINTSHOP.FindItemByID(item_id)
			if item then
				if LocalPlayer().Equiped then
					if LocalPlayer().Equiped[item_id] then
						strmodel = item.Model
					end
				end
			end
		end
		
		self.Hat = ClientsideModel(strmodel or "", RENDER_GROUP_OPAQUE_ENTITY )
		if ( !IsValid(self.Hat) ) then return end
	   
	    self.Hat:SetNoDraw( true )
	   
        // Try to find a nice sequence to play
        local iSeq = self.Entity:LookupSequence( "walk_all" );
        if (iSeq <= 0) then iSeq = self.Entity:LookupSequence( "WalkUnarmed_all" ) end
        if (iSeq <= 0) then iSeq = self.Entity:LookupSequence( "walk_all_moderate" ) end
       
        if (iSeq > 0) then self.Entity:ResetSequence( iSeq ) end
       
       
end
 
/*---------------------------------------------------------
   Name: OnMousePressed
---------------------------------------------------------*/
function PANEL:Paint()
 
        if ( !IsValid( self.Entity ) ) then return end
		if ( !IsValid( self.Hat ) ) then return end
	   
        local x, y = self:LocalToScreen( 0, 0 )
       
        self:LayoutEntity( self.Entity )
       
        cam.Start3D( self.vCamPos, (self.vLookatPos-self.vCamPos):Angle(), self.fFOV, x, y, self:GetWide(), self:GetTall() )
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
		
		local attach = Yourself:GetAttachment(Yourself:LookupAttachment("eyes"))
		if attach then
			pos = attach.Pos
			ang = attach.Ang
		end
		
		for id, item_id in pairs(LocalPlayer():PS_GetItems()) do
			local item = POINTSHOP.FindItemByID(item_id)
			if item then
				if LocalPlayer().Equiped then
					if LocalPlayer().Equiped[item_id] then
						IID = item_id
					end
				end
			end
		end
	
		
		if (Yourself:GetModel() == "models/player/guerilla.mdl") or (Yourself:GetModel() == "models/player/riot.mdl") or (Yourself:GetModel() == "models/player/urban.mdl") or (Yourself:GetModel() == "models/player/gasmask.mdl") or (Yourself:GetModel() == "models/player/swat.mdl")  then
			pos = pos + ang:Up()*6
		elseif (Yourself:GetModel() == "models/player/arctic.mdl") then
			pos = pos + ang:Up() + ang:Forward()*-2
			if self.Hat:GetModel() == "models/gmod_tower/aviators.mdl" then
				pos = pos + ang:Up()*-1 + ang:Forward()*0.5
			end
		elseif (Yourself:GetModel() == "models/player/leet.mdl") then
			pos = pos + ang:Up()*4.5 + ang:Forward()
			if self.Hat:GetModel() == "models/gmod_tower/aviators.mdl" then
				pos = pos + ang:Up()*-0.9 + ang:Forward()*-0.3
			end
			if self.Hat:GetModel() == "models/props/ld_office/ldtclan_hat.mdl" then
				pos = pos + ang:Forward()*0.5
			end
		elseif (Yourself:GetModel() == "models/player/phoenix.mdl") then
			pos = pos + ang:Up()*6
			if self.Hat:GetModel() == "models/gmod_tower/aviators.mdl" then
				pos = pos + ang:Up()*-1.1 + ang:Forward()*0.75
			end
		end
		
		for id, hat in pairs(LocalPlayer()._Hats) do 
			if IID == id then
				self.Hat, pos, ang = hat.Modify(hat.Model, pos, ang)
			end
		end
		self.Hat:SetRenderOrigin( pos )
		self.Hat:SetRenderAngles( ang )
		self.Hat:SetupBones()
		self.Hat:SetPos( pos )
		self.Hat:SetAngles( ang )
		self.Hat:DrawModel()
		self.Hat:SetRenderOrigin()
		self.Hat:SetRenderAngles()
	   
        render.SuppressEngineLighting( false )
        cam.IgnoreZ( false )
        cam.End3D()
       
        self.LastPaint = RealTime()
       
end
 
/*---------------------------------------------------------
   Name: RunAnimation
---------------------------------------------------------*/
function PANEL:RunAnimation()
        self.Entity:FrameAdvance( (RealTime()-self.LastPaint) * self.m_fAnimSpeed )    
end
 
/*---------------------------------------------------------
   Name: LayoutEntity
---------------------------------------------------------*/
function PANEL:LayoutEntity( Entity )
 
        //
        // This function is to be overriden
        //
 
        if ( self.bAnimated ) then
                self:RunAnimation()
        end
       
        Entity:SetAngles( Angle( 0, RealTime()*10,  0) )
 
end
 
/*---------------------------------------------------------
   Name: GenerateExample
---------------------------------------------------------*/
function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )
 
        local ctrl = vgui.Create( ClassName )
                ctrl:SetSize( 300, 300 )
                ctrl:SetModel( "models/error.mdl" )
               
        PropertySheet:AddSheet( ClassName, ctrl, nil, true, true )
 
end
 
derma.DefineControl( "DPlayerModelhat", "A panel containing the playermoldeand hat", PANEL, "DButton" )