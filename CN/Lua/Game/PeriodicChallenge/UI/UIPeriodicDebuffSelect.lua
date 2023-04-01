-- params : ...
-- function num : 0 , upvalues : _ENV
local UIPeriodicDebuffSelect = class("UIPeriodicDebuffSelect", UIBaseWindow)
local base = UIBaseWindow
local UINPeriodicDebuff = require("Game.PeriodicChallenge.UI.UINPeriodicDebuff")
local UINPeriodicDebuffTitle = require("Game.PeriodicChallenge.UI.UINPeriodicDebuffTitle")
local UINDungeonBuffItem = require("Game.CommonUI.DungeonState.UINDungeonBuffItem")
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
local HAType = FloatAlignEnum.HAType
local VAType = FloatAlignEnum.VAType
local cs_MessageCommon = CS.MessageCommon
UIPeriodicDebuffSelect.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINPeriodicDebuff, UINPeriodicDebuffTitle, UINDungeonBuffItem
  (UIUtil.AddButtonListener)((self.ui).btn_ClearAll, self, self.OnClickClear)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.OnClickConfirm)
  ;
  (UIUtil.SetTopStatus)(self, self.Delete)
  self.buffItemPool = (UIItemPool.New)(UINPeriodicDebuff, (self.ui).obj_debuffSelectItem)
  ;
  ((self.ui).obj_debuffSelectItem):SetActive(false)
  self.titleItemPool = (UIItemPool.New)(UINPeriodicDebuffTitle, (self.ui).obj_debuffTitle)
  ;
  ((self.ui).obj_debuffTitle):SetActive(false)
  self.buffIconPool = (UIItemPool.New)(UINDungeonBuffItem, (self.ui).img_BuffItem)
  ;
  ((self.ui).img_BuffItem):SetActive(false)
  self.resloader = ((CS.ResLoader).Create)()
  self.permillageLayer = 0
  self.__OnSelectTogAction = BindCallback(self, self.OnItemValueChange)
  self.__OnPressBuffItemAction = BindCallback(self, self.__OnPressBuffItem)
  self.__OnPressUpBuffItemAction = BindCallback(self, self.__OnPressUpBuffItem)
end

UIPeriodicDebuffSelect.InitDebuffSelect = function(self, fmtBuffSelectData, confirmFunc, closeCallback)
  -- function num : 0_1
  self.buffIdDic = fmtBuffSelectData:GetFmtAllBuff()
  self.fmtBuffSelectData = fmtBuffSelectData
  self.closeCallback = closeCallback
  self.confirmFunc = confirmFunc
  self:CreateDebuffGroupInfo()
  self:CreateDebuffSelectInfo(fmtBuffSelectData:GetFmtBuffSelect())
  self:CreateItemList()
  self:Refresh()
  ;
  ((self.ui).enemyPower):SetActive(fmtBuffSelectData:IsShowEmenyPowerInFmtBuff())
end

UIPeriodicDebuffSelect.CreateDebuffGroupInfo = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self._debuffGroupInfo = {
assis = {}
, 
normal = {}
, 
group = {}
}
  for buffId,_ in pairs(self.buffIdDic) do
    if (self.fmtBuffSelectData):IsFmtBuffAssis(buffId) then
      (table.insert)((self._debuffGroupInfo).assis, buffId)
    else
      local groupId = (self.fmtBuffSelectData):GetFmtBuffGroupId(buffId)
      if groupId == nil then
        (table.insert)((self._debuffGroupInfo).normal, buffId)
      else
        local groupDebuffList = ((self._debuffGroupInfo).group)[groupId]
        if groupDebuffList == nil then
          groupDebuffList = {}
          -- DECOMPILER ERROR at PC47: Confused about usage of register: R8 in 'UnsetPending'

          ;
          ((self._debuffGroupInfo).group)[groupId] = groupDebuffList
        end
        ;
        (table.insert)(groupDebuffList, buffId)
      end
    end
  end
  local Local_SortDebuff = function(list)
    -- function num : 0_2_0 , upvalues : _ENV, self
    (table.sort)(list, function(a, b)
      -- function num : 0_2_0_0 , upvalues : self
      local aPermillage = (self.buffIdDic)[a]
      local bPermillage = (self.buffIdDic)[b]
      if aPermillage >= bPermillage then
        do return aPermillage == bPermillage end
        do return a < b end
        -- DECOMPILER ERROR: 3 unprocessed JMP targets
      end
    end
)
  end

  Local_SortDebuff((self._debuffGroupInfo).assis)
  Local_SortDebuff((self._debuffGroupInfo).normal)
  for _,groupList in pairs((self._debuffGroupInfo).group) do
    Local_SortDebuff(groupList)
  end
end

