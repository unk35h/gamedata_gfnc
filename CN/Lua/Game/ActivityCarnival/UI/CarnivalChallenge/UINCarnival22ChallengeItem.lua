-- params : ...
-- function num : 0 , upvalues : _ENV
local UINCarnival22ChallengeItem = class("UINCarnival22ChallengeItem", UIBaseNode)
local base = UIBaseNode
local BattleUtil = require("Game.Battle.BattleUtil")
UINCarnival22ChallengeItem.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).challengeItem, self, self.OnClickSelect)
end

UINCarnival22ChallengeItem.InitCarnivalChallegeItem = function(self, carnivalData, dungeonId, clickCallback)
  -- function num : 0_1 , upvalues : _ENV
  self._carnivalData = carnivalData
  self._dungeonCfg = (ConfigData.battle_dungeon)[dungeonId]
  self._clickCallback = clickCallback
  ;
  ((self.ui).selected):SetActive(false)
  -- DECOMPILER ERROR at PC18: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_CNDifficulty).text = (LanguageUtil.GetLocaleText)((self._dungeonCfg).name)
  -- DECOMPILER ERROR at PC30: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_LockPre).text = (CheckCondition.GetUnlockInfoLua)((self._dungeonCfg).pre_condition, (self._dungeonCfg).pre_para1, (self._dungeonCfg).pre_para2)
  self:UpdateCarnivalChallenge()
end

UINCarnival22ChallengeItem.SetCarnivalChallengeBg = function(self, texture)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R2 in 'UnsetPending'

  ((self.ui).bottom).texture = texture
end

UINCarnival22ChallengeItem.UpdateCarnivalChallenge = function(self)
  -- function num : 0_3 , upvalues : _ENV, BattleUtil
  local isUnlock = (CheckCondition.CheckLua)((self._dungeonCfg).pre_condition, (self._dungeonCfg).pre_para1, (self._dungeonCfg).pre_para2)
  if not isUnlock then
    ((self.ui).time):SetActive(false)
    ;
    ((self.ui).lock):SetActive(true)
    return 
  end
  local finishiTime = (self._carnivalData):GetCarnivalChallengeRecord((self._dungeonCfg).id)
  ;
  ((self.ui).time):SetActive(true)
  ;
  ((self.ui).lock):SetActive(false)
  -- DECOMPILER ERROR at PC46: Confused about usage of register: R3 in 'UnsetPending'

  if finishiTime or 0 == 0 then
    ((self.ui).img_ClearTimeBg).color = (self.ui).color_gray
    ;
    ((self.ui).tex_TimeLeft):SetIndex(1)
  else
    -- DECOMPILER ERROR at PC59: Confused about usage of register: R3 in 'UnsetPending'

    if finishiTime == 4294967295 then
      ((self.ui).img_ClearTimeBg).color = (self.ui).color_gray
      ;
      ((self.ui).tex_TimeLeft):SetIndex(2)
    else
      finishiTime = finishiTime / BattleUtil.LogicFrameCount
      -- DECOMPILER ERROR at PC72: Confused about usage of register: R3 in 'UnsetPending'

      ;
      ((self.ui).img_ClearTimeBg).color = (self.ui).color_highlight
      local min = (math.floor)(finishiTime / 60)
      local sec = finishiTime % 60
      ;
      ((self.ui).tex_TimeLeft):SetIndex(0, (string.format)("%02d", min), (string.format)("%.03f", sec))
    end
  end
end

UINCarnival22ChallengeItem.SetCarnivalChallengeSelect = function(self, dungeonId)
  -- function num : 0_4
  ((self.ui).selected):SetActive(dungeonId == (self._dungeonCfg).id)
  -- DECOMPILER ERROR: 1 unprocessed JMP targets
end

UINCarnival22ChallengeItem.OnClickSelect = function(self)
  -- function num : 0_5 , upvalues : _ENV
  local unlock = (CheckCondition.CheckLua)((self._dungeonCfg).pre_condition, (self._dungeonCfg).pre_para1, (self._dungeonCfg).pre_para2)
  if unlock and self._clickCallback ~= nil then
    (self._clickCallback)((self._dungeonCfg).id)
  end
end

return UINCarnival22ChallengeItem

