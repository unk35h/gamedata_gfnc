-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEventWeChat = class("UIEventWeChat", UIBaseWindow)
local base = UIBaseWindow
local CommonRewardData = require("Game.CommonUI.CommonRewardData")
local UIItemPool = require("Game.CommonUI.UIItemPool")
local UINEventWeChatItem = require("Game.EventNoviceSign.UI.UINEventWeChatItem")
local ActivityFrameEnum = require("Game.ActivityFrame.ActivityFrameEnum")
UIEventWeChat.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UIItemPool, UINEventWeChatItem
  self.resloader = ((CS.ResLoader).Create)()
  self.itemPool = (UIItemPool.New)(UINEventWeChatItem, (self.ui).item)
  ;
  ((self.ui).item):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_GetReward, self, self.GetRewardClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_CopyKey, self, self.CopyKeyClicked)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self.OnClickInfo)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_QRCode, self, self.QRCodeClicked)
  self.WechatUpdata = BindCallback(self, self.__WechatUpdata)
  MsgCenter:AddListener(eMsgEventId.WechatUpdata, self.WechatUpdata)
end

UIEventWeChat.InitWeChat = function(self, id)
  -- function num : 0_1 , upvalues : _ENV, ActivityFrameEnum
  self.actId = id
  self.data = (ConfigData.wechat_activity)[id]
  self.actFrameCtr = ControllerManager:GetController(ControllerTypeId.ActivityFrame)
  if self.actFrameCtr == nil then
    error("微信关注活动页面获取不到活动控制器！")
  end
  self.states = ((self.actFrameCtr).wechatActivityElems)[self.actId]
  ;
  (self.itemPool):HideAll()
  for k,v in pairs((self.data).awardIds) do
    local item = (self.itemPool):GetOne()
    local itemCfg = (ConfigData.item)[v]
    local itemNums = ((self.data).awardCounts)[k]
    item:InitWeChatItem(itemCfg, v, itemNums, self.resloader)
  end
  -- DECOMPILER ERROR at PC51: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Key).text = (self.states).token
  self:RefreshNoviceSign()
  local actData = (self.actFrameCtr):GetActivityFrameDataByTypeAndId((ActivityFrameEnum.eActivityType).Tickets, id)
  self._actData = actData
  -- DECOMPILER ERROR at PC64: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = actData.name
  self._actName = actData.name
  local resPath = PathConsts:GetCharacterBigImgPrefabPath((self.data).res_name)
  ;
  (self.resloader):LoadABAssetAsync(resPath, function(prefab)
    -- function num : 0_1_0 , upvalues : _ENV, self, resPath
    if IsNull(prefab) then
      return 
    end
    local charGo = prefab:Instantiate((self.ui).heroHolder)
    local commonPicCtrl = charGo:FindComponent(eUnityComponentID.CommonPicController)
    if commonPicCtrl ~= nil then
      commonPicCtrl:SetPosType("EventWeChat")
    else
      error("CommonPicController MISS , path: " .. resPath)
    end
  end
)
  local endTime = actData:GetActivityEndTime()
  if endTime < 0 then
    (((self.ui).tex_TimeTips).gameObject):SetActive(false)
    return 
  else
    ;
    (((self.ui).tex_TimeTips).gameObject):SetActive(true)
    self:_UpdEndTime()
    TimerManager:StopTimer(self.__endTimer)
    self.__endTimer = TimerManager:StartTimer(2, self._UpdEndTime, self, false)
  end
end

UIEventWeChat._UpdEndTime = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local endTime = (self._actData):GetActivityEndTime()
  local lastTime = (math.max)((math.floor)(endTime - PlayerDataCenter.timestamp), 0)
  local d, h, m, s = TimeUtil:TimestampToTimeInter(lastTime, false, true)
  if s > 0 then
    m = m + 1
  end
  ;
  ((self.ui).tex_TimeTips):SetIndex(0, tostring(d), tostring(h), tostring(m))
