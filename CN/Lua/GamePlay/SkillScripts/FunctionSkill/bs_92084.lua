-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_92084 = class("bs_92084", LuaSkillBase)
local base = LuaSkillBase
bs_92084.config = {buffId = 1227, buffDuration = 90, select_code = 64, select_code = 59, 
hurt_config = {hit_formula = 0, basehurt_formula = 10187, crit_formula = 0, hurt_type = eHurtType.MagicDmg}
, effectId1 = 12071, effectId2 = 12072}
bs_92084.ctor = function(self)
  -- function num : 0_0
end

bs_92084.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddAfterAddBuffTrigger("bs_92084_2", 1, self.OnAfterAddBuff, nil, nil, nil, eBattleRoleBelong.enemy, (self.config).buffId)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_92084", 1, self.AfterBattleStart)
end

bs_92084.AfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:GetSelectTeamRoles(eBattleRoleBelong.enemy)
  if targetList == nil and targetList.Count < 1 then
    return 
  end
  for i = 0, targetList.Count - 1 do
    LuaSkillCtrl:CallBuff(self, targetList[i], (self.config).buffId, (self.arglist)[1], (self.config).buffDuration, true)
  end
end

bs_92084.OnAfterAddBuff = function(self, buff, target)
  -- function num : 0_3 , upvalues : _ENV
  if buff.dataId == (self.config).buffId and self:IsReadyToTake() then
    local tier = target:GetBuffTier((self.config).buffId)
    if tier <= (self.arglist)[2] then
      return 
    end
    LuaSkillCtrl:DispelBuff(target, (self.config).buffId, (self.arglist)[3], true)
    local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).select_code, 10)
    local skillIntensity = ((targetList[0]).targetRole).skill_intensity
    local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId2, self)
    LuaSkillCtrl:HurtResult(self, skillResult, (self.config).hurt_config, {(self.arglist)[4] * skillIntensity // 1000}, true)
    skillResult:EndResult()
    self:OnSkillTake()
  end
end

bs_92084.OnCasterDie = function(self)
  -- function num : 0_4 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_92084

