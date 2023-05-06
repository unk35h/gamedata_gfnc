-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92083 = class("bs_92083", LuaSkillBase)
local base = LuaSkillBase
bs_92083.config = {buffId = 195, buffDuration = 75, effect = 1, select_code = 59, 
hurt_config = {hit_formula = 0, basehurt_formula = 10187, crit_formula = 0, hurt_type = eHurtType.PhysicsDmg}
, effectId = 12070}
bs_92083.ctor = function(self)
  -- function num : 0_0
end

bs_92083.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_92083_2", 1, self.OnAfterAddBuff, nil, nil, nil, eBattleRoleBelong.enemy, (self.config).buffId)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_92083", 1, self.AfterBattleStart)
end

bs_92083.AfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetList == nil and targetList.Count < 1 then
    return 
  end
  for i = 0, targetList.Count - 1 do
    LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffId, (self.arglist)[1], (self.config).buffDuration, false)
  end
end

bs_92083.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_3 , upvalues : _ENV
  if buff.dataId == (self.config).buffId and self:IsReadyToTake() then
    local tier = target:GetBuffTier((self.config).buffId)
    if tier <= (self.arglist)[2] then
      return 
    end
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId, (self.arglist)[3], true)
    local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).select_code, 10)
    local pow = ((targetList[0]).targetRole).pow
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {(self.arglist)[4] * pow // 1000}, true)
    skillResult:EndResult()
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
    self:OnSkillTake()
  end
end

bs_92083.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92083

