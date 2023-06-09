-- params : ...
-- function num : 0 , upvalues : _ENV
local New_MailController = class("New_MailController", ControllerBase)
local HomeEnum = require("Game.Home.HomeEnum")
local cs_MessageCommon = CS.MessageCommon
local MailData = require("Game.Mail.MailData")
local MailEnum = require("Game.Mail.MailEnum")
local HomeEnum = require("Game.Home.HomeEnum")
local NoticeData = require("Game.Notice.NoticeData")
local JumpManager = require("Game.Jump.JumpManager")
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
New_MailController.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  self.hasNotify = false
  self.haveNotGetRewardMail = false
  self.haveCouldDeleteMail = false
  self.isUIOpen = false
  self._m_InitDataCallback = BindCallback(self, self.m_InitDataCallback)
  self.network = NetworkManager:GetNetwork(NetworkTypeID.Mail)
  self.mailDataDic = {}
end

New_MailController.OnMailUIShow = function(self, callback)
  -- function num : 0_1 , upvalues : _ENV
  if self.hasNotify then
    self:ReqMailFetch(true, function()
    -- function num : 0_1_0 , upvalues : self, callback
    self:DeletAllOutDataMail()
    self:StartAutoDeleteTimer()
    if callback ~= nil then
      callback()
    end
  end
)
  else
    self:DeletAllOutDataMail()
    self:StartAutoDeleteTimer()
    if callback ~= nil then
      callback()
    end
  end
  self.isUIOpen = true
  NoticeManager:DeleteNoticeByType((NoticeManager.eNoticeType).Mail)
end

New_MailController.OnMailUIHide = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.m_outDataTimerId ~= nil then
    TimerManager:StopTimer(self.m_outDataTimerId)
    self.m_outDataTimerId = nil
  end
  self.isUIOpen = false
end

New_MailController.GetInitData = function(self)
  -- function num : 0_3
  (self.network):CS_MAIL_Detail(self._m_InitDataCallback)
end

New_MailController.m_InitDataCallback = function(self, args)
  -- function num : 0_4 , upvalues : _ENV
  if args ~= nil and args.Count > 0 then
    local mailDetails = args[0]
    self:InitOrUpdateData(mailDetails, true)
  else
    do
      error("InitData args error")
    end
  end
end

New_MailController.RecvUpdateDiff = function(self, data, delete)
  -- function num : 0_5 , upvalues : _ENV
  if delete ~= nil and (table.count)(delete) > 0 then
    self:DeleteData(delete)
  end
  if data ~= nil and (table.count)(data) > 0 then
    self:InitOrUpdateData(data)
  end
end

New_MailController.ReqMailRead = function(self, uid, callback)
  -- function num : 0_6 , upvalues : MailEnum
  local mailDetail = (self.mailDataDic)[uid]
  if mailDetail.status == (MailEnum.eMailDetailType).None and not mailDetail.isReading then
    mailDetail.isReading = true
    ;
    (self.network):CS_MAIL_Read(uid, callback)
  end
end

New_MailController.ReqTreasuredMail = function(self, uid)
  -- function num : 0_7 , upvalues : _ENV, cs_MessageCommon
  local mailDetail = (self.mailDataDic)[uid]
  local treasureFunc = function()
    -- function num : 0_7_0 , upvalues : mailDetail, self, uid, _ENV
    mailDetail.isTreasure = true
    ;
    (self.network):CS_MAIL_Favorite(uid, true, function()
      -- function num : 0_7_0_0 , upvalues : self, _ENV, mailDetail
      self:m_RefreshDeleteAndNewState()
      MsgCenter:Broadcast(eMsgEventId.OnMailDiff, {mailDetail})
    end
)
  end

  local treasureCount = self:GetMailTreasureCount()
  if (ConfigData.game_config).MailTreasureCount <= treasureCount then
    (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(336))
    return 
  end
  treasureFunc()
end

New_MailController.ReqCancelTreasuredMail = function(self, uid)
  -- function num : 0_8 , upvalues : _ENV
  local mailDetail = (self.mailDataDic)[uid]
  local cancelFunc = function()
    -- function num : 0_8_0 , upvalues : mailDetail, self, uid, _ENV
    mailDetail.isTreasure = false
    ;
    (self.network):CS_MAIL_Favorite(uid, false, function()
      -- function num : 0_8_0_0 , upvalues : self, _ENV, mailDetail
      self:m_RefreshDeleteAndNewState()
      MsgCenter:Broadcast(eMsgEventId.OnMailDiff, {mailDetail})
    end
)
  end

  do
    if mailDetail.expiredTm < PlayerDataCenter.timestamp then
      local msgWin = UIManager:ShowWindow(UIWindowTypeID.MessageCommon)
      msgWin:ShowTextBoxWithYesAndNo(ConfigData:GetTipContent(337), function()
    -- function num : 0_8_1 , upvalues : cancelFunc
    cancelFunc()
  end
)
      return 
    end
    cancelFunc()
  end
