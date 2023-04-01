-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessMainTop_Goal = class("UINWarChessMainTop_Goal", UIBaseNode)
local UINWarChessMainTop_GoalBuff = require("Game.WarChess.UI.Main.Top.UINWarChessMainTop_GoalBuff")
UINWarChessMainTop_Goal.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV, UINWarChessMainTop_GoalBuff
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).goalNode, self, self._OnCliclGoalNode)
  self._isOpen = true
  self.BuffNode = (UINWarChessMainTop_GoalBuff.New)()
  ;
  (self.BuffNode):Init((self.ui).obj_buffNode)
  ;
  (self.BuffNode):Hide()
end

UINWarChessMainTop_Goal.OnShow = function(self)
  -- function num : 0_1 , upvalues : _ENV
  if WarChessSeasonManager:GetIsInWCSeason() then
    (self.BuffNode):Show()
  end
end

UINWarChessMainTop_Goal.RefreshWCGoal = function(self)
  -- function num : 0_2 , upvalues : _ENV
  ((self.ui).goalBrief):SetActive(not self._isOpen)
  ;
  ((self.ui).goalAll):SetActive(self._isOpen)
  if self._isOpen then
    local wcLevelCfg = WarChessManager:GetWCLevelCfg()
    -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_DesSuccess).text = (LanguageUtil.GetLocaleText)(wcLevelCfg.victory_long)
    -- DECOMPILER ERROR at PC30: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).tex_DesFail).text = (LanguageUtil.GetLocaleText)(wcLevelCfg.fail_long)
    -- DECOMPILER ERROR at PC39: Confused about usage of register: R2 in 'UnsetPending'

    ;
    ((self.ui).trans_arrow).localEulerAngles = (Vector3.New)(0, 0, 180)
  else
    do
      local goalStr = (LanguageUtil.GetLocaleText)((WarChessManager:GetWCLevelCfg()).victory)
      -- DECOMPILER ERROR at PC50: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).tex_Des).text = goalStr
      -- DECOMPILER ERROR at PC55: Confused about usage of register: R2 in 'UnsetPending'

      ;
      ((self.ui).trans_arrow).localEulerAngles = Vector3.zero
    end
  end
end

UINWarChessMainTop_Goal._OnCliclGoalNode = function(self)
  -- function num : 0_3
  self._isOpen = not self._isOpen
  self:RefreshWCGoal()
end

UINWarChessMainTop_Goal.GetWCMTGoalBuffPos = function(self)
  -- function num : 0_4
  return (self.BuffNode):GetWCMTBuffLocationPos()
end

UINWarChessMainTop_Goal.OnDelete = function(self)
  -- function num : 0_5
end

return UINWarChessMainTop_Goal

