-- params : ...
-- function num : 0 , upvalues : _ENV
local UIActivityFrameMain = class("UIActivityFrameMain", UIBaseWindow)
local base = UIBaseWindow
local ActivityFrameData = require("Game.ActivityFrame.ActivityFrameData")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local BattlePassEnum = require("Game.BattlePass.BattlePassEnum")
local UINActivityFrameItem = require("Game.ActivityFrame.UI.UINActivityFrameItem")
local openActivityPanelParam = {
[(ActivityFrameEnum.eActivityUIType).StarUp] = {UIType = UIWindowTypeID.ActivityStarUp, InitFunction = "InitWindow"}
, 
[(ActivityFrameEnum.eActivityUIType).BattlePass] = {UIType = UIWindowTypeID.EventBattlePass, InitFunction = "InitBattlePassUI"}
, 
[(ActivityFrameEnum.eActivityUIType).BattlePassV2] = {UIType = UIWindowTypeID.EventBattlePassV2, InitFunction = "InitBattlePassUIV2"}
, 
[(ActivityFrameEnum.eActivityUIType).EventGrowBag] = {UIType = UIWindowTypeID.EventGrowBag, InitFunction = "InitEventGrow"}
, 
[(ActivityFrameEnum.eActivityUIType).SevenDayLogin] = {UIType = UIWindowTypeID.EventNoviceSign, InitFunction = "InitNoviceSign"}
, 
[(ActivityFrameEnum.eActivityUIType).FestivalSign] = {UIType = UIWindowTypeID.EventFestivalSignIn, InitFunction = "InitEventFestivalSignIn"}
, 
[(ActivityFrameEnum.eActivityUIType).dailySignIn] = {UIType = UIWindowTypeID.EventSignin, InitFunction = "InitEventSignin"}
, 
[(ActivityFrameEnum.eActivityUIType).Tickets] = {UIType = UIWindowTypeID.EventWeChat, InitFunction = "InitWeChat"}
, 
[(ActivityFrameEnum.eActivityUIType).LimitTask] = {UIType = UIWindowTypeID.ActivityLimitTask, InitFunction = "InitActivityLimitTask"}
, 
[(ActivityFrameEnum.eActivityUIType).SignInMiniGame] = {UIType = UIWindowTypeID.SignInMiniGame, InitFunction = "InitSignInMiniGame"}
, 
[(ActivityFrameEnum.eActivityUIType).EventInvitation] = {UIType = UIWindowTypeID.EventInvitation, InitFunction = "InitInvitation"}
, 
[(ActivityFrameEnum.eActivityUIType).EventWeeklyQA] = {UIType = UIWindowTypeID.EventWeeklyQA, InitFunction = "InitEventWeeklyQA"}
, 
[(ActivityFrameEnum.eActivityUIType).EventAngelaGift] = {UIType = UIWindowTypeID.EventAngelaGift, InitFunction = "InitEventAngelaGiftMain"}
, 
[(ActivityFrameEnum.eActivityUIType).Gift] = {UIType = UIWindowTypeID.EventOptionalGift, InitFunction = "InitEventOptionalGift"}
}
UIActivityFrameMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINActivityFrameItem
  (UIUtil.SetTopStatus)(self, self.OnClickClose)
  self.swithItemPool = (UIItemPool.New)(UINActivityFrameItem, (self.ui).tog_SwitchItem)
  ;
  ((self.ui).tog_SwitchItem):SetActive(false)
  self.__OnSelectActivityItem = BindCallback(self, self.OnSelectActivityItem)
  self.resloader = ((CS.ResLoader).Create)()
  self.__ListerShowActivityCallback = BindCallback(self, self.__ListerShowActivity)
  MsgCenter:AddListener(eMsgEventId.ActivityShowChange, self.__ListerShowActivityCallback)
end

