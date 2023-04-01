-- params : ...
-- function num : 0 , upvalues : _ENV
local eActivityType = (require("Game.ActivityFrame.ActivityFrameEnum")).eActivityType
local eDynConfigData = require("Game.ConfigData.eDynConfigData")
local HandBookActReviewOpenFunc = {}
local ReviewOpenFunc = {[eActivityType.WhiteDay] = function(actId, CRPData)
  -- function num : 0_0 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.WhiteDayHistoryAlbum, function(window)
    -- function num : 0_0_0 , upvalues : actId
    if window == nil then
      return 
    end
    window:Hide()
    window:InitWDHistoryAlbum(actId)
  end
)
end
, [eActivityType.Spring] = function(actId, CRPData)
  -- function num : 0_1 , upvalues : _ENV, eDynConfigData
  UIManager:ShowWindowAsync(UIWindowTypeID.Spring23Story, function(window)
    -- function num : 0_1_0 , upvalues : _ENV, eDynConfigData, actId
    if window == nil then
      return 
    end
    ConfigData:LoadDynCfg(eDynConfigData.activity_spring_main_story)
    ConfigData:LoadDynCfg(eDynConfigData.activity_spring_interact_info)
    ConfigData:LoadDynCfg(eDynConfigData.activity_lobby)
    window:InitSpring23StoryReview(actId, function()
      -- function num : 0_1_0_0 , upvalues : _ENV, eDynConfigData
      ConfigData:ReleaseDynCfg(eDynConfigData.activity_spring_main_story)
      ConfigData:ReleaseDynCfg(eDynConfigData.activity_spring_interact_info)
      ConfigData:ReleaseDynCfg(eDynConfigData.activity_lobby)
    end
)
  end
)
end
}
local ReviewProcessFunc = {[eActivityType.WhiteDay] = function(actId, callback)
  -- function num : 0_2 , upvalues : _ENV, eDynConfigData
  local handbookCtrl = ControllerManager:GetController(ControllerTypeId.HandBook)
  handbookCtrl:ReqWhiteHistoryData(actId, function(activityPolariodData)
    -- function num : 0_2_0 , upvalues : _ENV, eDynConfigData, actId, callback
    ConfigData:LoadDynCfg(eDynConfigData.activity_white_day_photo)
    local photoCfgDic = (ConfigData.activity_white_day_photo)[actId]
    if activityPolariodData == nil or not activityPolariodData.data then
      local unlockedPhotoDic = {}
    end
    local totalCount = (table.count)(photoCfgDic) + 2
    local unlockCount = (table.count)(unlockedPhotoDic) + 1
    if unlockCount + 1 == totalCount then
      unlockCount = totalCount
    end
    ConfigData:ReleaseDynCfg(eDynConfigData.activity_white_day_photo)
    if callback ~= nil then
      callback(unlockCount, totalCount)
    end
  end
)
end
, [eActivityType.Spring] = function(actId, callback)
  -- function num : 0_3 , upvalues : _ENV, eDynConfigData, eActivityType
  ConfigData:LoadDynCfg(eDynConfigData.activity_spring_interact_info)
  ConfigData:LoadDynCfg(eDynConfigData.activity_lobby)
  local ids = ((ConfigData.activity_spring_interact_info).activityAvgsDic)[actId]
  local unlockCount = 0
  local totalCount = 0
  local avgPlayCtrl = ControllerManager:GetController(ControllerTypeId.AvgPlay)
  local actFrameId = (((ConfigData.activity).actTypeMapping)[eActivityType.Spring])[actId]
  local firstAvgId = ((ConfigData.activity_lobby)[actFrameId]).first_avg
  if ids ~= nil then
    for _,avgId in ipairs(ids) do
      totalCount = totalCount + 1
      if firstAvgId == avgId or avgPlayCtrl:IsAvgPlayed(avgId) then
        unlockCount = unlockCount + 1
      end
    end
  end
  do
    ConfigData:ReleaseDynCfg(eDynConfigData.activity_spring_interact_info)
    ConfigData:ReleaseDynCfg(eDynConfigData.activity_lobby)
    if callback ~= nil then
      callback(unlockCount, totalCount)
    end
  end
end
}
HandBookActReviewOpenFunc.ReviewOpenFunc = ReviewOpenFunc
HandBookActReviewOpenFunc.ReviewProcessFunc = ReviewProcessFunc
HandBookActReviewOpenFunc.OpenHandbookActReview = function(self, CRPData, closeCalbback)
  -- function num : 0_4 , upvalues : _ENV
  local bgResName, _ = CRPData:GetCPRBgResName()
  if bgResName == nil or #bgResName == 0 then
    UIManager:ShowWindowAsync(UIWindowTypeID.StoryReview, function(window)
    -- function num : 0_4_0 , upvalues : CRPData, closeCalbback
    if window == nil then
      return 
    end
    window:InitStoryReview(CRPData, closeCalbback)
    window:SetStoryAvgJustClientPlay()
  end
)
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.HeroPlotReview, function(window)
    -- function num : 0_4_1 , upvalues : CRPData, closeCalbback
    if window == nil then
      return 
    end
    window:InitCommonPlotReview(CRPData, closeCalbback)
    window:SetPlotAvgJustClientPlay()
  end
)
end

return HandBookActReviewOpenFunc

