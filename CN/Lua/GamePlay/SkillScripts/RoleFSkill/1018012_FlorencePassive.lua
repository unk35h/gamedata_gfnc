-- params : ...
-- function num : 0 , upvalues : _ENV
local base = require("GamePlay.SkillScripts.RoleFSkill.FakeCommonPassive")
local bs_1018012 = class("bs_1018012", base)
bs_1018012.config = {buffId_love = 10180201, effectId_pass = 101805}
bs_1018012.ctor = function(self)
  -- function num : 0_0
end

bs_1018012.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  if LuaSkillCtrl.IsInTDBattle and LuaSkillCtrl.cluaSkillCtrl ~= nil then
    return 
  end
  self:AddAfterHurtTrigger("bs_1018012_3", 1, self.OnAfterHurt, self.caster)
  self:AddBuffDieTrigger("bs_1018012_2", 1, self.OnBuffDie, nil, nil, (self.config).buffId_love)
  self:AddAfterAddBuffTrigger("bs_1018012_4", 1, self.OnAfterAddBuff, self.caster, nil, nil, nil, (self.config).buffId_love)
  self.time = 0
  self._cacheTargets = {}
end

bs_1018012.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if sender == self.caster and skill.isCommonAttack then
    self.time = self.time + 1
  end
  if (self.arglist)[1] <= self.time and LuaSkillCtrl:IsAbleAttackTarget(self.caster, target, (self.caster).attackRange) then
    self.time = 0
    LuaSkillCtrl:CallEffect(target, (self.config).effectId_pass, self)
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId_love, 1, (self.arglist)[2])
  end
end

bs_1018012.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_3 , upvalues : _ENV
  local skillCollisionCtrl = (LuaSkillCtrl.battleCtrl).skillCollisionController
  if skillCollisionCtrl ~= nil then
    skillCollisionCtrl:RemoveCollider(target.collider, target.belong)
    if target.collider ~= nil then
      (target.collider):Dispose()
      target.collider = nil
    end
  end
  local cacheBelong = target._thisBelong
  if target._thisBelong ~= nil then
    cacheBelong = target._thisBelong
    target._thisBelong = (self.caster).belong
  else
    if (target.summoner).belong ~= nil then
      cacheBelong = (target.summoner).belong
      -- DECOMPILER ERROR at PC34: Confused about usage of register: R5 in 'UnsetPending'

      ;
      (target.summoner).belong = (self.caster).belong
    end
  end
  -- DECOMPILER ERROR at PC36: Confused about usage of register: R5 in 'UnsetPending'

  ;
  (self._cacheTargets)[target] = cacheBelong
end

bs_1018012.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_4
  if buff.dataId == (self.config).buffId_love then
    self:RecoverBelong(target)
  end
end

bs_1018012.RecoverBelong = function(self, target)
  -- function num : 0_5 , upvalues : _ENV
  local cacheBelong = (self._cacheTargets)[target]
  if cacheBelong ~= nil then
    local skillCollisionCtrl = (LuaSkillCtrl.battleCtrl).skillCollisionController
    if skillCollisionCtrl ~= nil then
      skillCollisionCtrl:RemoveCollider(target.collider, target.belong)
      if target.collider ~= nil then
        (target.collider):Dispose()
        target.collider = nil
      end
    end
    if target._thisBelong ~= nil then
      target._thisBelong = cacheBelong
    else
      -- DECOMPILER ERROR at PC29: Confused about usage of register: R4 in 'UnsetPending'

      if target.summoner ~= nil then
        (target.summoner).belong = cacheBelong
      end
    end
    target:InitSkillCollider()
    -- DECOMPILER ERROR at PC33: Confused about usage of register: R4 in 'UnsetPending'

    ;
    (self._cacheTargets)[target] = nil
  end
end

bs_1018012.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  for k,v in pairs(self._cacheTargets) do
    self:RecoverBelong(k)
  end
end

bs_1018012.LuaDispose = function(self)
  -- function num : 0_7 , upvalues : base
  (base.LuaDispose)(self)
end

return bs_1018012