UIActivityFrameMain.ActivityParamDeal = function(self, actFrameData)
  -- function num : 0_1 , upvalues : ActivityFrameEnum, _ENV, BattlePassEnum
  local UIType = nil
  if actFrameData.actCat == (ActivityFrameEnum.eActivityType).StarUp then
    UIType = (ActivityFrameEnum.eActivityUIType).StarUp
  else
    if actFrameData.actCat == (ActivityFrameEnum.eActivityType).BattlePass then
      local cfg = (ConfigData.battlepass_type)[actFrameData.actId]
      if cfg ~= nil then
        if cfg.condition == (BattlePassEnum.ConditionType).AchievementLevel then
          UIType = (ActivityFrameEnum.eActivityUIType).EventGrowBag
        else
          if cfg.condition == (BattlePassEnum.ConditionType).BattlePassLevel then
            if cfg.version > 0 then
              UIType = (ActivityFrameEnum.eActivityUIType).BattlePassV2
            else
              UIType = (ActivityFrameEnum.eActivityUIType).BattlePass
            end
          end
        end
      end
    else
      do
        if actFrameData.actCat == (ActivityFrameEnum.eActivityType).SevenDayLogin then
          local signData = ((PlayerDataCenter.eventNoviceSignData).dataDic)[actFrameData.actId]
          if signData ~= nil and signData:IsFestivalSign() then
            UIType = (ActivityFrameEnum.eActivityUIType).FestivalSign
          else
            UIType = (ActivityFrameEnum.eActivityUIType).SevenDayLogin
          end
        else
          do
            if actFrameData.actCat == (ActivityFrameEnum.eActivityType).dailySignIn then
              UIType = (ActivityFrameEnum.eActivityUIType).dailySignIn
            else
              if actFrameData.actCat == (ActivityFrameEnum.eActivityType).Tickets then
                UIType = (ActivityFrameEnum.eActivityUIType).Tickets
              else
                if actFrameData.actCat == (ActivityFrameEnum.eActivityType).ActvtLimitTask then
                  UIType = (ActivityFrameEnum.eActivityUIType).LimitTask
                else
                  if actFrameData.actCat == (ActivityFrameEnum.eActivityType).SignInMiniGame then
                    UIType = (ActivityFrameEnum.eActivityUIType).SignInMiniGame
                  else
                    if actFrameData.actCat == (ActivityFrameEnum.eActivityType).Invitation then
                      UIType = (ActivityFrameEnum.eActivityUIType).EventInvitation
                    else
                      if actFrameData.actCat == (ActivityFrameEnum.eActivityType).EventWeeklyQA then
                        UIType = (ActivityFrameEnum.eActivityUIType).EventWeeklyQA
                      else
                        if actFrameData.actCat == (ActivityFrameEnum.eActivityType).EventAngelaGift then
                          UIType = (ActivityFrameEnum.eActivityUIType).EventAngelaGift
                        else
                          if actFrameData.actCat == (ActivityFrameEnum.eActivityType).Gift then
                            UIType = (ActivityFrameEnum.eActivityUIType).Gift
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
            -- DECOMPILER ERROR at PC129: Confused about usage of register: R3 in 'UnsetPending'

            ;
            (self.activityTypeDic)[actFrameData.id] = UIType
          end
        end
      end
    end
  end
end

