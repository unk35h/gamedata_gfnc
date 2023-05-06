-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEventComebackMain = class("UIEventComebackMain", UIBaseWindow)
local base = UIBaseWindow
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local UINActivityComebackTap = require("Game.ActivityComeback.UI.UINActivityComebackTap")
local ActivityUIType = {ComebackSign = 1, ComebackFund = 2, ComebackTask = 3, ComebackExchage = 4, ComebackShop = 5}
local ActivityPanemParam = {
[ActivityUIType.ComebackSign] = {UIName = "UI_EventComebackSignNode", InitFunction = "InitCombackSingIn", UITable = "Game.ActivityComeback.UI.UINEventComebackSignIn"}
, 
[ActivityUIType.ComebackFund] = {UIName = "UI_EventComebackGrowNode", InitFunction = "InitCombackFund", UITable = "Game.ActivityComeback.UI.UINEventComebackFund"}
, 
[ActivityUIType.ComebackTask] = {UIName = "UI_EventComebackTaskNode", InitFunction = "InitCombackTask", UITable = "Game.ActivityComeback.UI.UINEventComebackTask"}
, 
[ActivityUIType.ComebackExchage] = {UIName = "UI_EventComebackExchangeNode", InitFunction = "InitComebackExchange", UITable = "Game.ActivityComeback.UI.UINEventComebackExchange"}
, 
[ActivityUIType.ComebackShop] = {UIName = "UI_EventComebackShopNode", InitFunction = "InitComebackShop", UITable = "Game.ActivityComeback.UI.UINEventComebackShop"}
}
UIEventComebackMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActivityComebackTap
  (UIUtil.SetTopStatus)(self, self.__OnClickBack)
  self._tapPool = (UIItemPool.New)(UINActivityComebackTap, (self.ui).pageItem)
  ;
  ((self.ui).pageItem):SetActive(false)
  self.__ClickTapFunc = BindCallback(self, self.__ClickTap)
  self._resloader = ((CS.ResLoader).Create)()
  self._waitLoadingTable = {}
end

UIEventComebackMain.InitActivityCombackMain = function(self, activityId)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  self._activityCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  local activityDataDic = (self._activityCtrl):GetShowByEnterType((ActivityFrameEnum.eActivityEnterType).Comeback)
  ;
  (self._tapPool):HideAll()
  local list = {}
  for activityId,activityFrameData in pairs(activityDataDic) do
    (table.insert)(list, activityFrameData)
  end
  ;
  (table.sort)(list, function(a, b)
    -- function num : 0_1_0
    if a.order >= b.order then
      do return a.order == b.order end
      do return a:GetActivityFrameId() < b:GetActivityFrameId() end
      -- DECOMPILER ERROR: 3 unprocessed JMP targets
    end
  end
)
  if #list == 0 then
    error("回归活动没有内容")
    return 
  end
  self:__ActivityParamDeal(list)
  local comebackCtrl = ControllerManager:GetController(ControllerTypeId.ActivityComeback)
  local comebackData = comebackCtrl:GetTheLatestComebackData()
  local comebackCfg = comebackData:GetComebackCfg()
  self._showItemIds = comebackCfg.showitem_id
  local selectActFrameData = nil
  for i,actData in ipairs(list) do
    if actData:GetActivityFrameCat() ~= (ActivityFrameEnum.eActivityType).Comeback or comebackCfg.inPage ~= 0 then
      local item = (self._tapPool):GetOne()
      item:InitActivityCombackTap(actData, self.__ClickTapFunc, self._resloader)
      local isSelect = actData:GetActivityFrameId() == activityId
      item:RefreshCombackTapSelect(isSelect)
      if isSelect then
        selectActFrameData = actData
      end
    end
  end
  if selectActFrameData == nil then
    selectActFrameData = (((self._tapPool).listItem)[1]):GetActivityCombackData()
  end
  self:__ClickTap(selectActFrameData)
  self._finishTime = selectActFrameData.destoryTime
  self._timerId = TimerManager:StartTimer(1, self.__CutDown, self)
  self:__CutDown()
  self:__SetReddotListener()
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIEventComebackMain.__ActivityParamDeal = function(self, activityList)
  -- function num : 0_2 , upvalues : _ENV, ActivityFrameEnum, ActivityUIType
  self._activityUItype = {}
  self._activityUIEntity = {}
  for _,actFrameData in ipairs(activityList) do
    local UIType = nil
    if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).SevenDayLogin then
      UIType = ActivityUIType.ComebackSign
    else
      if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).BattlePass then
        UIType = ActivityUIType.ComebackFund
      else
        if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).Task then
          UIType = ActivityUIType.ComebackTask
        else
          if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).Round then
            UIType = ActivityUIType.ComebackExchage
          else
            if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).Comeback then
              UIType = ActivityUIType.ComebackShop
              self:__RecordAvg(actFrameData)
              local activityCfg = (ConfigData.activity)[actFrameData:GetActivityFrameId()]
              do
                if activityCfg ~= nil and activityCfg.rule_id > 0 then
                  (UIUtil.SetTopStateInfoFunc)(self, function()
    -- function num : 0_2_0 , upvalues : _ENV, activityCfg
    UIManager:CreateWindowAsync(UIWindowTypeID.CommonRuleInfo, function(window)
      -- function num : 0_2_0_0 , upvalues : activityCfg
      if window == nil then
        return 
      end
      window:InitCommonRule(activityCfg.rule_id)
    end
)
  end
)
                end
              end
            else
              do
                error("活动没有面板 " .. tostring(actFrameData:GetActivityFrameId()))
                do
                  if UIType ~= nil then
                    local frameId = actFrameData:GetActivityFrameId()
                    -- DECOMPILER ERROR at PC81: Confused about usage of register: R9 in 'UnsetPending'

                    ;
                    (self._activityUItype)[frameId] = UIType
                  end
                  -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out DO_STMT

                  -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                  -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_STMT

                  -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                  -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_STMT

                  -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                  -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_STMT

                  -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                  -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_STMT

                  -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                  -- DECOMPILER ERROR at PC82: LeaveBlock: unexpected jumping out IF_STMT

                end
              end
            end
          end
        end
      end
    end
  end
