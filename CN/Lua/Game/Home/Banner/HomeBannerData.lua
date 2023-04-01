-- params : ...
-- function num : 0 , upvalues : _ENV
local HomeBannerData = class("HomeBannerData")
local JumpManager = require("Game.Jump.JumpManager")
local cs_UnityWebRequest = ((CS.UnityEngine).Networking).UnityWebRequest
local emptyTimeString = ""
local eTimeSetType = {AfterMaintenance = 1, UntilOnly = 2, FullTime = 3, FullTimePassNewYear = 4}
local GetDurationTimeFuncDic = {[eTimeSetType.AfterMaintenance] = function(self, timeSetType)
  -- function num : 0_0 , upvalues : _ENV, emptyTimeString
  local startTime = TimeUtil:TimestampToDateString(self.eventStartTimeStamp, false, true, ConfigData:GetTipTag(TipTag.advStartTimeFormat, timeSetType))
  local endTime = emptyTimeString
  return startTime, endTime
end
, [eTimeSetType.UntilOnly] = function(self, timeSetType)
  -- function num : 0_1 , upvalues : emptyTimeString, _ENV
  local startTime = emptyTimeString
  local endTime = TimeUtil:TimestampToDateString(self.eventEndTimeStamp, false, true, ConfigData:GetTipTag(TipTag.advEndTimeFormat, timeSetType))
  return startTime, endTime
end
, [eTimeSetType.FullTime] = function(self, timeSetType)
  -- function num : 0_2 , upvalues : _ENV
  local startTime = TimeUtil:TimestampToDateString(self.eventStartTimeStamp, false, true, ConfigData:GetTipTag(TipTag.advStartTimeFormat, timeSetType))
  local endTime = TimeUtil:TimestampToDateString(self.eventEndTimeStamp, false, true, ConfigData:GetTipTag(TipTag.advEndTimeFormat, timeSetType))
  return startTime, endTime
end
, [eTimeSetType.FullTimePassNewYear] = function(self, timeSetType)
  -- function num : 0_3 , upvalues : _ENV
  local startTime = TimeUtil:TimestampToDateString(self.eventStartTimeStamp, false, true, ConfigData:GetTipTag(TipTag.advStartTimeFormat, timeSetType))
  local endTime = TimeUtil:TimestampToDateString(self.eventEndTimeStamp, false, true, ConfigData:GetTipTag(TipTag.advEndTimeFormat, timeSetType))
  return startTime, endTime
end
}
HomeBannerData.CreateNewBannerData = function(bannerJsonData)
  -- function num : 0_4 , upvalues : HomeBannerData
  local bannerData = (HomeBannerData.New)()
  bannerData.id = bannerJsonData.id
  bannerData:UpdateBannerData(bannerJsonData)
  return bannerData
end

HomeBannerData.ctor = function(self)
  -- function num : 0_5
  self.id = nil
  self.pic_name = nil
  self.pic_url = nil
  self.__isOpenUrl = false
  self.targetUrl = nil
  self.__isInnerJump = false
  self.jumpTargetId = nil
  self.jumpArgs = nil
  self.sort = nil
  self.delay = 3
  self.outOfDataTimeStamp = nil
  self.__isShowLeftTime = false
  self.timeSetType = 0
  self.eventStartTimeStamp = 0
  self.eventEndTimeStamp = 0
  self.__IsTriedTurnURL = false
end

HomeBannerData.UpdateBannerData = function(self, bannerJsonData)
  -- function num : 0_6 , upvalues : _ENV
  self.pic_name = bannerJsonData.pic_name
  self.pic_url = bannerJsonData.pic_url
  if bannerJsonData.type_id ~= nil then
    if bannerJsonData.type_id >= 0 or bannerJsonData.type_id == 0 then
      self.__isOpenUrl = true
      self.targetUrl = bannerJsonData.extra
      self.__urlExtraLogic = bannerJsonData.extra_id or 0
    else
      self.__isInnerJump = true
      if not bannerJsonData.extra_id then
        error("can\'t read bannerCfg with type_id:" .. tostring(bannerJsonData.type_id) .. " extra_id:" .. tostring(not bannerJsonData.extra_id and ((ConfigData.banner_tv)[bannerJsonData.type_id])[(ConfigData.banner_tv)[bannerJsonData.type_id] == nil or 0] ~= nil or 0))
        self.__isInnerJump = false
        do
          local bannerCfg = ((ConfigData.banner_tv)[bannerJsonData.type_id])[bannerJsonData.extra_id or 0]
          self.jumpTargetId = bannerCfg.jump_id
          self.jumpArgs = bannerCfg.jump_arg
          self.sort = bannerJsonData.sort
          self.delay = bannerJsonData.delay
          if not ((Consts.GameChannelType).IsInland)() or not TimeUtil:TimeStringToTimeStamp(bannerJsonData.end_time) then
            self.outOfDataTimeStamp = bannerJsonData.end_time_ts
            self.__isShowLeftTime = bannerJsonData.is_time_limit
            self.timeSetType = bannerJsonData.time_display_type
            self.eventStartTimeStamp = bannerJsonData.event_start_time_ts
            self.eventEndTimeStamp = bannerJsonData.event_end_time_ts
          end
        end
      end
    end
  end
