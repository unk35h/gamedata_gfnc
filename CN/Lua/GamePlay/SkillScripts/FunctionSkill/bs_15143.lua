-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15143 = class("bs_15143", LuaSkillBase)
local base = LuaSkillBase
bs_15143.config = {formula = 10106, effectId = 12066, buffId = 1059}
bs_15143.ctor = function(self)
  -- function num : 0_0
end

bs_15143.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_15143_1", 1, self.OnAfterBattleStart)
  self.damageNum = 0
end

bs_15143.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  if self.damTimer ~= nil then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
  self.damTimer = LuaSkillCtrl:StartTimer(nil, (self.arglist)[1], self.CallBack, self, -1, (self.arglist)[1])
end

bs_15143.CallBack = function(self)
  -- function num : 0_3 , upvalues : _ENV
  self:findMax()
  local targetList = LuaSkillCtrl:CallTargetSelect(self, 1001, 10)
  if targetList.Count > 0 then
    local targetRole = (targetList[0]).targetRole
    if targetRole.belongNum ~= eBattleRoleBelong.enemy then
      return 
    end
    LuaSkillCtrl:CallEffect(targetRole, (self.config).effectId, self)
    local skillResult1 = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
    LuaSkillCtrl:HurtResultWithConfig(self, skillResult1, 14, {self.damageNum}, true, true)
    LuaSkillCtrl:CallBuff(self, targetRole, (self.config).buffId, 1, 75)
  end
end

bs_15143.findMax = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local role, baseDamage = LuaSkillCtrl:CallFindMaxPowOrSkillIntensityRole()
  if role ~= nil then
    self.damageNum = baseDamage * (self.arglist)[2] // 1000
  end
end

bs_15143.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
  if self.damTimer then
    (self.damTimer):Stop()
    self.damTimer = nil
  end
end

return bs_15143

