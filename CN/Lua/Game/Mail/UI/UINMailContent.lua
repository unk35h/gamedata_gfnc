-- params : ...
-- function num : 0 , upvalues : _ENV
local UINMailContent = class("UINMailContent", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithReceived = require("Game.CommonUI.Item.UINBaseItemWithReceived")
local JumpManager = require("Game.Jump.JumpManager")
local cs_MessageCommon = CS.MessageCommon
local cs_UnityWebRequest = ((CS.UnityEngine).Networking).UnityWebRequest
UINMailContent.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithReceived
  self.ctrl = ControllerManager:GetController(ControllerTypeId.Mail, false)
  ;
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  self.poolMailItem = (UIItemPool.New)(UINBaseItemWithReceived, (self.ui).rewardItem)
  ;
  ((self.ui).rewardItem):SetActive(false)
  ;
  (((self.ui).tex_Content).onHrefClick):AddListener(BindCallback(self, self.OnClickHerf))
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Get, self, self.m_GetReward)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Delete, self, self.m_DeleteOneMail)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Collect, self, self.OnClickTreasure)
  self.timerId = TimerManager:StartTimer(1, self.m_OutOfDataTime, self, false, false, true)
end

UINMailContent.UpdateContent = function(self, mailData)
  -- function num : 0_1
  self.mailData = mailData
  if mailData == nil then
    ((self.ui).empty):SetActive(true)
    ;
    ((self.ui).normal):SetActive(false)
    return 
  end
  ;
  ((self.ui).empty):SetActive(false)
  ;
  ((self.ui).normal):SetActive(true)
  self:m_RefreshStaticUI(mailData)
  self:m_RefreshReward(mailData)
  self:m_OutOfDataTime()
end

UINMailContent.m_RefreshStaticUI = function(self, mailData)
  -- function num : 0_2 , upvalues : _ENV
  local isHaveAtt, attDic, isPicked = mailData:IsHaveAtt()
  local isTreasure = mailData:GetIsTreasure()
  if isTreasure then
    ((self.ui).tex_Collect):SetIndex(1)
    ;
    ((self.ui).img_Collect):SetIndex(1)
    if isHaveAtt then
      ((self.ui).expiryDate):SetIndex(1)
    else
      ;
      ((self.ui).expiryDate):SetIndex(0)
    end
  else
    ;
    ((self.ui).tex_Collect):SetIndex(0)
    ;
    ((self.ui).img_Collect):SetIndex(0)
    ;
    ((self.ui).expiryDate):SetIndex(0)
  end
  local mailWindow = UIManager:GetWindow(UIWindowTypeID.Mail)
  if mailWindow ~= nil then
    mailWindow:RefreshSenderPic(mailData)
  end
  -- DECOMPILER ERROR at PC59: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Tile).text = mailData:GetTitle()
  -- DECOMPILER ERROR at PC64: Confused about usage of register: R7 in 'UnsetPending'

  ;
  ((self.ui).tex_Frome).text = mailData:GetSender()
  local ymd, hm = mailData:GetTime()
  ;
  ((self.ui).tex_Time):SetIndex(0, ymd, hm)
  local text = self:__DealContent(mailData:GetContent())
  if self.__lastText ~= nil and self.__lastText == text then
    return 
  end
  self.__lastText = text
  -- DECOMPILER ERROR at PC88: Confused about usage of register: R10 in 'UnsetPending'

  ;
  ((self.ui).tex_Content).text = text
end

UINMailContent.m_RefreshReward = function(self, mailData)
  -- function num : 0_3 , upvalues : _ENV
  if mailData.expiredTm < PlayerDataCenter.timestamp then
    ((self.ui).reward):SetActive(false)
    ;
    (((self.ui).expiryDate).gameObject):SetActive(false)
    ;
    (((self.ui).btn_Delete).gameObject):SetActive(true)
    return 
  end
  ;
  (((self.ui).expiryDate).gameObject):SetActive(true)
  local isHaveAtt, attDic, isPicked = mailData:IsHaveAtt()
  ;
  ((self.ui).reward):SetActive(isHaveAtt)
  if isHaveAtt then
    local attList = self:_SortAttDicData(attDic)
    ;
    (self.poolMailItem):HideAll()
    for _,cfg in ipairs(attList) do
      local reward = (self.poolMailItem):GetOne()
      local count = attDic[cfg.id]
      reward:InitItemWithCount(cfg, count, nil, isPicked)
    end
    ;
    (((self.ui).btn_Get).gameObject):SetActive(not isPicked)
    ;
    (((self.ui).btn_Delete).gameObject):SetActive(isPicked)
  else
    do
      ;
      (((self.ui).btn_Delete).gameObject):SetActive(true)
    end
  end
end

UINMailContent._SortAttDicData = function(self, attDic)
  -- function num : 0_4 , upvalues : _ENV
  local attList = {}
  for id,num in pairs(attDic) do
    local itemCfg = (ConfigData.item)[id]
    if itemCfg == nil then
      error("Can\'t read itemCfg with id=" .. tostring(id))
    else
      ;
      (table.insert)(attList, itemCfg)
    end
  end
  return (CommonUtil.DefaultItemsSort)(attList)
end

