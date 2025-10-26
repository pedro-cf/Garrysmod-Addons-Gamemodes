POINTSHOP.Config = {}

-- Edit the lines below to your liking.
-- Do not delete any lines.
-- Just set each line to true or false, or a desired value.
-- Edit shop items in their respective files in the items folder.

POINTSHOP.Config.ShopKey = "F4" -- F1, F2, F3 or F4. Default is F4. Set to "None" to disable.

POINTSHOP.Config.ShopNotify = false -- Tell the player how many points they have and how to open the shop when they first spawn?

POINTSHOP.Config.DisplayPoints = false -- Shows players how many points they have on their screen.

POINTSHOP.Config.AlwaysDrawHats = false -- Should hats always be drawn? Override in your gamemode.

POINTSHOP.Config.PointsTimer = false -- Enable the timer for giving a player points for playing for a certain amount of time.
POINTSHOP.Config.PointsTimerDelay = 30 -- Delay in minutes between giving points.
POINTSHOP.Config.PointsTimerAmount = 20 -- Amount to give after the above delay.

POINTSHOP.Config.OnNPCKilled = false -- Give Points when an NPC is killed by a player?
POINTSHOP.Config.OnNPCKilledAmount = 10 -- Amount to give for killing an NPC.

POINTSHOP.Config.PlayerDeath = false -- Give Points when a player is killed by a player?
POINTSHOP.Config.PlayerDeathAmount = 10 -- Amount to give for killing a player.

-- Don't edit this unless you know what you are doing.
-- No really, don't.

POINTSHOP.Config.SellCost = function(cost) -- Tells the shop how much to give a player back when they sell an item. Whatever you do, don't delete this function.
	-- return cost -- Full.
	return math.Round(cost * 0.25) -- Three quarters.
	-- return math.Round(cost * 0.66) -- Two thirds.
	-- return cost * 0.5 -- Half.
	-- return math.Round(cost * 0.33) -- One thirds.
end

POINTSHOP.Config.SellersEnabled = false -- Should NPC sellers be enabled?

POINTSHOP.Config.Sellers = {
	gm_flatgrass = {
		{
			Name = "Weapons Seller",
			Model = "models/Humans/Group02/male_07.mdl",
			Position = Vector(0, 0, 0),
			Angle = Angle(0, 0, 0),
			Categories = { "Weapons" }
		}
	}
}

-- End config.