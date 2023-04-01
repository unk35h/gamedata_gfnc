-- params : ...
-- function num : 0 , upvalues : _ENV
local HeroListStateEnum = {}
HeroListStateEnum.eHeroListFlag = {none = 0, showLocked = 1, showFavor = 2, editorFavor = 4}
HeroListStateEnum.isHaveFlag = function(flag, enum)
  -- function num : 0_0
  if flag == nil or enum == nil then
    return false
  end
  do return flag & enum > 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return HeroListStateEnum