end

New_MailController.ReqReceiveAttachment = function(self, uid)
  -- function num : 0_9 , upvalues : _ENV, CommonRewardData
  self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
  local _, rewardDic, _ = ((self.mailDataDic)[uid]):IsHaveAtt()
  local itemTransDic = {}
  for id,rewardNum in pairs(rewardDic) do
    local itemCfg = (ConfigData.item)[id]
    if itemCfg.overflow_type == eItemTransType.actMoneyX then
      local num = PlayerDataCenter:GetItemOverflowNum(id, rewardNum)
      if num ~= 0 then
        itemTransDic[id] = num
      end
    end
  end
  ;
  (self.network):CS_MAIL_ReceiveAttachment(uid, function()
    -- function num : 0_9_0 , upvalues : _ENV, rewardDic, CommonRewardData, self, itemTransDic
    UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_9_0_0 , upvalues : _ENV, rewardDic, CommonRewardData, self, itemTransDic
      if window == nil then
        return 
      end
      local rewardIds = {}
      local rewardNums = {}
      for id,num in pairs(rewardDic) do
        (table.insert)(rewardIds, id)
        ;
        (table.insert)(rewardNums, num)
      end
      local CRData = ((CommonRewardData.CreateCRDataUseList)(rewardIds, rewardNums)):SetCRHeroSnapshoot(self._heroIdSnapShoot)
      CRData:SetCRItemTransDic(itemTransDic)
      window:AddAndTryShowReward(CRData)
    end
)
  end
)
end

New_MailController.ReqDeleteOneMail = function(self, uid)
  -- function num : 0_10 , upvalues : _ENV
  -- DECOMPILER ERROR at PC11: Unhandled construct in 'MakeBoolean' P1

  if self.isDeleting and (self.mailDataDic)[uid] ~= nil then
    if self.waitDeletDic == nil then
      self.waitDeletDic = {}
    end
    -- DECOMPILER ERROR at PC13: Confused about usage of register: R2 in 'UnsetPending'

    ;
    (self.waitDeletDic)[uid] = true
  end
  do return  end
  self.isDeleting = true
  ;
  (self.network):CS_MAIL_Delete(uid, function()
    -- function num : 0_10_0 , upvalues : self, _ENV
    self.isDeleting = false
    if self.waitDeletDic ~= nil and (table.count)(self.waitDeletDic) > 0 then
      for uid,_ in pairs(self.waitDeletDic) do
        -- DECOMPILER ERROR at PC15: Confused about usage of register: R5 in 'UnsetPending'

        (self.waitDeletDic)[uid] = nil
        self:ReqDeleteOneMail(uid)
        do break end
      end
    else
      do
        self.waitDeletDic = nil
      end
    end
  end
)
end

New_MailController._GenAllMailRewardOverflowDic = function(self)
  -- function num : 0_11 , upvalues : _ENV
  local itemTransDic = {}
  for i,v in pairs(self.mailDataDic) do
    local tempItemTransDic = {}
    local haveReward, rewardDic, isPicked = v:IsHaveAtt()
    local isOverflow = false
    if haveReward and rewardDic and not isPicked then
      for id,rewardNum in pairs(rewardDic) do
        local itemCfg = (ConfigData.item)[id]
        if itemCfg then
          if itemCfg.type == eItemType.Arithmetic and (ConfigData.game_config).athMaxNum < #(PlayerDataCenter.allAthData):GetAllAthList() + rewardNum then
            isOverflow = true
            break
          end
          if itemCfg.overflow_type == eItemTransType.actMoneyX then
            local num = PlayerDataCenter:GetItemOverflowNum(id, rewardNum)
            if num ~= 0 then
              tempItemTransDic[id] = num
            end
          else
            do
              do
                local nowNum = PlayerDataCenter:GetItemCount(itemCfg.id)
                if itemCfg.holdlimit < nowNum + rewardNum then
                  isOverflow = true
                  break
                end
                -- DECOMPILER ERROR at PC66: LeaveBlock: unexpected jumping out DO_STMT

                -- DECOMPILER ERROR at PC66: LeaveBlock: unexpected jumping out IF_ELSE_STMT

                -- DECOMPILER ERROR at PC66: LeaveBlock: unexpected jumping out IF_STMT

                -- DECOMPILER ERROR at PC66: LeaveBlock: unexpected jumping out IF_THEN_STMT

                -- DECOMPILER ERROR at PC66: LeaveBlock: unexpected jumping out IF_STMT

              end
            end
          end
        end
      end
      if not isOverflow then
        for id,overflowNum in pairs(tempItemTransDic) do
          if itemTransDic[id] then
            itemTransDic[id] = itemTransDic[id] + overflowNum
          else
            itemTransDic[id] = overflowNum
          end
        end
      end
    end
  end
  self.itemTransDic = itemTransDic
