-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_21040 = class("bs_21040", LuaSkillBase)
local base = LuaSkillBase
bs_21040.config = {buffId = 110031}
bs_21040.ctor = function(self)
  -- function num : 0_0
end

bs_21040.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.HurtResultStart, "bs_21040_14", 1, self.OnHurtResultStart)
  self:AddSelfTrigger(eSkillTriggerType.HurtResultEnd, "bs_21040_15", 1, self.OnHurtResultEnd)
end

bs_21040.OnHurtResultStart = function(self, skill, context)
  -- function num : 0_2 , upvalues : _ENV
  if skill.maker == self.caster then
    local targetlist = LuaSkillCtrl:FindRolesAroundRole(self.caster)
    if targetlist == nil or targetlist.Count == 0 then
      LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
    else
      local Num = 0
      for i = 0, targetlist.Count - 1 do
        local role = targetlist[i]
        if role.belongNum == eBattleRoleBelong.enemy and LuaSkillCtrl:IsRoleAdjacent(role, self.caster) then
          Num = Num + 1
        end
      end
      if Num == 0 then
        LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, nil, true)
      end
    end
  end
end

bs_21040.OnHurtResultEnd = function(self, skill, targetRole, hurtValue)
  -- function num : 0_3 , upvalues : _ENV
  if skill.maker == self.caster then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId, 0)
  end
end

bs_21040.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_21040

