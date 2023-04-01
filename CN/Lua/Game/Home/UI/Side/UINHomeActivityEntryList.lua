-- params : ...
-- function num : 0 , upvalues : _ENV
local UINHomeActivityEntryList = class("UINHomeActivityEntryList", UIBaseNode)
local base = UIBaseNode
local UINSectorActivityEntry = require("Game.ActivityFrame.UI.UINSectorActivityEntry")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local JumpManager = require("Game.Jump.JumpManager")
local CS_ClientConsts = CS.ClientConsts
local cs_MessageCommon = CS.MessageCommon
UINHomeActivityEntryList.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINSectorActivityEntry, CS_ClientConsts
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.entryPool = (UIItemPool.New)(UINSectorActivityEntry, (self.ui).btn_Activity)
  ;
  ((self.ui).btn_Activity):SetActive(false)
  self.__LoopActivityEntryCallback = BindCallback(self, self.__LoopActivityEntry)
  ;
  ((self.ui).pageView_root):onPageIndexChanged("+", self.__LoopActivityEntryCallback)
  self.__ActivityChangeListenerEvent = BindCallback(self, self.__ActivityChangeListener)
  MsgCenter:AddListener(eMsgEventId.ActivityShowChange, self.__ActivityChangeListenerEvent)
  self.__OnActivityPreviewEvent = BindCallback(self, self.__ActivityPreviewListen)
  MsgCenter:AddListener(eMsgEventId.ActivityPreview, self.__OnActivityPreviewEvent)
  self.__OnSectorIActivityUnlockEvent = BindCallback(self, self.__OnSectorIActivityUnlock)
  MsgCenter:AddListener(eMsgEventId.SectorActivityUnlock, self.__OnSectorIActivityUnlockEvent)
  self.__OnHeroGrowActivityUnlockEvent = BindCallback(self, self.__OnHeroGrowActivityUnlock)
  MsgCenter:AddListener(eMsgEventId.HeroGrowActivityUnlock, self.__OnHeroGrowActivityUnlockEvent)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_OpenList, self, self.__OnClickOpen)
  self.resloader = ((CS.ResLoader).Create)()
  self.countSizeX = (((self.ui).count).sizeDelta).x
  self.countDefaultPos = ((self.ui).rect_CurrNum).anchoredPosition
  self.__OnClickEntryCallback = BindCallback(self, self.OnClickEntry)
  if not ((Consts.GameChannelType).IsInland)() and CS_ClientConsts.IsAudit then
    self:Hide()
  end
end

UINHomeActivityEntryList.BindingEntryCountChange = function(self, callback)
  -- function num : 0_1
  self._countChangeCallback = callback
end

UINHomeActivityEntryList.BingEntryJumpCallback = function(self, callback)
  -- function num : 0_2
  if callback == nil then
    self._jumpCallback = nil
    return 
  end
  self._jumpCallback = function(jumpFunc)
    -- function num : 0_2_0 , upvalues : callback
    callback()
    jumpFunc()
  end

end

UINHomeActivityEntryList.InitHomeActivityEntryList = function(self, enterWay)
  -- function num : 0_3 , upvalues : _ENV, JumpManager
  self._waitShowDic = {}
  self._waitOpenDic = {}
  self._activityItemDic = {}
  self._activityInfoList = {}
  self.enterWay = enterWay
  ;
  (self.entryPool):HideAll()
  local actFrameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  for id,cfg in pairs(ConfigData.activity_entrance) do
    if cfg.jump_id ~= (JumpManager.eJumpTarget).DynActivity then
      local item = (self.entryPool):GetOne()
      item:RefreshNoActivityBanner(cfg, self.resloader, self.__OnClickEntryCallback)
    else
      do
        local activityFrameId = (cfg.jump_arg)[1]
        local activityFrameInfo = actFrameCtrl:GetActivityFrameData(activityFrameId)
        -- DECOMPILER ERROR at PC53: Confused about usage of register: R10 in 'UnsetPending'

        if activityFrameInfo ~= nil and not activityFrameInfo:GetIsActivityFinished() then
          if not activityFrameInfo:GetCouldShowActivity() then
            (self._waitOpenDic)[activityFrameId] = activityFrameInfo
          else
            -- DECOMPILER ERROR at PC61: Confused about usage of register: R10 in 'UnsetPending'

            if not self:__CheckEntryOpen(activityFrameInfo) then
              (self._waitShowDic)[activityFrameId] = activityFrameInfo
            else
              local item = (self.entryPool):GetOne()
              item:RefreshSectorActivity(cfg, activityFrameInfo, self.resloader, self.__OnClickEntryCallback)
              -- DECOMPILER ERROR at PC73: Confused about usage of register: R11 in 'UnsetPending'

              ;
              (self._activityItemDic)[activityFrameId] = item
              ;
              (table.insert)(self._activityInfoList, {activityFrameId = activityFrameId, cfg = cfg, activityFrameInfo = activityFrameInfo})
            end
          end
        end
        do
          -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out DO_STMT

          -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_ELSE_STMT

          -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_STMT

        end
      end
    end
  end
  self:__RefreshPage()
  self:__RefreshBtnOpen()
