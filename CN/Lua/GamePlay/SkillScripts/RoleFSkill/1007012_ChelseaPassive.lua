-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1007012 = class("bs_1007012", base)
bs_1007012.config = {hurtConfigId = 2, 
HurtConfig = {hit_formula = 0, basehurt_formula = 3000, crit_formula = 0, crithur_ratio = 0}
}
bs_1007012.ctor = function(self)
  -- function num : 0_0
end

bs_1007012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_1007012_3", 1, self.OnAfterHurt, self.caster, nil, nil, nil, nil, nil, 100700)
end

bs_1007012.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and skill.dataId == 100700 then
    local targets = (self:GetBehindTargetsPos(2, (self.caster).x, (self.caster).y, target.x, target.y))
    local targetNext = nil
    if targets ~= nil and (table.length)(targets) >= 2 and (targets[2]).belongNum ~= (self.caster).belongNum then
      targetNext = targets[2]
    end
    if targetNext ~= nil then
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetNext)
      LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig, {(self.arglist)[1]})
      skillResult:EndResult()
    end
  end
end

bs_1007012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_1007012

