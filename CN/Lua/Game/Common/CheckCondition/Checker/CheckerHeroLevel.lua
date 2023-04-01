-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerHeroLevel = {}
CheckerHeroLevel.LengthCheck = function(param)
  -- function num : 0_0
  do return #param >= 3 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CheckerHeroLevel.ParamsCheck = function(param)
  -- function num : 0_1 , upvalues : _ENV
  local heroId = param[2]
  local level = param[3]
  local heroData = (PlayerDataCenter.heroDic)[heroId]
  if heroData == nil then
    return false
  end
  do return level <= heroData.level end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CheckerHeroLevel.GetUnlockInfo = function(param)
  -- function num : 0_2 , upvalues : _ENV
  local heroId = param[2]
  local level = param[3]
  local heroName = (LanguageUtil.GetLocaleText)(((ConfigData.hero_data)[heroId]).name)
  return (string.format)(ConfigData:GetTipContent(923), heroName, level)
end

return CheckerHeroLevel

