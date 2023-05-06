-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerLastLoginBefore = {}
CheckerLastLoginBefore.LengthCheck = function(param)
  -- function num : 0_0
  if #param >= 2 then
    return true
  end
  return false
end

CheckerLastLoginBefore.ParamsCheck = function(param)
  -- function num : 0_1
  return true
end

CheckerLastLoginBefore.GetUnlockInfo = function(param)
  -- function num : 0_2
  return ""
end

return CheckerLastLoginBefore

