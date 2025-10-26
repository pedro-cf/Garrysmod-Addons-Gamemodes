include( 'shared.lua' )
include( 'cl_fretta_must_die.lua' )
include( 'cl_gib.lua' )
include( 'cl_health.lua' )

usermessage.Hook("Deathrun - Runners Win", function()
	surface.PlaySound("music/HL2_song15.mp3")
end)

usermessage.Hook("Deathrun - Death Wins", function()
	surface.PlaySound("music/stingers/HL1_stinger_song8.mp3")
end)