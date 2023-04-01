-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_4001223 = class("bs_4001223", LuaSkillBase)
local base = LuaSkillBase
bs_4001223.config = {buffId_fly = 130, 
Aoe = {effect_shape = 3, aoe_select_code = 4, aoe_range = 1}
}
bs_4001223.ctor = function(self)
  -- function num : 0_0
end

bs_4001223.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.AfterPlaySkill, "bs_4001223_1", 1, self.OnAfterPlaySkill)
  self:AddAfterHurtTrigger("bs_4001223_2", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, nil, eSkillTag.commonAttack)
  self.flag = false
end

bs_4001223.OnAfterPlaySkill = function(self, skill, role)
  -- function num : 0_2 , upvalues : _ENV
  if skill.maker == self.caster and skill.skillTag == eSkillTag.normalSkill then
    self.flag = true
  end
end

bs_4001223.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_3 , upvalues : _ENV
  if skill.isCommonAttack and self.flag == true then
    self.flag = false
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, self.caster, (self.config).Aoe)
    local random = LuaSkillCtrl:CallRange(1, 100)
    if random <= (self.arglist)[1] then
      for i = 0, (skillResult.roleList).Count - 1 do
        local role = (skillResult.roleList)[i]
        if role.belongNum == eBattleRoleBelong.enemy then
          LuaSkillCtrl:CallBuff(self, role, (self.config).buffId_fly, 1, (self.arglist)[2], true)
        end
      end
    end
    do
      skillResult:EndResult()
    end
  end
end

bs_4001223.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_4001223

