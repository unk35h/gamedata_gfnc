-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEventComebackMain = require("Game.ActivityComeback.UI.UIEventComebackMain")
local UIEventComebackLiteMain = class("UIEventComebackLiteMain", UIEventComebackMain)
local base = UIEventComebackMain
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local UINActivityComebackTap = require("Game.ActivityComeback.UI.UINActivityComebackTap")
local ActivityUIType = {ComebackSign = 1, ComebackTask = 3, ComebackExchage = 4}
local ActivityPanemParam = {
[ActivityUIType.ComebackSign] = {UIName = "UI_EventComebackLiteSignNode", InitFunction = "InitCombackSingIn", UITable = "Game.ActivityComeback.UI.UINEventComebackLiteSignIn"}
, 
[ActivityUIType.ComebackTask] = {UIName = "UI_EventComebackTaskNode", InitFunction = "InitCombackTask", UITable = "Game.ActivityComeback.UI.UINEventComebackLiteTask"}
, 
[ActivityUIType.ComebackExchage] = {UIName = "UI_EventComebackLiteExchangeNode", InitFunction = "InitComebackExchange", UITable = "Game.ActivityComeback.UI.UINEventComebackLiteExchange"}
}
UIEventComebackLiteMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActivityComebackTap
  (UIUtil.SetTopStatus)(self, self.__OnClickBack)
  self._tapPool = (UIItemPool.New)(UINActivityComebackTap, (self.ui).pageItem)
  ;
  ((self.ui).pageItem):SetActive(false)
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = ConfigData:GetTipContent(7406)
  self.__ClickTapFunc = BindCallback(self, self.__ClickTap)
  self._resloader = ((CS.ResLoader).Create)()
  self._waitLoadingTable = {}
end

UIEventComebackLiteMain.__ActivityParamDeal = function(self, activityList)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum, ActivityUIType
  self._activityUItype = {}
  self._activityUIEntity = {}
  for _,actFrameData in ipairs(activityList) do
    local UIType = nil
    if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).SevenDayLogin then
      UIType = ActivityUIType.ComebackSign
    else
      if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).Task then
        UIType = ActivityUIType.ComebackTask
      else
        if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).Round then
          UIType = ActivityUIType.ComebackExchage
        else
          if actFrameData:GetActivityFrameCat() == (ActivityFrameEnum.eActivityType).Comeback then
            local activityCfg = (ConfigData.activity)[actFrameData:GetActivityFrameId()]
            do
              if activityCfg ~= nil and activityCfg.rule_id > 0 then
                (UIUtil.SetTopStateInfoFunc)(self, function()
    -- function num : 0_1_0 , upvalues : _ENV, activityCfg
    UIManager:CreateWindowAsync(UIWindowTypeID.CommonRuleInfo, function(window)
      -- function num : 0_1_0_0 , upvalues : activityCfg
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
                  -- DECOMPILER ERROR at PC69: Confused about usage of register: R9 in 'UnsetPending'

                  ;
                  (self._activityUItype)[frameId] = UIType
                end
                -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                -- DECOMPILER ERROR at PC70: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
      end
    end
  end
end

UIEventComebackLiteMain.__ClickTap = function(self, activityData)
  -- function num : 0_2 , upvalues : _ENV, ActivityPanemParam, ActivityUIType
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
    ;
    (UIUtil.RefreshTopResId)(self._showItemIds)
    if entity ~= nil then
      entity:Show()
      ;
      (entity[panelParam.InitFunction])(entity, activityData:GetActId())
    else
      -- DECOMPILER ERROR at PC74: Confused about usage of register: R6 in 'UnsetPending'

      if not (self._waitLoadingTable)[uiType] then
        (self._waitLoadingTable)[uiType] = true
        ;
        (self._resloader):LoadABAssetAsync(PathConsts:GetActivityComebackPrefab(panelParam.UIName), function(prefab)
    -- function num : 0_2_0 , upvalues : _ENV, self, panelParam, uiType, activityData, ActivityUIType
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
    -- DECOMPILER ERROR: 5 unprocessed JMP targets
  end
end

return UIEventComebackLiteMain

