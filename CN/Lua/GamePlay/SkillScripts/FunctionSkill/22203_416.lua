-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_22203 = class("bs_22203", LuaSkillBase)
local base = LuaSkillBase
bs_22203.config = {effectId1 = 12046, effectId2 = 12047, effectId3 = 12048}
bs_22203.ctor = function(self)
  -- function num : 0_0
end

bs_22203.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_22203_1", 1, self.OnAfterBattleStart)
end

bs_22203.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if (self.caster).roleDataId ~= 1058 then
    return 
  end
  local lv = (self.caster).rank
  if lv < 8 and lv >= 0 then
    LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId1, self)
  else
    if lv < 10 and lv >= 8 then
      LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId2, self)
    else
      if lv >= 10 then
        LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId3, self)
      end
    end
  end
end

bs_22203.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_22203

