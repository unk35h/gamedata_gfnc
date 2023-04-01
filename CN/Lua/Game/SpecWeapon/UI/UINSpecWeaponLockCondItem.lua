-- params : ...
-- function num : 0 , upvalues : _ENV
local UINSpecWeaponLockCondItem = class("UINSpecWeaponLockCondItem", UIBaseNode)
local base = UIBaseNode
local CheckerTypeId, _ = (table.unpack)(require("Game.Common.CheckCondition.CheckerGlobalConfig"))
local titleMapping = {[CheckerTypeId.HeroLevel] = 0, [CheckerTypeId.MinHeroStar] = 1, [CheckerTypeId.FrienshipLevel] = 2}
UINSpecWeaponLockCondItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self._starList = {}
  ;
  (table.insert)(self._starList, (self.ui).star)
end

UINSpecWeaponLockCondItem.InitLockCond = function(self, condId, condPara1, condPara2)
  -- function num : 0_1 , upvalues : titleMapping, _ENV, CheckerTypeId
  local index = titleMapping[condId]
  if index == nil then
    if isGameDev then
      error("condition title nil " .. tostring(condId))
    end
    return 
  end
  ;
  ((self.ui).tex_Title):SetIndex(index)
  local condValMapping = {[CheckerTypeId.HeroLevel] = self.__SetLv, [CheckerTypeId.MinHeroStar] = self.__SetStar, [CheckerTypeId.FrienshipLevel] = self.__SetLv}
  local func = condValMapping[condId]
  if func == nil then
    if isGameDev then
      error("condition func nil " .. tostring(condId))
    end
    return 
  end
  func(self, condPara1, condPara2)
end

UINSpecWeaponLockCondItem.SetLockCondColor = function(self, color)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).img_root).color = color
end

UINSpecWeaponLockCondItem.__SetStar = function(self, condPara1, condPara2)
  -- function num : 0_3 , upvalues : _ENV
  (((self.ui).text_Level).gameObject):SetActive(false)
  ;
  ((self.ui).starsGroup):SetActive(true)
  for i,v in ipairs(self._starList) do
    v:SetActive(false)
  end
  local count = condPara2 // 2
  local hasHalf = condPara2 % 2
  for i,v in ipairs(self._starList) do
    if i <= count then
      v:SetActive(true)
    else
      v:SetActive(false)
    end
  end
  for i = #self._starList + 1, count do
    local star = ((self.ui).star):Instantiate((((self.ui).star).transform).parent)
    star:SetActive(true)
    ;
    (table.insert)(self._starList, star)
  end
  ;
  ((self.ui).half_Star):SetActive(hasHalf > 0)
  ;
  (((self.ui).half_Star).transform):SetAsLastSibling()
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINSpecWeaponLockCondItem.__SetLv = function(self, condPara1, condPara2)
  -- function num : 0_4 , upvalues : _ENV
  ((self.ui).starsGroup):SetActive(false)
  ;
  (((self.ui).text_Level).gameObject):SetActive(true)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).text_Level).text = "LV." .. tostring(condPara2)
end

return UINSpecWeaponLockCondItem