UIPeriodicDebuffSelect.CreateDebuffSelectInfo = function(self, selectedBuffIds)
  -- function num : 0_3 , upvalues : _ENV
  self._debuffSelectInfo = {
selectedDic = {}
, selectedAssisBuffId = nil, 
selecedGroupDic = {}
}
  if selectedBuffIds == nil then
    return 
  end
  for _,buffId in ipairs(selectedBuffIds) do
    if (self.buffIdDic)[buffId] ~= nil then
      local isAssis = (self.fmtBuffSelectData):IsFmtBuffAssis(buffId)
      local groupId = (self.fmtBuffSelectData):GetFmtBuffGroupId(buffId)
      -- DECOMPILER ERROR at PC41: Confused about usage of register: R9 in 'UnsetPending'

      if (not isAssis or (self._debuffSelectInfo).selectedAssisBuffId == nil) and (groupId == nil or ((self._debuffSelectInfo).selecedGroupDic)[groupId] == nil) then
        ((self._debuffSelectInfo).selectedDic)[buffId] = true
        -- DECOMPILER ERROR at PC45: Confused about usage of register: R9 in 'UnsetPending'

        if isAssis then
          (self._debuffSelectInfo).selectedAssisBuffId = buffId
        end
        -- DECOMPILER ERROR at PC50: Confused about usage of register: R9 in 'UnsetPending'

        if groupId ~= nil then
          ((self._debuffSelectInfo).selecedGroupDic)[groupId] = buffId
        end
      end
    end
  end
end

UIPeriodicDebuffSelect.CreateItemList = function(self)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Title).text = (self.fmtBuffSelectData):GetFmtBuffTitle()
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Intro).text = (self.fmtBuffSelectData):GetFmtBuffIntro()
  ;
  (self.buffItemPool):HideAll()
  ;
  (self.titleItemPool):HideAll()
  for i,buffId in ipairs((self._debuffGroupInfo).assis) do
    local item = (self.buffItemPool):GetOne()
    item:InitDebuffItem(buffId, (self.buffIdDic)[buffId], self.__OnSelectTogAction, ((self._debuffSelectInfo).selectedDic)[buffId], self.resloader)
  end
  for i,buffId in ipairs((self._debuffGroupInfo).normal) do
    local item = (self.buffItemPool):GetOne()
    item:InitDebuffItem(buffId, (self.buffIdDic)[buffId], self.__OnSelectTogAction, ((self._debuffSelectInfo).selectedDic)[buffId], self.resloader)
  end
  for _,groupId in ipairs((self.fmtBuffSelectData):GetFmtBuffGroupOrder()) do
    local groupBuffList = ((self._debuffGroupInfo).group)[groupId]
    if groupBuffList ~= nil then
      local titleItem = (self.titleItemPool):GetOne()
      titleItem:SetDebuffTitle((self.fmtBuffSelectData):GetFmtBuffGroupName(groupId))
      for _,buffId in ipairs(groupBuffList) do
        local item = (self.buffItemPool):GetOne()
        item:InitDebuffItem(buffId, (self.buffIdDic)[buffId], self.__OnSelectTogAction, ((self._debuffSelectInfo).selectedDic)[buffId], self.resloader)
      end
    end
  end
end

UIPeriodicDebuffSelect.Refresh = function(self)
  -- function num : 0_5 , upvalues : _ENV
  (self.buffIconPool):HideAll()
  local permillageAll = 0
  for buffId,_ in pairs((self._debuffSelectInfo).selectedDic) do
    local buffCfg = (ConfigData.exploration_buff)[buffId]
    local item = (self.buffIconPool):GetOne()
    item:InitBuffOnlyWithCfg(buffCfg, self.__OnPressBuffItemAction, self.__OnPressUpBuffItemAction)
    permillageAll = permillageAll + (self.buffIdDic)[buffId]
  end
  ;
  ((self.ui).tex_BuffCount):SetIndex(0, tostring((table.count)((self._debuffSelectInfo).selectedDic)))
  -- DECOMPILER ERROR at PC47: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Gain).text = tostring((math.floor)((permillageAll) / 10)) .. "%"
  local layer = (math.floor)((permillageAll) / 100)
  if layer <= 0 or not layer then
    layer = 0
  end
  ;
  ((self.ui).tex_Layer):SetIndex(0, tostring(layer))
  self.permillageLayer = layer
  self.permillage = permillageAll
  local basePower = (self.fmtBuffSelectData):GetFmtBuffRecomPowerBase()
  local powerRate = (self.fmtBuffSelectData):GetFmtBuffRecomPowerRate()
  -- DECOMPILER ERROR at PC82: Confused about usage of register: R5 in 'UnsetPending'

  ;
  ((self.ui).tex_EnemyPower).text = tostring((self.fmtBuffSelectData):GetBuffEmenyPower(layer, 1))
  for _,item in ipairs((self.buffItemPool).listItem) do
    local selected = ((self._debuffSelectInfo).selectedDic)[item.buffId] ~= nil
    if selected then
      item:ChangeState(selected, false)
    else
      local isForbid = false
      if (self._debuffSelectInfo).selectedAssisBuffId ~= nil then
        isForbid = true
      else
        local groupId = (self.fmtBuffSelectData):GetFmtBuffGroupId(item.buffId)
        isForbid = ((self._debuffSelectInfo).selecedGroupDic)[groupId] ~= nil
      end
      item:ChangeState(selected, isForbid)
    end
  end
  local warningTipValue = (self.fmtBuffSelectData):GetBuffScoreWarningValue(1)
  ;
  ((self.ui).obj_Warning):SetActive(warningTipValue <= permillageAll)
  -- DECOMPILER ERROR: 7 unprocessed JMP targets
