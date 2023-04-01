-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_1 = require("GamePlay.SkillScripts.CommonAttackSkill.1_CommonAttack_1")
local bs_106300 = class("bs_106300", bs_1)
local base = bs_1
bs_106300.config = {effectId_trail_1 = 106301, effectId_trail_2 = 106303, effectId_trail_3 = 106305, HurtConfigID = 10}
bs_106300.config = setmetatable(bs_106300.config, {__index = base.config})
bs_106300.ctor = function(self)
  -- function num : 0_0
end

bs_106300.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
end

bs_106300.ExecuteEffectAttack = function(self, data, atkActionId, target, effectId1, effectId2)
  -- function num : 0_2 , upvalues : _ENV
  local colorId = ((self.caster).recordTable).beforeAttackColor
  if colorId == 1 then
    LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_trail_1, self, nil, false, self.SkillEventFunc, data)
  else
    if colorId == 2 then
      LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_trail_2, self, nil, false, self.SkillEventFunc, data)
    else
      LuaSkillCtrl:CallEffectWithArg(target, (self.config).effectId_trail_3, self, nil, false, self.SkillEventFunc, data)
    end
  end
end

bs_106300.SkillEventFunc = function(self, configData, effect, eventId, target)
  -- function num : 0_3 , upvalues : _ENV
  if eventId == eBattleEffectEvent.Trigger and effect.dataId == (self.config).effectId_trail_1 then
    if configData.audioId5 ~= nil then
      LuaSkillCtrl:PlayAuSource(target.targetRole, configData.audioId5)
    end
    if configData.Imp == true then
      LuaSkillCtrl:PlayAuHit(self, target)
    end
    local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {((self.caster).recordTable).RedAtkDam})
    skillResult:EndResult()
  end
  do
    if eventId == eBattleEffectEvent.Trigger and effect.dataId == (self.config).effectId_trail_2 then
      if configData.audioId5 ~= nil then
        LuaSkillCtrl:PlayAuSource(target.targetRole, configData.audioId5)
      end
      if configData.Imp == true then
        LuaSkillCtrl:PlayAuHit(self, target)
      end
      local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
      LuaSkillCtrl:HurtResult(self, skillResult, generalHurtConfig)
      skillResult:EndResult()
    end
    do
      if eventId == eBattleEffectEvent.Trigger and effect.dataId == (self.config).effectId_trail_3 then
        if configData.audioId5 ~= nil then
          LuaSkillCtrl:PlayAuSource(target.targetRole, configData.audioId5)
        end
        if configData.Imp == true then
          LuaSkillCtrl:PlayAuHit(self, target)
        end
        local skillResult = LuaSkillCtrl:CallSkillResult(effect, target)
        LuaSkillCtrl:HurtResultWithConfig(self, skillResult, (self.config).HurtConfigID, {((self.caster).recordTable).YellowAtkDam})
        skillResult:EndResult()
      end
    end
  end
end

bs_106300.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_106300

