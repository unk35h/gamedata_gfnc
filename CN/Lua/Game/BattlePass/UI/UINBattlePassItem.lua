-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBattlePassItem = class("UINBattlePassItem", UIBaseNode)
local base = UIBaseNode
local BattlePassEnum = require("Game.BattlePass.BattlePassEnum")
local UINBaseItemWithLock = require("Game.CommonUI.Item.UINBaseItemWithLock")
UINBattlePassItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithLock
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.__baseItemPool = (UIItemPool.New)(UINBaseItemWithLock, (self.ui).baseItem)
  ;
  ((self.ui).baseItem):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Base, self, self.OnBtnPassBaseClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Advance, self, self.OnBtnPassSeniorClicked)
  self._lastItemType = 0
end

UINBattlePassItem.InitBattlePassItem = function(self, passLevelCfg, passInfo, clickEvent)
  -- function num : 0_1
  self.passLevelCfg = passLevelCfg
  self.level = passLevelCfg.level
  self.passInfo = passInfo
  self.clickEvent = clickEvent
  if self._lastItemType ~= 0 then
    ((self.ui).obj_normal):SetActive(true)
    ;
    ((self.ui).spHolder):SetActive(false)
    self._lastItemType = 0
    self._spPassItem = nil
  end
  self:__InitPassItemUI(passLevelCfg)
end

UINBattlePassItem.InitBattlePassSepcItem = function(self, spItem)
  -- function num : 0_2 , upvalues : _ENV
  if self._lastItemType ~= 1 then
    ((self.ui).obj_normal):SetActive(false)
    ;
    ((self.ui).spHolder):SetActive(true)
    self._spPassItem = spItem
    ;
    (spItem.transform):SetParent(((self.ui).spHolder).transform)
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (spItem.transform).anchoredPosition = Vector2.zero
    self._lastItemType = 1
  end
end

UINBattlePassItem.InitBattlePassEmptyItem = function(self)
  -- function num : 0_3
  if self._lastItemType ~= 2 then
    ((self.ui).obj_normal):SetActive(false)
    ;
    ((self.ui).spHolder):SetActive(false)
    self._lastItemType = 2
  end
end

UINBattlePassItem.__InitPassItemUI = function(self, passLevelCfg)
  -- function num : 0_4 , upvalues : _ENV
  (self.__baseItemPool):HideAll()
  local basepacked, baselocked, baseEnable = self:__GetPassRewardStateBase(self.passInfo)
  local seniorpacked, seniorlocked, seniorEnable = self:__GetPassRewardStateSenior(self.passInfo)
  ;
  ((self.ui).obj_SeniorBlack):SetActive(not (self.passInfo).unlockSenior)
  ;
  ((self.ui).obj_DownArrow):SetActive((self.passInfo).unlockSenior)
  ;
  ((self.ui).baseReward):SetActive(baseEnable)
  ;
  ((self.ui).advReward):SetActive(seniorEnable)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).baseTouch).raycastTarget = baseEnable
  -- DECOMPILER ERROR at PC37: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).advTouch).raycastTarget = seniorEnable
  -- DECOMPILER ERROR at PC43: Confused about usage of register: R8 in 'UnsetPending'

  ;
  ((self.ui).tex_Level).text = tostring(passLevelCfg.level)
  ;
  ((self.ui).img_Line):SetActive(self.level <= (self.passInfo).level)
  ;
  ((self.ui).obj_Arrow):SetActive(self.level == (self.passInfo).level)
  -- DECOMPILER ERROR at PC83: Confused about usage of register: R8 in 'UnsetPending'

  if self.level ~= (self.passInfo).level or not Vector3.one then
    ((self.ui).obj_level).localScale = (Vector3.New)(0.78, 0.78, 0.78)
    -- DECOMPILER ERROR at PC96: Confused about usage of register: R8 in 'UnsetPending'

    if self.level < (math.min)((self.passInfo).level, (self.passInfo).maxlevel) then
      ((self.ui).img_LevelBar).fillAmount = 1
    else
      -- DECOMPILER ERROR at PC115: Confused about usage of register: R8 in 'UnsetPending'

      if self.level == (self.passInfo).level or self.level == (self.passInfo).maxlevel and (self.passInfo):IsPassFullLevel() then
        ((self.ui).img_LevelBar).fillAmount = 0.5
      else
        -- DECOMPILER ERROR at PC119: Confused about usage of register: R8 in 'UnsetPending'

        ((self.ui).img_LevelBar).fillAmount = 0
      end
    end
    -- DECOMPILER ERROR at PC127: Confused about usage of register: R8 in 'UnsetPending'

    if self.level == (self.passInfo).maxlevel then
      ((self.ui).img_bar).fillAmount = 0.5
    else
      -- DECOMPILER ERROR at PC131: Confused about usage of register: R8 in 'UnsetPending'

      ((self.ui).img_bar).fillAmount = 1
    end
    for index,itemId in pairs(passLevelCfg.base_item_ids) do
      local itemCount = (passLevelCfg.base_item_nums)[index]
      local itemCfg = (ConfigData.item)[itemId]
      if itemCfg == nil then
        error("item cfg is null,id:" .. tostring(itemId))
      else
        local baseItem = self:__CreatePassRewardItem(((self.ui).btn_Base).transform)
        baseItem:InitItemWithLock(itemCfg, itemCount, nil, basepacked, baselocked)
      end
    end
    for index,itemId in pairs(passLevelCfg.senior_item_ids) do
      local itemCount = (passLevelCfg.senior_item_nums)[index]
      local itemCfg = (ConfigData.item)[itemId]
      if itemCfg == nil then
        error("item cfg is null,id:" .. tostring(itemId))
      else
        local baseItem = self:__CreatePassRewardItem(((self.ui).btn_Advance).transform)
        baseItem:InitItemWithLock(itemCfg, itemCount, nil, seniorpacked, seniorlocked)
      end
    end
    ;
    (((self.ui).baseTouch).transform):SetAsLastSibling()
    ;
    (((self.ui).advTouch).transform):SetAsLastSibling()
    -- DECOMPILER ERROR: 14 unprocessed JMP targets
  end
