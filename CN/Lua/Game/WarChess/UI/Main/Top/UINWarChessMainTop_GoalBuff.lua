-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINWarChessMainTop_GoalBuff = class("UINWarChessMainTop_GoalBuff", UIBaseNode)
local WarChessBuffData = require("Game.WarChess.Data.WarChessBuffData")
UINWarChessMainTop_GoalBuff.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
  ;
  (UIUtil.AddButtonListener)((self.ui).goalNode, self, self._OnCliclGoalBuffNode)
  self._isOpen = true
end

UINWarChessMainTop_GoalBuff.OnShow = function(self)
  -- function num : 0_1
  self:RefreshWCGoalBuff()
end

UINWarChessMainTop_GoalBuff.RefreshWCGoalBuff = function(self)
  -- function num : 0_2 , upvalues : _ENV, WarChessBuffData
  if not WarChessSeasonManager:GetIsInWCSeason() then
    return 
  end
  ;
  ((self.ui).goalBrief):SetActive(not self._isOpen)
  ;
  ((self.ui).goalAll):SetActive(self._isOpen)
  local wcSeasonManagerCtrl = WarChessSeasonManager:GetWCSCtrl()
  local roomData = wcSeasonManagerCtrl:WCSGetSurWCSRoomData()
  if not roomData or roomData.BuffId == nil or roomData.BuffId == 0 then
    self:Hide()
    return 
  end
  local buffData = (WarChessBuffData.CrearteBuffById)(roomData.BuffId)
  local buffColorType = buffData:GetWCBuffColorType()
  -- DECOMPILER ERROR at PC48: Confused about usage of register: R5 in 'UnsetPending'

  if self._isOpen then
    ((self.ui).tex_DesSuccess).text = (LanguageUtil.GetLocaleText)((buffData.wcBuffCfg).name)
    -- DECOMPILER ERROR at PC54: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_DesSuccess).color = ((self.ui).color_buffs)[buffColorType]
    -- DECOMPILER ERROR at PC62: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).tex_DesFail).text = (LanguageUtil.GetLocaleText)((buffData.wcBuffCfg).description)
    -- DECOMPILER ERROR at PC72: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).img_Buff).sprite = CRH:GetSprite((buffData.wcBuffCfg).icon, CommonAtlasType.ExplorationIcon)
    -- DECOMPILER ERROR at PC81: Confused about usage of register: R5 in 'UnsetPending'

    ;
    ((self.ui).trans_arrow).localEulerAngles = (Vector3.New)(0, 0, 180)
  else
    local goalStr = (LanguageUtil.GetLocaleText)((buffData.wcBuffCfg).name)
    -- DECOMPILER ERROR at PC90: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).tex_Des).text = goalStr
    -- DECOMPILER ERROR at PC95: Confused about usage of register: R6 in 'UnsetPending'

    ;
    ((self.ui).trans_arrow).localEulerAngles = Vector3.zero
  end
end

UINWarChessMainTop_GoalBuff._OnCliclGoalBuffNode = function(self)
  -- function num : 0_3
  self._isOpen = not self._isOpen
  self:RefreshWCGoalBuff()
end

UINWarChessMainTop_GoalBuff.GetWCMTBuffLocationPos = function(self)
  -- function num : 0_4
  return ((self.ui).location).position
end

UINWarChessMainTop_GoalBuff.OnDelete = function(self)
  -- function num : 0_5
end

return UINWarChessMainTop_GoalBuff

