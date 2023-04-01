-- params : ...
-- function num : 0 , upvalues : _ENV
local UIAniModeChange = class("UIAniModeChange", UIBaseWindow)
local base = UIBaseWindow
local aniNameDic = {"UI_SectorLevel_StageNormal", "UI_SectorLevel_StageHard", "UI_SectorLevel_StageEndless", "UI_SectorLevel_StageChallenge"}
local lvDiffMap = {[1] = 1, [2] = 2, [3] = 3}
UIAniModeChange.OnInit = function(self)
  -- function num : 0_0
  self:_StopStageAnima()
end

UIAniModeChange.ShowAniModeChangeSectorLvDiff = function(self, difficulty)
  -- function num : 0_1 , upvalues : lvDiffMap
  local index = lvDiffMap[difficulty]
  self:_ShowStageAnima(index)
end

UIAniModeChange.ShowAniModeChangeChallengeTask = function(self)
  -- function num : 0_2
  self:_ShowStageAnima(4)
end

UIAniModeChange._ShowStageAnima = function(self, difficulty)
  -- function num : 0_3
  self:_InitStageUI(difficulty)
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.ui).fade).alpha = 1
  ;
  ((self.ui).Ani_Logo):Play()
  ;
  ((self.ui).Ani_StageType):Play()
  ;
  ((self.ui).fadeTween):DOPlay()
end

UIAniModeChange._StopStageAnima = function(self)
  -- function num : 0_4
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R1 in 'UnsetPending'

  ((self.ui).fade).alpha = 0
  ;
  ((self.ui).Ani_Logo):Stop()
  ;
  ((self.ui).Ani_StageType):Stop()
  ;
  ((self.ui).fadeTween):DORewind()
end

UIAniModeChange._InitStageUI = function(self, difficulty)
  -- function num : 0_5 , upvalues : _ENV, aniNameDic
  self:_StopStageAnima()
  local diff = difficulty
  ;
  ((self.ui).tex_StageType):SetIndex(diff - 1)
  ;
  ((self.ui).tex_StageTypeEn):SetIndex(diff - 1)
  local col = ((self.ui).col_Colors)[diff]
  for index,v in ipairs((self.ui).com_SetColors) do
    v.color = col
  end
  for index,v in ipairs((self.ui).obj_Logos) do
    v:SetActive(index == diff)
  end
  local clipName = aniNameDic[diff]
  local clip = ((self.ui).Ani_Logo):GetClip(clipName)
  -- DECOMPILER ERROR at PC45: Confused about usage of register: R6 in 'UnsetPending'

  ;
  ((self.ui).Ani_Logo).clip = clip
  -- DECOMPILER ERROR: 2 unprocessed JMP targets
end

UIAniModeChange.Delete = function(self)
  -- function num : 0_6 , upvalues : base
  ((self.ui).fadeTween):DOKill()
  ;
  (base.OnDelete)(self)
end

return UIAniModeChange