end

UINBattlePassItem.UpdatePassItemUI = function(self, passInfo)
  -- function num : 0_5
  self:__InitPassItemUI(self.passLevelCfg)
end

UINBattlePassItem.__GetPassRewardStateBase = function(self, passInfo)
  -- function num : 0_6
  local basepacked = false
  local takenReward = (passInfo.taken)[self.level]
  if takenReward ~= nil and takenReward.base then
    basepacked = true
  end
  local baselocked = false
  if passInfo.level < self.level then
    baselocked = true
  end
  local baseEnable = (not basepacked and not baselocked)
  do return basepacked, baselocked, baseEnable end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINBattlePassItem.__GetPassRewardStateSenior = function(self, passInfo)
  -- function num : 0_7
  local unlockSenior = passInfo.unlockSenior
  local seniorpacked = false
  local takenReward = (passInfo.taken)[self.level]
  if takenReward ~= nil and takenReward.senior then
    seniorpacked = true
  end
  local seniorlocked = false
  if unlockSenior and passInfo.level < self.level then
    seniorlocked = true
  end
  local seniorEnable = unlockSenior and ((not seniorpacked and not seniorlocked))
  do return seniorpacked, seniorlocked, seniorEnable end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINBattlePassItem.__CreatePassRewardItem = function(self, parent)
  -- function num : 0_8 , upvalues : _ENV
  local baseItem = (self.__baseItemPool):GetOne()
  ;
  (baseItem.transform):SetParent(parent)
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (baseItem.transform).anchoredPosition3D = Vector3.zero
  return baseItem
end

UINBattlePassItem.OnBtnPassBaseClicked = function(self)
  -- function num : 0_9
  if self.clickEvent == nil then
    return 
  end
  local basepacked, baselocked, baseEnable = self:__GetPassRewardStateBase(self.passInfo)
  if baseEnable then
    (self.clickEvent)(self.level, false)
  end
end

UINBattlePassItem.OnBtnPassSeniorClicked = function(self)
  -- function num : 0_10
  if self.clickEvent == nil then
    return 
  end
  local seniorpacked, seniorlocked, seniorEnable = self:__GetPassRewardStateSenior(self.passInfo)
  if seniorEnable then
    (self.clickEvent)(self.level, true)
  end
end

UINBattlePassItem.OnDelete = function(self)
  -- function num : 0_11 , upvalues : base
  (base.OnDelete)(self)
end

return UINBattlePassItem

