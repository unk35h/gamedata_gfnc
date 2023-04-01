-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBattleDungeonPlotAutoStart = class("UINBattleDungeonPlotAutoStart", UIBaseNode)
local base = UIBaseNode
UINBattleDungeonPlotAutoStart.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Battle, self, self.OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Add, self, self.OnClickTimesAdd)
  ;
  (((self.ui).btn_Add).onPress):AddListener(BindCallback(self, self.OnClickTimesAdd))
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Sub, self, self.OnClickTimesReduce)
  ;
  (((self.ui).btn_Sub).onPress):AddListener(BindCallback(self, self.OnClickTimesReduce))
  ;
  (UIUtil.AddValueChangedListener)((self.ui).slider, self, self.OnValueTimeChange)
  self.__OnBattleCountRefresh = BindCallback(self, self.OnBattleCountRefresh)
  MsgCenter:AddListener(eMsgEventId.OnBattleDungeonLimitChange, self.__OnBattleCountRefresh)
  self.__OnItemRefresh = BindCallback(self, self.OnItemRefresh)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__OnItemRefresh)
end

UINBattleDungeonPlotAutoStart.InitPlotAutoStart = function(self, dungeonStageData, callback)
  -- function num : 0_1 , upvalues : _ENV
  self.dungeonStageData = dungeonStageData
  self.dungeonStageCfg = dungeonStageData:GetDungeonStageCfg()
  self.heroData = ((self.dungeonStageData).dungeonData):GetDungeonHeroData()
  if self.heroData == nil then
    error("HeroData is NIL")
    return 
  end
  self.fragId = (self.heroData).fragId
  self.callback = callback
  local ticketID = ConstGlobalItem.SKey
  local costItemCfg = (ConfigData.item)[ticketID]
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_HeroIcon).sprite = CRH:GetSpriteByItemId(self.fragId)
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).img_Ticket).sprite = CRH:GetDefaultKeySprite(ticketID)
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_TicketName).text = (LanguageUtil.GetLocaleText)(costItemCfg.name)
  self:RefreshData()
  self:RefreshSlider()
  self:RefreshPlotCount()
end

UINBattleDungeonPlotAutoStart.RefreshData = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local index = (table.indexof)((self.dungeonStageCfg).cost_itemIds, ConstGlobalItem.SKey)
  self.sKeySingleCost = index > 0 and ((self.dungeonStageCfg).cost_itemNums)[index] or 0
  if self.sKeySingleCost <= 0 then
    error("sKey cost Error")
    return 
  end
  self.battleRemainTimes = nil
  local flag, autoLimitTimes = ((self.dungeonStageData).dungeonData):GetDungeonAutoBattleMaxLimit()
  if not flag then
    error("limit count is NIL")
    return 
  end
  self.battleRemainTimes = autoLimitTimes
  self.sKeyCount = PlayerDataCenter:GetItemCount(ConstGlobalItem.SKey)
  self.maxTimes = (math.min)(self.battleRemainTimes, (math.floor)(self.sKeyCount / self.sKeySingleCost))
  if self.curTimes == nil then
    self.curTimes = self.maxTimes
  end
  self.curTimes = (math.clamp)(self.curTimes, 0, self.maxTimes)
end

UINBattleDungeonPlotAutoStart.RefreshSlider = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if self.maxTimes or 0 < 1 then
    error("times is 0")
    return 
  end
  self.inSetSlider = true
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R1 in 'UnsetPending'

  if ((self.ui).slider).maxValue ~= self.maxTimes then
    ((self.ui).slider).maxValue = self.maxTimes
  end
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R1 in 'UnsetPending'

  if ((self.ui).slider).minValue ~= 1 then
    ((self.ui).slider).minValue = 1
  end
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R1 in 'UnsetPending'

  if ((self.ui).slider).value ~= self.curTimes then
    ((self.ui).slider).value = self.curTimes
  end
  self:RefreshUIShow()
  self.inSetSlider = false
end

UINBattleDungeonPlotAutoStart.RefreshUIShow = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self.curTimes == nil then
    return 
  end
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_BattleTimes).text = tostring(self.curTimes)
  -- DECOMPILER ERROR at PC15: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_SKey_Before).text = tostring(self.sKeyCount)
  -- DECOMPILER ERROR at PC25: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_SKey_After).text = tostring(self.sKeyCount - self.sKeySingleCost * self.curTimes)
  -- DECOMPILER ERROR at PC31: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_remain_Before).text = tostring(self.battleRemainTimes)
  -- DECOMPILER ERROR at PC39: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_remain_After).text = tostring(self.battleRemainTimes - self.curTimes)
end

UINBattleDungeonPlotAutoStart.RefreshPlotCount = function(self)
  -- function num : 0_5 , upvalues : _ENV
  if self.heroData == nil then
    return 
  end
  if (self.heroData):IsFullRank() then
    ((self.ui).tex_chip_count):SetIndex(1)
    return 
  end
  local needCount = (self.heroData):StarNeedFrag()
  local existCount = PlayerDataCenter:GetItemCount(self.fragId)
  ;
  ((self.ui).tex_chip_count):SetIndex(0, tostring(existCount), tostring(needCount))
end

UINBattleDungeonPlotAutoStart.OnClickTimesAdd = function(self)
  -- function num : 0_6
  if ((self.ui).slider).maxValue <= self.curTimes then
    return 
  end
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).slider).value = self.curTimes + 1
end

UINBattleDungeonPlotAutoStart.OnClickTimesReduce = function(self)
  -- function num : 0_7
  if self.curTimes <= ((self.ui).slider).minValue then
    return 
  end
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).slider).value = self.curTimes - 1
end

UINBattleDungeonPlotAutoStart.OnValueTimeChange = function(self, value)
  -- function num : 0_8 , upvalues : _ENV
  if self.inSetSlider then
    return 
  end
  self.curTimes = (math.floor)(value)
  self:RefreshUIShow()
end

UINBattleDungeonPlotAutoStart.OnClickConfirm = function(self)
  -- function num : 0_9
  if self.callback ~= nil then
    (self.callback)(self.curTimes)
  end
end

UINBattleDungeonPlotAutoStart.OnItemRefresh = function(self, itemUpdate)
  -- function num : 0_10 , upvalues : _ENV
  if itemUpdate[ConstGlobalItem.SKey] ~= nil then
    self:RefreshData()
    self:RefreshSlider()
  end
  if self.fragId ~= nil and itemUpdate[self.fragId] ~= nil then
    self:RefreshPlotCount()
  end
end

UINBattleDungeonPlotAutoStart.OnBattleCountRefresh = function(self)
  -- function num : 0_11
  self:RefreshData()
  self:RefreshSlider()
end

UINBattleDungeonPlotAutoStart.OnDelete = function(self)
  -- function num : 0_12 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.OnBattleDungeonLimitChange, self.__OnBattleCountRefresh)
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__OnItemRefresh)
  ;
  (base.OnDelete)(self)
end

return UINBattleDungeonPlotAutoStart

