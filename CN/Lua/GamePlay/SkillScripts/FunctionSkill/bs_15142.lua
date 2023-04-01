-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15142 = class("bs_15142", LuaSkillBase)
local base = LuaSkillBase
bs_15142.config = {formula = 10106, buffId_Back = 3007, effectId = 12065}
bs_15142.ctor = function(self)
  -- function num : 0_0
end

bs_15142.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15142_1", 1, self.OnAfterBattleStart)
  self.damageNum = 0
end

bs_15142.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.damTimer ~= nil then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
  self.damTimer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], self.CallBack, self, -1, (self.arglist)[1])
end

bs_15142.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self:findMax()
  LuaSkillCtrl:CallEffect(self.caster, (self.config).effectId, self)
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 9, 10)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      local targetRole = (targetList[i]).targetRole
      local distance = LuaSkillCtrl:GetGridsDistance((self.caster).x, (self.caster).y, targetRole.x, targetRole.y)
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId_Back, 1, 3)
      local realDamageNum = self.damageNum + self.damageNum * distance * (self.arglist)[4] // 1000
      local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult, 14, {realDamageNum}, true, true)
      skillResult:EndResult()
    end
  end
end

bs_15142.findMax = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local role, baseDamage = LuaSkillCtrl:CallFindMaxPowOrSkillIntensityRole()
  if role ~= nil then
    self.damageNum = baseDamage * (self.arglist)[3] // 1000
  end
end

bs_15142.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
  if self.damTimer then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
end

return bs_15142

