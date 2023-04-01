-- params : ...
-- function num : 0 , upvalues : _ENV
local CheckerPlayerReturn = {}
CheckerPlayerReturn.LengthCheck = function(param)
  -- function num : 0_0
  do return #param >= 3 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CheckerPlayerReturn.ParamsCheck = function(param)
  -- function num : 0_1 , upvalues : _ENV
  local returnTm = (PlayerDataCenter.inforData):GetReturnTime()
  if returnTm == 0 or PlayerDataCenter.timestamp < returnTm then
    return false
  end
  local diffTime = PlayerDataCenter.timestamp - returnTm
  do return param[2] <= diffTime and diffTime <= param[3] or param[3] == -1 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

CheckerPlayerReturn.GetUnlockInfo = function(param)
  -- function num : 0_2
  return ""
end

return CheckerPlayerReturn

