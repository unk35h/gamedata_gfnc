-- params : ...
-- function num : 0 , upvalues : _ENV
local UINDunTowerRacingItem = class("UINDunTowerRacingItem", UIBaseNode)
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
UINDunTowerRacingItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Receive, self, self._BtnPickClicked)
  self.rewardItemPool = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).uINBaseItem, false)
end

UINDunTowerRacingItem.InitRacintTaskItem = function(self, racingCfg, isPicked, achieve, pickAction)
  -- function num : 0_1 , upvalues : _ENV
  self._racingCfg = racingCfg
  self._enablePick = (not isPicked and achieve)
  self._pickAction = pickAction
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).btn_Receive).enabled = self._enablePick
  local tindex, color = nil, nil
  if isPicked then
    tindex = 2
    color = (self.ui).col_piacked
  elseif achieve then
    tindex = 0
    color = (self.ui).col_enablePick
  else
    tindex = 1
    color = (self.ui).col_incomplete
  end
  ;
  ((self.ui).tex_Receive):SetIndex(tindex)
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).img_Bottom).color = color
  ;
  ((self.ui).tex_Des):SetIndex(0, TimeUtil:TimestampToTime(racingCfg.time_limit))
  ;
  (self.rewardItemPool):HideAll()
  for index,itemId in pairs((self._racingCfg).reward_ids) do
    local count = ((self._racingCfg).reward_nums)[index]
    local rewardItem = (self.rewardItemPool):GetOne()
    local itemCfg = (ConfigData.item)[itemId]
    rewardItem:InitItemWithCount(itemCfg, count)
    rewardItem:SetPickedUIActive(isPicked)
  end
  -- DECOMPILER ERROR: 6 unprocessed JMP targets
end

UINDunTowerRacingItem._BtnPickClicked = function(self)
  -- function num : 0_2
  if not self._enablePick then
    return 
  end
  if self._pickAction ~= nil then
    (self._pickAction)(self._racingCfg, self)
  end
end

return UINDunTowerRacingItem

