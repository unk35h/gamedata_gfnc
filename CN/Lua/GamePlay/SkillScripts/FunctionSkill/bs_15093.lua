-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15093 = class("bs_15093", LuaSkillBase)
local base = LuaSkillBase
bs_15093.config = {effectId = 12052}
bs_15093.ctor = function(self)
  -- function num : 0_0
end

bs_15093.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15093_1", 1, self.OnAfterBattleStart)
  self:AddAfterBuffRemoveTrigger("bs_15093_2", 4, self.AfterBuffRemove, self.caster, nil, nil, nil, eBuffFeatureType.Stun)
  self:AddAfterAddBuffTrigger("bs_15093_3", 1, self.OnAfterAddBuff, nil, self.caster, nil, nil, nil, nil, eBuffFeatureType.Stun)
  self.effect = nil
  self.damTimer = nil
end

bs_15093.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.damTimer ~= nil then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
  if self.effect ~= nil then
    (self.effect):Die()
    self.effect = nil
  end
  self.damTimer = LuaSkillCtrl:StartTimer(nil, 15, self.CallBack, self, -1, 15)
end

bs_15093.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  if LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.Stun) then
    local skills = (self.caster):GetBattleSkillList()
    if skills ~= nil then
      local count = skills.Count
      if count > 0 then
        for i = 0, count - 1 do
          local curCd = -(self.arglist)[1]
          if not (skills[i]).isCommonAttack then
            LuaSkillCtrl:CallResetCDForSingleSkill(skills[i], curCd)
          end
        end
      end
    end
  end
end

bs_15093.AfterBuffRemove = function(self, buffId, target, removeType)
  -- function num : 0_4 , upvalues : _ENV
  if target == self.caster and not LuaSkillCtrl:RoleContainsBuffFeature(self.caster, eBuffFeatureType.Stun) and self.effect ~= nil then
    (self.effect):Die()
    self.effect = nil
  end
end

bs_15093.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_5 , upvalues : _ENV
  if self.effect == nil then
    self.effect = LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
  end
end

bs_15093.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
  if self.damTimer ~= nil then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
  if self.effect ~= nil then
    (self.effect):Die()
    self.effect = nil
  end
end

return bs_15093

