-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_22101 = class("bs_22101", LuaSkillBase)
local base = LuaSkillBase
bs_22101.config = {buffId = 110044, effectId = 10164}
bs_22101.ctor = function(self)
  -- function num : 0_0
end

bs_22101.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterPlaySkill, "bs_22101_13", 1, self.OnAfterPlaySkill)
  self.Num = 0
end

bs_22101.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if role ~= self.caster then
    return 
  end
  if role:GetBuffTier((self.config).buffId) < 1 or skill.isCommonAttack then
    return 
  end
  if self.Num >= 2 then
    self.Num = 0
    local skills = (self.caster):GetBattleSkillList()
    if skills ~= nil then
      local count = skills.Count
      if count > 0 then
        for i = 0, count - 1 do
          local curCd = (skills[i]).totalCDTime
          if not (skills[i]).isCommonAttack then
            LuaSkillCtrl:CallResetCDForSingleSkill(skills[i], curCd)
            LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
          end
        end
      end
    end
  else
    do
      self.Num = self.Num + 1
    end
  end
end

bs_22101.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_22101

