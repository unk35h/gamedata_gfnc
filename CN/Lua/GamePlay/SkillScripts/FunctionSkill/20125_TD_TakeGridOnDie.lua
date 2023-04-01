-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_20125 = class("bs_20125", LuaSkillBase)
local base = LuaSkillBase
bs_20125.config = {}
bs_20125.OnCasterDie = function(self)
  -- function num : 0_0 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnTDTakeGrid, (self.caster).x, (self.caster).y, self.caster)
end

return bs_20125

