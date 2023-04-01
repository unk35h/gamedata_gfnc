-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_211501 = class("bs_211501", LuaSkillBase)
local base = LuaSkillBase
bs_211501.config = {buffId1 = 211501, buffIdys1 = 211506, buffIdys2 = 211507, buffIdys3 = 211508}
bs_211501.ctor = function(self)
  -- function num : 0_0
end

bs_211501.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self.grid = nil
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_211501_1", 3, self.OnAfterBattleStart)
  self:AddAfterAddBuffTrigger("bs_211501_3", 1, self.OnAfterAddBuff, nil, nil, nil, nil, (self.config).buffId1)
  self:AddBuffDieTrigger("bs_211501_2", 2, self.OnBuffDie, self.caster, nil, 211501)
end

bs_211501.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  self.callback = LuaSkillCtrl:StartTimer(self, 15, self.CallBack, self, -1, 1)
end

bs_211501.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  local grid1 = LuaSkillCtrl:GetGridWithRole(self.caster)
  if self.grid ~= nil and self.grid == grid1 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffId1, 1, nil, false)
  else
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffId1, 0, false)
  end
  self.grid = grid1
end

bs_211501.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_4 , upvalues : _ENV
  if target:GetBuffTier((self.config).buffId1) > 0 then
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdys1, 1, nil, true)
  end
  if target:GetBuffTier((self.config).buffId1) >= 5 then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffIdys1, 0, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdys2, 1, nil, true)
  end
  if target:GetBuffTier((self.config).buffId1) >= 10 then
    LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffIdys2, 0, true)
    LuaSkillCtrl:CallBuff(self, self.caster, (self.config).buffIdys3, 1, nil, true)
  end
end

bs_211501.OnBuffDie = function(self, buff, target, removeType)
  -- function num : 0_5 , upvalues : _ENV
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffIdys1, 0, true)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffIdys2, 0, true)
  LuaSkillCtrl:DispelBuff(self.caster, (self.config).buffIdys3, 0, true)
end

bs_211501.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base
  (base.OnCasterDie)(self)
  if self.callback ~= nil then
    (self.callback):Stop()
    self.callback = nil
  end
end

return bs_211501