end

New_MailController.ReqOneClickPickUp = function(self)
  -- function num : 0_12 , upvalues : _ENV, CommonRewardData
  if self.haveNotGetRewardMail then
    self:_GenAllMailRewardOverflowDic()
    self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
    ;
    (self.network):CS_MAIL_OneClickPickUp(function(args)
    -- function num : 0_12_0 , upvalues : _ENV, CommonRewardData, self
    if args ~= nil and args.Count > 0 then
      local update = args[0]
      do
        if update == nil then
          return 
        end
        local rewardDic = {}
        for uid,data in pairs(update) do
          for key,value in pairs((data.att).data) do
            if rewardDic[key] == nil then
              rewardDic[key] = value
            else
              rewardDic[key] = value + rewardDic[key]
            end
          end
        end
        local rewardIds = {}
        local rewardNums = {}
        for id,num in pairs(rewardDic) do
          (table.insert)(rewardIds, id)
          ;
          (table.insert)(rewardNums, R12_PC46)
        end
        UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
      -- function num : 0_12_0_0 , upvalues : CommonRewardData, rewardIds, rewardNums, self
      if window == nil then
        return 
      end
      local CRData = ((CommonRewardData.CreateCRDataUseList)(rewardIds, rewardNums)):SetCRHeroSnapshoot(self._heroIdSnapShoot)
      CRData:SetCRItemTransDic(self.itemTransDic)
      window:AddAndTryShowReward(CRData)
    end
)
      end
    else
      do
        ;
        ((CS.MessageCommon).ShowMessageTipsWithErrorSound)(ConfigData:GetTipContent(TipContent.ResourceOverflow))
      end
    end
  end
)
  end
end

New_MailController.ReqOneClickDelete = function(self)
  -- function num : 0_13
  if self.haveCouldDeleteMail then
    (self.network):CS_MAIL_OneKeyDelete()
  end
end

New_MailController.HasMailNotify = function(self)
  -- function num : 0_14 , upvalues : cs_MessageCommon, _ENV
  self.hasNotify = true
  ;
  (cs_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(TipContent.mail_Notice))
  local mailNode = RedDotController:AddRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Mail)
  mailNode:SetRedDotCount(1)
  local mailWin = UIManager:GetWindow(UIWindowTypeID.Mail)
  if mailWin ~= nil then
    self:ReqMailFetch(false)
  end
end

New_MailController.ReqMailFetch = function(self, waitRev, callback)
  -- function num : 0_15
  (self.network):CS_MAIL_Fetch(waitRev, callback)
end

New_MailController.RecvMailFetch = function(self)
  -- function num : 0_16
  self.hasNotify = false
  self:RefrshMailRedDot()
end

