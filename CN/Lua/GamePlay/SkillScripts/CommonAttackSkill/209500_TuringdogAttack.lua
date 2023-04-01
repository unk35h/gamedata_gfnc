-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_209500 = class("bs_209500", bs_1)
local base = bs_1
bs_209500.config = {effectId_trail = 209501, effectId_action_1 = 209503, effectId_action_2 = 209503, effectId_trail_1 = 209508, buffid_1 = 209501, buffid_2 = 209502, buffid_3 = 209503, action1 = 1001, action2 = 1001, 
HurtConfig = {hit_formula = 9991, def_formula = 9996, basehurt_formula = 10192, minhurt_formula = 9994, crit_formula = 9992, crithur_ratio = 9995, correct_formula = 9989, lifesteal_formula = 1001, spell_lifesteal_formula = 1002, returndamage_formula = 1000, hurt_type = -1}
}
bs_209500.config = setmetatable(bs_209500.config, {__index = base.config})
bs_209500.ctor = function(self)
  -- function num : 0_0
end

bs_209500.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self.arg1 = ((self.caster).recordTable).arg_1
  self.arg2 = ((self.caster).recordTable).arg_2
end

bs_209500.ExecuteEffectAttack = function(self, data, atkActionId, target, effectId1, effectId2)
  -- function num : 0_2 , upvalues : _ENV
  if data.effectId_trail ~= nil then
    if data.audioId4 ~= nil then
      LuaSkillCtrl:PlayAuSource(self.caster, data.audioId4)
    end
    if data.effectId_trail_ex ~= nil then
      if atkActionId == data.action1 then
        if not effectId1 then
          effectId1 = data.effectId_trail
        end
        if LuaSkillCtrl:GetCasterSkinId(self.caster) == 305703 then
          LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_trail_1, self, nil, false, self.SkillEventFunc, data)
        else
          LuaSkillCtrl:CallEffectWithArg(target, effectId1, self, nil, false, self.SkillEventFunc, data)
        end
      else
        if not effectId2 then
          effectId2 = data.effectId_trail_ex
        end
        if LuaSkillCtrl:GetCasterSkinId(self.caster) == 305703 then
          LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_trail_1, self, nil, false, self.SkillEventFunc, data)
        else
          LuaSkillCtrl:CallEffectWithArg(target, effectId2, self, nil, false, self.SkillEventFunc, data)
        end
      end
    else
      if not effectId1 then
        effectId1 = data.effectId_trail
      end
      if LuaSkillCtrl:GetCasterSkinId(self.caster) == 305703 then
        LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_trail_1, self, nil, false, self.SkillEventFunc, data)
      else
        LuaSkillCtrl:CallEffectWithArg(target, effectId1, self, nil, false, self.SkillEventFunc, data)
      end
    end
  else
    if data.effectId_hit_target ~= nil then
      LuaSkillCtrl:CallEffectWithArg(target, data.effectId_hit_target, self, nil, false, self.SkillEventFunc, data)
    end
  end
end

bs_209500.SkillEventFunc = function(self, configData, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger then
    if configData.audioId5 ~= nil then
      LuaSkillCtrl:PlayAuSource(target.targetRole, configData.audioId5)
    end
    if configData.Imp == true then
      LuaSkillCtrl:PlayAuHit(self, target)
    end
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).HurtConfig)
    skillResult:EndResult()
    if self.arg1 == 1 then
      LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffid_1, 1, self.arg2)
    else
      if self.arg1 == 2 then
        LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffid_2, 1, self.arg2)
      else
        if self.arg1 == 3 then
          LuaSkillCtrl:CallBuff(self, target.targetRole, (self.config).buffid_3, 1, self.arg2)
        end
      end
    end
  end
end

bs_209500.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_209500

