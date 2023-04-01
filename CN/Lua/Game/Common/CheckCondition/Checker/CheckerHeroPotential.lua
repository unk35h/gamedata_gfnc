-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerHeroPotential = {}
CheckerHeroPotential.LengthCheck = function(param)
  -- function num : 0_0
  do return #param >= 3 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CheckerHeroPotential.ParamsCheck = function(param)
  -- function num : 0_1 , upvalues : _ENV
  local heroId = param[2]
  local potential = param[3]
  local heroData = (PlayerDataCenter.heroDic)[heroId]
  if heroData == nil then
    return false
  end
  do return potential <= heroData:GetHeroPotential() end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CheckerHeroPotential.GetUnlockInfo = function(param)
  -- function num : 0_2 , upvalues : _ENV
  local heroId = param[2]
  local potential = param[3]
  local heroName = (LanguageUtil.GetLocaleText)(((ConfigData.hero_data)[heroId]).name)
  return (string.format)(ConfigData:GetTipContent(922), heroName, potential)
end

return CheckerHeroPotential