New_MailController.InitOrUpdateData = function(self, mailDetails, isInit)
  -- function num : 0_17 , upvalues : _ENV, MailData, MailEnum, NoticeData, JumpManager, HomeEnum
  local hasDiff = false
  local hasNew = false
  local needNoticeNew = false
  local diffDatas = {}
  for _,mailDetail in pairs(mailDetails) do
    if (self.mailDataDic)[mailDetail.uid] ~= nil then
      ((self.mailDataDic)[mailDetail.uid]):Update(mailDetail)
      hasDiff = true
      ;
      (table.insert)(diffDatas, (self.mailDataDic)[mailDetail.uid])
    else
      local mailData = (MailData.CreateMailData)(mailDetail)
      -- DECOMPILER ERROR at PC33: Confused about usage of register: R13 in 'UnsetPending'

      ;
      (self.mailDataDic)[mailDetail.uid] = mailData
      hasNew = true
      if not mailData:IsSignInRewardMail() then
        needNoticeNew = true
      end
    end
  end
  self:m_RefreshDeleteAndNewState()
  if hasDiff or hasNew then
    MsgCenter:Broadcast(eMsgEventId.OnMailDiff, diffDatas, hasNew)
  end
  if self.isUIOpen then
    self:StartAutoDeleteTimer()
  end
  self:RefrshMailRedDot()
  do
    if isInit then
      local latestTime = nil
      for _,mailData in pairs(self.mailDataDic) do
        if mailData:GetState() == (MailEnum.eMailDetailType).None and not mailData:IsSignInRewardMail() then
          local time = mailData:GetTime(true)
          if latestTime == nil or latestTime < time then
            latestTime = time
          end
        end
      end
      if latestTime ~= nil then
        NoticeManager:AddNotice((NoticeData.CreateNoticeData)(PlayerDataCenter.timestamp, (NoticeManager.eNoticeType).Mail, {jumpType = (JumpManager.eJumpTarget).Mail, argList = nil}, nil, nil))
      end
    end
    if not isInit and needNoticeNew then
      NoticeManager:AddNotice((NoticeData.CreateNoticeData)(latestTime, (NoticeManager.eNoticeType).Mail, {jumpType = (JumpManager.eJumpTarget).Mail, argList = nil}, nil, nil))
    end
    self.notPickedSinginMailUIDList = nil
    local homeController = ControllerManager:GetController(ControllerTypeId.HomeController)
    if homeController ~= nil and not homeController.isRunningAutoShow and homeController.homeState == (HomeEnum.eHomeState).Normal and homeController:ValidCouldOpenSinginReward() then
      homeController:AddAutoShowGuide((HomeEnum.eAutoShwoCommand).Singin)
    end
  end
end

New_MailController.DeleteData = function(self, delete)
  -- function num : 0_18 , upvalues : _ENV
  for uid,_ in pairs(delete) do
    if (self.mailDataDic)[uid] ~= nil then
      ((self.mailDataDic)[uid]):Delete()
      -- DECOMPILER ERROR at PC13: Confused about usage of register: R7 in 'UnsetPending'

      ;
      (self.mailDataDic)[uid] = nil
    end
  end
  self:m_RefreshDeleteAndNewState()
  self:RefrshMailRedDot()
  MsgCenter:Broadcast(eMsgEventId.OnMailDelete, delete)
end

New_MailController.m_RefreshDeleteAndNewState = function(self)
  -- function num : 0_19 , upvalues : _ENV, MailEnum
  self.haveCouldDeleteMail = false
  self.haveNotGetRewardMail = false
  local haveNeedNoticeMail = false
  for _,mailData in pairs(self.mailDataDic) do
    local isHaveAtt, attDic, isPicked = mailData:IsHaveAtt()
    if isHaveAtt and not isPicked then
      self.haveNotGetRewardMail = true
    else
      if isHaveAtt and isPicked and not mailData:GetIsTreasure() then
        self.haveCouldDeleteMail = true
      else
        if not isHaveAtt and mailData:GetState() ~= (MailEnum.eMailDetailType).None and not mailData:GetIsTreasure() then
          self.haveCouldDeleteMail = true
        end
      end
    end
    if mailData:GetState() == (MailEnum.eMailDetailType).None then
      haveNeedNoticeMail = true
    end
  end
  do
    if (self.haveCouldDeleteMail and self.haveNotGetRewardMail and haveNeedNoticeMail) or not haveNeedNoticeMail then
      NoticeManager:DeleteNoticeByType((NoticeManager.eNoticeType).Mail)
    end
  end
end

New_MailController.SetOnlyShowTreasureMail = function(self, bool)
  -- function num : 0_20
  self.isOnlyShowTreasureMail = bool
end

New_MailController.GetOnlyShowTreasureMail = function(self)
  -- function num : 0_21
  return self.isOnlyShowTreasureMail
end

New_MailController.GetMailDataList = function(self)
  -- function num : 0_22 , upvalues : _ENV
  local list = {}
  for _,data in pairs(self.mailDataDic) do
    if (data:GetCouldShow() and not self.isOnlyShowTreasureMail) or data:GetCouldShow() and self.isOnlyShowTreasureMail and data:GetIsTreasure() then
      (table.insert)(list, data)
    end
  end
  ;
  (table.sort)(list, function(a, b)
    -- function num : 0_22_0
    if a.status == b.status then
      local aTreasure = a:GetIsTreasure()
      local bTreasure = b:GetIsTreasure()
      if aTreasure ~= bTreasure then
        return aTreasure
      end
      if b.uid >= a.uid then
        do
          do return a:GetTime(true) ~= b:GetTime(true) end
          do return b:GetTime(true) < a:GetTime(true) end
          do return a.status < b.status end
          -- DECOMPILER ERROR: 6 unprocessed JMP targets
        end
      end
    end
  end
)
  return list
end