end

UIEventComebackMain.__ClickTap = function(self, activityData)
  -- function num : 0_3 , upvalues : _ENV, ActivityPanemParam, ActivityUIType
  if activityData == nil then
    return 
  end
  local frameId = activityData:GetActivityFrameId()
  if (self._activityUItype)[frameId] == nil then
    return 
  end
  if self._selectActData ~= nil then
    local uiType = (self._activityUItype)[(self._selectActData):GetActivityFrameId()]
    local entity = (self._activityUIEntity)[uiType]
    if entity ~= nil then
      entity:Hide()
    end
  end
  do
    self._selectActData = activityData
    for _,tap in ipairs((self._tapPool).listItem) do
      local actData = tap:GetActivityCombackData()
      if actData:GetActivityFrameId() ~= frameId then
        do
          do
            local isSelect = actData == nil
            tap:RefreshCombackTapSelect(isSelect)
            tap:RefreshCombackTapSelect(false)
            -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out DO_STMT

            -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC47: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
    local uiType = (self._activityUItype)[frameId]
    local entity = (self._activityUIEntity)[uiType]
    local panelParam = ActivityPanemParam[uiType]
    if uiType == ActivityUIType.ComebackFund then
      (UIUtil.RefreshTopResId)(nil)
    else
      (UIUtil.RefreshTopResId)(self._showItemIds)
    end
    if entity ~= nil then
      entity:Show()
      ;
      (entity[panelParam.InitFunction])(entity, activityData:GetActId())
    else
      -- DECOMPILER ERROR at PC82: Confused about usage of register: R6 in 'UnsetPending'

      if not (self._waitLoadingTable)[uiType] then
        (self._waitLoadingTable)[uiType] = true
        ;
        (self._resloader):LoadABAssetAsync(PathConsts:GetActivityComebackPrefab(panelParam.UIName), function(prefab)
    -- function num : 0_3_0 , upvalues : _ENV, self, panelParam, uiType, activityData, ActivityUIType
    if IsNull(self.transform) or IsNull(prefab) then
      return 
    end
    local obj = prefab:Instantiate(((self.ui).frameHolder).transform)
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (obj.transform).localPosition = Vector3.zero
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (obj.transform).localScale = Vector3.one
    local newEntity = ((require(panelParam.UITable)).New)()
    -- DECOMPILER ERROR at PC31: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._activityUIEntity)[uiType] = newEntity
    -- DECOMPILER ERROR at PC34: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self._waitLoadingTable)[uiType] = nil
    newEntity:Init(obj)
    local isNeedShow = activityData == self._selectActData
    if isNeedShow then
      (newEntity[panelParam.InitFunction])(newEntity, activityData:GetActId())
    else
      newEntity:Hide()
    end
    if uiType == ActivityUIType.ComebackSign then
      if self.__PlayAvgCallback == nil then
        self.__PlayAvgCallback = BindCallback(self, self.__PlayAvg)
      end
      newEntity:SetPlayComebackAvg(self.__PlayAvgCallback)
    end
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
)
      end
    end
    -- DECOMPILER ERROR: 7 unprocessed JMP targets
  end
