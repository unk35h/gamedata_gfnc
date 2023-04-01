-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBattleDungeonLevelAutoStart = class("UINBattleDungeonLevelAutoStart", UIBaseNode)
local base = UIBaseNode
UINBattleDungeonLevelAutoStart.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Battle, self, self.OnClickConfirm)
  ;
  (UIUtil.AddValueChangedListener)((self.ui).slider, self, self.OnValueTimesChange)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Add, self, self.OnClickTimesAdd)
  ;
  (((self.ui).btn_Add).onPress):AddListener(BindCallback(self, self.OnClickTimesAdd))
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Sub, self, self.OnClickTimesReduce)
  ;
  (((self.ui).btn_Sub).onPress):AddListener(BindCallback(self, self.OnClickTimesReduce))
  self.__OnItemRefresh = BindCallback(self, self.OnItemRefresh)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__OnItemRefresh)
end

UINBattleDungeonLevelAutoStart.InitDunLevelAutoStart = function(self, dungeonLevelData, callback)
  -- function num : 0_1
  self.dungeonLevelData = dungeonLevelData
  self.callback = callback
  self:RefreshData()
  self:RefreshSlider()
end

UINBattleDungeonLevelAutoStart.RefreshData = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local ticketItemId = (self.dungeonLevelData):GetEnterLevelCost()
  self.ticketItemCount = PlayerDataCenter:GetItemCount(ticketItemId)
  self.ticketSingleCost = (self.dungeonLevelData):GetConsumeKeyNum()
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).img_Ticket).sprite = CRH:GetDefaultKeySprite(ticketItemId)
  local costItemCfg = (ConfigData.item)[ticketItemId]
  -- DECOMPILER ERROR at PC28: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_TicketName).text = (LanguageUtil.GetLocaleText)(costItemCfg.name)
  if self.ticketSingleCost > 0 then
    self.maxTimes = (math.floor)(self.ticketItemCount / self.ticketSingleCost)
    if not self.curTimes then
      self.curTimes = self.maxTimes
      if self.curTimes > self.maxTimes or not self.curTimes then
        self.curTimes = self.maxTimes
      end
    end
  end
end

UINBattleDungeonLevelAutoStart.RefreshSlider = function(self)
  -- function num : 0_3
  if self.maxTimes or 0 < 1 then
    ((self.ui).silderNode):SetActive(false)
    self:RefreshAutoStartUI()
    return 
  end
  local valueChange = false
  -- DECOMPILER ERROR at PC24: Confused about usage of register: R2 in 'UnsetPending'

  if ((self.ui).slider).maxValue ~= self.maxTimes then
    ((self.ui).slider).maxValue = self.maxTimes
  end
  -- DECOMPILER ERROR at PC32: Confused about usage of register: R2 in 'UnsetPending'

  if ((self.ui).slider).minValue ~= 1 then
    ((self.ui).slider).minValue = 1
  end
  -- DECOMPILER ERROR at PC42: Confused about usage of register: R2 in 'UnsetPending'

  if ((self.ui).slider).value ~= self.curTimes then
    ((self.ui).slider).value = self.curTimes
    valueChange = true
  end
  if not valueChange then
    self:RefreshAutoStartUI()
  end
end

UINBattleDungeonLevelAutoStart.RefreshAutoStartUI = function(self)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_BattleTimes).text = tostring((math.floor)(self.curTimes))
  -- DECOMPILER ERROR at PC14: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Before).text = tostring(self.ticketItemCount)
  -- DECOMPILER ERROR at PC27: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_After).text = tostring((math.floor)(self.ticketItemCount - self.curTimes * self.ticketSingleCost))
end

UINBattleDungeonLevelAutoStart.OnItemRefresh = function(self, itemUpdate)
  -- function num : 0_5 , upvalues : _ENV
  if itemUpdate[ConstGlobalItem.SKey] == nil then
    return 
  end
  self:RefreshData()
  self:RefreshSlider()
end

UINBattleDungeonLevelAutoStart.OnClickTimesAdd = function(self)
  -- function num : 0_6
  if self.maxTimes <= self.curTimes then
    return 
  end
  self.curTimes = self.curTimes + 1
  self:RefreshSlider()
end

UINBattleDungeonLevelAutoStart.OnClickTimesReduce = function(self)
  -- function num : 0_7
  if self.curTimes <= 1 then
    return 
  end
  self.curTimes = self.curTimes - 1
  self:RefreshSlider()
end

UINBattleDungeonLevelAutoStart.OnValueTimesChange = function(self, value)
  -- function num : 0_8 , upvalues : _ENV
  self.curTimes = (math.floor)(value)
  self:RefreshAutoStartUI()
end

UINBattleDungeonLevelAutoStart.OnClickConfirm = function(self)
  -- function num : 0_9
  if self.callback == nil then
    return 
  end
  ;
  (self.callback)(self.curTimes)
end

UINBattleDungeonLevelAutoStart.OnHide = function(self)
  -- function num : 0_10 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.UpdateItem, self.__OnItemRefresh)
  ;
  (base.OnHide)(self)
end

return UINBattleDungeonLevelAutoStart

