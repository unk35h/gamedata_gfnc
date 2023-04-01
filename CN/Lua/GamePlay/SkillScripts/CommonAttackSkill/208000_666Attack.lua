-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_208000 = class("bs_208000", bs_1)
local base = bs_1
bs_208000.config = {effectId_trail = 208003, effectId_action_1 = 208001, effectId_action_2 = 208002, effectId_trail_pow = 208005}
bs_208000.config = setmetatable(bs_208000.config, {__index = base.config})
bs_208000.ctor = function(self)
  -- function num : 0_0
end

bs_208000.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_208000.ExecuteEffectAttack = function(self, data, atkActionId, target, effectId1, effectId2)
  -- function num : 0_2 , upvalues : _ENV
  if ((self.caster).recordTable).pass == true then
    LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_trail_pow, self, nil, false, self.SkillEventFunc, data)
  else
    LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_trail, self, nil, false, self.SkillEventFunc, data)
  end
end

bs_208000.SkillEventFunc = function(self, configData, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    if configData.audioId5 ~= nil then
      LuaSkillCtrl:PlayAuSource(target.targetRole, configData.audioId5)
    end
    if configData.Imp == true then
      LuaSkillCtrl:PlayAuHit(self, target)
    end
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResult(self, skillResult, generalHurtConfig)
    skillResult:EndResult()
    LuaSkillCtrl:BroadcastLuaTrigger(eSkillLuaTrigger.OnSixAttack, target, self.caster, self.cskill)
  end
end

bs_208000.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_208000

