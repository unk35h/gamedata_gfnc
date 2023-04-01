-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_15146 = class("bs_15146", LuaSkillBase)
local base = LuaSkillBase
bs_15146.config = {
hurt_config = {hit_formula = 0, basehurt_formula = 10182, crit_formula = 0}
, 
aoe_config = {effect_shape = 3, aoe_select_code = 5, aoe_range = 1}
, effectId = 10936, ysBuff = 1227, ysBuffDuration = 90}
bs_15146.ctor = function(self)
  -- function num : 0_0
end

bs_15146.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base
  (base.InitSkill)(self, isMidwaySkill)
  self:AddBeforeAddBuffTrigger("bs_15146_2", 1, self.OnBeforeAddBuff, nil, nil, (self.caster).belongNum)
end

bs_15146.OnBeforeAddBuff = function(self, target, context)
  -- function num : 0_2 , upvalues : _ENV
  if target ~= self.caster and ((context.buff).buffCfg).IsControl and self:IsReadyToTake() then
    self:PlayChipEffect()
    self:OnSkillTake()
    local arriveCallBack = BindCallback(self, self.OnArriveAction, target)
    LuaSkillCtrl:StartTimer(nil, 15, arriveCallBack)
    LuaSkillCtrl:CallEffect(target, (self.config).effectId, self)
  end
end

bs_15146.OnArriveAction = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  self:findMax()
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, role, (self.config).aoe_config)
  if (skillResult.roleList).Count > 0 then
    for i = 0, (skillResult.roleList).Count - 1 do
      local targetRole = (skillResult.roleList)[i]
      local skillResult1 = LuaSkillCtrl:CallSkillResultNoEffect(self, targetRole)
      LuaSkillCtrl:HurtResultWithConfig(self, skillResult1, 14, {self.damageNum}, true, true)
      skillResult1:EndResult()
      LuaSkillCtrl:CallBuff(self, targetRole, (self.config).ysBuff, 1, (self.config).ysBuffDuration)
    end
  end
  do
    skillResult:EndResult()
  end
end

bs_15146.findMax = function(self)
  -- function num : 0_4 , upvalues : _ENV
  local role, baseDamage = LuaSkillCtrl:CallFindMaxPowOrSkillIntensityRole()
  if role ~= nil then
    self.damageNum = baseDamage * (self.arglist)[1] // 1000
  end
end

bs_15146.OnCasterDie = function(self)
  -- function num : 0_5 , upvalues : base
  (base.OnCasterDie)(self)
end

return bs_15146

