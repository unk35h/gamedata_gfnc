-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_94101 = class("bs_94101", LuaSkillBase)
local base = LuaSkillBase
bs_94101.config = {buffId = 205}
bs_94101.ctor = function(self)
  -- function num : 0_0
end

bs_94101.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_94101_1", 1, self.OnAfterBattleStart)
end

bs_94101.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, (self.arglist)[1])
  local skills = (self.caster):GetBattleSkillList()
  if skills ~= nil then
    local count = skills.Count
    if count > 0 then
      for i = 0, count - 1 do
        local curCd = 0
        if (skills[i]).isCommonAttack then
          (skills[i]):ResetCDTimeRatio(0)
        end
      end
    end
  end
end

bs_94101.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_94101

