-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("Game.WarChess.UI.Info.Info.UINWarChessInfoInfoBase")
local UINWarChessInfoMoney = class("UINWarChessInfoMoney", base)
local CS_DoTween = ((CS.DG).Tweening).DOTween
UINWarChessInfoMoney.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINWarChessInfoMoney.InitWCGetMoneyItem = function(self, itemId, itemNum)
  -- function num : 0_1 , upvalues : _ENV
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R3 in 'UnsetPending'

  ((self.ui).tex_Count).text = tostring(itemNum)
  -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).icon).sprite = CRH:GetSpriteByItemId(itemId)
end

UINWarChessInfoMoney.WCGetMoneyPlayTween = function(self)
  -- function num : 0_2 , upvalues : CS_DoTween
  if self.sequence == nil then
    local sequence = ((((((((CS_DoTween.Sequence)()):AppendCallback(function()
    -- function num : 0_2_0 , upvalues : self
    -- DECOMPILER ERROR at PC2: Confused about usage of register: R0 in 'UnsetPending'

    ((self.ui).money).alpha = 1
  end
)):Append(((self.transform):DOLocalMoveY(20, 0.3)):SetRelative(true))):Join((((self.ui).money):DOFade(0, 0.15)):From())):Append((((self.transform):DOLocalMoveY(20, 0.3)):SetRelative(true)):SetDelay(1))):Join((((self.ui).money):DOFade(0, 0.15)):SetDelay(0.15))):AppendCallback(function()
    -- function num : 0_2_1 , upvalues : self
    self:Hide()
  end
)):SetAutoKill(false)
    self.sequence = sequence
  else
    do
      ;
      (self.sequence):Restart()
    end
  end
end

UINWarChessInfoMoney.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  if self.sequence ~= nil then
    (self.sequence):Kill()
    self.sequence = nil
  end
  ;
  (base.OnDelete)(self)
end

return UINWarChessInfoMoney

