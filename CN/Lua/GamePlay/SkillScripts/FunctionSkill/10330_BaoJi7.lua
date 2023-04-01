-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_10330 = class("bs_10330", LuaSkillBase)
local base = LuaSkillBase
bs_10330.config = {buffId = 2061, effectId = 10975}
bs_10330.ctor = function(self)
  -- function num : 0_0
end

bs_10330.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterHurtTrigger("bs_10330_3", 3, self.OnAfterHurt, nil, nil, nil, eBattleRoleBelong.enemy)
  self:AddAfterAddBuffTrigger("bs_10330_2", 0, self.OnAfterAddBuff, nil, nil, eBattleRoleBelong.player)
  self:AddOnRoleDieTrigger("bs_10330_02", 1, self.OnRoleDie)
  self.times = 0
  self.countBuffEffect = {}
end

bs_10330.OnAfterHurt = function(self, sender, target, skill, hurt, isMiss, isCrit, hurtType, isTriggerSet)
  -- function num : 0_2 , upvalues : _ENV
  if isCrit and self:IsReadyToTake() and not isTriggerSet then
    self:OnSkillTake()
    self.times = self.times + 1
    if (self.arglist)[1] <= self.times then
      self.times = 0
      local targetList = LuaSkillCtrl:CallTargetSelect(self, 6, 10)
      if targetList.Count > 0 then
        for i = 0, targetList.Count - 1 do
          local target = (targetList[i]).targetRole
          LuaSkillCtrl:CallBuff(self, (targetList[i]).targetRole, (self.config).buffId, 1)
        end
      end
    end
  end
end

bs_10330.OnAfterAddBuff = function(self, buff, target)
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

bs_10330.OnRoleDie = function(self, killer, role)
  -- function num : 0_4
  if (self.countBuffEffect)[role.uid] ~= nil then
    ((self.countBuffEffect)[role.uid]):Die()
    -- DECOMPILER ERROR at PC12: Confused about usage of register: R3 in 'UnsetPending'

    ;
    (self.countBuffEffect)[role.uid] = nil
  end
end

bs_10330.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

bs_10330.LuaDispose = function(self)
  -- function num : 0_6 , upvalues : base
  self.countBuffEffect = nil
  ;
  (base.LuaDispose)(self)
end

return bs_10330

