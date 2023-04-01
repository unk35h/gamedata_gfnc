-- params : ...
-- function num : 0 , upvalues : _ENV
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
local HomeEnum = require("Game.Home.HomeEnum")
local __isSendingSingle = false
local __singleQueue = {}
local SendSingle = function(callback)
  -- function num : 0_0 , upvalues : __isSendingSingle, _ENV, __singleQueue
  if __isSendingSingle then
    (table.insert)(__singleQueue, callback)
    return 
  else
    __isSendingSingle = true
    if callback ~= nil then
      callback()
    end
  end
end

local SendSingleOver = function()
  -- function num : 0_1 , upvalues : __isSendingSingle, __singleQueue, _ENV
  __isSendingSingle = false
  if #__singleQueue > 0 then
    local callback = __singleQueue[1]
    ;
    (table.remove)(__singleQueue, 1)
    callback()
  end
end

local ActivityDailyFlushFunc = {[(ActivityFrameEnum.eActivityType).SevenDayLogin] = function(frameIdDic, actFrameCtrl)
  -- function num : 0_2 , upvalues : _ENV, HomeEnum
  TimerManager:StartTimer(1, function()
    -- function num : 0_2_0 , upvalues : _ENV, frameIdDic, actFrameCtrl, HomeEnum
    MsgCenter:Broadcast(eMsgEventId.NoviceSignTime)
    local eventSignWindow = UIManager:GetWindow(UIWindowTypeID.EventNoviceSign)
    if eventSignWindow ~= nil then
      eventSignWindow:RefreshNoviceSign()
    end
    local festivalSignWindow = UIManager:GetWindow(UIWindowTypeID.EventFestivalSignIn)
    if festivalSignWindow ~= nil then
      festivalSignWindow:UpdUIFestivalSignIn()
    end
    local HomeController = ControllerManager:GetController(ControllerTypeId.HomeController)
    local isAddGuide = false
    for actFrameId,v in pairs(frameIdDic) do
      local actInfo = actFrameCtrl:GetActivityFrameData(actFrameId)
      if actInfo ~= nil and actInfo:GetCouldShowActivity() then
        local signData = ((PlayerDataCenter.eventNoviceSignData).dataDic)[actInfo:GetActId()]
        local reddotNode = actInfo:GetActivityReddotNode()
        if signData == nil or not signData:IsAllowReceive() or not 1 then
          do
            reddotNode:SetRedDotCount(reddotNode == nil or 0)
            if signData ~= nil and signData:IsCanPop() then
              isAddGuide = true
              if HomeController ~= nil and HomeController.homeState == (HomeEnum.eHomeState).Normal then
                HomeController:AddAutoShowGuide((HomeEnum.eAutoShwoCommand).NoviceSign, true)
              end
            end
            -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_STMT

            -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_THEN_STMT

            -- DECOMPILER ERROR at PC84: LeaveBlock: unexpected jumping out IF_STMT

          end
        end
      end
    end
    if isAddGuide and HomeController ~= nil then
      HomeController:TryRunAutoShow()
    end
  end
, nil, true)
end
, [(ActivityFrameEnum.eActivityType).HeroGrow] = function(frameIdDic, actFrameCtrl)
  -- function num : 0_3 , upvalues : _ENV, SendSingle, SendSingleOver
  TimerManager:StartTimer(2, function()
    -- function num : 0_3_0 , upvalues : _ENV, frameIdDic, actFrameCtrl, SendSingle, SendSingleOver
    local heroGrowCtrl = ControllerManager:GetController(ControllerTypeId.ActivityHeroGrow, true)
    heroGrowCtrl:RefreshHeroGrowStateDailyFlush()
    for actFrameId,v in pairs(frameIdDic) do
      do
        local actInfo = actFrameCtrl:GetActivityFrameData(actFrameId)
        local heroGrowData = heroGrowCtrl:GetHeroGrowActivity(actInfo:GetActId())
        if heroGrowData ~= nil and not heroGrowData:IsHeroGrowTaskAllUnlock() then
          SendSingle(function()
      -- function num : 0_3_0_0 , upvalues : _ENV, actFrameId, SendSingleOver
      (NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)):CS_ACTIVITY_SingleConcreteInfo(actFrameId, function(args)
        -- function num : 0_3_0_0_0 , upvalues : SendSingleOver
        SendSingleOver()
      end
)
    end
)
        end
      end
    end
  end
, nil, true)
end
, [(ActivityFrameEnum.eActivityType).DailyChallenge] = function(frameIdDic, actFrameCtrl)
  -- function num : 0_4 , upvalues : _ENV
  local adcCtrl = ControllerManager:GetController(ControllerTypeId.ActivityDailyChallenge)
  if adcCtrl ~= nil then
    adcCtrl:RefreshADCDailyFlush()
  end
end
}
return ActivityDailyFlushFunc

