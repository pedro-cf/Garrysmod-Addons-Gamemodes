function GM:DrawPlayerRing(ply)
end

function GM:HUDDrawTargetID()
end

function GM:HUDWeaponPickedUp( wep )
end

function GM:UpdateHUD_Dead( bWaitingToSpawn, InRound )
end

function GM:UpdateHUD_Alive( InRound )
end

function GM:UpdateHUD_Observer( bWaitingToSpawn, InRound, ObserveMode, ObserveTarget )
end

function GM:UpdateHUD_RoundResult( RoundResult, Alive )
end

function GM:InitPostEntity()

	GAMEMODE:ShowSplash();

end

function GM:TeamChangeNotification( ply, oldteam, newteam )

	if( ply && ply:IsValid() ) then
		local nick = ply:Nick();
		local oldTeamColor = team.GetColor( oldteam );
		local newTeamName = team.GetName( newteam );
		local newTeamColor = team.GetColor( newteam );
		
		chat.PlaySound( "buttons/button15.wav" );
	end
end

hook.Add( "HUDShouldDraw", "HideHealthHUD", function(name)
	for k, v in pairs{ "CHudHealth", "CHudBattery", "CHudAmmo", "CHudSecondaryAmmo", "CHudHistoryResource" } do
		if name == v then return false end
	end
end )