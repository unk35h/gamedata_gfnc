-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1021012 = class("bs_1021012", base)
bs_1021012.config = {effectId_Grid = 10709, buffId_lockCD = 170, audioId1 = 77, 
AOE = {effect_shape = 3, aoe_select_code = 4, aoe_range = 10}
}
bs_1021012.ctor = function(self)
  -- function num : 0_0
end

bs_1021012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_1021012_3", 1, self.OnAfterHurt, nil, nil, nil, nil, nil, eBattleRoleType.character)
end

bs_1021012.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isMiss and target.roleType == 1 and target.belongNum == (self.caster).belongNum and (self.caster):GetBuffTier((self.config).buffId_lockCD) == 0 then
    LuaSkillCtrl:CallResetCDNumForRole(self.caster, (self.arglist)[1])
  end
end

bs_1021012.OnCasterDie = function(self)
  -- function num : 0_3 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  if self.timerhurt ~= nil then
    (self.timerhurt):Stop()
    self.timerhurt = nil
  end
  if self.loop ~= nil then
    LuaSkillCtrl:StopAudioByBack(self.loop)
    self.loop = nil
  end
end

bs_1021012.LuaDispose = function(self)
  -- function num : 0_4 , upvalues : base
  (base.LuaDispose)(self)
  self.loop = nil
  self.effectQ = nil
end

return bs_1021012