New_MailController.GetMailTreasureCount = function(self)
  -- function num : 0_23 , upvalues : _ENV
  local count = 0
  for _,data in pairs(self.mailDataDic) do
    if data:GetCouldShow() and data:GetIsTreasure() then
      count = count + 1
    end
  end
  return count
end

New_MailController.GetSignInRewardMailUIDs = function(self, isNotFirstGetSignInReward, notRead, onlyMonthCard)
  -- function num : 0_24 , upvalues : _ENV, MailEnum
  if self.notPickedSinginMailUIDList ~= nil then
    return self.notPickedSinginMailUIDList
  end
  local notPickedSinginMailUIDList = {}
  for _,mailData in pairs(self.mailDataDic) do
    do
      -- DECOMPILER ERROR at PC30: Unhandled construct in 'MakeBoolean' P1

      if mailData:IsSignInRewardMail() and (not onlyMonthCard or mailData:IsSignInMonthCardReward()) and isNotFirstGetSignInReward and mailData:GetState() == (MailEnum.eMailDetailType).None then
        local isHaveReward, _, isPicked = mailData:IsHaveAtt()
        if isHaveReward and not isPicked then
          (table.insert)(notPickedSinginMailUIDList, mailData.uid)
        end
      end
      if not notRead then
        self:ReqMailRead(mailData.uid)
      end
      do
        local isHaveReward, _, isPicked = mailData:IsHaveAtt()
        if isHaveReward and not isPicked then
          (table.insert)(notPickedSinginMailUIDList, mailData.uid)
        end
        -- DECOMPILER ERROR at PC56: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  return notPickedSinginMailUIDList
end

New_MailController.StartAutoDeleteTimer = function(self)
  -- function num : 0_25 , upvalues : _ENV
  if self.m_outDataTimerId ~= nil then
    TimerManager:StopTimer(self.m_outDataTimerId)
    self.m_outDataTimerId = nil
  end
  if (table.count)(self.mailDataDic) > 0 then
    local time = self:GetLatestRefreshTm()
    self.m_outDataTimerId = TimerManager:StartTimer(time, (BindCallback(self, self.DeletAllOutDataMail, true)), nil, true, false, true)
  end
end

New_MailController.GetLatestRefreshTm = function(self)
  -- function num : 0_26 , upvalues : _ENV
  local seconds = math.maxinteger
  for _,data in pairs(self.mailDataDic) do
    seconds = (math.min)(data:GetTimeBeforeExpired(), seconds)
  end
  return seconds
end

New_MailController.DeletAllOutDataMail = function(self, isFromTimer)
  -- function num : 0_27 , upvalues : _ENV
  if isFromTimer == true then
    self.m_outDataTimerId = nil
  end
  local delete = {}
  for uid,data in pairs(self.mailDataDic) do
    if data:GetTimeBeforeExpired() <= 0 and not data.isTreasure then
      ((self.mailDataDic)[uid]):Delete()
      -- DECOMPILER ERROR at PC20: Confused about usage of register: R8 in 'UnsetPending'

      ;
      (self.mailDataDic)[uid] = nil
      delete[uid] = true
    end
  end
  if (table.count)(delete) > 0 then
    self:RefrshMailRedDot()
    MsgCenter:Broadcast(eMsgEventId.OnMailDelete, delete)
  end
end

New_MailController.RefrshMailRedDot = function(self)
  -- function num : 0_28 , upvalues : _ENV, MailEnum
  local mailNode = RedDotController:AddRedDotNode(RedDotStaticTypeId.Main, RedDotStaticTypeId.Mail)
  if not FunctionUnlockMgr:ValidateUnlock(proto_csmsg_SystemFunctionID.SystemFunctionID_Mail) then
    mailNode:SetRedDotCount(0)
    return 
  end
  for uid,mailData in pairs(self.mailDataDic) do
    if mailData:GetCouldShow() then
      if mailData:GetState() == (MailEnum.eMailDetailType).None then
        mailNode:SetRedDotCount(1)
        return 
      else
        if mailData:GetState() == (MailEnum.eMailDetailType).Read and mailData:IsHaveAtt() then
          mailNode:SetRedDotCount(1)
          return 
        end
      end
    end
  end
  if self.hasNotify then
    mailNode:SetRedDotCount(1)
    return 
  end
  mailNode:SetRedDotCount(0)
end

New_MailController.OnDelete = function(self)
  -- function num : 0_29 , upvalues : _ENV
  if self.m_outDataTimerId ~= nil then
    TimerManager:StopTimer(self.m_outDataTimerId)
    self.m_outDataTimerId = nil
  end
end

return New_MailController

