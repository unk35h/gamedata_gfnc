-- params : ...
-- function num : 0 , upvalues : _ENV
local UIEventWeeklyQAMain = class("UIEventWeeklyQAMain", UIBaseWindow)
local base = UIBaseWindow
local UINEventWeeklyQAQuestionNode = require("Game.EventWeeklyQA.UI.UINEventWeeklyQAQuestionNode")
local UInSectorTaskRewardFloat = require("Game.Sector.SectorTask.UInSectorTaskRewardFloat")
local EventWeeklyQAQuestionRewardData = require("Game.EventWeeklyQA.Data.EventWeeklyQAQuestionRewardData")
local UINWeeklyQARewardItem = require("Game.EventWeeklyQA.UI.UINWeeklyQARewardItem")
local FloatAlignEnum = require("Game.CommonUI.FloatWin.FloatAlignEnum")
local HAType = FloatAlignEnum.HAType
local VAType = FloatAlignEnum.VAType
local CS_MessageCommon = CS.MessageCommon
UIEventWeeklyQAMain.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UInSectorTaskRewardFloat, UINEventWeeklyQAQuestionNode
  self.eventWeeklyQAController = ControllerManager:GetController(ControllerTypeId.EventWeeklyQA, true)
  self.__OnClickRewardFunc = BindCallback(self, self.OnClickRewardItem)
  self.viewReward = (UInSectorTaskRewardFloat.New)()
  ;
  (self.viewReward):Init((self.ui).viewReward)
  self.questionNode = (UINEventWeeklyQAQuestionNode.New)()
  ;
  (self.questionNode):Init((self.ui).obj_questionNode)
  ;
  (self.questionNode):Hide()
  ;
  ((self.ui).obj_allRightNode):SetActive(false)
  ;
  ((self.ui).obj_finishNode):SetActive(false)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_check, self, self.InitEventWeeklyQA)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_again, self, self.InitEventWeeklyQA)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_tips, self, self.__ShowWeeklyQAGuideTip)
end

UIEventWeeklyQAMain.InitEventWeeklyQA = function(self, actId)
  -- function num : 0_1 , upvalues : CS_MessageCommon, _ENV
  if self.qaData ~= nil and (self.qaData):GetQADataIsExpired() then
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7804))
    return 
  end
  ;
  (self.eventWeeklyQAController):ShowWindowByWeeklyQAData()
end

UIEventWeeklyQAMain.RefreshWeeklyQAByQAData = function(self, qaData)
  -- function num : 0_2 , upvalues : CS_MessageCommon, _ENV
  self.qaData = qaData
  ;
  ((self.ui).obj_allRightNode):SetActive(false)
  ;
  ((self.ui).obj_finishNode):SetActive(false)
  ;
  (self.questionNode):InitWeeklyQAQuestionNodeByQAData(qaData)
  ;
  (self.questionNode):Show()
  self:SetCharacterTalkLabel()
  self:RefreshWeeklyQARewards(qaData)
  if qaData:GetQADataIsExpired() then
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7804))
    return 
  end
  qaData:SetWeeklyQADataLooked()
end

UIEventWeeklyQAMain.RefreshWeeklyQARewards = function(self, qaData)
  -- function num : 0_3 , upvalues : _ENV, UINWeeklyQARewardItem
  if not self.rewardItems then
    local rewardItems = {}
  end
  for index,rewardData in ipairs(qaData.rewards) do
    do
      do
        if rewardItems[index] == nil then
          local rewardItem = (UINWeeklyQARewardItem.New)()
          rewardItem:Init(((self.ui).obj_rewardItems)[index])
          rewardItems[index] = rewardItem
        end
        ;
        (rewardItems[index]):InitWeeklyQARewardItem(index, rewardData.currentState, rewardData.needScore, self.__OnClickRewardFunc)
        -- DECOMPILER ERROR at PC26: LeaveBlock: unexpected jumping out DO_STMT

      end
    end
  end
  self.rewardItems = rewardItems
end

UIEventWeeklyQAMain.ShowAllRightNode = function(self)
  -- function num : 0_4
  (self.questionNode):Hide()
  ;
  ((self.ui).obj_allRightNode):SetActive(true)
  ;
  ((self.ui).obj_finishNode):SetActive(false)
  self:SetCharacterTalkLabel()
  ;
  (self.eventWeeklyQAController):RecordCurrentQuestionIndex(self.qaData, (((self.qaData).questions)[1]).questionId)
  ;
  (self.qaData):ReFlushAllQuestionOptions()
end

UIEventWeeklyQAMain.ShowFinishNode = function(self)
  -- function num : 0_5
  (self.questionNode):Hide()
  ;
  ((self.ui).obj_allRightNode):SetActive(false)
  ;
  ((self.ui).obj_finishNode):SetActive(true)
  self:SetCharacterTalkLabel()
  ;
  (self.eventWeeklyQAController):RecordCurrentQuestionIndex(self.qaData, (((self.qaData).questions)[1]).questionId)
  ;
  (self.qaData):ReFlushAllQuestionOptions()
end

UIEventWeeklyQAMain.SetResultItemByIndex = function(self, index, newState)
  -- function num : 0_6
  (self.questionNode):SetResultItemByIndex(index, newState)
end

UIEventWeeklyQAMain.SetCharacterTalkLabel = function(self)
  -- function num : 0_7 , upvalues : _ENV
  -- DECOMPILER ERROR at PC11: Confused about usage of register: R1 in 'UnsetPending'

  if (self.qaData):CheckIsAllRight() then
    ((self.ui).tex_talkLable).text = ConfigData:GetTipContent(7803)
  else
    -- DECOMPILER ERROR at PC19: Confused about usage of register: R1 in 'UnsetPending'

    ;
    ((self.ui).tex_talkLable).text = ConfigData:GetTipContent(7802)
  end
end

UIEventWeeklyQAMain.__ShowAchivRewardsFloatWin = function(self, rewardItem, achivRewardIds, achivRewardNums)
  -- function num : 0_8 , upvalues : HAType, VAType, _ENV
  (self.viewReward):FloatTo(rewardItem.transform, HAType.autoCenter, VAType.up)
  ;
  (self.viewReward):RefreshItems(achivRewardIds, achivRewardNums, function()
    -- function num : 0_8_0 , upvalues : rewardItem
    rewardItem:SetViewState(false)
  end
)
  ;
  (self.viewReward):Show()
  rewardItem:SetViewState(true)
  AudioManager:PlayAudioById(1055)
end

UIEventWeeklyQAMain.OnClickRewardItem = function(self, item, index)
  -- function num : 0_9 , upvalues : CS_MessageCommon, _ENV, EventWeeklyQAQuestionRewardData
  if (self.qaData):GetQADataIsExpired() then
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7804))
    return 
  end
  local rewardData = ((self.qaData).rewards)[index]
  if rewardData.currentState == (EventWeeklyQAQuestionRewardData.eRewardState).CompleteNoPicked then
    item:SetPicking(true)
    ;
    (self.eventWeeklyQAController):ReqGetWeeklyQAReward(self.qaData, rewardData.needScore, function()
    -- function num : 0_9_0 , upvalues : item, _ENV, self, rewardData
    item:SetPicking(false)
    AudioManager:PlayAudioById(1120)
    ;
    (self.qaData):SetWeeklyQARewardGotten(rewardData.needScore)
    self:RefreshWeeklyQARewards(self.qaData)
  end
)
  else
    self:__ShowAchivRewardsFloatWin(item, (rewardData.rewardCfg).rewardIds, (rewardData.rewardCfg).rewardNums)
  end
end

UIEventWeeklyQAMain.__ShowWeeklyQAGuideTip = function(self)
  -- function num : 0_10 , upvalues : CS_MessageCommon, _ENV
  if (self.qaData):GetQADataIsExpired() then
    (CS_MessageCommon.ShowMessageTips)(ConfigData:GetTipContent(7804))
    return 
  end
  UIManager:ShowWindowAsync(UIWindowTypeID.CommonInfo, function(window)
    -- function num : 0_10_0 , upvalues : _ENV, self
    if window == nil then
      return 
    end
    window:InitCommonInfo(ConfigData:GetTipContent(((self.qaData):GetWeeklyQAMainCfg()).rule_des), (ConfigData:GetTipContent(((self.qaData):GetWeeklyQAMainCfg()).rule_title)), nil)
  end
)
end

UIEventWeeklyQAMain.OnDelete = function(self)
  -- function num : 0_11
  if self.questionNode ~= nil then
    (self.questionNode):Delete()
  end
end

return UIEventWeeklyQAMain

