-- params : ...
-- function num : 0 , upvalues : _ENV
local UINFmtChallengeTask = class("UINFmtChallengeTask", UIBaseNode)
local base = UIBaseNode
local UINCommonSwitchToggle = require("Game.CommonUI.CommonSwitchToggle.UINCommonSwitchToggle")
UINFmtChallengeTask.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINCommonSwitchToggle
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).btn_Info, self, self._OnClickInfo)
  self._switchTog = (UINCommonSwitchToggle.New)()
  ;
  (self._switchTog):Init((self.ui).tog_Switch)
  ;
  (self._switchTog):CommonSwitchTogAutoSetValue(false)
  self._changeValueFunc = BindCallback(self, self._OnClickTogSwitch)
  self._OnChallengeTaskChangeFunc = BindCallback(self, self._OnChallengeTaskChange)
  MsgCenter:AddListener(eMsgEventId.OnStageChanllengeTaskChange, self._OnChallengeTaskChangeFunc)
end

UINFmtChallengeTask.InitFmtChallengeTask = function(self, fmtCtrl, enterFmtData, editorNodeUI)
  -- function num : 0_1
  self.fmtCtrl = fmtCtrl
  self.editorNodeUI = editorNodeUI
  self.stgChallengeData = enterFmtData:GetFmtChallengeModeData()
  local isChallengeMode = (self.stgChallengeData):IsStageChallengeOpen()
  self:_UpdChallengeModeUI(isChallengeMode)
  ;
  (self._switchTog):InitCommonSwitchToggle(isChallengeMode, self._changeValueFunc)
end

UINFmtChallengeTask._UpdChallengeModeUI = function(self, isChallengeMode)
  -- function num : 0_2
  ((self.ui).img_ChallengeBg):SetActive(isChallengeMode)
  self:_UpdRewardNumPrewview()
  ;
  (self.editorNodeUI):RefreshEnterBattleTip()
  ;
  (self.editorNodeUI):RefreshBattlePow()
end

UINFmtChallengeTask._OnClickInfo = function(self)
  -- function num : 0_3 , upvalues : _ENV
  UIManager:ShowWindowAsync(UIWindowTypeID.FmtChallengeInfo, function(win)
    -- function num : 0_3_0 , upvalues : self
    if win == nil then
      return 
    end
    win:InitFmtChallengeInfo(self.stgChallengeData, function()
      -- function num : 0_3_0_0 , upvalues : self
      if (self.stgChallengeData):IsStageChallengeOpen() then
        return 
      end
      self:_SetChallengeMode(true, false)
    end
)
  end
)
end

UINFmtChallengeTask._OnClickTogSwitch = function(self, isChallengeMode)
  -- function num : 0_4
  self:_SetChallengeMode(isChallengeMode, true)
end

UINFmtChallengeTask._SetChallengeMode = function(self, isChallengeMode, showChallengeInfo)
  -- function num : 0_5 , upvalues : _ENV
  (self.fmtCtrl):SetFmtChallengeMode(isChallengeMode, showChallengeInfo, function()
    -- function num : 0_5_0 , upvalues : self, isChallengeMode, _ENV
    self:_UpdChallengeModeUI(isChallengeMode)
    ;
    (self._switchTog):SetCommonSwitchToggleValue(isChallengeMode)
    ;
    (self.editorNodeUI):RefreshBattleBtnState()
    UIManager:ShowWindowAsync(UIWindowTypeID.AniModeChange, function(win)
      -- function num : 0_5_0_0 , upvalues : isChallengeMode
      if win == nil then
        return 
      end
      if isChallengeMode then
        win:ShowAniModeChangeChallengeTask()
      else
        win:ShowAniModeChangeSectorLvDiff(1)
      end
    end
)
  end
)
end

UINFmtChallengeTask._OnChallengeTaskChange = function(self)
  -- function num : 0_6
  self:_UpdRewardNumPrewview()
end

UINFmtChallengeTask._UpdRewardNumPrewview = function(self)
  -- function num : 0_7 , upvalues : _ENV
  local rewardNum = (self.stgChallengeData):GetStgChallengeTaskRewardNum()
  if rewardNum > 0 then
    ((self.ui).reward):SetActive(true)
    ;
    ((self.ui).tex_RewardNum):SetIndex(0, tostring(rewardNum))
  else
    ;
    ((self.ui).reward):SetActive(false)
  end
end

UINFmtChallengeTask.OnDelete = function(self)
  -- function num : 0_8 , upvalues : _ENV, base
  MsgCenter:RemoveListener(eMsgEventId.OnStageChanllengeTaskChange, self._OnChallengeTaskChangeFunc)
  UIManager:DeleteWindow(UIWindowTypeID.AniModeChange)
  ;
  (self._switchTog):Delete()
  ;
  (base.OnDelete)(self)
end

return UINFmtChallengeTask

