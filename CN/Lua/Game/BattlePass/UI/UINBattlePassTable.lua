-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBattlePassTable = class("UINBattlePassTable", UIBaseNode)
local base = UIBaseNode
local UINBattlePassItem = require("Game.BattlePass.UI.UINBattlePassItem")
local UINBattlePassLimitItem = require("Game.BattlePass.UI.UINBattlePassLimitItem")
local UINBattlePassTagItem = require("Game.BattlePass.UI.UINBattlePassTagItem")
local BattlePassEnum = require("Game.BattlePass.BattlePassEnum")
UINBattlePassTable.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBattlePassTagItem
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loopScrollRect).onInstantiateItem = BindCallback(self, self.__OnPassNewItem)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).loopScrollRect).onChangeItem = BindCallback(self, self.__OnPasItemChanged)
  ;
  (((self.ui).loopScrollRect).onValueChanged):AddListener(BindCallback(self, self.OnScrollValueChanged))
  self.__passItemDic = {}
  self.passTagItem = (UINBattlePassTagItem.New)()
  ;
  (self.passTagItem):Init((self.ui).tagBattlePassItem)
  self.passTagValueOffset = 0.5
  self.__OnBattlePassItemClicked = BindCallback(self, self.OnBattlePassItemClicked)
  self.__onLimitsItemClicked = BindCallback(self, self.OnBattlePassLimitItemClicked)
end

UINBattlePassTable.InitBattlePassTable = function(self, passInfo, overLimitReward)
  -- function num : 0_1 , upvalues : UINBattlePassLimitItem, _ENV
  self.passInfo = passInfo
  self._overLimitReward = overLimitReward or false
  if self._overLimitReward then
    if self.passLimitItem == nil then
      self.passLimitItem = (UINBattlePassLimitItem.New)()
      ;
      (self.passLimitItem):Init((self.ui).spBattlePassItem)
    end
    ;
    (self.passLimitItem):UpdatePassLimitItemUI(passInfo, self.__onLimitsItemClicked)
  end
  local baseItemWidth = ((self.ui).ly_battlePassItem).preferredWidth
  local itemSpaceWidth = ((self.ui).layout_rect).spacing
  local limitItemWidth = 0
  local limitItemCount = 0
  if self._overLimitReward then
    limitItemCount = 2
    limitItemWidth = (baseItemWidth + itemSpaceWidth) * limitItemCount
  end
  local baseItemTotalWidth = baseItemWidth * passInfo.maxlevel + (passInfo.maxlevel - 1) * itemSpaceWidth
  local totalWidth = baseItemTotalWidth + limitItemWidth
  local scrollWidth = ((((self.ui).loopScrollRect).transform).rect).width
  self.offsetRatio = scrollWidth / (totalWidth - scrollWidth)
  self.baseScrollRatioUint = (totalWidth - limitItemWidth) / (totalWidth - scrollWidth) / passInfo.maxlevel
  local defaultLevel = (self.passInfo):GetPassDefaultShowLevel()
  -- DECOMPILER ERROR at PC66: Confused about usage of register: R11 in 'UnsetPending'

  ;
  ((self.ui).loopScrollRect).totalCount = passInfo.maxlevel + limitItemCount
  ;
  ((self.ui).loopScrollRect):RefillCells((math.clamp)(defaultLevel - 2, 0, passInfo.maxlevel - 1 - limitItemCount))
  -- DECOMPILER ERROR at PC86: Confused about usage of register: R11 in 'UnsetPending'

  if (self.passInfo).maxlevel <= defaultLevel + 3 then
    ((self.ui).loopScrollRect).horizontalNormalizedPosition = 1
  end
  self:__OnPassTableValueChanged(((self.ui).loopScrollRect).horizontalNormalizedPosition)
end

UINBattlePassTable.UpdateBattlePassTable = function(self, passInfo)
  -- function num : 0_2
  ((self.ui).loopScrollRect):RefreshCells()
  if self.passLimitItem ~= nil then
    (self.passLimitItem):UpdatePassLimitItemUI(passInfo, self.__onLimitsItemClicked)
  end
  if (self.passTagItem).active then
    (self.passTagItem):UpdatePassItemUI(passInfo)
  end
end