end

UIEventComebackMain.__CutDown = function(self)
  -- function num : 0_4 , upvalues : _ENV
  if self._finishTime == -1 then
    if self._timerId ~= nil then
      TimerManager:StopTimer(self._timerId)
      self._timerId = nil
    end
    ;
    ((self.ui).tex_Time):SetIndex(2, "0")
    return 
  end
  local diff = self._finishTime - PlayerDataCenter.timestamp
  if diff <= 0 then
    if self._timerId ~= nil then
      TimerManager:StopTimer(self._timerId)
      self._timerId = nil
    end
    ;
    ((self.ui).tex_Time):SetIndex(2, "0")
    ;
    (UIUtil.OnClickBackByUiTab)(self)
    return 
  end
  if diff < 60 then
    ((self.ui).tex_Time):SetIndex(2, "0")
  else
    if diff < 3600 then
      ((self.ui).tex_Time):SetIndex(2, tostring((math.floor)(diff // 60)))
    else
      if diff < 86400 then
        ((self.ui).tex_Time):SetIndex(1, tostring((math.floor)(diff // 3600)))
      else
        ;
        ((self.ui).tex_Time):SetIndex(0, tostring((math.floor)(diff // 86400)))
      end
    end
  end
end

UIEventComebackMain.__RecordAvg = function(self, actFrameData)
  -- function num : 0_5 , upvalues : _ENV
  local comebackCtrl = ControllerManager:GetController(ControllerTypeId.ActivityComeback)
  if comebackCtrl == nil then
    return 
  end
  local comebackData = comebackCtrl:GetComebackData(actFrameData:GetActId())
  if comebackData == nil then
    return 
  end
  self._avgId = comebackData:GetComebackAvgId()
  local comebackCfg = comebackData:GetComebackCfg()
  self._showItemIds = comebackCfg.showitem_id
end

UIEventComebackMain.__PlayAvg = function(self)
  -- function num : 0_6 , upvalues : _ENV
  if self._avgId == nil then
    return 
  end
  local avgCtrl = ControllerManager:GetController(ControllerTypeId.Avg, true)
  avgCtrl:StartAvg(nil, self._avgId)
end

UIEventComebackMain.__OnClickBack = function(self)
  -- function num : 0_7
  self:OnCloseWin()
  self:Delete()
end

UIEventComebackMain.__SetReddotListener = function(self)
  -- function num : 0_8 , upvalues : _ENV
  if self.__reddotListenerCallback == nil then
    self.__reddotListenerCallback = BindCallback(self, self.__RefreshReddot)
    RedDotController:AddListener(RedDotDynPath.ActivityComebackPath, self.__reddotListenerCallback)
  end
  local _, node = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivityInHome, RedDotStaticTypeId.ActivityComeback)
  if node ~= nil then
    self:__RefreshReddot(node)
  end
end

UIEventComebackMain.__CancleReddotListener = function(self)
  -- function num : 0_9 , upvalues : _ENV
  if self.__reddotListenerCallback ~= nil then
    RedDotController:RemoveListener(RedDotDynPath.ActivityComebackPath, self.__reddotListenerCallback)
    self.__reddotListenerCallback = nil
  end
end

UIEventComebackMain.__RefreshReddot = function(self, node)
  -- function num : 0_10 , upvalues : _ENV
  for _,tap in pairs((self._tapPool).listItem) do
    local actFrameData = tap:GetActivityCombackData()
    local childNode = node:GetChild(actFrameData.id)
    tap:SetComebackTabReddot(childNode ~= nil and childNode:GetRedDotCount() > 0)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIEventComebackMain.OnDelete = function(self)
  -- function num : 0_11 , upvalues : base, _ENV
  (base.OnDelete)(self)
  self:__CancleReddotListener()
  if self._timerId ~= nil then
    TimerManager:StopTimer(self._timerId)
    self._timerId = nil
  end
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
  if self._activityUIEntity ~= nil then
    for k,v in pairs(self._activityUIEntity) do
      v:Delete()
    end
    self._activityUIEntity = nil
  end
  self._activityUItype = nil
end

return UIEventComebackMain

