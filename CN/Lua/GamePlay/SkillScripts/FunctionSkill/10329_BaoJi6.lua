-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10329 = class("bs_10329", LuaSkillBase)
local base = LuaSkillBase
bs_10329.config = {buffId = 2055, effectId = 10974}
bs_10329.ctor = function(self)
  -- function num : 0_0
end

bs_10329.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_10329_3", 1, self.OnAfterHurt, nil, nil, eBattleRoleBelong.player)
  self:AddAfterAddBuffTrigger("bs_10329_2", 1, self.OnAfterAddBuff, nil, nil, eBattleRoleBelong.player)
  self:AddOnRoleDieTrigger("bs_10329_02", 1, self.OnRoleDie)
  self.countBuffEffect = {}
end

bs_10329.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isCrit and self:IsReadyToTake() and not isTriggerSet and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[2] then
    LuaSkillCtrl:CallBuff(self, target, (self.config).buffId, 1)
    self:OnSkillTake()
  end
end

bs_10329.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_3 , upvalues : _ENV
  if buff.dataId == (self.config).buffId and target ~= nil and target.hp > 0 then
    local buffTier1 = target:GetBuffTier((self.config).buffId)
    -- DECOMPILER ERROR at PC25: Confused about usage of register: R4 in 'UnsetPending'

    if buffTier1 == 1 then
      (self.countBuffEffect)[target.uid] = LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
      LuaSkillCtrl:EffectSetCountValue((self.countBuffEffect)[target.uid], buffTier1 - 1)
    else
      if (self.countBuffEffect)[target.uid] ~= nil then
        LuaSkillCtrl:EffectSetCountValue((self.countBuffEffect)[target.uid], buffTier1 - 1)
      end
    end
  end
end

bs_10329.OnRoleDie = function(self, killer, role)
  -- function num : 0_4
  if (self.countBuffEffect)[role.uid] ~= nil then
    ((self.countBuffEffect)[role.uid]):Die()
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.countBuffEffect)[role.uid] = nil
  end
end

bs_10329.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_10329.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  self.countBuffEffect = nil
  ;
  (base.LuaDispose)(self)
end

return bs_10329

