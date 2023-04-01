-- params : ...
-- function num : 0 , upvalues : _ENV
local base = UIBaseNode
local UINActivityTimer = class("UINActivityTimer", base)
UINActivityTimer.OnInit = function(self)
  -- function num : 0_0 , upvalues : _ENV
  (UIUtil.LuaUIBindingTable)(self.transform, self.ui)
end

UINActivityTimer.InitActivityTimer = function(self)
  -- function num : 0_1
end

UINActivityTimer.UpdActTimer = function(self, tile, timer, days)
  -- function num : 0_2
  -- DECOMPILER ERROR at PC2: Confused about usage of register: R4 in 'UnsetPending'

  ((self.ui).tex_TimerTitle).text = tile
  -- DECOMPILER ERROR at PC5: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Timer).text = timer
  -- DECOMPILER ERROR at PC8: Confused about usage of register: R4 in 'UnsetPending'

  ;
  ((self.ui).tex_Days).text = days
end

UINActivityTimer.OnDelete = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnDelete)(self)
end

return UINActivityTimer

