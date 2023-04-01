-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21029 = class("bs_21029", LuaSkillBase)
local base = LuaSkillBase
bs_21029.config = {buffId = 110025}
bs_21029.ctor = function(self)
  -- function num : 0_0
end

bs_21029.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.HurtResultStart, "bs_21029_5", 1, self.OnHurtResultStart)
  self:AddSelfTrigger(eSkillTriggerType.HurtResultEnd, "bs_21029_6", 1, self.OnHurtResultEnd)
end

bs_21029.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster or context.target == self.caster then
    local targetList = LuaSkillCtrl:FindAllRolesWithinRange(self.caster, 1, false)
    if targetList.Count ~= 0 then
      local Num = 0
      for i = 0, targetList.Count - 1 do
        local role = targetList[i]
        if role.belongNum == eBattleRoleBelong.player then
          Num = Num + 1
        end
      end
      if Num > 0 then
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
      end
    end
  end
end

bs_21029.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_3 , upvalues : _ENV
  if skill.maker == self.caster or targetRole == self.caster then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_21029.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21029

