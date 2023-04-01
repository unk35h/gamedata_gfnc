-- params : ...
-- function num : 0 , upvalues : _ENV
local bs_204502 = class("bs_204502", LuaSkillBase)
local base = LuaSkillBase
bs_204502.config = {restBuffId = 204503, select_id = 6, select_range = 10, 
HealConfig = {baseheal_formula = 3021}
}
bs_204502.ctor = function(self)
  -- function num : 0_0
end

bs_204502.InitSkill = function(self, isMidwaySkill)
  -- function num : 0_1 , upvalues : base, _ENV
  (base.InitSkill)(self, isMidwaySkill)
  self:AddTrigger(eSkillTriggerType.AfterBattleStart, "bs_204502_1", 1, self.OnAfterBattleStart)
  self:AddSetHurtTrigger("bs_204502_2", 90, self.OnSetHurt, nil, nil, nil, nil, eBattleRoleType.character)
  self:AddLuaTrigger(eSkillLuaTrigger.OnRealSummonerCaster, self.CallBuffForSameCamp)
end

bs_204502.OnAfterBattleStart = function(self)
  -- function num : 0_2 , upvalues : _ENV
  local targetList = LuaSkillCtrl:CallTargetSelect(self, (self.config).select_id, (self.config).select_range)
  if targetList.Count > 0 then
    for i = 0, targetList.Count - 1 do
      if (targetList[i]).targetRole ~= nil then
        self:CallBuffForSameCamp((targetList[i]).targetRole)
      end
    end
  end
end

bs_204502.CallBuffForSameCamp = function(self, role)
  -- function num : 0_3 , upvalues : _ENV
  local camp = role.camp
  if role.roleType == eBattleRoleType.realSummoner then
    camp = LuaSkillCtrl:GetSummonerCamp(role)
  end
  if camp == (self.caster).camp then
    LuaSkillCtrl:CallBuff(self, role, (self.config).restBuffId, 1, nil)
    local heal = role.maxHp * (self.arglist)[1] // 1000
    LuaSkillCtrl:CallHeal(heal, self, role, true)
  end
end

bs_204502.OnSetHurt = function(self, context)
  -- function num : 0_4 , upvalues : _ENV
  if (context.target):GetBuffTier((self.config).restBuffId) ~= 0 and context.sender ~= self.caster and LuaSkillCtrl:CallRange(1, 1000) <= (self.arglist)[2] and (context.sender).roleType == 1 and (context.skill).isCommonAttack and self:IsReadyToTake() and not context.isTriggerSet and context.extraArg ~= (ConfigData.buildinConfig).HurtIgnoreKey then
    self:OnSkillTake()
    local finalHurt = context.hurt * (1000 - (self.arglist)[4]) // 1000
    context.hurt = finalHurt
    local skilltarget = context.target
    self:onOverHeal(skilltarget)
  end
end

bs_204502.onOverHeal = function(self, target)
  -- function num : 0_5 , upvalues : _ENV
  local skillResult = LuaSkillCtrl:CallSkillResultNoEffect(self, target)
  if target.career == 1 then
    LuaSkillCtrl:HealResult(skillResult, (self.config).HealConfig, {(self.arglist)[3] * 2})
  else
    LuaSkillCtrl:HealResult(skillResult, (self.config).HealConfig, {(self.arglist)[3]})
  end
  skillResult:EndResult()
end

bs_204502.OnCasterDie = function(self)
  -- function num : 0_6 , upvalues : base, _ENV
  (base.OnCasterDie)(self)
  local teamMates = LuaSkillCtrl:GetSelectTeamRoles((self.caster).belongNum)
  if teamMates.Count > 0 then
    for i = 0, teamMates.Count - 1 do
      local buffrole = teamMates[i]
      if buffrole.hp > 0 then
        LuaSkillCtrl:DispelBuff(buffrole, (self.config).restBuffId, 1, true)
        if buffrole.maxHp < buffrole.hp then
          buffrole._curHp = buffrole.maxHp
        end
      end
    end
  end
end

return bs_204502

