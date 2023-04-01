-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1026012 = class("bs_1026012", base)
bs_1026012.config = {effectId_pass = 10725, effectId_pass_ex = 10726, effectId_pass_old = 10856, buffId_232 = 23201, buffId_231 = 23101, selectId = 47, 
heal_config = {baseheal_formula = 10088}
}
bs_1026012.ctor = function(self)
  -- function num : 0_0
end

bs_1026012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  self.effectHalo = nil
  self.halo = nil
  ;
  (base.InitSkill)(self, isMidwaySkill)
  self:AddSelfTrigger(eSkillTriggerType.BuffDie, "bs_1026012_11", 1, self.OnBuffDie)
  self:AddAfterAddBuffTrigger("bs_1026012_13", 1, self.OnAfterAddBuff, nil, nil, nil, nil, (self.config).buffId_232)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_1026012_1", 1, self.OnAfterBattleStart)
  self:AddTrigger(eSkillTriggerType.BeforeBattleEnd, "bs_1026012_3", 1, self.BeforeEndBattle)
end

bs_1026012.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.effectHalo == nil then
    self.effectHalo = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_pass, self)
  end
  local collisionEnter = BindCallback(self, self.OnCollisionEnter)
  local collisionExit = BindCallback(self, self.OnCollisionExit)
  self.halo = LuaSkillCtrl:CallCircledEmissionStraightly(self, self.caster, self.caster, 175, 0, eColliderInfluenceType.Player, collisionEnter, nil, collisionExit, nil, false, false, nil, self.caster)
end

bs_1026012.OnCollisionEnter = function(self, collider, index, entity)
  -- function num : 0_3 , upvalues : _ENV
  if entity:GetBuffTier((self.config).buffId_231) < 1 then
    LuaSkillCtrl:CallBuff(self, entity, (self.config).buffId_231, 1)
  end
end

bs_1026012.OnCollisionExit = function(self, collider, entity)
  -- function num : 0_4 , upvalues : _ENV
  if entity:GetBuffTier((self.config).buffId_231) >= 1 then
    LuaSkillCtrl:DispelBuff(entity, (self.config).buffId_231, 0)
  end
end

bs_1026012.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_5 , upvalues : _ENV
  if buff.dataId == (self.config).buffId_232 and target == self.caster then
    if self.effectHalo ~= nil then
      (self.effectHalo):Die()
      self.effectHalo = nil
      self.effectHalo = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_pass_ex, self)
    end
    if self.halo ~= nil then
      LuaSkillCtrl:SetCircleColliderAndEffectRadius((self.halo).collider, 275, nil)
    end
  end
end

bs_1026012.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_6 , upvalues : _ENV
  if buff.dataId == (self.config).buffId_232 and target == self.caster then
    if self.effectHalo ~= nil then
      (self.effectHalo):Die()
      self.effectHalo = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId_pass_old, self)
    end
    if self.halo ~= nil then
      LuaSkillCtrl:SetCircleColliderAndEffectRadius((self.halo).collider, 175, nil)
    end
  end
end

bs_1026012.BeforeEndBattle = function(self)
  -- function num : 0_7 , upvalues : _ENV
  if self.loopAudio ~= nil then
    LuaSkillCtrl:StopAudioByBack(self.loopAudio)
    self.loopAudio = nil
  end
end

bs_1026012.OnCasterDie = function(self)
  -- function num : 0_8 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  if self.loopAudio ~= nil then
    LuaSkillCtrl:StopAudioByBack(self.loopAudio)
    self.loopAudio = nil
  end
  if self.effectHalo ~= nil then
    (self.effectHalo):Die()
    self.effectHalo = nil
  end
  if self.halo ~= nil then
    (self.halo):EndAndDisposeEmission()
    self.halo = nil
  end
end

bs_1026012.LuaDispose = function(self)
  -- function num : 0_9 , upvalues : base
  (base.LuaDispose)(self)
  self.effectHalo = nil
  self.halo = nil
end

return bs_1026012