end

UIEventWeChat.GetRewardClicked = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local actFrameCtr = NetworkManager:GetNetwork(NetworkTypeID.ActivityFrame)
  actFrameCtr:CS_ACTIVITY_Wechat_Follow_Take(self.actId, BindCallback(self, self.RewardClickedBack))
end

UIEventWeChat.RewardClickedBack = function(self)
  -- function num : 0_4 , upvalues : _ENV, CommonRewardData
  self._heroIdSnapShoot = PlayerDataCenter:TakeHeroIdSnapShoot()
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonReward, function(window)
    -- function num : 0_4_0 , upvalues : CommonRewardData, self
    if window == nil then
      return 
    end
    local CRData = (((CommonRewardData.CreateCRDataUseList)((self.data).awardIds, (self.data).awardCounts)):SetCRHeroSnapshoot(self._heroIdSnapShoot, false)):SetCRNotHandledGreat(true)
    window:AddAndTryShowReward(CRData)
  end
)
end

UIEventWeChat.__WechatUpdata = function(self)
  -- function num : 0_5
  self.states = ((self.actFrameCtr).wechatActivityElems)[self.actId]
  self:RefreshNoviceSign()
end

UIEventWeChat.RefreshNoviceSign = function(self)
  -- function num : 0_6
  if (self.states).followed == false then
    ((self.ui).btn_CantGetReward):SetActive(true)
    ;
    ((self.ui).tex_CantGetReward):SetIndex(0)
    ;
    (((self.ui).btn_GetReward).gameObject):SetActive(false)
  else
    if (self.states).followed == true and (self.states).redeemed == true then
      ((self.ui).btn_CantGetReward):SetActive(true)
      ;
      ((self.ui).tex_CantGetReward):SetIndex(1)
      ;
      (((self.ui).btn_GetReward).gameObject):SetActive(false)
    else
      ;
      ((self.ui).btn_CantGetReward):SetActive(false)
      ;
      (((self.ui).btn_GetReward).gameObject):SetActive(true)
    end
  end
  if (self.states).redeemed == false then
    self:RefreshItem(false)
  else
    self:RefreshItem(true)
  end
end

UIEventWeChat.CopyKeyClicked = function(self)
  -- function num : 0_7 , upvalues : _ENV
  -- DECOMPILER ERROR at PC6: Confused about usage of register: R1 in 'UnsetPending'

  ((CS.UnityEngine).GUIUtility).systemCopyBuffer = ((self.ui).tex_Key).text
  ;
  ((CS.MessageCommon).ShowMessageTips)(ConfigData:GetTipContent(TipContent.UserInfo_CopyUIDDone))
  AudioManager:PlayAudioById(1124)
end

UIEventWeChat.RefreshItem = function(self, hasGet)
  -- function num : 0_8 , upvalues : _ENV
  for i,v in ipairs((self.itemPool).listItem) do
    v:RefreshItem(hasGet)
  end
end

UIEventWeChat.OnClickInfo = function(self)
  -- function num : 0_9 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.EventWeChatInformation, function(window)
    -- function num : 0_9_0 , upvalues : self
    window:InitWeChatInfo(self._actName)
  end
)
end

UIEventWeChat.QRCodeClicked = function(self)
  -- function num : 0_10 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.EventWeChatViewQRCode)
end

UIEventWeChat.SetCloseCallback = function(self, callback)
  -- function num : 0_11
end

UIEventWeChat.OnDelete = function(self)
  -- function num : 0_12 , upvalues : _ENV, base
  (self.itemPool):DeleteAll()
  if self.resloader ~= nil then
    (self.resloader):Put2Pool()
    self.resloader = nil
  end
  MsgCenter:RemoveListener(eMsgEventId.WechatUpdata, self.WechatUpdata)
  TimerManager:StopTimer(self.__endTimer)
  ;
  (base.OnDelete)(self)
end

return UIEventWeChat