end

UIPeriodicDebuffSelect.OnClickClear = function(self)
  -- function num : 0_6
  self:__ClearSelectInfo()
  self:Refresh()
end

UIPeriodicDebuffSelect.OnClickConfirm = function(self)
  -- function num : 0_7 , upvalues : _ENV
  do
    if self.confirmFunc ~= nil then
      local selectedBuffIds = {}
      for buffId,_ in pairs((self._debuffSelectInfo).selectedDic) do
        (table.insert)(selectedBuffIds, buffId)
      end
      ;
      (self.confirmFunc)(selectedBuffIds)
    end
    if self.closeCallback ~= nil then
      (self.closeCallback)(self.permillageLayer)
    end
    ;
    (UIUtil.OnClickBack)()
  end
end

UIPeriodicDebuffSelect.OnItemValueChange = function(self, buffId, flag)
  -- function num : 0_8
  if flag then
    self:__SelectDebuff(buffId)
  else
    self:__CancleDebuff(buffId)
  end
  self:Refresh()
end

UIPeriodicDebuffSelect.__SelectDebuff = function(self, buffId)
  -- function num : 0_9 , upvalues : cs_MessageCommon, _ENV
  if ((self._debuffSelectInfo).selectedDic)[buffId] ~= nil then
    return 
  end
  if (self._debuffSelectInfo).selectedAssisBuffId ~= nil then
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(908))
    return 
  end
  local groupId = (self.fmtBuffSelectData):GetFmtBuffGroupId(buffId)
  do
    if groupId ~= nil and ((self._debuffSelectInfo).selecedGroupDic)[groupId] ~= nil then
      local lastSelect = ((self._debuffSelectInfo).selecedGroupDic)[groupId]
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self._debuffSelectInfo).selecedGroupDic)[groupId] = nil
      -- DECOMPILER ERROR at PC36: Confused about usage of register: R4 in 'UnsetPending'

      ;
      ((self._debuffSelectInfo).selectedDic)[lastSelect] = nil
    end
    if (self.fmtBuffSelectData):IsFmtBuffAssis(buffId) then
      self:__ClearSelectInfo()
      -- DECOMPILER ERROR at PC46: Confused about usage of register: R3 in 'UnsetPending'

      ;
      (self._debuffSelectInfo).selectedAssisBuffId = buffId
    end
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R3 in 'UnsetPending'

    if groupId ~= nil then
      ((self._debuffSelectInfo).selecedGroupDic)[groupId] = buffId
    end
    -- DECOMPILER ERROR at PC54: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self._debuffSelectInfo).selectedDic)[buffId] = true
  end
end

UIPeriodicDebuffSelect.__CancleDebuff = function(self, buffId)
  -- function num : 0_10
  if ((self._debuffSelectInfo).selectedDic)[buffId] == nil then
    return 
  end
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self._debuffSelectInfo).selectedDic)[buffId] = nil
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  if (self._debuffSelectInfo).selectedAssisBuffId ~= nil and (self.fmtBuffSelectData):IsFmtBuffAssis(buffId) then
    (self._debuffSelectInfo).selectedAssisBuffId = nil
  end
  local groupId = (self.fmtBuffSelectData):GetFmtBuffGroupId(buffId)
  -- DECOMPILER ERROR at PC29: Confused about usage of register: R3 in 'UnsetPending'

  if groupId ~= nil then
    ((self._debuffSelectInfo).selecedGroupDic)[groupId] = nil
  end
end

UIPeriodicDebuffSelect.__ClearSelectInfo = function(self)
  -- function num : 0_11
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  (self._debuffSelectInfo).selectedDic = {}
  -- DECOMPILER ERROR at PC4: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self._debuffSelectInfo).selectedAssisBuffId = nil
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R1 in 'UnsetPending'

  ;
  (self._debuffSelectInfo).selecedGroupDic = {}
end

UIPeriodicDebuffSelect.__OnPressBuffItem = function(self, buffItem, buffCfg)
  -- function num : 0_12 , upvalues : _ENV, HAType, VAType
  local win = UIManager:ShowWindow(UIWindowTypeID.FloatingFrame)
  win:SetTitleAndContext((LanguageUtil.GetLocaleText)(buffCfg.name), (LanguageUtil.GetLocaleText)(buffCfg.describe))
  win:FloatTo(buffItem.transform, HAType.autoCenter, VAType.down)
end

UIPeriodicDebuffSelect.__OnPressUpBuffItem = function(self)
  -- function num : 0_13 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.FloatingFrame)
  if win ~= nil then
    win:Hide()
    win:Clean3DModifier()
  end
end

UIPeriodicDebuffSelect.OnDelete = function(self)
  -- function num : 0_14 , upvalues : base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIPeriodicDebuffSelect

