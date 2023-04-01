-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_6017 = class("bs_6017", LuaSkillBase)
local base = LuaSkillBase
bs_6017.config = {}
bs_6017.ctor = function(self)
  -- function num : 0_0
end

bs_6017.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.RoleDie, "bs_6017_1", 10, self.OnRoleDie)
  self:AddTrigger(eSkillTriggerType.SetDeadHurt, "bs_6017_4", 1, self.OnSetDeadHurt)
  -- DECOMPILER ERROR at PC20: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).pre_pow = 0
  -- DECOMPILER ERROR at PC23: Confused about usage of register: R2 in 'UnsetPending'

  ;
  ((self.caster).recordTable).pre_skill = 0
  self.times = {}
end

bs_6017.OnSetDeadHurt = function(self, context)
  -- function num : 0_2 , upvalues : _ENV
  if context.sender == self.caster then
    local buffs = LuaSkillCtrl:GetRoleBuffs(context.target)
    -- DECOMPILER ERROR at PC15: Confused about usage of register: R3 in 'UnsetPending'

    if buffs ~= nil and buffs.Count > 0 then
      (self.times)[context.target] = 0
      for i = 0, buffs.Count - 1 do
        -- DECOMPILER ERROR at PC41: Confused about usage of register: R7 in 'UnsetPending'

        if (buffs[i]).buffType == 2 and (self.times)[context.target] * (self.arglist)[1] < (self.arglist)[2] then
          (self.times)[context.target] = (self.times)[context.target] + 1
        end
      end
    end
  end
end

bs_6017.OnRoleDie = function(self, killer, role)
  -- function num : 0_3 , upvalues : _ENV
  if killer == self.caster and (self.times)[role] ~= nil and (self.times)[role] > 0 then
    local times = (self.times)[role]
    local Num = times * (self.arglist)[1]
    local add_pow = Num * (self.caster).pow // 100
    local add_skill_intensity = Num * (self.caster).skill_intensity // 100
    local pre_pow = ((self.caster).recordTable).pre_pow
    local pre_skill = ((self.caster).recordTable).pre_skill
    if pre_pow < add_pow then
      (self.caster):AddRoleProperty(eHeroAttr.pow, add_pow - pre_pow, eHeroAttrType.Extra)
      -- DECOMPILER ERROR at PC42: Confused about usage of register: R9 in 'UnsetPending'

      ;
      ((self.caster).recordTable).pre_pow = add_pow
    end
    if pre_skill < add_skill_intensity then
      (self.caster):AddRoleProperty(eHeroAttr.skill_intensity, add_skill_intensity - pre_skill, eHeroAttrType.Extra)
      -- DECOMPILER ERROR at PC55: Confused about usage of register: R9 in 'UnsetPending'

      ;
      ((self.caster).recordTable).pre_skill = add_skill_intensity
    end
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster)
    skillResult:EndResult()
  end
end

bs_6017.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_6017

