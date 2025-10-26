/*-------------------------------------------------------------------------------------------------------------------------
	Configure stuff here
-------------------------------------------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------------------------------------------------
	Configure which vote types are allowed
-------------------------------------------------------------------------------------------------------------------------*/

VOTE_KICK = true
VOTE_BAN = true
VOTE_CLEAN = false
VOTE_NOCLIP = false
VOTE_GODMODE = false
VOTE_CUSTOM = true // Admins can create their own votes?

/*-------------------------------------------------------------------------------------------------------------------------
	Configure some settings for votes
-------------------------------------------------------------------------------------------------------------------------*/

VOTE_DELAY = 240  // Time in seconds before a new vote can be started by normal players
VOTE_BAN_TIME = 120 // Configure the voteban time in minutes
VOTE_KICK_BANTIME = 0 // Configure how long players have to wait before allowed to rejoin after being kicked

/*-------------------------------------------------------------------------------------------------------------------------
	Configure the instruction ad
-------------------------------------------------------------------------------------------------------------------------*/

VOTE_AD_ENABLED = false // Ad enabled?
VOTE_AD_TIME = 240 // The ad appears every VOTE_ADTIME seconds
VOTE_AD_MESSAGE = "Type votekick <player>, voteban <player>, votecleanup or votenoclip to start a vote!"