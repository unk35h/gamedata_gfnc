-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15151 = class("bs_15151", LuaSkillBase)
local base = LuaSkillBase
bs_15151.config = {}
bs_15151.ctor = function(self)
  -- function num : 0_0
end

bs_15151.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : _ENV
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15151_4", 1, self.OnAfterBattleStart)
end

bs_15151.OnAfterBattleStart = function(self)
  -- function num : 0_2
  local originalRebornTime = 150
  if ((self.caster).recordTable).RebornTime ~= nil then
    originalRebornTime = ((self.caster).recordTable).RebornTime
  end
  -- DECOMPILER ERROR at PC16: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).RebornTime = originalRebornTime - originalRebornTime * (self.arglist)[1] // 1000
end

bs_15151.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15151

