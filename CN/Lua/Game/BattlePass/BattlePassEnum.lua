-- params : ...
-- function num : 0 , upvalues : _ENV
local BattlePassEnum = {}
BattlePassEnum.ConditionType = {AchievementLevel = 1, BattlePassLevel = 2}
BattlePassEnum.TakeWay = {Base = 0, Senior = 1, BaseAndSenior = 2, All = 3, Overflow = 4}
BattlePassEnum.BuyQuality = {Senior = 0, Ultimate = 1, SupplyUltimate = 2}
BattlePassEnum.GetPassPayId = function(quality, passCfg)
  -- function num : 0_0 , upvalues : BattlePassEnum
  local payId = 0
  if quality == (BattlePassEnum.BuyQuality).Senior then
    payId = passCfg.senior_price
  else
    if quality == (BattlePassEnum.BuyQuality).Ultimate then
      payId = passCfg.ultimate_price
    else
      if quality == (BattlePassEnum.BuyQuality).SupplyUltimate then
        payId = passCfg.supply_price
      end
    end
  end
  return payId
end

BattlePassEnum.pickColor = (Color.New)(1, 0.56, 0.13, 0.9)
BattlePassEnum.ReHolderStyleMapping = {BattlePassReHolderStyleNormal = "UINReHolderStyleNormal"}
return BattlePassEnum