end

HomeBannerData.GetBannerIsInnerJump = function(self)
  -- function num : 0_7
  return self.__isInnerJump
end

HomeBannerData.GetBannerIsOpenURL = function(self)
  -- function num : 0_8
  return self.__isOpenUrl
end

HomeBannerData.GetWebURL = function(self)
  -- function num : 0_9 , upvalues : _ENV, cs_UnityWebRequest
  if not self.__IsTriedTurnURL then
    if self.__urlExtraLogic == 1 then
      local token = ((CS.MicaSDKManager).Instance).accessToken
      token = (cs_UnityWebRequest.EscapeURL)(token)
      if token == nil then
        token = ""
      end
      if (string.match)(self.targetUrl, "?") ~= nil then
        self.targetUrl = self.targetUrl .. "&token=" .. token
      else
        self.targetUrl = self.targetUrl .. "?token=" .. token
      end
    else
      do
        if (string.match)(self.targetUrl, "h5game=true") ~= nil then
          local url = self.targetUrl
          local UID = PlayerDataCenter.strPlayerId
          local game_channel_id = ((CS.MicaSDKManager).Instance).SDK_Channel_Id
          local type_id = ((CS.MicaSDKManager).Instance).Type_id
          url = (GR.StringFormat)(url, game_channel_id, type_id, UID)
          local args = (string.split)(url, "?")
          args[2] = ((CS.AESEncrypt).Encrypt)(args[2])
          url = args[1] .. "?token=" .. args[2]
          self.targetUrl = url
        end
        do
          self.__IsTriedTurnURL = true
          return self.targetUrl
        end
      end
    end
  end
end

HomeBannerData.GetBannerIsShowLeftTime = function(self)
  -- function num : 0_10
  return self.__isShowLeftTime
end

HomeBannerData.GetBannerLeftTime = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local curTs = PlayerDataCenter.timestamp
  return self.outOfDataTimeStamp - curTs
end

HomeBannerData.GetBannerIsOutOfData = function(self)
  -- function num : 0_12
  do return self:GetBannerLeftTime() <= 0 end
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

HomeBannerData.GetStartAndEndTime = function(self)
  -- function num : 0_13 , upvalues : emptyTimeString, GetDurationTimeFuncDic
  local timeSetType = self.timeSetType
  local startTime = emptyTimeString
  local endTime = emptyTimeString
  if GetDurationTimeFuncDic[timeSetType] ~= nil then
    startTime = (GetDurationTimeFuncDic[timeSetType])(self, timeSetType)
  end
  return startTime, endTime
end

HomeBannerData.GetBannerPicUrl = function(self)
  -- function num : 0_14
  return self.pic_url
end

HomeBannerData.GetIsLotteryOrShopItemClosed = function(self)
  -- function num : 0_15 , upvalues : JumpManager, _ENV
  if self.jumpTargetId == (JumpManager.eJumpTarget).DynLottery then
    if self.jumpArgs == nil or #self.jumpArgs <= 0 then
      return false
    end
    local poolId = nil
    if self.jumpArgs ~= nil then
      poolId = (self.jumpArgs)[1]
    end
    return not (PlayerDataCenter.allLtrData):GetIsSpecificPoolOpen(poolId)
  else
    do
      if self.jumpTargetId == (JumpManager.eJumpTarget).DynShop then
        if self.jumpArgs == nil or #self.jumpArgs <= 0 then
          return false
        end
        local shopId, shopDataId, shopPageId = nil, nil, nil
        if self.jumpArgs ~= nil then
          shopId = (self.jumpArgs)[1]
          shopDataId = (self.jumpArgs)[2]
          shopPageId = (self.jumpArgs)[3]
        end
        local ctrl = ControllerManager:GetController(ControllerTypeId.Shop, true)
        if not ctrl:GetIsUnlock() then
          return true
        end
        if not ctrl:ShopIsUnlock(shopId) then
          return true
        end
        if shopDataId ~= nil and ctrl:GetShelfIsSouldOut(shopId, shopDataId) then
          return true
        end
      else
        do
          if self.jumpTargetId == (JumpManager.eJumpTarget).DynActivity then
            if self.jumpArgs == nil or #self.jumpArgs <= 0 then
              return false
            end
            return not JumpManager:Jump2DynActivityValidate(self.jumpArgs, true)
          end
          return false
        end
      end
    end
  end
end

HomeBannerData.GetBannerPicName = function(self)
  -- function num : 0_16
  return self.pic_name
end

return HomeBannerData

