TowerParams = {
	StandardTowerDamage = 15,
	StandardTowerAttackRate = 0.8, --attacks per second

	LaserTowerDamage = 1,
	LaserTowerAttackRate = 4,


	UpgradeDamageIncrease = 2,
	TowerDamageUpgradeStartingCost = 20,
	TowerDamageUpgradeCostIncrease = 5,

	UpgradeAttackRateIncrease = 0.2,	
	TowerAttackRateUpgradeStartingCost = 20,
	TowerAttackRateUpgradeCostIncrease = 5,

	UpgradeRangeIncrease = 15, --pixels
	TowerRangeUpgradeStartingCost = 20,
	TowerRangeUpgradeCostIncrease = 5,


	TowerProjectileSpeed = 180, --pixels per second


	onFireTimer = 2,
	onFireDOTTickTimer = 0.5, --seconds
	onFireDOTDamage = 4,

	slowDebuffTime = 2, --seconds
	slowDebuffSlowAmount = 0.7,

	shockTimer = 2, --seconds
	shockDamageAmplifier = 0.1,
	shockDamageMaxStack = 4,


	TowerCost = 100,
	ElementalTowerCost = 150,

	TowerSellPriceMultiplier = 0.5 --Towers can be sold for half of their costs.
}

return TowerParams