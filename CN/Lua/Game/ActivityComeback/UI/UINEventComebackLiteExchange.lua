-- params : ...
-- function num : 0 , upvalues : _ENV
local UINEventComebackExchange = require("Game.ActivityComeback.UI.UINEventComebackExchange")
local UINEventComebackLiteExchange = class("UINEventComebackLiteExchange", UINEventComebackExchange)
local base = UINEventComebackExchange
local CS_Resloader = CS.ResLoader
local CS_MessageCommon = CS.MessageCommon
local UINEventComebackExchangeReward = require("Game.ActivityComeback.UI.UINEventComebackExchangeReward")
local UINEventComebackLiteExchangeShow = require("Game.ActivityComeback.UI.UINEventComebackLiteExchangeShow")
UINEventComebackLiteExchange.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINEventComebackExchangeReward, UINEventComebackLiteExchangeShow
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Des, self, self.__OnClickShow)
  self.__OnClickChangeNumAddCallback = BindCallback(self, self.__OnClickChangeNum, true)
  self.__OnClickChangeNumReduceCallback = BindCallback(self, self.__OnClickChangeNum, false)
  ;
  (((self.ui).btn_Min).onPress):AddListener(self.__OnClickChangeNumReduceCallback)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Min, self.__OnClickChangeNumReduceCallback)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Least, self, self.__OnhangeMinNum)
  ;
  (((self.ui).btn_Add).onPress):AddListener(self.__OnClickChangeNumAddCallback)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Add, self.__OnClickChangeNumAddCallback)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Max, self, self.__OnChangeMaxNum)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Exchange, self, self.__OnClickLottery)
  ;
  (((self.ui).inputField).onEndEdit):AddListener(BindCallback(self, self.__OnClickInputNum))
  self._itemPool = (UIItemPool.New)(UINEventComebackExchangeReward, (self.ui).itemNode)
  ;
  ((self.ui).itemNode):SetActive(false)
  self._colorLottery = ((self.ui).img_Exchange).color
  -- DECOMPILER ERROR at PC100: Confused about usage of register: R1 in 'UnsetPending'

  ;
  ((self.ui).tex_Des).text = ConfigData:GetTipContent(7409)
  self.__RefreshLotteryTimesStateCallback = BindCallback(self, self.__RefreshLotteryTimesState)
  MsgCenter:AddListener(eMsgEventId.UpdateItem, self.__RefreshLotteryTimesStateCallback)
  self._rewardShowNode = (UINEventComebackLiteExchangeShow.New)()
  ;
  (self._rewardShowNode):Init((self.ui).rewardList)
end

UINEventComebackLiteExchange.InitComebackExchange = function(self, id)
  -- function num : 0_1 , upvalues : _ENV
  local activityRoundCtrl = ControllerManager:GetController(ControllerTypeId.ActivityRound)
  if activityRoundCtrl == nil then
    error("奖池抽奖活动不存在")
    return 
  end
  self._roundData = activityRoundCtrl:GetActivityRound(id)
  if self._roundData == nil then
    error("奖池抽奖活动不存在")
    return 
  end
  local curRoundId = (self._roundData):GetCurRoundId()
  self._poolData = (self._roundData):GetRoundPoolData(curRoundId)
  self._roundIdList = (self._roundData):GetRoundIds()
  local allCount = #self._roundIdList
  self.curIndex = (table.indexof)(self._roundIdList, curRoundId)
  self:__RefreshPool()
  ;
  (self._rewardShowNode):Hide()
end

UINEventComebackLiteExchange.__RefreshPool = function(self)
  -- function num : 0_2 , upvalues : _ENV, CS_Resloader
  -- DECOMPILER ERROR at PC10: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).tex_Count).text = (self._poolData):GetRoundTimes() .. "/" .. (self._poolData):GetRoundTotalTimes()
  local poolparaCfg = (self._poolData):GetPoolParaCfg()
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).tex_Title).text = (LanguageUtil.GetLocaleText)(poolparaCfg.pool_name)
  if self._resloader ~= nil then
    (self._resloader):Put2Pool()
    self._resloader = nil
  end
  self._resloader = (CS_Resloader.Create)()
  ;
  (((self.ui).img_Gift).gameObject):SetActive(false)
  ;
  (self._resloader):LoadABAssetAsync(PathConsts:GetRoundRewardPoolPic(poolparaCfg.poolimg_name), function(texture)
    -- function num : 0_2_0 , upvalues : _ENV, self
    if IsNull(texture) then
      error("comeback_exchange texture MISS")
      return 
    end
    ;
    (((self.ui).img_Gift).gameObject):SetActive(true)
    -- DECOMPILER ERROR at PC17: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).img_Gift).texture = texture
  end
)
  local bigRewardIds = poolparaCfg.reward_id
  self._rewardItemDic = {}
  ;
  (self._itemPool):HideAll()
  for _,rewardId in ipairs(bigRewardIds) do
    local usedMun, allNum = (self._poolData):GetRoundSingleRewardCount(rewardId)
    local poolContent = (poolparaCfg.poolContent)[rewardId]
    local item = (self._itemPool):GetOne()
    local remainCount = allNum - usedMun
    item:InitExchangeReward(poolContent.rewardId, poolContent.rewardNum, remainCount)
    -- DECOMPILER ERROR at PC71: Confused about usage of register: R13 in 'UnsetPending'

    ;
    (self._rewardItemDic)[rewardId] = item
  end
  -- DECOMPILER ERROR at PC81: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).icon_Cost).sprite = CRH:GetSpriteByItemId(poolparaCfg.costId, true)
  self._lotteryTimes = self:__ClampLotteryCount(1)
  -- DECOMPILER ERROR at PC91: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).inputField).text = tostring(self._lotteryTimes)
  self:__RefreshLotteryTimesState()
end

UINEventComebackLiteExchange.__CanLottery = function(self, showTip)
  -- function num : 0_3 , upvalues : CS_MessageCommon, _ENV
  if not (self._roundData):IsUnlockPool((self._poolData):GetRoundId()) and showTip then
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7402))
  end
  do return  end
  if (self._poolData):GetRoundRemainTimes() <= 0 then
    if showTip then
      (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7404))
    end
    return false
  end
  local poolparaCfg = (self._poolData):GetPoolParaCfg()
  local costId = poolparaCfg.costId
  local costNum = poolparaCfg.costNum * self._lotteryTimes
  local hasNum = PlayerDataCenter:GetItemCount(costId)
  if hasNum < costNum then
    if showTip then
      (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7405))
    end
    return false
  end
  return true
end

return UINEventComebackLiteExchange