UIActivityFrameMain.InitFrameMain = function(self, enterType, activityId)
  -- function num : 0_2 , upvalues : _ENV
  self._enterType = enterType
  self.frameCtrl = ControllerManager:GetController(ControllerTypeId.ActivityFrame, true)
  local actDic = (self.frameCtrl):GetShowByEnterType(enterType)
  if actDic == nil or (table.count)(actDic) == 0 then
    error("该活动入口没有已开启活动： enterType is " .. tostring(enterType))
    return 
  end
  local list = {}
  for _,activityFrameDate in pairs(actDic) do
    (table.insert)(list, activityFrameDate)
  end
  ;
  (table.sort)(list, function(a, b)
    -- function num : 0_2_0
    do return a.order < b.order end
    -- DECOMPILER ERROR: 1 unprocessed JMP targets
  end
)
  self.activityTypeDic = {}
  for _,actFrameData in ipairs(list) do
    self:ActivityParamDeal(actFrameData)
  end
  if #list == 0 then
    error("该活动入口没有已开启活动： enterType is " .. tostring(enterType))
    return 
  end
  ;
  (self.swithItemPool):HideAll()
  self._swithItemDic = {}
  local targetInedx = nil
  local listCount = #list
  for index,activityFrameDate in ipairs(list) do
    local item = (self.swithItemPool):GetOne()
    item:InitActivitySwitchItem(activityFrameDate, self.__OnSelectActivityItem, self.resloader)
    if activityId ~= nil and activityFrameDate:GetActivityFrameId() == activityId then
      targetInedx = index
    end
    item:SetActivitySwitchLineState(index < listCount)
    -- DECOMPILER ERROR at PC102: Confused about usage of register: R13 in 'UnsetPending'

    ;
    (self._swithItemDic)[activityFrameDate:GetActivityFrameId()] = item
  end
  self:CancelAndSetActivityFrameListener(enterType)
  if targetInedx == nil then
    targetInedx = 1
  end
  ;
  (((self.swithItemPool).listItem)[targetInedx]):SelectActivityTag()
  -- DECOMPILER ERROR: 3 unprocessed JMP targets
end

UIActivityFrameMain.__ListerShowActivity = function(self, ids, flag)
  -- function num : 0_3 , upvalues : _ENV
  if flag then
    for _,id in ipairs(ids) do
      local activityFrameDate = (self.frameCtrl):GetActivityFrameData(id)
      if (self._swithItemDic)[id] == nil and activityFrameDate ~= nil and activityFrameDate:GetEnterType() == self._enterType then
        self:ActivityParamDeal(activityFrameDate)
        local item = (self.swithItemPool):GetOne()
        item:InitActivitySwitchItem(activityFrameDate, self.__OnSelectActivityItem, self.resloader)
        -- DECOMPILER ERROR at PC35: Confused about usage of register: R10 in 'UnsetPending'

        ;
        (self._swithItemDic)[activityFrameDate:GetActivityFrameId()] = item
      end
    end
  else
    do
      do
        local curShowOutTime = false
        for _,id in ipairs(ids) do
          if (self._swithItemDic)[id] ~= nil then
            local item = (self._swithItemDic)[id]
            ;
            (self.swithItemPool):HideOne(item)
            -- DECOMPILER ERROR at PC55: Confused about usage of register: R10 in 'UnsetPending'

            ;
            (self._swithItemDic)[id] = nil
            if id == self.selectedId then
              curShowOutTime = true
            end
          end
        end
        if ((self.swithItemPool).listItem)[1] == nil then
          (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActivityFrameMain, true)
        else
          if curShowOutTime then
            (UIUtil.ReturnUntil2Marker)(UIWindowTypeID.ActivityFrameMain, false)
            ;
            (((self.swithItemPool).listItem)[1]):SelectActivityTag()
          end
        end
        for i,item in ipairs((self.swithItemPool).listItem) do
          item:SetActivitySwitchLineState(((self.swithItemPool).listItem)[i + 1] ~= nil)
        end
        -- DECOMPILER ERROR: 2 unprocessed JMP targets
      end
    end
  end
end

