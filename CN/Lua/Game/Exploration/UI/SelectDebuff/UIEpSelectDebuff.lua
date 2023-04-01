-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEpSelectDebuff = class("UIEpSelectDebuff", UIBaseWindow)
local base = UIBaseWindow
local UINPeriodicDebuff = require("Game.PeriodicChallenge.UI.UINPeriodicDebuff")
local UINDungeonBuffItem = require("Game.CommonUI.DungeonState.UINDungeonBuffItem")
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
local HAType = FloatAlignEnum.HAType
local VAType = FloatAlignEnum.VAType
local ExplorationEnum = require("Game.Exploration.ExplorationEnum")
UIEpSelectDebuff.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINPeriodicDebuff, UINDungeonBuffItem
  self.resloader = ((CS.ResLoader).Create)()
  self.explorationNetworkCtrl = NetworkManager:GetNetwork(NetworkTypeID.Exploration)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Confirm, self, self.__OnClickConfirm)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Cancel, self, self.__OnClickCancle)
  self.selectBuffItemPool = (UIItemPool.New)(UINPeriodicDebuff, (self.ui).obj_debuffSelectItem)
  ;
  ((self.ui).obj_debuffSelectItem):SetActive(false)
  self.buffItemPool = (UIItemPool.New)(UINDungeonBuffItem, (self.ui).obj_BuffItem)
  ;
  ((self.ui).obj_BuffItem):SetActive(false)
  self.__OnItemValueChange = BindCallback(self, self.OnItemSelect)
  self.__onPressBuffItem = BindCallback(self, self.__OnPressBuffItem)
  self.__onPressUpBuffItem = BindCallback(self, self.__OnPressUpBuffItem)
  self.selectedBuffIdDic = nil
  self.effectBuffList = nil
end

UIEpSelectDebuff.InitEpSelectDebuff = function(self, dynPlayer, closeCallback)
  -- function num : 0_1 , upvalues : _ENV
  self.dynPlayer = dynPlayer
  self.buffIdDic = dynPlayer:GetEpDebuffSelectDic()
  self.closeCallback = closeCallback
  local wcData = (PlayerDataCenter.allWeeklyChallengeData):GetWeeklyChallengeDataByDungeonId(ExplorationManager:GetEpDungeonId())
  self._fmtBuffSelect = wcData:GetFmtBuffSelectData()
  self:RefreshMonsterLevel()
  self:RefreshCouldSelectBuff()
  self:RefreshCurrBuffList()
  self:RefreshEnemyBattlePow()
end

UIEpSelectDebuff.__OnClickConfirm = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.selectedBuffIdDic == nil or (table.count)(self.selectedBuffIdDic) <= 0 then
    self:__OnClickCancle()
    return 
  end
  ;
  (self.explorationNetworkCtrl):CS_WEEKLYCHALLENGE_SelectBuff(self.selectedBuffIdDic, function()
    -- function num : 0_2_0 , upvalues : self
    self:__OnClickCancle()
  end
)
end

UIEpSelectDebuff.__OnClickCancle = function(self)
  -- function num : 0_3 , upvalues : _ENV, ExplorationEnum
  (self.explorationNetworkCtrl):CS_WEEKLYCHALLENGE_SelectBuffExit(function()
    -- function num : 0_3_0 , upvalues : _ENV, ExplorationEnum, self
    MsgCenter:Broadcast(eMsgEventId.OnExitRoomComplete, (ExplorationEnum.eExitRoomCompleteType).SelectDebuff)
    self:Delete()
    if self.closeCallback ~= nil then
      (self.closeCallback)()
    end
  end
)
end

UIEpSelectDebuff.OnItemSelect = function(self, buffId, flag)
  -- function num : 0_4 , upvalues : _ENV
  -- DECOMPILER ERROR at PC7: Confused about usage of register: R3 in 'UnsetPending'

  if flag and not (self.selectedBuffIdDic)[buffId] then
    (self.selectedBuffIdDic)[buffId] = true
  else
    -- DECOMPILER ERROR at PC16: Confused about usage of register: R3 in 'UnsetPending'

    if not flag and (self.selectedBuffIdDic)[buffId] then
      (self.selectedBuffIdDic)[buffId] = nil
    end
  end
  for i,item in ipairs((self.selectBuffItemPool).listItem) do
    item:ChangeState((self.selectedBuffIdDic)[item.buffId], false)
  end
  self:RefreshBuffListWhenSelect(buffId, flag)
  self:RefreshEnemyBattlePow()
end