UINBattlePassTable.__OnPassNewItem = function(self, go)
  -- function num : 0_3 , upvalues : UINBattlePassItem
  local passItem = (UINBattlePassItem.New)()
  passItem:Init(go)
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self.__passItemDic)[go] = passItem
end

UINBattlePassTable.__OnPasItemChanged = function(self, go, index)
  -- function num : 0_4 , upvalues : _ENV
  local passItem = (self.__passItemDic)[go]
  if passItem == nil then
    error("Can\'t find passItem by gameObject")
    return 
  end
  local level = index + 1
  do
    if (self.passInfo).maxlevel < level then
      local offset = level - (self.passInfo).maxlevel
      if offset == 1 then
        passItem:InitBattlePassSepcItem(self.passLimitItem)
      else
        passItem:InitBattlePassEmptyItem()
      end
      return 
    end
    local passLevelCfg = ((ConfigData.battlepass)[(self.passInfo).id])[level]
    if passLevelCfg == nil then
      error((string.format)("battle pass cfg is null,id:%d level:%d", passInfo.id, level))
      return 
    end
    passItem:InitBattlePassItem(passLevelCfg, self.passInfo, self.__OnBattlePassItemClicked)
  end
end

UINBattlePassTable.OnScrollValueChanged = function(self, vec2)
  -- function num : 0_5 , upvalues : _ENV
  local x = vec2.x
  if (math.abs)(self.__lastX - x) < 0.001 then
    return 
  end
  self:__OnPassTableValueChanged(x)
end

UINBattlePassTable.__OnPassTableValueChanged = function(self, x)
  -- function num : 0_6 , upvalues : _ENV
  self.__lastX = x
  local tag_level = ((ConfigData.battlepass).tag_levels)[(self.passInfo).id]
  local useLevel = tag_level[#tag_level]
  local offset = self.offsetRatio
  local level = (math.floor)((x + offset) / self.baseScrollRatioUint + self.passTagValueOffset)
  for i = 1, #tag_level do
    local cur_level = tag_level[i]
    if level < cur_level then
      useLevel = cur_level
      break
    end
  end
  do
    local finalLevel = tag_level[#tag_level]
    if useLevel == finalLevel and self._overLimitReward and finalLevel - 2 < level then
      useLevel = 0
    end
    if self.__lastTagLevel ~= useLevel then
      self:UpdatePassTagItem(useLevel)
    end
  end
end

UINBattlePassTable.UpdatePassTagItem = function(self, level)
  -- function num : 0_7 , upvalues : _ENV
  self.__lastTagLevel = level
  if level == 0 then
    (self.passTagItem):Hide()
    return 
  end
  local passLevelCfg = ((ConfigData.battlepass)[(self.passInfo).id])[level]
  if passLevelCfg == nil then
    error((string.format)("battle pass cfg is null,id:%d level:%d", (self.passInfo).id, level))
  end
  ;
  (self.passTagItem):InitBattlePassItem(passLevelCfg, self.passInfo)
  ;
  (self.passTagItem):Show()
end

UINBattlePassTable.LocationPassItemByLevel = function(self, level)
  -- function num : 0_8
end

UINBattlePassTable.OnBattlePassItemClicked = function(self, level, isSenior)
  -- function num : 0_9 , upvalues : _ENV, BattlePassEnum
  local battlepassCtrl = ControllerManager:GetController(ControllerTypeId.BattlePass, true)
  local takeway = (BattlePassEnum.TakeWay).Base
  if isSenior then
    takeway = (BattlePassEnum.TakeWay).Senior
  end
  battlepassCtrl:TakeBattlePassReward((self.passInfo).id, level, takeway)
end

UINBattlePassTable.OnBattlePassLimitItemClicked = function(self)
  -- function num : 0_10 , upvalues : _ENV, BattlePassEnum
  local battlepassCtrl = ControllerManager:GetController(ControllerTypeId.BattlePass, true)
  battlepassCtrl:TakeBattlePassReward((self.passInfo).id, 0, (BattlePassEnum.TakeWay).Overflow)
end

UINBattlePassTable.OnDelete = function(self)
  -- function num : 0_11 , upvalues : base
  (base.OnDelete)(self)
end

return UINBattlePassTable

