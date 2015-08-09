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


	TowerCost = 100,
	ElementalTowerCost = 150, --Elemental damage has no effect in the game for now.

	TowerSellPriceMultiplier = 0.5 --Towers can be sold for half of their costs.
}

return TowerParams