-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHalloweenAchievementStar = class("UINHalloweenAchievementStar", UIBaseNode)
local base = UIBaseNode
UINHalloweenAchievementStar.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._starList = {(self.ui).img_star}
end

UINHalloweenAchievementStar.InitStarNum = function(self, star, num)
  -- function num : 0_1 , upvalues : _ENV
  local count = #self._starList
  for i = 1, count do
    local starItem = (self._starList)[i]
    starItem:SetActive(i <= star)
  end
  for i = count + 1, star do
    local starItem = ((self.ui).img_star):Instantiate()
    ;
    (table.insert)(self._starList, starItem)
    starItem:SetActive(true)
  end
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).text = tostring(num)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

return UINHalloweenAchievementStar