UIEpSelectDebuff.RefreshCouldSelectBuff = function(self)
  -- function num : 0_5 , upvalues : _ENV
  self.selectedBuffIdDic = {}
  local list = {}
  for buffId,permillage in pairs(self.buffIdDic) do
    (table.insert)(list, {buffId = buffId, permillage = permillage})
  end
  ;
  (table.sort)(list, function(a, b)
    -- function num : 0_5_0
    if a.permillage >= b.permillage then
      do return a.permillage == b.permillage end
      do return a.buffId < b.buffId end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  ;
  (self.selectBuffItemPool):HideAll()
  for i,buffData in ipairs(list) do
    local item = (self.selectBuffItemPool):GetOne(true)
    ;
    (item.gameObject):SetActive(true)
    item:InitDebuffItem(buffData.buffId, buffData.permillage, self.__OnItemValueChange, false, self.resloader)
  end
end

UIEpSelectDebuff.RefreshCurrBuffList = function(self)
  -- function num : 0_6 , upvalues : _ENV
  self.effectBuffList = {}
  ;
  (self.buffItemPool):HideAll()
  local epBuffList = (self.dynPlayer):GetEpBuffList()
  for index,dynBuff in ipairs(epBuffList) do
    if (self._fmtBuffSelect):IsFmtEffectBuff(dynBuff.dataId) then
      local item = (self.buffItemPool):GetOne()
      item:InitBuffByCfg(dynBuff, dynBuff:GetBuffCfg(), self.__onPressBuffItem, self.__onPressUpBuffItem)
      ;
      (table.insert)(self.effectBuffList, dynBuff.dataId)
    end
  end
  ;
  ((self.ui).tex_BuffCount):SetIndex(0, tostring(#self.effectBuffList))
end

UIEpSelectDebuff.RefreshBuffListWhenSelect = function(self, buffId, isSelect)
  -- function num : 0_7 , upvalues : _ENV
  if self.preSelectItemDic == nil then
    self.preSelectItemDic = {}
  end
  if isSelect then
    if self.preSelectItemDic ~= nil and (self.preSelectItemDic)[buffId] ~= nil then
      return 
    end
    local buffCfg = (ConfigData.exploration_buff)[buffId]
    local item = (self.buffItemPool):GetOne()
    item:InitBuffOnlyWithCfg(buffCfg, self.__onPressBuffItem, self.__onPressUpBuffItem)
    -- DECOMPILER ERROR at PC27: Confused about usage of register: R5 in 'UnsetPending'

    ;
    (self.preSelectItemDic)[buffId] = item
  else
    do
      if self.preSelectItemDic == nil or (self.preSelectItemDic)[buffId] == nil then
        return 
      end
      do
        local item = (self.preSelectItemDic)[buffId]
        ;
        (self.buffItemPool):HideOne(item)
        -- DECOMPILER ERROR at PC44: Confused about usage of register: R4 in 'UnsetPending'

        ;
        (self.preSelectItemDic)[buffId] = nil
        ;
        ((self.ui).tex_BuffCount):SetIndex(0, tostring(#self.effectBuffList + (table.count)(self.preSelectItemDic)))
      end
    end
  end
end

UIEpSelectDebuff.__OnPressBuffItem = function(self, buffItem, buffCfg)
  -- function num : 0_8 , upvalues : _ENV, HAType, VAType
  local win = UIManager:ShowWindow(UIWindowTypeID.FloatingFrame)
  win:SetTitleAndContext((LanguageUtil.GetLocaleText)(buffCfg.name), (LanguageUtil.GetLocaleText)(buffCfg.describe))
  win:FloatTo(buffItem.transform, HAType.autoCenter, VAType.down)
end

UIEpSelectDebuff.__OnPressUpBuffItem = function(self)
  -- function num : 0_9 , upvalues : _ENV
  local win = UIManager:GetWindow(UIWindowTypeID.FloatingFrame)
  if win ~= nil then
    win:Hide()
    win:Clean3DModifier()
  end
end

UIEpSelectDebuff.RefreshEnemyBattlePow = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local effectAll = 0
  if self._cacheEffect == nil then
    for _,buffId in ipairs(self.effectBuffList) do
      effectAll = effectAll + ((self._fmtBuffSelect):GetFmtBuffEffect(buffId) or 0)
    end
    self._cacheEffect = effectAll
  else
    effectAll = effectAll + self._cacheEffect
  end
  for buffId,_ in pairs(self.selectedBuffIdDic) do
    effectAll = effectAll + ((self._fmtBuffSelect):GetFmtBuffEffect(buffId) or 0)
  end
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Gain).text = tostring((math.floor)((effectAll) / 10)) .. "%"
  local logicLayer = (math.floor)((effectAll) / 100)
  local showLayer = (math.clamp)(logicLayer, 0, 100)
  ;
  ((self.ui).tex_Layer):SetIndex(0, tostring(showLayer))
  -- DECOMPILER ERROR at PC74: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_EnemyPower).text = tostring((self._fmtBuffSelect):GetBuffEmenyPower(logicLayer, self.realCurLevel))
  local warningTipValue = (self._fmtBuffSelect):GetBuffScoreWarningValue(self.realCurLevel)
  ;
  ((self.ui).obj_Warning):SetActive(warningTipValue <= effectAll)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UIEpSelectDebuff.RefreshMonsterLevel = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local monsterLvData = (self.dynPlayer):GetMonsterLevelData()
  local realCurLevel = monsterLvData.lv
  -- DECOMPILER ERROR at PC9: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_CurLevel).text = tostring(realCurLevel - 1)
  local monsterLevelCfgs = ExplorationManager:GetMonsterLevelCfgs()
  if monsterLevelCfgs == nil then
    error("monsterLevelCfgs is nil")
    return 
  end
  local maxLevel = monsterLevelCfgs.maxLevel
  if realCurLevel < maxLevel then
    ((self.ui).tex_NextLevel):SetIndex(0, tostring(realCurLevel))
  else
    ;
    ((self.ui).tex_NextLevel):SetIndex(1)
  end
  self.realCurLevel = realCurLevel
end

UIEpSelectDebuff.OnDelete = function(self)
  -- function num : 0_12 , upvalues : base
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (base.OnDelete)(self)
end

return UIEpSelectDebuff