end

UINHomeActivityEntryList.__TryShowActItem = function(self, activityFrameId)
  -- function num : 0_4 , upvalues : _ENV
  local actInfo = nil
  actInfo = (self._waitOpenDic)[activityFrameId]
  if actInfo == nil then
    actInfo = (self._waitShowDic)[activityFrameId]
    -- DECOMPILER ERROR at PC8: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._waitShowDic)[activityFrameId] = nil
  else
    -- DECOMPILER ERROR at PC11: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._waitOpenDic)[activityFrameId] = nil
  end
  if actInfo == nil then
    return 
  end
  -- DECOMPILER ERROR at PC21: Confused about usage of register: R3 in 'UnsetPending'

  if not self:__CheckEntryOpen(actInfo) then
    (self._waitShowDic)[activityFrameId] = actInfo
    return 
  end
  local item = (self.entryPool):GetOne()
  local cfgId = ((ConfigData.activity_entrance).activityIdDic)[activityFrameId]
  local cfg = (ConfigData.activity_entrance)[cfgId]
  item:RefreshSectorActivity(cfg, actInfo, self.resloader, self.__OnClickEntryCallback)
  ;
  (table.insert)(self._activityInfoList, {activityFrameId = activityFrameId, cfg = cfg, activityFrameInfo = actInfo})
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R6 in 'UnsetPending'

  ;
  (self._activityItemDic)[activityFrameId] = item
  self:__RefreshBtnOpen()
end

UINHomeActivityEntryList.__TryHideActItem = function(self, activityFrameId)
  -- function num : 0_5 , upvalues : _ENV
  -- DECOMPILER ERROR at PC1: Confused about usage of register: R2 in 'UnsetPending'

  (self._waitOpenDic)[activityFrameId] = nil
  -- DECOMPILER ERROR at PC3: Confused about usage of register: R2 in 'UnsetPending'

  ;
  (self._waitShowDic)[activityFrameId] = nil
  if (self._activityItemDic)[activityFrameId] == nil then
    return 
  end
  local item = (self._activityItemDic)[activityFrameId]
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  (self._activityItemDic)[activityFrameId] = nil
  for i,v in ipairs(self._activityInfoList) do
    if v.activityFrameId == activityFrameId then
      (table.remove)(self._activityInfoList, i)
      break
    end
  end
  do
    ;
    (self.entryPool):HideOne(item)
    self:__RefreshBtnOpen()
  end
end

UINHomeActivityEntryList.__OnClickOpen = function(self)
  -- function num : 0_6 , upvalues : _ENV
  local win = UIManager:ShowWindowAsync(UIWindowTypeID.ActEntrySpread, function(win)
    -- function num : 0_6_0 , upvalues : self
    win:SetActEntrySpreadProperty(self._activityInfoList, self.resloader, self.__OnClickEntryCallback, self.enterWay, (self.ui).pageView_root)
  end
)
end

UINHomeActivityEntryList.__RefreshBtnOpen = function(self)
  -- function num : 0_7
  if #self._activityInfoList >= 2 then
    (((self.ui).btn_OpenList).gameObject):SetActive(true)
  else
    ;
    (((self.ui).btn_OpenList).gameObject):SetActive(false)
  end
end

