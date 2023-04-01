-- params : ...
-- function num : 0 , upvalues : _ENV
local UINBtResultWinterChallenge = class("UINBtResultWinterChallenge", UIBaseNode)
local base = UIBaseNode
UINBtResultWinterChallenge.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINBtResultWinterChallenge.InitBtResultWinterChallenge = function(self, scoreAdd, scoreAll)
  -- function num : 0_1 , upvalues : _ENV
  ((self.ui).tex_ScoreAdd):SetIndex(0, tostring(scoreAdd))
  -- DECOMPILER ERROR at PC13: Confused about usage of register: R3 in 'UnsetPending'

  ;
  ((self.ui).tex_ScoreAll).text = tostring(scoreAll)
  ;
  ((self.ui).tex_ScoreAll):StartScrambleTypeWriter()
end

UINBtResultWinterChallenge.OnDelete = function(self)
  -- function num : 0_2 , upvalues : base
  (base.OnDelete)(self)
end

return UINBtResultWinterChallenge

