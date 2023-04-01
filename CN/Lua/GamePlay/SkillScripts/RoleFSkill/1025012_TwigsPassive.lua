-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1025012 = class("bs_1025012", base)
bs_1025012.config = {
HurtConfig = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0, crithur_ratio = 0, returndamage_formula = 0}
, buffId_CH = 10250101}
bs_1025012.ctor = function(self)
  -- function num : 0_0
end

bs_1025012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_1025012_3", 90, self.OnAfterHurt, self.caster)
  self:AddBuffDieTrigger("bs_1025012_5", 99, self.OnBuffDie, nil, eBattleRoleBelong.player, (self.config).buffId_CH)
end

bs_1025012.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and target.belongNum ~= (self.caster).belongNum and isTriggerSet ~= true and (skill.dataId == 102500 or skill.dataId == 1025022) then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_CH, 1)
  end
end

bs_1025012.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_3 , upvalues : _ENV
  if target.belongNum ~= (self.caster).belongNum then
    local num = buff.tier
    if num > 0 then
      local hurt = num * (self.arglist)[1]
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {hurt})
      skillResult:EndResult()
    end
  end
end

bs_1025012.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1025012