UINHomeActivityEntryList.__CheckEntryOpen = function(self, activityFrameInfo)
  -- function num : 0_8 , upvalues : ActivityFrameEnum, _ENV
  local actCat = activityFrameInfo:GetActivityFrameCat()
  if actCat == (ActivityFrameEnum.eActivityType).SectorI and not (PlayerDataCenter.allActivitySectorIData):IsOpenSectorIEntrance() then
    return false
  else
    if actCat == (ActivityFrameEnum.eActivityType).HeroGrow and not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_HeroActivity) then
      return false
    end
  end
  return true
end

UINHomeActivityEntryList.__LoopActivityEntry = function(self, index)
  -- function num : 0_9 , upvalues : _ENV
  -- DECOMPILER ERROR at PC17: Confused about usage of register: R2 in 'UnsetPending'

  if #(self.entryPool).listItem > 0 then
    ((self.ui).rect_CurrNum).anchoredPosition = (Vector2.New)((self.countDefaultPos).x + self.countSizeX * index, (self.countDefaultPos).y)
  end
end

UINHomeActivityEntryList.__RefreshPage = function(self)
  -- function num : 0_10 , upvalues : _ENV
  local totalCount = #(self.entryPool).listItem
  local canScroll = totalCount > 1
  ;
  (((self.ui).count).gameObject):SetActive(canScroll)
  ;
  ((self.ui).pageView_root):InitPosList(totalCount)
  ;
  ((self.ui).pageView_root):SetPageIndexImmediate(0)
  -- DECOMPILER ERROR at PC34: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).count).sizeDelta = (Vector2.New)(self.countSizeX * totalCount, (((self.ui).count).sizeDelta).y)
  -- DECOMPILER ERROR at PC38: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).rect_CurrNum).anchoredPosition = self.countDefaultPos
  if self._countChangeCallback ~= nil then
    (self._countChangeCallback)(totalCount)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UINHomeActivityEntryList.__ActivityChangeListener = function(self, list, isopen)
  -- function num : 0_11 , upvalues : _ENV
  if isopen then
    for i,frameId in ipairs(list) do
      self:__TryShowActItem(frameId)
    end
  else
    do
      for i,frameId in ipairs(list) do
        self:__TryHideActItem(frameId)
      end
      do
        self:__RefreshPage()
      end
    end
  end
end

UINHomeActivityEntryList.__ActivityPreviewListen = function(self, list)
  -- function num : 0_12 , upvalues : _ENV
  for i,frameId in ipairs(list) do
    self:__TryShowActItem(frameId)
  end
end

UINHomeActivityEntryList.__OnSectorIActivityUnlock = function(self)
  -- function num : 0_13 , upvalues : _ENV, ActivityFrameEnum
  for k,actInfo in pairs(self._waitShowDic) do
    if actInfo:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).SectorI then
      self:__TryShowActItem(k)
    end
  end
  self:__RefreshPage()
end

UINHomeActivityEntryList.__OnHeroGrowActivityUnlock = function(self)
  -- function num : 0_14 , upvalues : _ENV, ActivityFrameEnum
  for k,actInfo in pairs(self._waitShowDic) do
    if actInfo:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).HeroGrow then
      self:__TryShowActItem(k)
    end
  end
  self:__RefreshPage()
end

UINHomeActivityEntryList.OnClickEntry = function(self, entryCfg)
  -- function num : 0_15 , upvalues : JumpManager, cs_MessageCommon, _ENV
  if entryCfg == nil then
    return 
  end
  local couldJump = JumpManager:ValidateJump(entryCfg.jump_id, entryCfg.jump_arg)
  if couldJump then
    JumpManager:Jump(entryCfg.jump_id, self._jumpCallback, nil, entryCfg.jump_arg)
  else
    ;
    (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(6033))
  end
end

UINHomeActivityEntryList.OnDelete = function(self)
  -- function num : 0_16 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.ActivityShowChange, self.__ActivityChangeListenerEvent)
  MsgCenter:RemoveListener(eMsgEventId.ActivityPreview, self.__OnActivityPreviewEvent)
  MsgCenter:RemoveListener(eMsgEventId.SectorActivityUnlock, self.__OnSectorIActivityUnlockEvent)
  MsgCenter:RemoveListener(eMsgEventId.HeroGrowActivityUnlock, self.__OnHeroGrowActivityUnlockEvent)
  self._countChangeCallback = nil
  self._jumpCallback = nil
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  ;
  (self.entryPool):DeleteAll()
  ;
  (base.OnDelete)(self)
end

return UINHomeActivityEntryList