local tiemType = {day = 0, hour = 1, min = 2, second = 3}
UINMailContent.m_OutOfDataTime = function(self)
  -- function num : 0_5 , upvalues : _ENV, tiemType
  if self.mailData == nil then
    return 
  end
  local time = (self.mailData):GetTimeBeforeExpired()
  if time > 86400 then
    local num = (math.ceil)(time // 86400)
    ;
    ((self.ui).tex_ExpiryDate):SetIndex(tiemType.day, tostring(num))
  else
    do
      if time > 3600 then
        local num = (math.ceil)(time // 3600)
        ;
        ((self.ui).tex_ExpiryDate):SetIndex(tiemType.hour, tostring(num))
      else
        do
          if time > 60 then
            local num = (math.ceil)(time // 60)
            ;
            ((self.ui).tex_ExpiryDate):SetIndex(tiemType.min, tostring(num))
          else
            do
              if time > 0 then
                ((self.ui).tex_ExpiryDate):SetIndex(tiemType.second, tostring(time))
              end
            end
          end
        end
      end
    end
  end
end

UINMailContent.OnClickTreasure = function(self)
  -- function num : 0_6
  local isTreasure = (self.mailData):GetIsTreasure()
  if isTreasure then
    (self.ctrl):ReqCancelTreasuredMail((self.mailData).uid)
  else
    ;
    (self.ctrl):ReqTreasuredMail((self.mailData).uid)
  end
end

UINMailContent.m_GetReward = function(self)
  -- function num : 0_7 , upvalues : _ENV, cs_MessageCommon
  local containAth = false
  for k,item in ipairs((self.poolMailItem).listItem) do
    local itemCfg = item.itemCfg
    if itemCfg ~= nil and itemCfg.type == eItemType.Arithmetic then
      containAth = true
      break
    end
  end
  do
    if containAth and (ConfigData.game_config).athMaxNum <= #(PlayerDataCenter.allAthData):GetAllAthList() then
      (cs_MessageCommon.ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.Ath_MaxCount))
      return 
    end
    ;
    (self.ctrl):ReqReceiveAttachment((self.mailData).uid)
  end
end

UINMailContent.m_DeleteOneMail = function(self)
  -- function num : 0_8 , upvalues : _ENV
  AudioManager:PlayAudioById(1057)
  ;
  (self.ctrl):ReqDeleteOneMail((self.mailData).uid)
end

UINMailContent.OnClickHerf = function(self, herfStr)
  -- function num : 0_9 , upvalues : _ENV, JumpManager
  local arg = {}
  local index = (string.find)(herfStr, ":")
  arg[1] = (string.sub)(herfStr, 1, index - 1)
  arg[2] = (string.sub)(herfStr, index + 1, -1)
  if arg[1] == "GameJump" then
    local typeAndArgs = (string.split)(arg[2], "=")
    do
      local jumpTypeId = (tonumber(typeAndArgs[1]))
      local jumpArgs = nil
      if typeAndArgs[2] ~= nil then
        jumpArgs = (CommonUtil.SplitStrToNumber)(typeAndArgs[2], "_")
      end
      if jumpTypeId > 0 then
        JumpManager:Jump(jumpTypeId, function(jumpCallback)
    -- function num : 0_9_0 , upvalues : jumpTypeId, JumpManager, _ENV
    if jumpTypeId == (JumpManager.eJumpTarget).Mail then
      return 
    end
    do
      if jumpTypeId ~= (JumpManager.eJumpTarget).UserCenter then
        local win = UIManager:GetWindow(UIWindowTypeID.Mail)
        win:Delete()
      end
      if jumpCallback ~= nil then
        jumpCallback()
      end
    end
  end
, nil, jumpArgs)
      end
    end
  else
    do
      if arg[1] == "link" then
        local webLink = arg[2]
        ;
        (((CS.UnityEngine).Application).OpenURL)(webLink)
      else
        do
          if arg[1] == "token" then
            local webLink = arg[2]
            webLink = self:GetWebURL(webLink)
            ;
            (((CS.UnityEngine).Application).OpenURL)(webLink)
          end
        end
      end
    end
  end
end

UINMailContent.GetWebURL = function(self, sourceURL)
  -- function num : 0_10 , upvalues : _ENV, cs_UnityWebRequest
  if (string.match)(sourceURL, "h5game=true") ~= nil then
    local url = sourceURL
    local UID = PlayerDataCenter.strPlayerId
    local game_channel_id = ((CS.MicaSDKManager).Instance).SDK_Channel_Id
    local type_id = ((CS.MicaSDKManager).Instance).Type_id
    url = (GR.StringFormat)(url, game_channel_id, type_id, UID)
    local args = (string.split)(url, "?")
    args[2] = ((CS.AESEncrypt).Encrypt)(args[2])
    url = args[1] .. "?token=" .. args[2]
    sourceURL = url
  else
    do
      do
        local token = ((CS.MicaSDKManager).Instance).accessToken
        token = (cs_UnityWebRequest.EscapeURL)(token)
        if token == nil then
          token = ""
        end
        if (string.match)(sourceURL, "?") ~= nil then
          sourceURL = sourceURL .. "&token=" .. token
        else
          sourceURL = sourceURL .. "?token=" .. token
        end
        return sourceURL
      end
    end
  end
end

UINMailContent.__DealContent = function(self, content)
  -- function num : 0_11
  content = self:__DealPlayerName(content)
  return content
end

UINMailContent.__DealPlayerName = function(self, content)
  -- function num : 0_12 , upvalues : _ENV
  local p = "<cmdr>"
  local playName = PlayerDataCenter:GetSelfName()
  content = (string.gsub)(content, p, playName)
  return content
end

UINMailContent.OnDelete = function(self)
  -- function num : 0_13 , upvalues : _ENV, base
  if self.timerId ~= nil then
    TimerManager:StopTimer(self.timerId)
    self.timerId = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINMailContent

