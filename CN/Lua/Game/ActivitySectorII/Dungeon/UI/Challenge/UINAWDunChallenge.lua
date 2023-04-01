-- params : ...
-- function num : 0 , upvalues : _ENV
local UINAWDunChallenge = class("UINAWDunChallenge", UIBaseNode)
local base = UIBaseNode
local UINBaseItemWithCount = require("Game.CommonUI.Item.UINBaseItemWithCount")
UINAWDunChallenge.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINBaseItemWithCount
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_rewardInfo, self, self._OnClickRewardInfo)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Root, self, self._OnClickRoot)
  self.rewardItemPool = (UIItemPool.New)(UINBaseItemWithCount, (self.ui).uINBaseItemWithCount, false)
  ;
  ((self.ui).emptyReward):SetActive(false)
  self.emptyRewardGoDic = {[3] = (self.ui).emptyReward}
  self.__OnSettleFunc = BindCallback(self, self._OnSettle)
  MsgCenter:AddListener(eMsgEventId.WinterChallengeSettle, self.__OnSettleFunc)
end

UINAWDunChallenge.InitAWDunChallenge = function(self, sectorIIData, clickFunc)
  -- function num : 0_1 , upvalues : _ENV
  self.clickFunc = clickFunc
  self.sectorIIData = sectorIIData
  local chanllegeDgData = sectorIIData:GetActvWinChallengeDgData()
  self.chanllegeDgData = chanllegeDgData
  local pos = chanllegeDgData:GetSectorIIChallengeLvPos()
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self.transform).anchoredPosition = pos
  local unlock = chanllegeDgData:GetIsLevelUnlock()
  ;
  ((self.ui).scoreNode):SetActive(unlock)
  ;
  ((self.ui).img_Locked):SetActive(not unlock)
  if unlock then
    self:_UpdateScore()
    self:_UpdCompleteState()
  else
    local unlockList = (CheckCondition.GetUnlockAndInfoList)(chanllegeDgData:GetLevelUnlockConditionCfg())
    for k,v in ipairs(unlockList) do
      -- DECOMPILER ERROR at PC43: Confused about usage of register: R12 in 'UnsetPending'

      if not v.unlock then
        ((self.ui).tex_Unlock).text = v.lockReason
        break
      end
    end
  end
end

UINAWDunChallenge._UpdateScore = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local maxScore = (self.chanllegeDgData):GetSctIIChallengeDgMaxScore()
  local maxHisScore = (self.chanllegeDgData):GetSctIIChallengeDgHisMaxScore()
  local realMaxScore = (math.max)(maxScore, maxHisScore)
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_CurPoint).text = tostring(maxScore)
  local rewardListCfg = (self.chanllegeDgData):GetSectorIIChallengeRewardListCfg()
  self.rewardListCfg = rewardListCfg
  local curPhase = 0
  for k,v in ipairs(rewardListCfg) do
    if v.need_point <= realMaxScore then
      curPhase = k
    else
      break
    end
  end
  do
    self.curPhase = curPhase
    local maxPhase = #rewardListCfg
    local nextPhase = (math.min)(curPhase + 1, maxPhase)
    -- DECOMPILER ERROR at PC51: Confused about usage of register: R8 in 'UnsetPending'

    ;
    ((self.ui).tex_Stage).text = tostring(nextPhase) .. "/" .. tostring(maxPhase)
    local isMaxStage = maxPhase <= curPhase
    if isMaxStage then
      ((self.ui).tex_Point):SetIndex(1)
    else
      local stageScore = 0
      local rewardCfg = rewardListCfg[nextPhase]
      if rewardCfg ~= nil then
        stageScore = rewardCfg.need_point
      end
      ;
      ((self.ui).tex_Point):SetIndex(0, tostring(stageScore))
      ;
      (self.rewardItemPool):HideAll()
      for i = 1, 3 do
        local rewardId = (rewardCfg.rewardIds)[i]
        local rewardNum = (rewardCfg.rewardNums)[i]
        if rewardId == nil then
          local emptyGo = (self.emptyRewardGoDic)[i]
          if emptyGo == nil then
            emptyGo = ((self.ui).emptyReward):Instantiate()
            -- DECOMPILER ERROR at PC100: Confused about usage of register: R18 in 'UnsetPending'

            ;
            (self.emptyRewardGoDic)[i] = emptyGo
          end
          emptyGo:SetActive(true)
          ;
          (emptyGo.transform):SetAsLastSibling()
        else
          local rewardItem = (self.rewardItemPool):GetOne()
          local itemCfg = (ConfigData.item)[rewardId]
          rewardItem:InitItemWithCount(itemCfg, rewardNum)
          if (self.emptyRewardGoDic)[i] ~= nil then
            ((self.emptyRewardGoDic)[i]):SetActive(false)
          end
        end
      end
    end
    ;
    ((self.ui).obj_ReceivedAll):SetActive(isMaxStage)
    -- DECOMPILER ERROR: 7 unprocessed JMP targets
  end
end

UINAWDunChallenge._OnSettle = function(self)
  -- function num : 0_3
  self:_UpdateScore()
  self:_UpdCompleteState()
end

UINAWDunChallenge._UpdCompleteState = function(self)
  -- function num : 0_4
  local isFinish, inDungeon = (self.chanllegeDgData):GetSctIIChallengeDgStage()
  ;
  ((self.ui).img_Continue):SetActive(inDungeon)
end

UINAWDunChallenge._OnClickRewardInfo = function(self)
  -- function num : 0_5 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.StageRewardPreview, function(win)
    -- function num : 0_5_0 , upvalues : self
    if win == nil then
      win:InitUIStageRewardPreview(self.rewardListCfg, self.curPhase)
    end
  end
)
end

UINAWDunChallenge._OnClickRoot = function(self)
  -- function num : 0_6
  local challengeDgData = (self.sectorIIData):GetActvWinChallengeDgData()
  if self.clickFunc ~= nil then
    (self.clickFunc)(self, challengeDgData)
  end
end

UINAWDunChallenge.OnDelete = function(self)
  -- function num : 0_7 , upvalues : _ENV, base
  (self.rewardItemPool):DeleteAll()
  MsgCenter:RemoveListener(eMsgEventId.WinterChallengeSettle, self.__OnSettleFunc)
  ;
  (base.OnDelete)(self)
end

return UINAWDunChallenge

