-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_7008 = class("bs_7008", LuaSkillBase)
local base = LuaSkillBase
bs_7008.config = {buffId = 1225}
bs_7008.ctor = function(self)
  -- function num : 0_0
end

bs_7008.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_7008_1", 10, self.OnRoleDie)
  self:AddTrigger(eSkillTriggerType.BeforePlaySkill, "bs_7008_1", 1, self.OnBeforePlaySkill)
end

bs_7008.OnBeforePlaySkill = function(self, role, context)
  -- function num : 0_2
  if role ~= self.caster then
    return 
  end
  if role == self.caster and (context.skill).isCommonAttack then
    local moveTarget = (context.skill).moveSelectTarget
    if moveTarget ~= nil then
      local curAtkRole = moveTarget.targetRole
      -- DECOMPILER ERROR at PC20: Confused about usage of register: R5 in 'UnsetPending'

      if curAtkRole ~= nil then
        ((self.caster).recordTable).lastAttackRoleInTd = curAtkRole
      end
    end
  end
end

bs_7008.OnRoleDie = function(self, killer, role)
  -- function num : 0_3 , upvalues : _ENV
  if role.belongNum ~= (self.caster).belongNum and ((self.caster).recordTable).lastAttackRoleInTd == role then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId, 1, 30, true)
    -- DECOMPILER ERROR at PC22: Confused about usage of register: R3 in 'UnsetPending'

    ;
    ((self.caster).recordTable).lastAttackRoleInTd = nil
  end
end

bs_7008.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_7008

