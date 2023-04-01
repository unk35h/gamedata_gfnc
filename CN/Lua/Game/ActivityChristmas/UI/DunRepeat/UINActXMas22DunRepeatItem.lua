-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActXMas22DunRepeatItem = class("UIActXMas22DunRepeatItem", UIBaseNode)
local base = UIActXMas22DunRepeatItem
UIActXMas22DunRepeatItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).item, self, self.OnClickChallenge)
end

UIActXMas22DunRepeatItem.InitXMas22ChallengeItem = function(self, dungeonLevelData, callback)
  -- function num : 0_1
  self._dungeonLevelData = dungeonLevelData
  self._callback = callback
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = dungeonLevelData:GetDungeonLevelName()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Num).text = dungeonLevelData:GetDungeonIndex()
  self:__Refresh()
end

UIActXMas22DunRepeatItem.__Refresh = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local idx = (self._dungeonLevelData):GetDungeonIndex()
  if idx % 2 == 0 then
    (((self.ui).tex_kuang).transform):SetParent(((self.ui).textPosUp).transform)
  else
    ;
    (((self.ui).tex_kuang).transform):SetParent(((self.ui).textPosDown).transform)
  end
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (((self.ui).tex_kuang).transform).anchoredPosition = Vector2.zero
  local isLock = not (self._dungeonLevelData):GetIsLevelUnlock()
  ;
  ((self.ui).obj_Lock):SetActive(isLock)
  ;
  ((self.ui).img_icon):SetActive(not isLock)
  -- DECOMPILER ERROR at PC49: Confused about usage of register: R3 in 'UnsetPending'

  if isLock then
    ((self.ui).tex_Num).color = (self.ui).lockColor
    -- DECOMPILER ERROR at PC54: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_kuang).color = (self.ui).lockColor
    ;
    ((self.ui).obj_Clear):SetActive(false)
    return 
  else
    -- DECOMPILER ERROR at PC66: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_Num).color = (self.ui).unlockColor
    -- DECOMPILER ERROR at PC71: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).tex_kuang).color = (self.ui).unlockColor
  end
  local isComplect = PlayerDataCenter:GetTotalBattleTimes((self._dungeonLevelData):GetDungeonLevelStageId()) > 0
  ;
  ((self.ui).obj_Clear):SetActive(isComplect)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIActXMas22DunRepeatItem.OnClickChallenge = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)(self._dungeonLevelData)
  end
end

return UIActXMas22DunRepeatItem

