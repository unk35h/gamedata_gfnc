-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204807 = class("bs_204807", LuaSkillBase)
local base = LuaSkillBase
bs_204807.config = {}
bs_204807.OnCasterDie = function(self)
  -- function num : 0_0 , upvalues : _ENV, base
  LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnSummonerDieForDemiurge, self.caster)
  ;
  (base.OnCasterDie)(self)
end

return bs_204807