UIActivityFrameMain.OnSelectActivityItem = function(self, tag, flag)
  -- function num : 0_4 , upvalues : openActivityPanelParam, _ENV
  if flag then
    local id = (tag.activityFrameData).id
    do
      if id == self.selectedId then
        return 
      end
      if (self.activityTypeDic)[id] == nil then
        return 
      end
      local openParam = openActivityPanelParam[(self.activityTypeDic)[self.selectedId]]
      if self.selectedId ~= nil and (self.activityTypeDic)[id] ~= (self.activityTypeDic)[self.selectedId] then
        UIManager:DeleteWindow(openParam.UIType, true)
      end
      self.selectedId = id
      openParam = openActivityPanelParam[(self.activityTypeDic)[self.selectedId]]
      UIManager:ShowWindowAsync(openParam.UIType, function(window)
    -- function num : 0_4_0 , upvalues : self, openParam, tag, _ENV
    (window.transform):SetParent((self.ui).pageNode)
    ;
    (window[openParam.InitFunction])(window, (tag.activityFrameData).actId)
    if (UIUtil.CheckTopIsWindow)(openParam.UIType) then
      (UIUtil.PopFromBackStack)()
      ;
      (UIUtil.ReShowTopStatus)()
    end
  end
)
    end
  end
end

UIActivityFrameMain.CancelAndSetActivityFrameListener = function(self, enterType)
  -- function num : 0_5 , upvalues : ActivityFrameEnum, _ENV
  self.entertype = enterType
  local oldRedDotDynPath = self.redDotDynPath
  local node = nil
  if enterType == (ActivityFrameEnum.eActivityEnterType).Novice then
    self.redDotDynPath = RedDotDynPath.ActivityFrameNovicePath
    _ = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivityInHome, RedDotStaticTypeId.ActivityFrameNovice)
  else
    if enterType == (ActivityFrameEnum.eActivityEnterType).LimitTime then
      self.redDotDynPath = RedDotDynPath.ActivityFrameLimitTimePath
      -- DECOMPILER ERROR at PC38: Overwrote pending register: R3 in 'AssignReg'

      _ = RedDotController:GetRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.ActivityInHome, RedDotStaticTypeId.ActivityFrameLimitTime)
    else
      self.redDotDynPath = nil
    end
  end
  if node ~= nil then
    self:OnListenerActivityCallback(node)
  end
  if oldRedDotDynPath ~= self.redDotDynPath then
    if self.__OnListenerActivityCallback == nil then
      self.__OnListenerActivityCallback = BindCallback(self, self.OnListenerActivityCallback)
    end
    if oldRedDotDynPath ~= nil then
      RedDotController:RemoveListener(oldRedDotDynPath, self.__OnListenerActivityCallback)
    end
    if self.redDotDynPath ~= nil then
      RedDotController:AddListener(self.redDotDynPath, self.__OnListenerActivityCallback)
    end
  end
end

UIActivityFrameMain.OnListenerActivityCallback = function(self, node)
  -- function num : 0_6 , upvalues : _ENV
  for _,swithItem in pairs((self.swithItemPool).listItem) do
    local childNode = node:GetChild((swithItem.activityFrameData).id)
    swithItem:ActivityTagReddotShow(childNode ~= nil and childNode:GetRedDotCount() > 0)
  end
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIActivityFrameMain.SetTagPageNodeState = function(self, flag)
  -- function num : 0_7
  ((self.ui).tagPageNode):SetActive(flag)
end

UIActivityFrameMain.OnClickClose = function(self)
  -- function num : 0_8
  self:OnCloseWin()
  self:Delete()
end

UIActivityFrameMain.OnDelete = function(self)
  -- function num : 0_9 , upvalues : _ENV, openActivityPanelParam, base
  MsgCenter:RemoveListener(eMsgEventId.ActivityShowChange, self.__ListerShowActivityCallback)
  self:CancelAndSetActivityFrameListener(nil)
  do
    if self.selectedId ~= nil then
      local openParam = openActivityPanelParam[(self.activityTypeDic)[self.selectedId]]
      UIManager:DeleteWindow(openParam.UIType, true)
    end
    if self.closeCallback ~= nil then
      (self.closeCallback)()
    end
    ;
    (self.swithItemPool):DeleteAll()
    local openParam = openActivityPanelParam[(self.activityTypeDic)[self.selectedId]]
    if self.resloader ~= nil then
      (self.resloader):Put2Pool()
      self.resloader = nil
    end
    ;
    (base.OnDelete)(self)
  end
end

return UIActivityFrameMain

