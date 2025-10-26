/*-------------------------------------------------------------------------------------------------------------------------
	Serverside autorun file
-------------------------------------------------------------------------------------------------------------------------*/

// Send required files to clients
AddCSLuaFile( "autorun/client/cv_autorun.lua" )
AddCSLuaFile( "cv_cl_init.lua" )
resource.AddFile( "materials/vote/check.vmt" )
resource.AddFile( "materials/vote/check.vtf" )
resource.AddFile( "materials/vote/cross.vmt" )
resource.AddFile( "materials/vote/cross.vtf" )
resource.AddFile( "materials/vote/checkLarge.vmt" )
resource.AddFile( "materials/vote/checkLarge.vtf" )
resource.AddFile( "materials/vote/crossLarge.vmt" )
resource.AddFile( "materials/vote/crossLarge.vtf" )

// Load config
include( "config.lua" )

// Include serverside initialization file
include( "cv_init.lua" )