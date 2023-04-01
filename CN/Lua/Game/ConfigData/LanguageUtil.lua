-- params : ...
-- function num : 0 , upvalues : _ENV
LanguageUtil = {}
-- DECOMPILER ERROR at PC4: Confused about usage of register: R0 in 'UnsetPending'

LanguageUtil.GetLocaleText = function(idx)
  -- function num : 0_0 , upvalues : _ENV
  if type(idx) ~= "number" then
    return idx
  end
  return (ConfigData.locale_text)[idx]
end

local defaultLanguageRule = {unitStr = 147, num = 10000}
local unitRule = {
[eLanguageType.EN_US] = {unitStr = 147, num = 1000}
}
local textWriterSpeed = {[eLanguageType.ZH_CN] = 1, [eLanguageType.ZH_TW] = 1, [eLanguageType.EN_US] = 1.5, [eLanguageType.JA_JP] = 1, [eLanguageType.KO_KR] = 1}
-- DECOMPILER ERROR at PC33: Confused about usage of register: R3 in 'UnsetPending'

LanguageUtil.GetWriterSpeed = function()
  -- function num : 0_1 , upvalues : _ENV, textWriterSpeed
  local languageInt = LanguageUtil.LanguageInt
  local speed = textWriterSpeed[languageInt] or 1
  return speed
end

-- DECOMPILER ERROR at PC36: Confused about usage of register: R3 in 'UnsetPending'

LanguageUtil.GetNum2UnitStr = function(num, n)
  -- function num : 0_2 , upvalues : _ENV, unitRule, defaultLanguageRule
  local finStr = ""
  local float = nil
  local languageInt = LanguageUtil.LanguageInt
  local rule = unitRule[languageInt]
  if rule == nil then
    rule = defaultLanguageRule
  end
  if rule.num <= num then
    float = GetPreciseDecimalStr(num / rule.num, n)
    finStr = float .. ConfigData:GetTipContent(rule.unitStr)
  else
    finStr = tostring(num)
  end
  return tostring(finStr)
end

local RomanNumber = {"I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X"}
-- DECOMPILER ERROR at PC51: Confused about usage of register: R4 in 'UnsetPending'

LanguageUtil.GetRomanNumber = function(number)
  -- function num : 0_3 , upvalues : RomanNumber, _ENV
  if not RomanNumber[number] then
    return tostring(number)
  end
end

-- DECOMPILER ERROR at PC56: Confused about usage of register: R4 in 'UnsetPending'

if IsInVerify then
  LanguageUtil.LanguageInt = 0
  IsInVerify = nil
else
  -- DECOMPILER ERROR at PC64: Confused about usage of register: R4 in 'UnsetPending'

  LanguageUtil.LanguageInt = ((CS.LanguageGlobal).GetLanguageInt)()
end

