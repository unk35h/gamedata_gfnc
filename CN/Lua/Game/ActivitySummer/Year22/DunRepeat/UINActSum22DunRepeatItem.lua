-- params : ...
-- function num : 0 , upvalues : _ENV
local UINActSum22DunRepeatItem = class("UINActSum22DunRepeatItem", UIBaseNode)
local base = UINActSum22DunRepeatItem
UINActSum22DunRepeatItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).item, self, self.OnClickChallenge)
end

UINActSum22DunRepeatItem.InitSum22ChallengeItem = function(self, dungeonLevelData, callback)
  -- function num : 0_1 , upvalues : _ENV
  self._dungeonLevelData = dungeonLevelData
  self._callback = callback
  ;
  ((self.ui).tex_Stage):SetIndex(0, tostring(dungeonLevelData:GetDungeonIndex()))
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Name).text = dungeonLevelData:GetDungeonLevelName()
  self:__Refresh()
end

UINActSum22DunRepeatItem.__Refresh = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local isLock = not (self._dungeonLevelData):GetIsLevelUnlock()
  ;
  ((self.ui).obj_image):SetActive(not isLock)
  ;
  ((self.ui).lock):SetActive(isLock)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  if isLock then
    ((self.ui).img_Title).color = (self.ui).color_title_nor
    ;
    ((self.ui).img_Clear):SetActive(false)
    local color = ((self.ui).img_Bottom).color
    color.a = 0.1
    -- DECOMPILER ERROR at PC32: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_Bottom).color = color
    -- DECOMPILER ERROR at PC38: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (((self.ui).tex_Stage).text).color = (self.ui).color_title_nor
    -- DECOMPILER ERROR at PC43: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_Dot).color = (self.ui).color_title_nor
    return 
  end
  do
    local isComplect = PlayerDataCenter:GetTotalBattleTimes((self._dungeonLevelData):GetDungeonLevelStageId()) > 0
    ;
    ((self.ui).img_Clear):SetActive(isComplect)
    -- DECOMPILER ERROR at PC64: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.ui).img_Title).color = (self.ui).color_title_cpl
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
end

UINActSum22DunRepeatItem.OnClickChallenge = function(self)
  -- function num : 0_3
  if self._callback ~= nil then
    (self._callback)(self._dungeonLevelData)
  end
end

UINActSum22DunRepeatItem.OnClickSelectDungeon = function(self)
  -- function num : 0_4
  if self._callback ~= nil then
    (self._callback)(self._dungeonLevelData)
  end
end

UINActSum22DunRepeatItem.GetSum22ChallengeItemCanvasGroup = function(self)
  -- function num : 0_5
  return (self.ui).cvsGrp
end

return UINActSum22DunRepeatItem

