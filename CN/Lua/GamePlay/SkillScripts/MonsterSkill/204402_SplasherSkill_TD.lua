-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204401 = require("GamePlay.SkillScripts.MonsterSkill.204401_SplasherSkill")
local bs_204402 = class("bs_204402", bs_204401)
local base = bs_204401
bs_204402.config = {selectId = 43}
bs_204402.config = setmetatable(bs_204402.config, {__index = base.config})
bs_204402.ctor = function(self)
  -- function num : 0_0
end

bs_204402.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_204402.CallEffectAndEmissions = function(self, target)
  -- function num : 0_2 , upvalues : _ENV
  LuaSkillCtrl:CallEffect(target, (self.config).effectid_Hurt, self, self.SkillEventFunc)
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectid_start, self)
end

bs_204402.SkillEventFunc = function(self, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    if target == nil or (target.targetRole).hp <= 0 or (target.targetRole):IsTowerLoadOff() then
      return 
    end
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {(self.arglist)[1]}, false)
    LuaSkillCtrl:CallEffect(target, (self.config).effectid_Sj, self)
    skillResult:EndResult()
  end
end

bs_204402.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_204402

